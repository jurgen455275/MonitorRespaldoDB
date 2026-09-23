# Matriz de cumplimiento

| Requisito | Implementación | Evidencia |
|---|---|---|
| Registrar una base de datos | Vista Bases de datos | Registro ARCHIVELOG y NOARCHIVELOG incluido |
| Crear una estrategia | Constructor de cuatro pasos | Datos persistidos en localStorage |
| Definir qué respaldar | Base, tablespace, datafile, control file, SPFILE y archived redo logs | Alcance reflejado en el script |
| Seleccionar cómo respaldar | Completo, nivel 0, nivel 1 diferencial y acumulativo | Generador RMAN |
| Establecer cuándo | Inicio, hora, frecuencia, días, intervalo y ventana | Próxima ejecución calculada |
| Destino y espacio | Ruta y capacidad disponible | Alertas por espacio bajo |
| Generar y visualizar script | Vista Scripts RMAN | Descarga `.rcv` |
| Aprobación administrativa | Acción Aprobar script | Auditoría con fecha |
| Programar estrategia | Estado y próxima ejecución | Puente de Windows Task Scheduler |
| Ejecutar respaldo | Simulación controlada y puente PowerShell | Resultado exitoso, advertencia y fallo |
| Registrar resultado | Historial completo | CSV y JSON exportables |
| Alertas preventivas | Motor de reglas | NOARCHIVELOG, falta de espacio, fallo, falta de programación y validación pendiente |
| Verificar respaldo | `RESTORE DATABASE VALIDATE` | Campo de validación separado de existencia |
| Conservar historial | Ejecuciones y auditoría | Exportación de evidencia |
| Documento de análisis | Informe DOCX y PDF | Carpeta `output` |
| Diseño de aplicación | Arquitectura, módulos, datos, interfaz y flujo | Informe y esquema SQL |
| Presentación | Demostración guiada | Archivo PPTX |

