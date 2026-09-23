[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ScriptPath,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9_#$]+$')]
    [string]$OracleSid,

    [string]$RmanPath,
    [string]$EvidenceDirectory = (Join-Path $PSScriptRoot '..\evidence'),
    [switch]$Execute
)

$ErrorActionPreference = 'Stop'
$resolvedScript = (Resolve-Path -LiteralPath $ScriptPath).Path
$resolvedEvidence = [System.IO.Path]::GetFullPath($EvidenceDirectory)

if (-not $RmanPath) {
    if (-not $env:ORACLE_HOME) {
        throw 'ORACLE_HOME no está definido. Indique -RmanPath de forma explícita.'
    }
    $RmanPath = Join-Path $env:ORACLE_HOME 'bin\rman.exe'
}

if (-not (Test-Path -LiteralPath $RmanPath -PathType Leaf)) {
    throw "No se encontró RMAN en: $RmanPath"
}

$scriptText = Get-Content -LiteralPath $resolvedScript -Raw
$forbidden = @(
    '(?im)^\s*DROP\s+',
    '(?im)^\s*DELETE\s+(?!NOPROMPT\s+EXPIRED\s+BACKUP)',
    '(?im)^\s*RESTORE\s+DATABASE\s*;(?!\s*VALIDATE)',
    '(?im)^\s*SHUTDOWN\s+',
    '(?im)^\s*STARTUP\s+'
)
foreach ($pattern in $forbidden) {
    if ($scriptText -match $pattern) {
        throw "El script contiene una operación fuera del alcance seguro del prototipo: $pattern"
    }
}

$hash = (Get-FileHash -LiteralPath $resolvedScript -Algorithm SHA256).Hash
$startedAt = Get-Date
$logName = 'rman_' + $startedAt.ToString('yyyyMMdd_HHmmss') + '.log'
$jsonName = 'evidence_' + $startedAt.ToString('yyyyMMdd_HHmmss') + '.json'
$logPath = Join-Path $resolvedEvidence $logName
$jsonPath = Join-Path $resolvedEvidence $jsonName

Write-Host "Script aprobado: $resolvedScript"
Write-Host "SHA256: $hash"
Write-Host "ORACLE_SID: $OracleSid"
Write-Host "RMAN: $RmanPath"

if (-not $Execute) {
    Write-Warning 'Modo de revisión. No se ejecutó RMAN. Use -Execute únicamente en desarrollo o pruebas.'
    return
}

New-Item -ItemType Directory -Force -Path $resolvedEvidence | Out-Null
$previousSid = $env:ORACLE_SID
try {
    $env:ORACLE_SID = $OracleSid
    & $RmanPath 'target' '/' "cmdfile=$resolvedScript" "log=$logPath"
    $exitCode = $LASTEXITCODE
}
finally {
    $env:ORACLE_SID = $previousSid
}

$finishedAt = Get-Date
$logText = if (Test-Path -LiteralPath $logPath) { Get-Content -LiteralPath $logPath -Raw } else { '' }
$hasRmanError = $logText -match '(?m)^(RMAN-00569|RMAN-03002|RMAN-03009|ORA-\d{5})'
$result = if ($exitCode -ne 0 -or $hasRmanError) { 'failed' } elseif ($logText -match '(?i)warning') { 'warning' } else { 'success' }
$evidence = [ordered]@{
    strategyScript = $resolvedScript
    scriptSha256 = $hash
    oracleSid = $OracleSid
    startedAt = $startedAt.ToString('o')
    finishedAt = $finishedAt.ToString('o')
    durationSeconds = [math]::Round(($finishedAt - $startedAt).TotalSeconds, 2)
    result = $result
    exitCode = $exitCode
    logPath = $logPath
    validationMentioned = [bool]($logText -match '(?i)RESTORE.+VALIDATE|validation complete')
    generatedBy = 'Invoke-RmanBackup.ps1'
}
$evidence | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
Write-Host "Resultado: $result"
Write-Host "Evidencia: $jsonPath"

if ($result -eq 'failed') {
    throw "RMAN reportó un fallo. Revise $logPath"
}

