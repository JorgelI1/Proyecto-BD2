-- =========================================
-- PROCEDIMIENTO CARGAR PROGRAMAS PRINCIPALES
-- =========================================

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