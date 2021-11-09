DECLARE
    CURSOR ARTICULOS IS
    SELECT * FROM B_ARTICULOS
        WHERE STOCK_ACTUAL < STOCK_MINIMO;

    CURSOR proveedores(var_id_articulo NUMBER) IS
    SELECT com.id_proveedor FROM b_detalle_compras dcom
        INNER JOIN b_compras com ON dcom.id_compra = com.id
        WHERE dcom.id_articulo=var_id_articulo
        ORDER BY com.fecha DESC;

    cantidad_a_pedir_variable NUMBER(4);
    id_provendedor_variable NUMBER(4);
    var_id_proveedor NUMBER(4);

    TYPE articulo_proveedor IS RECORD(
        id_articulo NUMBER(2),
        nombre VARCHAR2(5),
        cantidad_a_pedir NUMBER(4),
        id_proveedor NUMBER(4)
    );

    var_articulo_proveedor articulo_proveedor;

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

        -- insertar registro
        var_articulo_proveedor.id_articulo := ARTICULO.ID;
        var_articulo_proveedor.nombre := ARTICULO.NOMBRE;
        var_articulo_proveedor.cantidad_a_pedir := cantidad_a_pedir_variable;
        var_articulo_proveedor.id_proveedor := var_id_proveedor;
        
        -- insertar var_articulo_proveedor en la tabla reposicion
        INSERT INTO REPOSICION
            (
                CODIGO_ARTICULO, 
                NOMBRE_ARTICULO, 
                CANTIDAD_A_PEDIR, 
                ID_PROVENDEDOR
            )
        VALUES
            (
                var_articulo_proveedor.id_articulo, 
                var_articulo_proveedor.nombre, 
                var_articulo_proveedor.cantidad_a_pedir, 
                var_articulo_proveedor.id_proveedor
            );

    END LOOP;
END;