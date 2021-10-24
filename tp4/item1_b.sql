DECLARE
    TYPE detalle_operaciones IS TABLE OF D_DETALLE_OPERACIONES%ROWTYPE;
    v_detalle_operaciones detalle_operaciones;
    
    TYPE productos_medida_precio IS TABLE OF D_PRODUCTOS_MEDIDA_PRECIO%ROWTYPE;
    v_productos_medida_precio productos_medida_precio;
                
    -- Consulta interna
    consulta_productos VARCHAR(400);
    consulta_detalles VARCHAR(400);

    -- Input variables
    v_id_pago_operacion NUMBER;
    v_id_forma_pago NUMBER;

    j NUMBER;
    i NUMBER;
BEGIN
    -- test
    v_id_pago_operacion := 2;
    v_id_forma_pago := 1;

    -- Obtener detalle de operaciones
    -- parametros:
    --   id_operacion
    consulta_detalles := 'SELECT * 
    FROM D_DETALLE_OPERACIONES
    WHERE id_operacion = :1';
    
    EXECUTE IMMEDIATE consulta_detalles 
    BULK COLLECT INTO v_detalle_operaciones
    USING v_id_pago_operacion; -- id operacion

    i := v_detalle_operaciones.FIRST;
    WHILE i <= v_detalle_operaciones.LAST
        LOOP -- Se recorre el cursor de detalle_operaciones
            DBMS_OUTPUT.PUT_LINE('- Detalle operacion ------- id: ' || v_id_pago_operacion);
            DBMS_OUTPUT.PUT_LINE('ID Detalle: '||v_detalle_operaciones(i).id_registro);
            DBMS_OUTPUT.PUT_LINE('ID producto: '||v_detalle_operaciones(i).id_producto);
            DBMS_OUTPUT.PUT_LINE('Cod medida: '||v_detalle_operaciones(i).cod_medida);
            DBMS_OUTPUT.PUT_LINE('---------------------------');

            -- Obtener precio de producto
            -- parametros:
            --  id_producto
            --  cod_medida
            --  cod_forma_pago
            --  cod_sucursal
            consulta_productos := 'SELECT *
            FROM d_productos_medida_precio m
            WHERE m.id_producto = :1
                AND m.cod_medida = :2
                AND m.cod_forma_pago = :3
                AND m.cod_sucursal = (
                            SELECT cod_sucursal FROM d_movimiento_operaciones
                            WHERE id_operacion = :4
                        )';
                
            EXECUTE IMMEDIATE consulta_productos  
            BULK COLLECT INTO v_productos_medida_precio
                    USING v_detalle_operaciones(i).id_producto, 
                    v_detalle_operaciones(i).cod_medida,
                    v_id_forma_pago, 
                    v_id_pago_operacion;

            j := v_productos_medida_precio.FIRST;
            WHILE j <= v_productos_medida_precio.LAST LOOP -- Se recorre el cursor de productos_medida_precio
                DBMS_OUTPUT.PUT_LINE('----'||v_productos_medida_precio(j).id_producto);
                j:= v_productos_medida_precio.NEXT(j);
            END LOOP; 
        
        i:= v_detalle_operaciones.NEXT(i);
        END LOOP;
END;        
            
            
        