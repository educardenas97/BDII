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