/*
    TABLAS INDEXADAS
    Metodos:
    - EXISTS
    - COUNT
    - LIMIT
    - FIRST / LAST / NEXT
    - DELETE / EXTEND
*/
declare
    type t_vector is table of number(3)
    index by varchar2(10);
    v_vector t_vector;
    subind varchar2(10);
begin
    v_vector('Cuarenta') := 40;
    v_vector('cuarenta') := -40;
    v_vector('Cinco') := 5;
    v_vector('Quince') := 15;
    dbms_output.put_line('count: '|| v_vector.count);
    subind := v_vector.first;
    while subind is not NULL loop
        dbms_output.put_line(subind ||': '|| v_vector(subind));
        subind := v_vector.next(subind);
    end loop;
end;



/*
    NESTED TABLES (Tablas Anidadas)
    - Son tablas indexadas pero que se pueden guardar en la BD
    - Crecen dinamicamente
    - El posicionamiento debe ser secuencial
*/
DECLARE -- --Definición del Tipo Tabla:
    TYPE typ_nest_tab IS TABLE OF VARCHAR2(25);
    --Declaramos una Variable del Tipo Tabla: typ_nest_tab
    v_nest_tab typ_nest_tab;
BEGIN
    --A continuación Inicializamos la variable tipo tabla
    v_nest_tab := typ_nest_tab();
    --EXTEND: Inserta un Registro Nulo a la Tabla.
    v_nest_tab.EXTEND;
    v_nest_tab(1) := 'Valor para el Indice 1';
    v_nest_tab.EXTEND;
    v_nest_tab(2) := 'Valor para el Indice 2';
    v_nest_tab.EXTEND;
    v_nest_tab(3) := 'Valor para el Indice 3';
    -- Despliega los valores en pantalla
    DBMS_OUTPUT.PUT_LINE(v_nest_tab(1)||', '||v_nest_tab(2)||', '||v_nest_tab(3));
END;

-- Tablas anidadas en la BD
CREATE OR REPLACE TYPE linea_t AS OBJECT( 
    linum NUMBER, item VARCHAR2(30),
    cantidad NUMBER, descuento NUMBER(6,2) 
);

CREATE TYPE lineas_pedido_t AS TABLE OF linea_t; 