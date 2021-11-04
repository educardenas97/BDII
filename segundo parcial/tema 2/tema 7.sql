/*
Verifica que el número de comprobante no sea repetido.
*/
CREATE OR REPLACE TRIGGER FACTURAS_VENTA_TRIGGER
BEFORE INSERT FACTURAS_VENTA
DECLARE
    V_NUMERO_COMPROBANTE VARCHAR2(20);
BEGIN
    SELECT nro_comprobante INTO v_numero_comprobante FROM D_MOVIMIENTO_OPERACIONES
        WHERE id_operacion = :new.id_operacion;

    IF v_numero_comprobante = new.nro_comprobante THEN
        RAISE_APPLICATION_ERROR(-20001, 'El número de comprobante ya existe.');
    END IF;
END;
