-- Procedimiento para crear una actividad grupal-----------------------------------------------------
CREATE OR REPLACE PROCEDURE CREAR_ACTIVIDAD(
    P_NOMBRE_ACTIVIDAD        IN ACTIVIDAD_GRUPAL.NOMBRE_ACTIVIDAD%TYPE,
    P_DESCRIPCION_ACTIVIDAD   IN ACTIVIDAD_GRUPAL.DESCRIPCION_ACTIVIDAD%TYPE,
    P_FECHA_ACTIVIDAD         IN ACTIVIDAD_GRUPAL.FECHA_ACTIVIDAD%TYPE,
    P_LUGAR_ACTIVIDAD         IN ACTIVIDAD_GRUPAL.LUGAR_ACTIVIDAD%TYPE,
    P_HR_INICIO_ACTIVIDAD     IN ACTIVIDAD_GRUPAL.HR_INICIO_ACTIVIDAD%TYPE,
    P_HR_FIN_ACTIVIDAD        IN ACTIVIDAD_GRUPAL.HR_FIN_ACTIVIDAD%TYPE,
    P_CANTIDAD_PARTICIPANTES  IN ACTIVIDAD_GRUPAL.CANTIDAD_PARTICIPANTES%TYPE,
    P_ID_PSICOLOGO            IN ACTIVIDAD_GRUPAL.ID_PSICOLOGO%TYPE,
    P_ID_PROGRAMA             IN ACTIVIDAD_GRUPAL.ID_PROGRAMA%TYPE,
    P_ID_ACTIVIDAD            OUT ACTIVIDAD_GRUPAL.ID_ACTIVIDAD%TYPE,
    P_RESULTADO               OUT VARCHAR2
)
IS
    V_EXISTE_PSICOLOGO NUMBER;
    V_EXISTE_PROGRAMA  NUMBER;
BEGIN

    IF P_CANTIDAD_PARTICIPANTES <= 0 THEN

        P_ID_ACTIVIDAD := NULL;
        P_RESULTADO := 'Error: La cantidad de participantes debe ser mayor a 0.';

    ELSIF P_HR_FIN_ACTIVIDAD <= P_HR_INICIO_ACTIVIDAD THEN

        P_ID_ACTIVIDAD := NULL;
        P_RESULTADO := 'Error: La hora final debe ser mayor que la hora de inicio.';

    ELSE

        SELECT COUNT(*)
        INTO V_EXISTE_PSICOLOGO
        FROM PSICOLOGO
        WHERE ID_PSICOLOGO = P_ID_PSICOLOGO;

        SELECT COUNT(*)
        INTO V_EXISTE_PROGRAMA
        FROM PROGRAMAS
        WHERE ID_PROGRAMA = P_ID_PROGRAMA;

        IF V_EXISTE_PSICOLOGO = 0 THEN

            P_ID_ACTIVIDAD := NULL;
            P_RESULTADO := 'Error: El psicólogo no existe.';

        ELSIF V_EXISTE_PROGRAMA = 0 THEN

            P_ID_ACTIVIDAD := NULL;
            P_RESULTADO := 'Error: El programa no existe.';

        ELSE

            P_ID_ACTIVIDAD := SEQ_ACTIVIDAD.NEXTVAL;

            INSERT INTO ACTIVIDAD_GRUPAL(
                ID_ACTIVIDAD,
                NOMBRE_ACTIVIDAD,
                DESCRIPCION_ACTIVIDAD,
                FECHA_ACTIVIDAD,
                LUGAR_ACTIVIDAD,
                HR_INICIO_ACTIVIDAD,
                HR_FIN_ACTIVIDAD,
                CANTIDAD_PARTICIPANTES,
                ID_PSICOLOGO,
                ID_PROGRAMA
            )
            VALUES(
                P_ID_ACTIVIDAD,
                P_NOMBRE_ACTIVIDAD,
                P_DESCRIPCION_ACTIVIDAD,
                P_FECHA_ACTIVIDAD,
                P_LUGAR_ACTIVIDAD,
                P_HR_INICIO_ACTIVIDAD,
                P_HR_FIN_ACTIVIDAD,
                P_CANTIDAD_PARTICIPANTES,
                P_ID_PSICOLOGO,
                P_ID_PROGRAMA
            );

            COMMIT;

            P_RESULTADO := 'Actividad grupal registrada correctamente.';

        END IF;

    END IF;

EXCEPTION
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        P_ID_ACTIVIDAD := NULL;
        P_RESULTADO := 'Error: Valor inválido.';

    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        P_ID_ACTIVIDAD := NULL;
        P_RESULTADO := 'Error: Registro duplicado.';

    WHEN OTHERS THEN
        ROLLBACK;
        P_ID_ACTIVIDAD := NULL;
        P_RESULTADO := 'Error: ' || SQLERRM;

END;
/

-- Procedimiento para cargar programas-----------------------------------------------------
CREATE OR REPLACE PROCEDURE CARGAR_PROGRAMAS (
    p_nombre_programa      IN programas.nombre_programa%TYPE,
    p_descripcion_programa IN programas.descripcion_programa%TYPE,
    p_poblacion_objetivo   IN programas.poblacion_objetivo%TYPE,
    p_id_programa          OUT programas.id_programa%TYPE,
    p_mensaje              OUT VARCHAR2
)
AS
BEGIN

    p_id_programa := seq_programa.NEXTVAL;
    INSERT INTO programas (
        id_programa,
        nombre_programa,
        descripcion_programa,
        poblacion_objetivo
    )
    VALUES (
        p_id_programa,
        p_nombre_programa,
        p_descripcion_programa,
        p_poblacion_objetivo
    );

    COMMIT;

    p_mensaje := 'Programa registrado correctamente.';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_id_programa := NULL;
        p_mensaje := 'Error: El nombre del programa ya existe.';
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        p_id_programa := NULL;
        p_mensaje := 'Error: Valor invalido.';
    WHEN OTHERS THEN
        ROLLBACK;
        p_id_programa := NULL;
        p_mensaje := 'ERROR: ' || SQLERRM;
END cargar_programas;
/

--Procedimiento para crear un registro médico-----------------------------------------------------
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
        -- En seguimiento por defecto
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



-- Procedimiento para cargar programas principales (los que ya existen, sesupone que son predefinidos)-----------------------------------------------------
CREATE OR REPLACE PROCEDURE cargar_programas_principales (
    p_total_cargados OUT NUMBER,
    p_mensaje        OUT VARCHAR2
)
AS
    v_id_programa programas.id_programa%TYPE;
    v_mensaje     VARCHAR2(250);
BEGIN

    p_total_cargados := 0;

    cargar_programas(
        'Acompanamiento Psicologico',
        'Programa de atencion y seguimiento psicologico para la comunidad universitaria.',
        'Estudiantes',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Prevencion y Promocion de la Salud Mental',
        'Programa enfocado en actividades de prevencion, bienestar y salud mental.',
        'Comunidad universitaria',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Psicoeducativo',
        'Programa orientado al desarrollo de charlas, talleres y actividades educativas.',
        'Estudiantes',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Orientacion Profesional y Vocacional',
        'Programa de apoyo para la orientacion academica, profesional y vocacional.',
        'Estudiantes',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Profesional OPEN HOUSE-UTP',
        'Programa relacionado con actividades de orientacion profesional de la UTP.',
        'Estudiantes y aspirantes',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Apoyo a Docentes e Investigadores',
        'Programa de apoyo psicologico y orientacion dirigido a docentes e investigadores.',
        'Docentes e investigadores',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Apoya a Docentes e Investigadores',
        'Programa de apoyo dirigido a docentes e investigadores.',
        'Docentes e investigadores',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    cargar_programas(
        'Apoyo al Personal Administrativo',
        'Programa de apoyo y seguimiento dirigido al personal administrativo.',
        'Personal administrativo',
        v_id_programa,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);

    IF v_id_programa IS NOT NULL THEN
        p_total_cargados := p_total_cargados + 1;
    END IF;


    p_mensaje := 'Carga de programas principales finalizada.';

EXCEPTION
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        p_total_cargados := 0;
        p_mensaje := 'Error: Valor invalido.';

    WHEN OTHERS THEN
        ROLLBACK;
        p_total_cargados := 0;
        p_mensaje := 'ERROR: ' || SQLERRM;

END cargar_programas_principales;
/

--Procedimiento para registrar una cita-----------------------------------------------------
CREATE OR REPLACE PROCEDURE REGISTRAR_CITA(
    P_FECHA_CITA      IN CITA.FECHA_CITA%TYPE,
    P_HORA_INICIO     IN CITA.HORA_INICIO%TYPE,
    P_HORA_FIN        IN CITA.HORA_FIN%TYPE,
    P_MOTIVO_CITA     IN CITA.MOTIVO_CITA%TYPE,
    P_ID_PACIENTE     IN CITA.ID_PACIENTE%TYPE,
    P_ID_PSICOLOGO    IN CITA.ID_PSICOLOGO%TYPE,
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

-- Procedimiento para registrar un paciente y su teléfono-----------------------------------------------------
CREATE OR REPLACE PROCEDURE cargar_pacientes (
    p_primer_nombre_paciente    IN paciente.primer_nombre_paciente%TYPE,
    p_segundo_nombre_paciente   IN paciente.segundo_nombre_paciente%TYPE,
    p_primer_apellido_paciente  IN paciente.primer_apellido_paciente%TYPE,
    p_segundo_apellido_paciente IN paciente.segundo_apellido_paciente%TYPE,
    p_cedula                    IN paciente.cedula%TYPE,
    p_fecha_nacimiento          IN paciente.fecha_nacimiento%TYPE,
    p_provincia                 IN paciente.provincia%TYPE,
    p_distrito                  IN paciente.distrito%TYPE,
    p_corregimiento             IN paciente.corregimiento%TYPE,
    p_sexo                      IN paciente.sexo%TYPE,
    p_sede                      IN paciente.sede%TYPE,
    p_discapacidad              IN paciente.discapacidad%TYPE,
    p_correo_utp                IN paciente.correo_utp%TYPE,
    p_rol_paciente              IN paciente.rol_paciente%TYPE,
    p_asegurado                 IN paciente.asegurado%TYPE,
    p_telefono                  IN telefono.telefono%TYPE,
    p_descripcion_telefono      IN tipo_telefono.descripcion_telefono%TYPE,
    p_id_paciente               OUT paciente.id_paciente%TYPE,
    p_id_tipotel                OUT tipo_telefono.id_tipotel%TYPE,
    p_mensaje                   OUT VARCHAR2
)
AS
    v_existe_tipo NUMBER;
BEGIN

    p_id_paciente := seq_paciente.NEXTVAL;

    INSERT INTO paciente (
        id_paciente,
        primer_nombre_paciente,
        segundo_nombre_paciente,
        primer_apellido_paciente,
        segundo_apellido_paciente,
        cedula,
        fecha_nacimiento,
        provincia,
        distrito,
        corregimiento,
        sexo,
        sede,
        discapacidad,
        correo_utp,
        rol_paciente,
        asegurado
    )
    VALUES (
        p_id_paciente,
        p_primer_nombre_paciente,
        p_segundo_nombre_paciente,
        p_primer_apellido_paciente,
        p_segundo_apellido_paciente,
        p_cedula,
        p_fecha_nacimiento,
        p_provincia,
        p_distrito,
        p_corregimiento,
        p_sexo,
        p_sede,
        p_discapacidad,
        p_correo_utp,
        p_rol_paciente,
        p_asegurado
    );

    SELECT COUNT(*)
    INTO v_existe_tipo
    FROM tipo_telefono
    WHERE UPPER(descripcion_telefono) = UPPER(p_descripcion_telefono);

    IF v_existe_tipo = 0 THEN

        p_id_tipotel := seq_tipotel.NEXTVAL;

        INSERT INTO tipo_telefono (
            id_tipotel,
            descripcion_telefono
        )
        VALUES (
            p_id_tipotel,
            p_descripcion_telefono
        );

    ELSE

        SELECT id_tipotel
        INTO p_id_tipotel
        FROM tipo_telefono
        WHERE UPPER(descripcion_telefono) = UPPER(p_descripcion_telefono)
        AND ROWNUM = 1;

    END IF;

    INSERT INTO telefono (
        telefono,
        id_paciente,
        id_tipotel
    )
    VALUES (
        p_telefono,
        p_id_paciente,
        p_id_tipotel
    );

    COMMIT;

    p_mensaje := 'Paciente y teléfono registrados correctamente.';

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_id_paciente := NULL;
        p_id_tipotel := NULL;
        p_mensaje := 'Error: La cédula o el teléfono ya existe.';

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        p_id_paciente := NULL;
        p_id_tipotel := NULL;
        p_mensaje := 'Error: Valor inválido.';

    WHEN OTHERS THEN
        ROLLBACK;
        p_id_paciente := NULL;
        p_id_tipotel := NULL;
        p_mensaje := 'ERROR: ' || SQLERRM;

END cargar_pacientes;
/

--Procedimiento para registrar un psicólogo-----------------------------------------------------
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