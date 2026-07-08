-- =========================================
-- PROCEDIMIENTO CARGAR PROGRAMAS
-- =========================================

CREATE OR REPLACE PROCEDURE cargar_programas (
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