DECLARE
    TYPE detalle_operaciones IS TABLE OF D_DETALLE_OPERACIONES%ROWTYPE;
    v_detalle_operaciones detalle_operaciones;
    
    TYPE productos_medida_precio IS TABLE OF D_PRODUCTOS_MEDIDA_PRECIO%ROWTYPE;
    v_productos_medida_precio productos_medida_precio;
                
    -- Consulta interna
    consulta_productos VARCHAR(200);
    consulta_detalles VARCHAR(200);

    j NUMBER;
    i NUMBER;
BEGIN

    -- Obtener detalle de operaciones
    consulta_detalles := 'SELECT * 
    FROM D_DETALLE_OPERACIONES
    WHERE id_producto = :1';
    
    EXECUTE IMMEDIATE consulta_detalles 
    BULK COLLECT INTO v_detalle_operaciones
    USING 20;

    i := v_detalle_operaciones.FIRST;
    WHILE i <= v_detalle_operaciones.LAST
        LOOP -- Se recorre el cursor de detalle_operaciones
            DBMS_OUTPUT.PUT_LINE('---------------------------');
            DBMS_OUTPUT.PUT_LINE(''||v_detalle_operaciones(i).id_producto);
            DBMS_OUTPUT.PUT_LINE(''||v_detalle_operaciones(i).cod_medida);
            DBMS_OUTPUT.PUT_LINE('---------------------------');


            consulta_productos := 'SELECT *
            FROM d_productos_medida_precio m
            WHERE m.id_producto = :1
                AND m.cod_medida = :2';
                
            EXECUTE IMMEDIATE consulta_productos  
            BULK COLLECT INTO v_productos_medida_precio
                    USING v_detalle_operaciones(i).id_producto, v_detalle_operaciones(i).cod_medida;
                    
                            
            j := v_productos_medida_precio.FIRST;
            WHILE j <= v_productos_medida_precio.LAST LOOP
                DBMS_OUTPUT.PUT_LINE('----'||v_productos_medida_precio(j).id_producto);
                j:= v_productos_medida_precio.NEXT(j);
            END LOOP; 
        
        i:= v_detalle_operaciones.NEXT(i);
        END LOOP;
END;        
            
            
        