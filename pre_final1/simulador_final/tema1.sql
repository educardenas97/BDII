/*
    VARRAYS + OBJETOS
*/

-- Creacion con SQL
CREATE TYPE cliente AS OBJECT( -- Primero se crea el objeto
    ID_CLIENTE NUMBER,
    NOMBRE_CLIENTE VARCHAR2(50)
);

CREATE TYPE clientes IS VARRAY(10) OF cliente; -- Se crea el VARRAY

-- Utilizacion en PL SQL
DECLARE
    clientes_v clientes;
    v_cont        NUMBER := 0;
BEGIN
    clientes_v := clientes(); -- Es necesario usar un constructor
    FOR i IN 1..10 LOOP
        -- i := i+1;
        clientes_v.EXTEND; -- Instancia un 'lugar' en el varray
        -- el constructor debe usarse para instanciar el objeto dentro del varray
        clientes_v(i) := cliente(i, 'ID_CLIENTE');
        DBMS_OUTPUT.PUT_LINE(clientes_v(i).ID_CLIENTE || ' - ' || clientes_v(i).NOMBRE_CLIENTE);
    END LOOP;
END;
