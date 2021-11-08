DECLARE
    CURSOR tablas_cursos IS 
        SELECT * FROM USER_TABLES;

BEGIN
    FOR tabla IN tablas_cursos LOOP
        dbms_output.put_line('Tabla: ' || tabla.table_name);
    END LOOP;
END;