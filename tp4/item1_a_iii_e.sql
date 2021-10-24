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