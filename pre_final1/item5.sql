DECLARE
    CURSOR tablas_cursos IS 
         SELECT TABLE_NAME FROM TABS;

    CURSOR tablas_columnas(table_name_var VARCHAR2) IS 
         select column_name from all_tab_columns where table_name = table_name_var;
BEGIN
    FOR tabla IN tablas_cursos LOOP
        dbms_output.put_line('Tabla: ' || tabla.table_name);
        FOR columna IN tablas_columnas(tabla.table_name) LOOP
            dbms_output.put_line('Columna: ' || columna.column_name);
        END LOOP;
    END LOOP;
END;