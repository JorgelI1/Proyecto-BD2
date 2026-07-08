SET SERVEROUTPUT ON;

DECLARE
    v_mensaje        VARCHAR2(250);
    v_resultado      VARCHAR2(250);

    v_id_programa    PROGRAMAS.ID_PROGRAMA%TYPE;

    v_id_psicologo_1 PSICOLOGO.ID_PSICOLOGO%TYPE;
    v_id_psicologo_2 PSICOLOGO.ID_PSICOLOGO%TYPE;

    v_id_paciente_1  PACIENTE.ID_PACIENTE%TYPE;
    v_id_paciente_2  PACIENTE.ID_PACIENTE%TYPE;
    v_id_paciente_3  PACIENTE.ID_PACIENTE%TYPE;

    v_id_tipotel_1   TIPO_TELEFONO.ID_TIPOTEL%TYPE;
    v_id_tipotel_2   TIPO_TELEFONO.ID_TIPOTEL%TYPE;
    v_id_tipotel_3   TIPO_TELEFONO.ID_TIPOTEL%TYPE;

    v_id_cita_1      CITA.ID_CITA%TYPE;
    v_id_cita_2      CITA.ID_CITA%TYPE;
    v_id_cita_3      CITA.ID_CITA%TYPE;

    v_id_actividad_1 ACTIVIDAD_GRUPAL.ID_ACTIVIDAD%TYPE;
    v_id_actividad_2 ACTIVIDAD_GRUPAL.ID_ACTIVIDAD%TYPE;

    v_id_registro_1  REGISTRO_MEDICO.ID_REGISTRO%TYPE;
    v_id_registro_2  REGISTRO_MEDICO.ID_REGISTRO%TYPE;
    v_id_registro_3  REGISTRO_MEDICO.ID_REGISTRO%TYPE;

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


    -- PSICOLOGOS

    registrar_psicologo(
        v_id_psicologo_1,
        'MEILYN',
        'CAMAÑO',
        '8-1032-2281',
        'meilyn.camano@utp.ac.pa',
        'PSICOLOGO',
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Psicologo 1: ' || v_id_psicologo_1);


    registrar_psicologo(
        v_id_psicologo_2,
        'ROBERT',
        'PIMENTEL',
        '7-714-1252',
        'robert.pimentel@utp.ac.pa',
        'PSICOLOGO',
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Psicologo 2: ' || v_id_psicologo_2);


    -- PACIENTE 1: JORGE

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
        v_id_paciente_1,
        v_id_tipotel_1,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('ID Paciente 1: ' || v_id_paciente_1);
    DBMS_OUTPUT.PUT_LINE('ID Tipo Telefono Paciente 1: ' || v_id_tipotel_1);
    --Aprueba la cita de Jorge
    UPDATE cita
    SET estado_cita = 'APROBADA'
    WHERE id_cita = v_id_cita_1;

    DBMS_OUTPUT.PUT_LINE('Cita de Jorge cambiada a APROBADA');

    -- PACIENTE 2: JOHN BARAHONA

    cargar_pacientes(
        'JOHN',
        NULL,
        'BARAHONA',
        NULL,
        '8-1027-1259',
        TO_DATE('12/05/2005', 'DD/MM/YYYY'),
        'PANAMA',
        'PANAMA',
        'SAN FRANCISCO',
        'M',
        'CAMPUS CENTRAL',
        'NO',
        'john.barahona@utp.ac.pa',
        'ESTUDIANTE',
        'NO',
        61234568,
        'CELULAR',
        v_id_paciente_2,
        v_id_tipotel_2,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('ID Paciente 2: ' || v_id_paciente_2);
    DBMS_OUTPUT.PUT_LINE('ID Tipo Telefono Paciente 2: ' || v_id_tipotel_2);


    -- PACIENTE 3: KRYSS BOTACIO

    cargar_pacientes(
        'KRYSS',
        NULL,
        'BOTACIO',
        NULL,
        '8-1027-235',
        TO_DATE('20/08/2005', 'DD/MM/YYYY'),
        'PANAMA',
        'SAN MIGUELITO',
        'BELISARIO PORRAS',
        'F',
        'CAMPUS CENTRAL',
        'NO',
        'kryss.botacio@utp.ac.pa',
        'ESTUDIANTE',
        'NO',
        61234569,
        'CELULAR',
        v_id_paciente_3,
        v_id_tipotel_3,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('ID Paciente 3: ' || v_id_paciente_3);
    DBMS_OUTPUT.PUT_LINE('ID Tipo Telefono Paciente 3: ' || v_id_tipotel_3);


    -- CITAS

    registrar_cita(
        TO_DATE('10/07/2026', 'DD/MM/YYYY'),
        TO_DATE('10/07/2026 08:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('10/07/2026 09:00', 'DD/MM/YYYY HH24:MI'),
        'ANSIEDAD POR CARGA ACADEMICA',
        v_id_paciente_1,
        v_id_psicologo_1,
        v_id_cita_1,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Cita 1: ' || v_id_cita_1);


    registrar_cita(
        TO_DATE('11/07/2026', 'DD/MM/YYYY'),
        TO_DATE('11/07/2026 09:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('11/07/2026 10:00', 'DD/MM/YYYY HH24:MI'),
        'ORIENTACION PERSONAL',
        v_id_paciente_2,
        v_id_psicologo_2,
        v_id_cita_2,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Cita 2: ' || v_id_cita_2);


    registrar_cita(
        TO_DATE('12/07/2026', 'DD/MM/YYYY'),
        TO_DATE('12/07/2026 10:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('12/07/2026 11:00', 'DD/MM/YYYY HH24:MI'),
        'SEGUIMIENTO PSICOLOGICO',
        v_id_paciente_3,
        v_id_psicologo_1,
        v_id_cita_3,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Cita 3: ' || v_id_cita_3);


    -- REGISTROS MEDICOS

    v_estado_clinico := NULL;

    crear_registro_medico(
        1,
        v_estado_clinico,
        'DIAGNOSTICO DEL PACIENTE JORGE',
        'OBSERVACIONES DEL REGISTRO DE JORGE',
        v_id_psicologo_1,
        v_id_paciente_1,
        v_id_cita_1,
        v_id_registro_1,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Registro Medico 1: ' || v_id_registro_1);
    DBMS_OUTPUT.PUT_LINE('Estado clinico 1: ' || v_estado_clinico);


    v_estado_clinico := NULL;

    crear_registro_medico(
        1,
        v_estado_clinico,
        'DIAGNOSTICO DEL PACIENTE JOHN',
        'OBSERVACIONES DEL REGISTRO DE JOHN',
        v_id_psicologo_2,
        v_id_paciente_2,
        v_id_cita_2,
        v_id_registro_2,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Registro Medico 3: ' || v_id_registro_3);
    DBMS_OUTPUT.PUT_LINE('Estado clinico 3: ' || v_estado_clinico);


    -- ACTIVIDADES GRUPALES

    crear_actividad(
        'MANEJO DEL ESTRES ACADEMICO',
        'ACTIVIDAD PARA ORIENTAR A ESTUDIANTES SOBRE EL MANEJO DEL ESTRES',
        TO_DATE('15/07/2026', 'DD/MM/YYYY'),
        'SALON DE CONFERENCIAS UTP',
        TO_DATE('15/07/2026 10:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('15/07/2026 12:00', 'DD/MM/YYYY HH24:MI'),
        25,
        v_id_psicologo_1,
        v_id_programa,
        v_id_actividad_1,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Actividad 1: ' || v_id_actividad_1);


    crear_actividad(
        'ORIENTACION Y BIENESTAR ESTUDIANTIL',
        'CHARLA SOBRE HABITOS SALUDABLES Y BIENESTAR EMOCIONAL',
        TO_DATE('16/07/2026', 'DD/MM/YYYY'),
        'AUDITORIO PRINCIPAL UTP',
        TO_DATE('16/07/2026 14:00', 'DD/MM/YYYY HH24:MI'),
        TO_DATE('16/07/2026 16:00', 'DD/MM/YYYY HH24:MI'),
        30,
        v_id_psicologo_2,
        v_id_programa,
        v_id_actividad_2,
        v_resultado
    );

    DBMS_OUTPUT.PUT_LINE(v_resultado);
    DBMS_OUTPUT.PUT_LINE('ID Actividad 2: ' || v_id_actividad_2);


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en el programa principal: ' || SQLERRM);

END;
/