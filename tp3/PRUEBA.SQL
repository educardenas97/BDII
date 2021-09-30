/*
c) El procedimiento P_ACTUALIZAR_STOCK que recibe como parámetros id_producto,
cod_sucursal, cantidad, uso_stock
El procedimiento debe actualizar la tabla D_STOCK_SUCURSAL, que almacena el stock de
un producto en una sucursal, en base a los parámetros recibidos.
• Si el valor del parámetro USO_STOCK es 2 (sumar), debe aumentar la
CANTIDAD_EXISTENCIA en la tabla D_STOCK_SUCURSAL del producto dado por el
ID_PRODUCTO, y en la sucursal determinada por el COD_SUCURSAL.
• Si el valor del parámetro USO_STOCK es 1 (restar), debe disminuir la
CANTIDAD_EXISTENCIA en la tabla D_STOCK_SUCURSAL del producto dado por el
ID_PRODUCTO, y en la sucursal determinada por el COD_SUCURSAL. Ello siempre que la
(CANTIDAD_EXISTENCIA - CANTIDAD_OPERACION) >= STOCK_MINIMO. Si no se cumple
*/

CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_STOCK(
v_id_producto IN D_STOCK_SUCURSAL.ID_PRODUCTO%TYPE,
v_cod_sucursal IN D_STOCK_SUCURSAL.COD_SUCURSAL%TYPE, 
v_cantidad IN D_STOCK_SUCURSAL.CANTIDAD_EXISTENCIA%TYPE,
v_uso_stock NUMBER
)
IS
    BEGIN
        IF V_USO_STOCK = 2 THEN
            UPDATE D_STOCK_SUCURSAL SET CANTIDAD_EXISTENCIA = CANTIDAD_EXISTENCIA + V_CANTIDAD
            WHERE ID_PRODUCTO = V_ID_PRODUCTO 
            AND COD_SUCURSAL = v_cod_sucursal;
        ELSIF V_USO_STOCK = 1 THEN
            UPDATE D_STOCK_SUCURSAL SET CANTIDAD_EXISTENCIA = CANTIDAD_EXISTENCIA - V_CANTIDAD
            WHERE ID_PRODUCTO = V_ID_PRODUCTO 
            AND COD_SUCURSAL = v_cod_sucursal   
            AND (CANTIDAD_EXISTENCIA - V_CANTIDAD) >= STOCK_MINIMO; 
        ELSE
            DBMS_OUTPUT.PUT_LINE('***USO STOCK NO VALIDO***');
        END IF;
    END;

EXECUTE P_ACTUALIZAR_STOCK(1, 3, 5,1);