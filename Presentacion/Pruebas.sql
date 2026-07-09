SET LINESIZE 32000
SET PAGESIZE 50000
SET WRAP ON
SET TRIMSPOOL OFF
SET TAB OFF
SET LONG 100000
SET LONGCHUNKSIZE 100000
SET SERVEROUTPUT ON

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI';

SELECT * FROM paciente;
SELECT * FROM psicologo;
SELECT * FROM programas;
SELECT * FROM cita;
SELECT * FROM registro_medico;
SELECT * FROM actividad_grupal;
SELECT * FROM tipo_telefono;
SELECT * FROM telefono;
SELECT * FROM auditoria_estado_cita;

-- Vista de citas psicológicas
SELECT * FROM VW_CITAS_PSICOLOGICAS;
-- Vista de historial clínico
SELECT * FROM VW_HISTORIAL_CLINICO;
-- Vista de actividades grupales
SELECT * FROM VW_ACTIVIDADES_GRUPALES;
-- Vista de reporte de pacientes
SELECT * FROM VW_REPORTE_PACIENTES;
-- Vista de estadísticas de pacientes
SELECT * FROM VW_ESTADISTICAS_PACIENTES;
-- Vista de reporte de actividades
SELECT * FROM VW_REPORTE_ACTIVIDADES;
-- Vista resumen general DNOP
SELECT * FROM VW_RESUMEN_DNOP;