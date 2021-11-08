DECLARE
    indice NUMBER;
BEGIN
    FOR indice IN 1000..2000 LOOP
        BEGIN
            dbms_output.put_line(-indice);
            raise_application_error(-indice, 'error: ');
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('exception: ' || SQLCODE || ' ' || SQLERRM);
        END;
    END LOOP;
END;