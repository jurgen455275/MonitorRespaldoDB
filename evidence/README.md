# Evidencia de pruebas

La aplicación incluye registros demostrativos para los seis puntos requeridos:

1. ejecución exitosa;
2. ejecución fallida controlada;
3. consulta del historial;
4. generación y aprobación de un script;
5. detección de una advertencia;
6. aplicación de una recomendación.

Para generar evidencia nueva, abra la aplicación, use Ejecuciones y exporte el paquete JSON desde Evidencia. Para una prueba real, `scripts/Invoke-RmanBackup.ps1` produce un log de RMAN y un JSON con fechas, duración, hash del script, resultado y referencia al log.

Nunca ejecute operaciones destructivas ni restauraciones reales sobre producción. `RESTORE DATABASE VALIDATE` comprueba la disponibilidad de respaldos sin restaurar archivos de datos.

