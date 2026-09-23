# Respaldo Seguro

Prototipo académico para construir, validar, programar y monitorear estrategias de respaldo Oracle con RMAN. La solución organiza el proceso en tres decisiones: qué respaldar, cómo respaldarlo y cuándo ejecutarlo.

## Entregables incluidos

- `dist/index.html`: aplicación web funcional sin dependencias externas.
- `scripts/Invoke-RmanBackup.ps1`: puente local con modo seguro por defecto y evidencia JSON.
- `scripts/Register-RmanScheduledTask.ps1`: registro opcional en Windows Task Scheduler.
- `sql/modelo_datos_oracle.sql`: modelo relacional de referencia para Oracle 21c.
- `examples/`: scripts RMAN y evidencias de demostración.
- `docs/`: documento de análisis, matriz de cumplimiento y presentación.
- `output/`: versiones finales listas para entregar.

## Ejecución del prototipo

Abra `dist/index.html` en un navegador moderno. La aplicación usa `localStorage`, por lo que conserva bases, estrategias, aprobaciones, ejecuciones y alertas en el equipo.

También puede iniciar un servidor local desde la raíz del proyecto:

```powershell
python -m http.server 8080 --directory dist
```

Después abra `http://localhost:8080`.

## Flujo de demostración

1. Registre una base Oracle e indique si utiliza `ARCHIVELOG` o `NOARCHIVELOG`.
2. Cree una estrategia y complete las cuatro etapas del constructor.
3. Revise las advertencias y corrija los datos bloqueantes.
4. Abra Scripts RMAN, revise el texto generado y apruébelo.
5. Registre una ejecución exitosa, una con advertencias y una fallida.
6. Consulte Alertas y Evidencia.
7. Exporte el historial CSV y el paquete JSON.

El navegador no ejecuta RMAN. Esta separación mantiene el control del administrador. Para una prueba real en Oracle XE use el puente PowerShell, primero sin `-Execute` y luego, únicamente en un entorno controlado, con `-Execute`.

## Prueba local de RMAN

```powershell
.\scripts\Invoke-RmanBackup.ps1 `
  -ScriptPath .\examples\nivel0_semanal.rcv `
  -OracleSid XE `
  -EvidenceDirectory .\evidence
```

El comando anterior valida y muestra lo que se ejecutaría. Agregue `-Execute` solamente después de revisar el script y confirmar que el ambiente es de desarrollo o pruebas.

## Supuestos de alcance

- El prototipo demuestra el flujo y conserva evidencia local.
- Las ejecuciones incluidas son simulaciones controladas.
- La conexión real usa autenticación del sistema operativo con `rman target /`.
- La ruta de respaldo, permisos, capacidad y variables de Oracle deben validarse en cada equipo.
- La estrategia de recuperación se debe probar con restauraciones controladas, no solo con ejecuciones exitosas.

## Fuentes técnicas principales

- Oracle Database 21c Backup and Recovery User's Guide: https://docs.oracle.com/en/database/oracle/oracle-database/21/bradv/
- Conceptos de respaldos RMAN: https://docs.oracle.com/en/database/oracle/oracle-database/21/bradv/rman-backup-concepts.html
- Validación de archivos y respaldos: https://docs.oracle.com/en/database/oracle/oracle-database/21/bradv/validating-database-files-backups.html

