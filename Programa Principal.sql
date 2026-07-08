SET SERVEROUTPUT ON;

DECLARE
    -- Variables generales
    v_mensaje        VARCHAR2(250);
    v_resultado      VARCHAR2(250);

    -- Variables de salida
    v_id_programa    PROGRAMAS.ID_PROGRAMA%TYPE;
    v_id_psicologo   PSICOLOGO.ID_PSICOLOGO%TYPE;
    v_id_paciente    PACIENTE.ID_PACIENTE%TYPE;
    v_id_cita        CITA.ID_CITA%TYPE;
    v_id_actividad   ACTIVIDAD_GRUPAL.ID_ACTIVIDAD%TYPE;
    v_id_registro    REGISTRO_MEDICO.ID_REGISTRO%TYPE;

    -- Variables especiales
    v_total_cargados NUMBER;
    v_estado_clinico REGISTRO_MEDICO.ESTADO_CLINICO%TYPE;

BEGIN
    -- 1. CARGAR PROGRAMAS PREDEFINIDOS

    cargar_programas_principales(
        v_total_cargados,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('Total de programas cargados: ' || v_total_cargados);

    /*-- 2. CARGAR UN PROGRAMA MANUAL
    cargar_programas(
        'NOMBRE DEL PROGRAMA',
        'DESCRIPCION DEL PROGRAMA',
        'POBLACION OBJETIVO',
        v_id_programa,
        v_mensaje
    );*/

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('ID Programa: ' || v_id_programa);


    -- 3. REGISTRAR PSICOLOGO
    registrar_psicologo(
        v_id_psicologo,
        'PRIMER NOMBRE',
        'PRIMER APELLIDO',
        'CEDULA',
        'correo@utp.ac.pa',
        'PSICOLOGO',
        v_resultado
    );
    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Psicologo: ' || v_id_psicologo);



    -- 4. REGISTRAR PACIENTE
    cargar_pacientes(
        'PRIMER NOMBRE',
        'SEGUNDO NOMBRE',
        'PRIMER APELLIDO',
        'SEGUNDO APELLIDO',
        'CEDULA',
        TO_DATE('01/01/2000', 'DD/MM/YYYY'),
        'PROVINCIA',
        'DISTRITO',
        'CORREGIMIENTO',
        'M',
        'SEDE',
        'NINGUNA',
        'correo@utp.ac.pa',
        'ESTUDIANTE',
        'SI',
        v_id_paciente,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('ID Paciente: ' || v_id_paciente);



    -- 5. REGISTRAR CITA
    registrar_cita(
        TO_DATE('10/07/2026', 'DD/MM/YYYY'),
        TO_DATE('10/07/2026 08:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('10/07/2026 09:00', 'DD/MM/YYYY HH24:MI'),
        'MOTIVO DE LA CITA',
        v_id_paciente,
        v_id_psicologo,
        'APROBADA',
        v_id_cita,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Cita: ' || v_id_cita);


    -- 6. CREAR REGISTRO MEDICO (solo citas aprobadas)
    v_estado_clinico := NULL;

    crear_registro_medico(
        1,
        v_estado_clinico,
        'DIAGNOSTICO DEL PACIENTE',
        'OBSERVACIONES DEL REGISTRO',
        v_id_psicologo,
        v_id_paciente,
        v_id_cita,
        v_id_registro,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Registro Medico: ' || v_id_registro);
    DBMS_OUTPUT.PUT_LINE('Estado clinico: ' || v_estado_clinico);


    -- 7. CREAR ACTIVIDAD GRUPAL

    crear_actividad(
        'NOMBRE DE LA ACTIVIDAD',
        'DESCRIPCION DE LA ACTIVIDAD',
        TO_DATE('15/07/2026', 'DD/MM/YYYY'),
        'LUGAR DE LA ACTIVIDAD',
        TO_DATE('15/07/2026 10:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('15/07/2026 12:00', 'DD/MM/YYYY HH24:MI'),
        25,
        v_id_psicologo,
        v_id_programa,
        v_id_actividad,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Actividad: ' || v_id_actividad);


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en el programa principal: ' || SQLERRM);

END;
/