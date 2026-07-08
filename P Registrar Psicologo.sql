CREATE OR REPLACE PROCEDURE REGISTRAR_PSICOLOGO(
    P_ID_PSICOLOGO              OUT PSICOLOGO.ID_PSICOLOGO%TYPE,
    P_PRIMER_NOMBRE             IN PSICOLOGO.PRIMER_NOMBRE_PSICOLOGO%TYPE,
    P_PRIMER_APELLIDO           IN PSICOLOGO.PRIMER_APELLIDO_PSICOLOGO%TYPE,
    P_CEDULA                    IN PSICOLOGO.CEDULA_PSICOLOGO%TYPE,
    P_CORREO                    IN PSICOLOGO.CORREO_UTP%TYPE,
    P_CARGO                     IN PSICOLOGO.CARGO%TYPE,
    P_RESULTADO                 OUT VARCHAR2
)
IS
    V_EXISTE NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO V_EXISTE
    FROM PSICOLOGO
    WHERE CEDULA_PSICOLOGO = P_CEDULA;

    IF V_EXISTE > 0 THEN

        P_ID_PSICOLOGO := NULL;
        P_RESULTADO := 'Error: Ya existe un psicólogo con esa cédula.';

    ELSE

        P_ID_PSICOLOGO := SEQ_PSICOLOGO.NEXTVAL;

        INSERT INTO PSICOLOGO(
            ID_PSICOLOGO,
            PRIMER_NOMBRE_PSICOLOGO,
            PRIMER_APELLIDO_PSICOLOGO,
            CEDULA_PSICOLOGO,
            CARGO,
            CORREO_UTP
        )
        VALUES(
            P_ID_PSICOLOGO,
            P_PRIMER_NOMBRE,
            P_PRIMER_APELLIDO,
            P_CEDULA,
            P_CARGO,
            P_CORREO
        );

        COMMIT;
        P_RESULTADO := 'Psicólogo registrado correctamente.';

    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        P_ID_PSICOLOGO := NULL;
        P_RESULTADO := 'Error: Registro duplicado.';

    WHEN OTHERS THEN
        ROLLBACK;
        P_ID_PSICOLOGO := NULL;
        P_RESULTADO := 'Error: ' || SQLERRM;

END;
/