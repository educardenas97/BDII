-------------------------------------------
CREATE OR REPLACE TRIGGER item1_a_i
    AFTER INSERT ON D_PAGO_OPERACION
    FOR EACH ROW
    DECLARE 
        TYPE pago_operacion IS TABLE OF d_pago_operacion%ROWTYPE; 
        v_pago_operacion pago_operacion; 

    BEGIN
        SELECT * 
        BULK COLLECT INTO v_pago_operacion 
        FROM d_pago_operacion
        WHERE id_operacion = :new.id_operacion;

        IF v_pago_operacion.COUNT > 0 THEN
            dbms_output.put_line('Movimiento ya pagado');
        END IF;

END item1_a;

---------------------------------------------------
CREATE OR REPLACE TRIGGER item1_a_iii
    AFTER INSERT ON D_PAGO_OPERACION
    FOR EACH ROW
DECLARE
    -- Tablas a recorrer
    TYPE detalle_operaciones IS TABLE OF D_DETALLE_OPERACIONES%ROWTYPE;
    v_detalle_operaciones detalle_operaciones;
    
    TYPE productos_medida_precio IS TABLE OF D_PRODUCTOS_MEDIDA_PRECIO%ROWTYPE;
    v_productos_medida_precio productos_medida_precio;

    -- Porcentajes
    TYPE FORMA_PAGO IS TABLE OF D_FORMA_PAGO%ROWTYPE;
    porcentaje FORMA_PAGO;

    TYPE TIPO_IVA IS TABLE OF D_TIPO_IVA%ROWTYPE;
    divisor TIPO_IVA;

    -- Consulta interna
    consulta_productos VARCHAR(500);
    consulta_detalles VARCHAR(400);
    consulta_porcentajes VARCHAR(400);
    consulta_update VARCHAR(400);
    -- Input variables
    v_id_pago_operacion NUMBER;
    v_id_forma_pago NUMBER;

    -- Indices
    j NUMBER;
    i NUMBER;

    -- Variables de proceso
    precio_operacion NUMBER;
    importe_descuento NUMBER;
    importe_recargo NUMBER;
    importe_operacion NUMBER;
    importe_iva NUMBER;

    -- Sumatoria
    sum_importe_operacion NUMBER;
    sum_importe_descuento NUMBER;
    sum_importe_recargo NUMBER;
BEGIN
    -- test
    v_id_pago_operacion := :NEW.id_operacion;
    v_id_forma_pago := :NEW.cod_forma_pago;
    ---------

    --
    sum_importe_operacion := 0;
    sum_importe_descuento := 0;
    sum_importe_recargo := 0;
    --

    -- Obtener detalle de operaciones
    -- parametros:
    --   id_operacion
    consulta_detalles := 'SELECT * 
    FROM D_DETALLE_OPERACIONES
    WHERE id_operacion = :1';
    
    EXECUTE IMMEDIATE consulta_detalles 
    BULK COLLECT INTO v_detalle_operaciones
    USING v_id_pago_operacion; 

    i := v_detalle_operaciones.FIRST;
    WHILE i <= v_detalle_operaciones.LAST
        LOOP -- Se recorre el cursor de detalle_operaciones
           
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
                    SELECT COD_SUCURSAL FROM D_MOVIMIENTO_OPERACIONES
                    WHERE ID_OPERACION = :4
                )';

            EXECUTE IMMEDIATE consulta_productos  
            BULK COLLECT INTO v_productos_medida_precio
                    USING v_detalle_operaciones(i).id_producto, 
                    v_detalle_operaciones(i).cod_medida,
                    v_id_forma_pago,
                    v_detalle_operaciones(i).id_operacion;

            -- Obtener porcentajes de forma de pago
            consulta_porcentajes := 'SELECT *
                    FROM d_forma_pago WHERE cod_forma_pago = :1';
            
            EXECUTE IMMEDIATE consulta_porcentajes
            BULK COLLECT INTO porcentaje
            USING v_id_forma_pago;

            -- Obtener divisor de iva
            consulta_porcentajes := 'SELECT *
                    FROM d_tipo_iva WHERE cod_tipo_iva = :1';

            EXECUTE IMMEDIATE consulta_porcentajes 
            BULK COLLECT INTO divisor
            USING v_detalle_operaciones(i).cod_tipo_iva;

            j := v_productos_medida_precio.FIRST;
            WHILE j <= v_productos_medida_precio.LAST LOOP -- Se recorre el cursor de productos_medida_precio
                DBMS_OUTPUT.PUT_LINE('- Detalle operacion ------- id: ' || v_detalle_operaciones(i).id_operacion);
                DBMS_OUTPUT.PUT_LINE('ID producto: '||v_detalle_operaciones(i).id_producto);
                DBMS_OUTPUT.PUT_LINE('Cantidad: '||v_detalle_operaciones(i).cantidad_operacion);
                DBMS_OUTPUT.PUT_LINE('iva: '||divisor(divisor.first).divisor_iva_incluido);

                --b.1
                precio_operacion := v_productos_medida_precio(j).precio_venta;
                --b.2
                importe_descuento := (precio_operacion * v_detalle_operaciones(i).cantidad_operacion) * (porcentaje(porcentaje.FIRST).porcentaje_descuento / 100);
                --b.3
                importe_recargo := (precio_operacion * v_detalle_operaciones(i).cantidad_operacion) * (porcentaje(porcentaje.FIRST).porcentaje_recargo / 100);
                --b.4
                importe_operacion := precio_operacion * v_detalle_operaciones(i).cantidad_operacion;
                --b.5
                importe_iva := (importe_operacion - importe_descuento + importe_recargo) / (divisor(divisor.FIRST).divisor_iva_incluido);

                DBMS_OUTPUT.PUT_LINE('Producto_medida_precio------');
                DBMS_OUTPUT.PUT_LINE('--- Precio: '||v_productos_medida_precio(j).precio_venta);
                DBMS_OUTPUT.PUT_LINE('--- Importe descuento: '||importe_descuento);
                DBMS_OUTPUT.PUT_LINE('--- Importe recargo: '||importe_recargo);
                DBMS_OUTPUT.PUT_LINE('--- Importe operacion: '||importe_operacion);
                DBMS_OUTPUT.PUT_LINE('--- Importe iva: '||importe_iva);
                DBMS_OUTPUT.PUT_LINE('---------------------------');
                
                -- Sumatoria
                sum_importe_operacion := sum_importe_operacion + importe_operacion;
                sum_importe_descuento := sum_importe_descuento + importe_descuento;
                sum_importe_recargo := sum_importe_recargo + importe_recargo;

                j:= v_productos_medida_precio.NEXT(j);
            END LOOP; 

            IF sum_importe_operacion <> 0 THEN
                -- mostrar sumatoria
                DBMS_OUTPUT.PUT_LINE('Sumatoria');
                DBMS_OUTPUT.PUT_LINE('--- Importe recargo: '||sum_importe_recargo);
                DBMS_OUTPUT.PUT_LINE('--- Importe operacion: '||sum_importe_operacion);
                DBMS_OUTPUT.PUT_LINE('--- Importe descuento: '||sum_importe_descuento);
                -- reset sumatoria
                sum_importe_operacion := 0;
                sum_importe_descuento := 0;
                sum_importe_recargo := 0;
                DBMS_OUTPUT.PUT_LINE('---------------------------');
                DBMS_OUTPUT.PUT_LINE(' ');
                -- update importe_operacion en la tabla d_pago_operacion
                consulta_update := 'UPDATE D_PAGO_OPERACION
                SET IMPORTE_PAGO = :1
                WHERE ID_OPERACION = :2';
                EXECUTE IMMEDIATE consulta_update
                USING sum_importe_operacion, v_detalle_operaciones(i).id_operacion;
            END IF;

            i:= v_detalle_operaciones.NEXT(i);
        END LOOP;
END;

-------------------------------------------
CREATE OR REPLACE TRIGGER item1_a_iii_d
    BEFORE INSERT ON D_PAGO_OPERACION
    FOR EACH ROW WHEN (NEW.NRO_REFERENCIA_PAGO IS NULL)
    DECLARE
        v_require_nro_comprobante NUMBER;
    BEGIN
        SELECT requiere_nro_comprobante INTO v_require_nro_comprobante
        FROM D_FORMA_PAGO
        WHERE COD_FORMA_PAGO = :NEW.COD_FORMA_PAGO;

        if v_require_nro_comprobante = 1 then
            dbms_output.put_line('El tipo de forma de pago seleccionado requiere un número de comprobante.');
        end if;
    END;

-------------------------------------------
CREATE OR REPLACE TRIGGER item1_a_iii_e
    BEFORE INSERT ON D_PAGO_OPERACION
    FOR EACH ROW WHEN (NEW.NRO_CUENTA IS NULL OR NEW.NRO_CHEQUE IS NULL OR COD_BANCO IS NULL)
    DECLARE
        forma_pago NUMBER;
    BEGIN
        SELECT desc_forma_pago INTO forma_pago
        FROM D_FORMA_PAGO
        WHERE COD_FORMA_PAGO = :NEW.COD_FORMA_PAGO;

        if forma_pago = 'CHEQUE' then
            dbms_output.put_line('El tipo de forma de pago seleccionado requiere un número NRO_CUENTA y NRO_CHEQUE.');
        end if;
    END;


------------------------------------------
CREATE OR REPLACE TRIGGER T_PAGOS
BEFORE DELETE OR UPDATE ON D_PAGO_OPERACION
FOR EACH ROW
BEGIN
    IF DELETING OR UPDATING THEN
       RAISE_APPLICATION_ERROR(-20011,'NO SE PERMITE ELIMINAR DATOS DE ESTA TABLA');
    END IF; 
END;
/

-------------------------------------------
CREATE OR REPLACE TRIGGER NO_MODIFICAR_DETALLE_OPERACIONES
BEFORE DELETE OR UPDATE ON D_DETALLE_OPERACIONES
FOR EACH ROW
DECLARE
    V_ID_OPERACION NUMBER(12) := 0;
BEGIN
    SELECT ID_OPERACION INTO V_ID_OPERACION FROM D_PAGO_OPERACION
    WHERE ID_OPERACION = :NEW.ID_OPERACION;

    IF V_ID_OPERACION > 0 THEN
         RAISE_APPLICATION_ERROR(-2009,'NO SE PERMITE MODIFICAR O ELIMINAR DATOS DE ESTA TABLA');
    END IF;

EXCEPTION WHEN NO_DATA_FOUND THEN
    NULL;
END;
