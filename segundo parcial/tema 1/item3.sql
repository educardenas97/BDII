CREATE OR REPLACE TYPE BODY T_FACTURA IS
    STATIC FUNCTION INSTANCIAR_FACTURA(id_operacion NUMBER) RETURN T_FACTURA IS
        v_cantidad_registros NUMBER;

        TYPE detalles IS TABLE OF T_DETALLE INDEX BY BINARY_INTEGER;
        v_detalles detalles;
        i NUMBER;

        movimiento D_MOVIMIENTO_OPERACIONES%ROWTYPE;

        CURSOR c_detalle IS
            SELECT DOP.*, PRO.DESC_PRODUCTO, PRO.PRECIO_ULTIMA_COMPRA, MED.DESC_MEDIDA FROM D_DETALLE_OPERACIONES DOP
            JOIN D_PRODUCTOS PRO ON PRO.ID_PRODUCTO = DOP.ID_PRODUCTO
            JOIN D_MEDIDA MED ON MED.COD_MEDIDA = DOP.COD_MEDIDA
            WHERE id_operacion = id_operacion;

        v_t_factura T_FACTURA;
    BEGIN
        -- Verifica en la tabla D_MOVIMIENTO_OPERACIONES que el ID de operación exista. 
        SELECT COUNT(*) INTO v_cantidad_registros FROM D_MOVIMIENTO_OPERACIONES WHERE ID_OPERACION = id_operacion;
        IF v_cantidad_registros = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'El ID de operación no existe.');
        END IF;

        -- Verifica que se trate de una operación de VENTA. Si no se cumple alguna esta condición, ya no realiza la instanciación
        SELECT count(mop.id_operacion) INTO v_cantidad_registros FROM D_MOVIMIENTO_OPERACIONES MOP
        INNER JOIN D_OPERACIONES OP ON OP.cod_operacion = mop.cod_operacion
        WHERE op.desc_operacion = 'VENTA' AND ID_OPERACION = id_operacion;
        IF v_cantidad_registros = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'La operación no es de tipo VENTA.');
        ELSE
            -- instancia un objeto del tipo T_FACTURA con los datos del movimiento y el detalle de la factura
            SELECT * INTO movimiento FROM D_MOVIMIENTO_OPERACIONES WHERE ID_OPERACION = id_operacion;
            
            v_detalles := detalles();
            i := 1;
            FOR detalle IN c_detalle LOOP
                -- Agrega un nuevo elemento al arreglo de detalles
                v_detalles(i).DESC_PRODUCTO := detalle.DESC_PRODUCTO;
                v_detalles(i).DESC_UNIDAD_MEDIDA := detalle.DESC_MEDIDA;
                v_detalles(i).CANTIDAD := detalle.CANTIDAD_OPERACION;
                v_detalles(i).PRECIO_ULTIMA_COMPRA := detalle.PRECIO_ULTIMA_COMPRA;
                v_detalles(i).PRECIO := detalle.PRECIO_OPERACION;
                v_detalles(i).IMPORTE_OPERACION := detalle.IMPORTE_OPERACION;
                v_detalles(i).RECARGO_DESCUENTO := detalle.IMPORTE_RECARGO;
                v_detalles(i).PORCENTAJE_IVA := detalle.PORCENTAJE_IVA;
                v_detalles(i).IMPORTE_IVA := detalle.IMPORTE_IVA;
            END LOOP;

            -- Se instancia el objeto T_FACTURA con los datos del movimiento y el detalle de la factura
            v_t_factura := T_FACTURA(movimiento.NRO_TIMBRADO, movimiento.NRO_COMPROBANTE, movimiento.FECHA_OPERACION, NULL, NULL, NULL, NULL, NULL, v_detalles);

            RETURN v_t_factura;

        END IF;        

    END INSTANCIAR_FACTURA;

END;