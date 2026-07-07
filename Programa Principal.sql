DECLARE
    v_total_cargados NUMBER;
    v_mensaje        VARCHAR2(250);
BEGIN

    cargar_programas_principales(
        v_total_cargados,
        v_mensaje
    );

    DBMS_OUTPUT.PUT_LINE(v_mensaje);
    DBMS_OUTPUT.PUT_LINE('Total cargados: ' || v_total_cargados);

END;
/