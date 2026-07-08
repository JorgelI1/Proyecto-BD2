SET SERVEROUTPUT ON;

DECLARE
    v_mensaje        VARCHAR2(250);
    v_resultado      VARCHAR2(250);

    v_id_programa    PROGRAMAS.ID_PROGRAMA%TYPE;
    v_id_psicologo   PSICOLOGO.ID_PSICOLOGO%TYPE;
    v_id_paciente    PACIENTE.ID_PACIENTE%TYPE;
    v_id_tipotel     TIPO_TELEFONO.ID_TIPOTEL%TYPE;
    v_id_cita        CITA.ID_CITA%TYPE;
    v_id_actividad   ACTIVIDAD_GRUPAL.ID_ACTIVIDAD%TYPE;
    v_id_registro    REGISTRO_MEDICO.ID_REGISTRO%TYPE;

    v_total_cargados NUMBER;
    v_estado_clinico REGISTRO_MEDICO.ESTADO_CLINICO%TYPE;

BEGIN

    cargar_programas_principales(
        v_total_cargados,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('Total de programas cargados: ' || v_total_cargados);

    SELECT MIN(id_programa)
    INTO v_id_programa
    FROM programas;

    DBMS_OUTPUT.PUT_LINE('ID Programa usado: ' || v_id_programa);


    registrar_psicologo(
        v_id_psicologo,
        'PRIMER NOMBRE',
        'PRIMER APELLIDO',
        'CEDULA123',
        'correo123@utp.ac.pa',
        'PSICOLOGO',
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Psicologo: ' || v_id_psicologo);


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