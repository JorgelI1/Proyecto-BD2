-- =========================================
-- PROCEDIMIENTO REGISTRAR CITA
-- =========================================

CREATE OR REPLACE PROCEDURE REGISTRAR_CITA(
    P_FECHA_CITA      IN CITA.FECHA_CITA%TYPE,
    P_HORA_INICIO     IN CITA.HORA_INICIO%TYPE,
    P_HORA_FIN        IN CITA.HORA_FIN%TYPE,
    P_MOTIVO_CITA     IN CITA.MOTIVO_CITA%TYPE,
    P_ID_PACIENTE     IN CITA.ID_PACIENTE%TYPE,
    P_ID_PSICOLOGO    IN CITA.ID_PSICOLOGO%TYPE,
    P_ESTADO_CITA     IN CITA.ESTADO_CITA%TYPE,
    P_ID_CITA         OUT CITA.ID_CITA%TYPE,
    P_RESULTADO       OUT VARCHAR2
)
IS
    V_EXISTE_PACIENTE  NUMBER;
    V_EXISTE_PSICOLOGO NUMBER;
BEGIN

    -- Validar hora de la cita
    IF P_HORA_FIN <= P_HORA_INICIO THEN
        P_ID_CITA := NULL;
        P_RESULTADO := 'Error: La hora final debe ser mayor que la hora de inicio.';

    ELSE

        -- Verificar si existe el paciente
        SELECT COUNT(*)
        INTO V_EXISTE_PACIENTE
        FROM PACIENTE
        WHERE ID_PACIENTE = P_ID_PACIENTE;

        -- Verificar si existe el psicólogo
        SELECT COUNT(*)
        INTO V_EXISTE_PSICOLOGO
        FROM PSICOLOGO
        WHERE ID_PSICOLOGO = P_ID_PSICOLOGO;

        IF V_EXISTE_PACIENTE = 0 THEN
            P_ID_CITA := NULL;
            P_RESULTADO := 'Error: El paciente no existe.';

        ELSIF V_EXISTE_PSICOLOGO = 0 THEN
            P_ID_CITA := NULL;
            P_RESULTADO := 'Error: El psicólogo no existe.';

        ELSE
            P_ID_CITA := SEQ_CITA.NEXTVAL;

            INSERT INTO CITA(
                ID_CITA,
                FECHA_CITA,
                HORA_INICIO,
                HORA_FIN,
                ESTADO_CITA,
                MOTIVO_CITA,
                FECHA_SOLICITUD,
                ID_PACIENTE,
                ID_PSICOLOGO
            )
            VALUES(
                P_ID_CITA,
                P_FECHA_CITA,
                P_HORA_INICIO,
                P_HORA_FIN,
                P_ESTADO_CITA,
                P_MOTIVO_CITA,
                SYSDATE,
                P_ID_PACIENTE,
                P_ID_PSICOLOGO
            );

            COMMIT;
            P_RESULTADO := 'Cita registrada correctamente.';
        END IF;
    END IF;

EXCEPTION
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        P_ID_CITA := NULL;
        P_RESULTADO := 'Error: Valor inválido.';
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        P_ID_CITA := NULL;
        P_RESULTADO := 'Error: Registro duplicado.';
    WHEN OTHERS THEN
        ROLLBACK;
        P_ID_CITA := NULL;
        P_RESULTADO := 'Error: ' || SQLERRM;
END;
/