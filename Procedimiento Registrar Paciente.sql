-- =========================================
-- PROCEDIMIENTO CARGAR PACIENTES
-- =========================================

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
    p_rol_paciente              IN OUT paciente.rol_paciente%TYPE,
    p_asegurado                 IN paciente.asegurado%TYPE,
    p_id_paciente               OUT paciente.id_paciente%TYPE,
    p_mensaje                   OUT VARCHAR2
)
AS
BEGIN

    p_id_paciente := seq_paciente.NEXTVAL;
    p_rol_paciente := p_rol_paciente;

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

    COMMIT;

    p_mensaje := 'Paciente registrado correctamente.';

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        p_id_paciente := NULL;
        p_mensaje := 'Error: La cedula del paciente ya existe.';

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        p_id_paciente := NULL;
        p_mensaje := 'Error: Valor invalido.';

    WHEN OTHERS THEN
        ROLLBACK;
        p_id_paciente := NULL;
        p_mensaje := 'ERROR: ' || SQLERRM;

END cargar_pacientes;
/