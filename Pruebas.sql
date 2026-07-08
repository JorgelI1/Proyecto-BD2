SET LINESIZE 200;
SET PAGESIZE 100;
SET WRAP OFF;
SET TRIMSPOOL ON;

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