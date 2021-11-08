DECLARE
    CURSOR ARTICULOS IS
    SELECT * FROM B_ARTICULOS
        WHERE STOCK_ACTUAL < STOCK_MINIMO;

    cantidad_a_pedir_variable NUMBER(3);
    id_provendedor_variable NUMBER(3);
    var_id_proveedor NUMBER(3);

    

    CURSOR proveedores(var_id_articulo NUMBER) IS
    SELECT com.id_proveedor FROM b_detalle_compras dcom
        INNER JOIN b_compras com ON dcom.id_compra = com.id
        WHERE dcom.id_articulo=var_id_articulo
        ORDER BY com.fecha DESC;


BEGIN
    FOR ARTICULO IN ARTICULOS
    LOOP
        cantidad_a_pedir_variable := ARTICULO.STOCK_MINIMO + ARTICULO.STOCK_MINIMO * 0.35;
        dbms_output.put_line('Cantidad a pedir: ' || cantidad_a_pedir_variable);
        -- mostrar el campo ultima_compra
        dbms_output.put_line('Fecha ultima compra: ' || ARTICULO.ULTIMA_COMPRA);
        -- recuperar el id del proveedor
        OPEN proveedores(ARTICULO.ID);
        FETCH proveedores INTO var_id_proveedor;
        -- mostrar el id del proveedor
        dbms_output.put_line('Id del proveedor: ' || var_id_proveedor);
        CLOSE proveedores;
    END LOOP;
END;