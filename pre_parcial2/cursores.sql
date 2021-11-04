DECLARE
    CURSOR C_CLIENTES IS
    SELECT * FROM B_PERSONAS C WHERE c.es_cliente = 'S' ;
    R_CLIENTES B_PERSONAS%ROWTYPE;
BEGIN
    for clientes IN C_CLIENTES LOOP
        IF clientes.NOMBRE is not null THEN
            DBMS_OUTPUT.PUT_LINE('CLIENTE: ' || clientes.NOMBRE);
        ELSE
            DBMS_OUTPUT.PUT_LINE('CLIENTE CANTI:');
        END IF;
    END LOOP;
    
END;
