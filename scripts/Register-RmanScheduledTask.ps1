[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskName,
    [Parameter(Mandatory = $true)]
    [string]$RunnerPath,
    [Parameter(Mandatory = $true)]
    [string]$ScriptPath,
    [Parameter(Mandatory = $true)]
    [string]$OracleSid,
    [Parameter(Mandatory = $true)]
    [datetime]$StartAt,
    [ValidateSet('Daily','Weekly')]
    [string]$Frequency = 'Daily'
)

$ErrorActionPreference = 'Stop'
$resolvedRunner = (Resolve-Path -LiteralPath $RunnerPath).Path
$resolvedScript = (Resolve-Path -LiteralPath $ScriptPath).Path
$arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$resolvedRunner`" -ScriptPath `"$resolvedScript`" -OracleSid `"$OracleSid`" -Execute"
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arguments
$trigger = if ($Frequency -eq 'Weekly') {
    New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek $StartAt.DayOfWeek -At $StartAt
} else {
    New-ScheduledTaskTrigger -Daily -At $StartAt
}
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 8)

if ($PSCmdlet.ShouldProcess($TaskName, 'Registrar tarea de respaldo RMAN')) {
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Description 'Estrategia RMAN aprobada y gestionada por Respaldo Seguro' -Force
}

