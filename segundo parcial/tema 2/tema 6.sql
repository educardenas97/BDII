/*
a. Obtiene la descripción de la operación y la descripción de la forma de pago, y las guarda en variables
de paquete.
*/

CREATE OR REPLACE TRIGGER D_PAGO_OPERACION_TRIGEGER
AFTER INSERT D_PAGO_OPERACION
DECLARE
    v_desc_operacion VARCHAR2(100);
    v_desc_forma_pago VARCHAR2(100);

BEGIN
    -- descripcion operacion
    SELECT mo.descripcion_operacion INTO v_desc_operacion FROM D_PAGO_OPERACION PA 
    INNER JOIN D_MOVIMIENTO_OPERACIONES MO ON mo.id_operacion = pa.id_operacion
    WHERE pa.id_operacion = :NEW.id_operacion
        AND pa.cod_forma_pago = :NEW.cod_forma_pago;
    
    paquete.descripcion_operacion = v_desc_operacion;
    -- descripcion forma pago
    SELECT fp.desc_forma_pago INTO v_desc_forma_pago FROM D_PAGO_OPERACION PA
    INNER JOIN D_FORMA_PAGO FP ON fp.cod_forma_pago = pa.cod_forma_pago
    WHERE pa.id_operacion = :NEW.id_operacion 
        AND pa.cod_forma_pago = :NEW.cod_forma_pago;

    paquete.desc_forma_pago = v_desc_forma_pago;

END D_PAGO_OPERACION_TRIGEGER;

/* Creacion del paquete */
CREATE PACKAGE paquete IS
    descripcion_operacion VARCHAR2(100);
    desc_forma_pago VARCHAR2(100);
END;