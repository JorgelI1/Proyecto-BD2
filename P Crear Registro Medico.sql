-- =========================================
-- PROCEDIMIENTO CREAR REGISTRO MEDICO
-- =========================================

CREATE OR REPLACE PROCEDURE CREAR_REGISTRO_MEDICO(
    P_NUMERO_REGISTRO IN REGISTRO_MEDICO.NUMERO_REGISTRO%TYPE,
    P_ESTADO_CLINICO  IN OUT REGISTRO_MEDICO.ESTADO_CLINICO%TYPE,
    P_DIAGNOSTICO     IN REGISTRO_MEDICO.DIAGNOSTICO%TYPE,
    P_OBSERVACIONES   IN REGISTRO_MEDICO.OBSERVACIONES%TYPE,
    P_ID_PSICOLOGO    IN REGISTRO_MEDICO.ID_PSICOLOGO%TYPE,
    P_ID_PACIENTE     IN REGISTRO_MEDICO.ID_PACIENTE%TYPE,
    P_ID_CITA         IN REGISTRO_MEDICO.ID_CITA%TYPE,
    P_ID_REGISTRO     OUT REGISTRO_MEDICO.ID_REGISTRO%TYPE,
    P_RESULTADO       OUT VARCHAR2
)
IS
    V_EXISTE_PSICOLOGO NUMBER;
    V_EXISTE_PACIENTE  NUMBER;
    V_EXISTE_CITA      NUMBER;
    V_APROBADO_CITA    NUMBER;
BEGIN

    -- Verificar si existe el psicólogo
    SELECT COUNT(*)
    INTO V_EXISTE_PSICOLOGO
    FROM PSICOLOGO
    WHERE ID_PSICOLOGO = P_ID_PSICOLOGO;

    -- Verificar si existe el paciente
    SELECT COUNT(*)
    INTO V_EXISTE_PACIENTE
    FROM PACIENTE
    WHERE ID_PACIENTE = P_ID_PACIENTE;

    -- Verificar si existe la cita con ese paciente y psicólogo
    SELECT COUNT(*)
    INTO V_EXISTE_CITA
    FROM CITA
    WHERE ID_CITA = P_ID_CITA
    AND ID_PACIENTE = P_ID_PACIENTE
    AND ID_PSICOLOGO = P_ID_PSICOLOGO;

    -- Verificar si existe la cita aprobada con ese paciente y psicólogo
    SELECT COUNT(*)
    INTO V_APROBADO_CITA
    FROM CITA
    WHERE ID_CITA = P_ID_CITA
    AND ID_PACIENTE = P_ID_PACIENTE
    AND ID_PSICOLOGO = P_ID_PSICOLOGO
    AND ESTADO_CITA = 'APROBADA';

    IF V_EXISTE_PSICOLOGO = 0 THEN
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: El psicólogo no existe.';

    ELSIF V_EXISTE_PACIENTE = 0 THEN
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: El paciente no existe.';

    ELSIF V_EXISTE_CITA = 0 THEN
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: La cita no existe para el paciente y psicólogo ingresado.';

    ELSIF V_APROBADO_CITA = 0 THEN
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: La cita no está aprobada.';

    ELSE
        -- Si no se envia estado clinico, se pone en seguimiento por defecto
        IF P_ESTADO_CLINICO IS NULL THEN
            P_ESTADO_CLINICO := 'En seguimiento';
        END IF;

        P_ID_REGISTRO := SEQ_REGISTRO.NEXTVAL;

        INSERT INTO REGISTRO_MEDICO(
            ID_REGISTRO,
            NUMERO_REGISTRO,
            FECHA_ATENCION,
            ESTADO_CLINICO,
            DIAGNOSTICO,
            OBSERVACIONES,
            ID_PSICOLOGO,
            ID_PACIENTE,
            ID_CITA
        )
        VALUES(
            P_ID_REGISTRO,
            P_NUMERO_REGISTRO,
            SYSDATE,
            P_ESTADO_CLINICO,
            P_DIAGNOSTICO,
            P_OBSERVACIONES,
            P_ID_PSICOLOGO,
            P_ID_PACIENTE,
            P_ID_CITA
        );
        COMMIT;
        P_RESULTADO := 'Registro médico creado correctamente.';
    END IF;

EXCEPTION
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: Valor inválido.';
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: Registro duplicado.';
    WHEN OTHERS THEN
        ROLLBACK;
        P_ID_REGISTRO := NULL;
        P_RESULTADO := 'Error: ' || SQLERRM;
END;
/