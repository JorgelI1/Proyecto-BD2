SET SERVEROUTPUT ON;

DECLARE
    v_total_cargados NUMBER;
    v_mensaje VARCHAR2(250);
BEGIN
    cargar_programas_principales(
        v_total_cargados,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('Total cargados: ' || v_total_cargados);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_id_psicologo PSICOLOGO.ID_PSICOLOGO%TYPE;
    v_resultado VARCHAR2(250);
BEGIN
    registrar_psicologo(
        v_id_psicologo,
        'Ana',
        'Gomez',
        '8-888-111',
        'ana.gomez@utp.ac.pa',
        'PSICOLOGO',
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Psicologo: ' || v_id_psicologo);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_id_paciente PACIENTE.ID_PACIENTE%TYPE;
    v_id_tipotel  TIPO_TELEFONO.ID_TIPOTEL%TYPE;
    v_mensaje     VARCHAR2(250);
BEGIN
    cargar_pacientes(
        'Jorge',
        'Luis',
        'Li',
        'Luo',
        '3-759-2256',
        TO_DATE('28/03/2006', 'DD/MM/YYYY'),
        'PANAMA OESTE',
        'LA CHORRERA',
        'BARRIO BALBOA',
        'M',
        'CAMPUS CENTRAL',
        'NO',
        'jorge.li@utp.ac.pa',
        'ESTUDIANTE',
        'SI',
        61234567,
        'CELULAR',
        v_id_paciente,
        v_id_tipotel,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('ID Paciente: ' || v_id_paciente);
    DBMS_OUTPUT.PUT_LINE('ID Tipo Telefono: ' || v_id_tipotel);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_id_cita CITA.ID_CITA%TYPE;
    v_resultado VARCHAR2(250);
BEGIN
    registrar_cita(
        TO_DATE('10/07/2026', 'DD/MM/YYYY'),
        TO_DATE('10/07/2026 08:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('10/07/2026 09:00', 'DD/MM/YYYY HH24:MI'),
        'Consulta por estrés académico',
        1,
        1,
        'APROBADA',
        v_id_cita,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Cita: ' || v_id_cita);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_id_registro REGISTRO_MEDICO.ID_REGISTRO%TYPE;
    v_resultado VARCHAR2(250);
    v_estado_clinico REGISTRO_MEDICO.ESTADO_CLINICO%TYPE;
BEGIN
    v_estado_clinico := NULL;

    crear_registro_medico(
        1,
        v_estado_clinico,
        'Diagnóstico de prueba',
        'Observaciones de prueba',
        1,
        1,
        1,
        v_id_registro,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Registro Medico: ' || v_id_registro);
    DBMS_OUTPUT.PUT_LINE('Estado Clinico: ' || v_estado_clinico);
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_id_actividad ACTIVIDAD_GRUPAL.ID_ACTIVIDAD%TYPE;
    v_resultado VARCHAR2(250);
BEGIN
    crear_actividad(
        'Charla de manejo del estrés',
        'Actividad grupal para estudiantes',
        TO_DATE('15/07/2026', 'DD/MM/YYYY'),
        'Salón principal',
        TO_DATE('15/07/2026 10:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('15/07/2026 12:00', 'DD/MM/YYYY HH24:MI'),
        25,
        1,
        1,
        v_id_actividad,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Actividad: ' || v_id_actividad);
END;
/