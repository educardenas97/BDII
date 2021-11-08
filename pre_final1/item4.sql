DECLARE
    CURSOR localidades_cursor IS
        SELECT id, nombre FROM B_LOCALIDAD;

    CURSOR clientes(id NUMBER) IS
        SELECT * FROM B_PERSONAS per
        WHERE per.id_localidad = id;

BEGIN
    FOR localidad IN localidades_cursor
    LOOP
        FOR cliente IN clientes(localidad.id) LOOP
            dbms_output.put_line(cliente.nombre || ' ' || cliente.apellido);
        END LOOP;
    END LOOP;
END;