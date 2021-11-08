DECLARE
    nombre VARCHAR2(50);
    table_space_v VARCHAR2(50);
    respuesta VARCHAR2(50);
BEGIN
    nombre := 'SYS';
    SELECT USERNAME, DEFAULT_TABLESPACE INTO respuesta, table_space_v FROM dba_users WHERE USERNAME = nombre;
    DBMS_OUTPUT.PUT_LINE(respuesta || ' ' || table_space_v);
END;