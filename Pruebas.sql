SET LINESIZE 200;
SET PAGESIZE 100;
SET WRAP OFF;
SET TRIMSPOOL OFF;

COLUMN table_name FORMAT A35;
COLUMN object_name FORMAT A35;
COLUMN object_type FORMAT A20;
COLUMN status FORMAT A10;
COLUMN sequence_name FORMAT A35;
COLUMN column_name FORMAT A30;
COLUMN data_type FORMAT A20;

SELECT table_name
FROM user_tables
ORDER BY table_name;

SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('TABLE', 'SEQUENCE', 'PROCEDURE', 'TRIGGER', 'VIEW')
ORDER BY object_type, object_name;

SELECT sequence_name, last_number
FROM user_sequences
ORDER BY sequence_name;

SELECT table_name,
       column_name,
       data_type,
       data_length,
       nullable
FROM user_tab_columns
ORDER BY table_name, column_id;

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
SELECT *
FROM VW_CITAS_PSICOLOGICAS;

-- Vista de historial clínico
SELECT *
FROM VW_HISTORIAL_CLINICO;

-- Vista de actividades grupales
SELECT *
FROM VW_ACTIVIDADES_GRUPALES;

-- Vista de reporte de pacientes
SELECT *
FROM VW_REPORTE_PACIENTES;

-- Vista de estadísticas de pacientes
SELECT *
FROM VW_ESTADISTICAS_PACIENTES;

-- Vista de reporte de actividades
SELECT *
FROM VW_REPORTE_ACTIVIDADES;

-- Vista resumen general DNOP
SELECT *
FROM VW_RESUMEN_DNOP;



SET LINESIZE 32767
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