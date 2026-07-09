SET SERVEROUTPUT ON;

BEGIN
    DELETE FROM registro_medico;
    DELETE FROM actividad_grupal;
    DELETE FROM telefono;
    DELETE FROM cita;
    DELETE FROM auditoria_estado_cita;
    DELETE FROM paciente;
    DELETE FROM tipo_telefono;
    DELETE FROM psicologo;
    DELETE FROM programas;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se borro todo');
END;
/

DECLARE
    PROCEDURE recrear_secuencia(p_nombre VARCHAR2) IS
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || p_nombre;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE != -2289 THEN
                    RAISE;
                END IF;
        END;
        EXECUTE IMMEDIATE
            'CREATE SEQUENCE ' || p_nombre ||
            ' START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE';
        DBMS_OUTPUT.PUT_LINE('Secuencia reiniciada: ' || p_nombre);
    END;
BEGIN
    recrear_secuencia('seq_paciente');
    recrear_secuencia('seq_psicologo');
    recrear_secuencia('seq_tipotel');
    recrear_secuencia('seq_programa');
    recrear_secuencia('seq_cita');
    recrear_secuencia('seq_registro');
    recrear_secuencia('seq_actividad');
    recrear_secuencia('seq_auditoria_cita');

    DBMS_OUTPUT.PUT_LINE('Todas las secuencias fueron reiniciadas.');
END;
/