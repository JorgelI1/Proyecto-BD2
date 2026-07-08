-- PROCEDIMIENTO CARGAR PACIENTES
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