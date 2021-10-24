--create trigger item1 after insert on item1
CREATE OR REPLACE TRIGGER item1
    AFTER INSERT ON D_PAGO_OPERACION
    DECLARE
        v_id_pago_operacion integer;
        v_id_forma_pago integer;
        CURSOR detalle_operaciones IS 
            SELECT * FROM D_DETALLE_OPERACIONES
            WHERE id_operacion = NEW.id_operacion;

        -- Sumatoria
        v_importe_total_descuento float;
        v_importe_total_recargo float;
        v_importe_total_operacion float;
    BEGIN
        v_id_pago_operacion := NEW.id_operacion;
        v_id_forma_pago := NEW.cod_forma_pago;

        -- ii. Recorre la tabla D_DETALLE_OPERACIONES correspondiente a la operación que se paga
        for registro in detalle_operaciones loop -- Se recorre el cursor de detalle_operaciones
            DECLARE
                CURSOR c_precio_venta IS
                    SELECT m.precio_venta as precio_venta FROM d_productos_medida_precio m
                    WHERE m.id_producto = registro.id_producto
                        AND m.cod_medida = registro.cod_medida
                        AND m.cod_forma_pago = v_id_forma_pago
                        AND m.cod_sucursal = (
                            SELECT cod_sucursal FROM d_movimiento_operaciones
                            WHERE id_operacion = v_id_pago_operacion
                        );

                v_precio_operacion float;
                v_importe_descuento float;
                v_importe_recargo float;
                v_importe_operacion float;
                v_importe_iva float;

                v_porcentaje_descuento float;
                v_porcentaje_recargo float;
                v_porcentaje_iva float;
                v_divisor_iva float;

 

            BEGIN
                v_precio_operacion := c_precio_venta.precio_venta;

                -- Porcentaje descuento
                SELECT porcentaje_descuento INTO v_porcentaje_descuento 
                    FROM d_forma_pago WHERE cod_forma_pago = v_id_forma_pago;
                v_importe_descuento := (v_precio_operacion * registro.cantidad_producto) * (v_porcentaje_descuento)/100;

                -- Porcentaje recargo                
                SELECT porcentaje_recargo INTO v_porcentaje_recargo
                    FROM d_forma_pago WHERE cod_forma_pago = v_id_forma_pago;
                v_importe_recargo := (v_precio_operacion * registro.cantidad_producto) * (v_porcentaje_recargo)/100;
                
                -- Importe operación
                v_importe_operacion := v_precio_operacion * registro.cantidad_producto;

                -- Importe IVA
                SELECT divisor_iva_incluido INTO v_divisor_iva
                    FROM d_tipo_iva WHERE cod_tipo_iva = registro.cod_tipo_iva;
                v_importe_iva := (v_importe_operacion - v_importe_descuento + v_importe_recargo) / v_divisor_iva;

                -- Update de valores en la tabla D_DETALLE_OPERACIONES
                UPDATE d_detalle_operaciones 
                SET precio_operacion = c_precio_venta.precio_venta,
                    importe_descuento = v_importe_descuento,
                    importe_recargo = v_importe_recargo,
                    importe_operacion = v_importe_operacion,
                    importe_iva = v_importe_iva
                WHERE id_registro = registro.id_registro;

                -- Sumatoria
                v_importe_total_operacion := v_importe_total_operacion + v_importe_operacion;
                v_importe_total_descuento := v_importe_total_descuento + v_importe_descuento;
                v_importe_total_recargo := v_importe_total_recargo + v_importe_recargo;
            END;
        end loop; 

        -- Update de valores en la tabla D_PAGO_OPERACION
        UPDATE d_pago_operacion
            SET importe_pago = (
                v_importe_total_operacion + 
                v_importe_total_recargo - 
                v_importe_total_descuento)
            WHERE m.id_producto = registro.id_producto
                        AND m.cod_medida = registro.cod_medida
                        AND m.cod_forma_pago = v_id_forma_pago
                        AND m.cod_sucursal = (
                            SELECT cod_sucursal FROM d_movimiento_operaciones
                            WHERE id_operacion = v_id_pago_operacion)
                        );

END item1;



