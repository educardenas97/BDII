/*
1. El tipo tabla anidada TAB_DETALLE, compuesta de objetos con los siguientes atributos:
*/

TYPE TAB_DETALLE IS OBJECT(
	DESC_PRODUCTO VARCHAR2(80),
    DESC_UNIDAD_MEDIDA VARCHAR2(30),
    CANTIDAD NUMBER(12,2),
    PRECIO_ULTIMA_COMPRA NUMBER(12,2),
    PRECIO NUMBER(12),
    IMPORTE_OPERACION NUMBER(12),
    RECARGO_DESCUENTO NUMBER(10),
    PORCENTAJE_IVA NUMBER(3),
    IMPORTE_IVA NUMBER(10)
);

/*
El tipo T_FACTURA como un objeto con los siguientes elementos:
*/
CREATE OR REPLACE TYPE T_FACTURA AS OBJECT(
    TIMBRADO NUMBER(12),
    NRO_COMPROBANTE VARCHAR2(20),
    FECHA_FACTURA DATE,
    NOMBRE_CLIENTE VARCHAR2(80),
    RUC_CEDULA VARCHAR2(20),
    MONTO_FACTURA NUMBER(12),
    MONTO_IVA NUMBER(10),
    CONTABILIZADO VARCHAR2(1),
    DETALLE_FACTURA TAB_DETALLE,
    STATIC FUNCTION INSTANCIAR_FACTURA(id_operacion NUMBER) RETURN T_FACTURA,
    MEMBER PROCEDURE ASIGNAR_MONTOS
);

/*
En el body de T_FACTURA:
3. La función estática INSTANCIAR_FACTURA, realiza lo siguiente:
 Verifica en la tabla D_MOVIMIENTO_OPERACIONES que el ID de operación exista. Si no existe,
da un mensaje de error.
 Verifica que se trate de una operación de VENTA. Si no se cumple alguna esta condición, ya no realiza
la instanciación
 Si el movimiento existe y es una venta, instancia un objeto del tipo T_FACTURA con los datos del
movimiento y el detalle de la factura. Note que en el detalle de la factura debe asignar la descripción
del producto y la descripción de la unidad de medida. En RECARGO_DESCUENTO va el recargo
con signo positivo y el descuento con signo negativo. El PRECIO_ULTIMA_COMPRA, deberá
buscarlo del producto
*/

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


/*
El procedimiento miembro ASIGNAR_MONTOS deberá recorrer los elementos del atributo
DETALLE_FACTURA, y sumar el importe operación +/- descuento o recargo según corresponda.
También deberá sumar por separado el IMPORTE_IVA, y asignar los atributos MONTO_FACTURA y
MONTO_IVA respectivamente.
*/
MEMBER PROCEDURE ASIGNAR_MONTOS IS
    V_IMPORTE_IVA NUMBER;
    V_MONTO_FACTURA NUMBER;
    V_IMPORTE_DESCUENTO NUMBER;
    V_IMPORTE_OPERACION NUMBER;
    BEGIN
        -- se recorre el arreglo de facturas
        FOR detalle IN SELF.DETALLE_FACTURA LOOP
            V_IMPORTE_OPERACION := V_IMPORTE_OPERACION + detalle.IMPORTE_OPERACION;
            V_IMPORTE_IVA := V_IMPORTE_IVA + detalle.IMPORTE_IVA;
            V_IMPORTE_DESCUENTO := V_IMPORTE_DESCUENTO + detalle.RECARGO_DESCUENTO;
        END LOOP;
        -- se asignan a la instancia del objeto
        SELF.MONTO_FACTURA := V_IMPORTE_OPERACION - V_IMPORTE_DESCUENTO + V_IMPORTE_IVA;
        SELF.MONTO_IVA := V_IMPORTE_IVA;
    END;
END get_address;


/*
Cree la tabla FACTURAS_VENTA como una tabla relacional compuesta de elementos T_FACTURA 
*/
CREATE TABLE FACTURAS_VENTA OF T_FACTURA NESTED TABLE DETALLE_FACTURA STORE AS F_DET;


/*
TEMA 2
6.a. Obtiene la descripción de la operación y la descripción de la forma de pago, y las guarda en variables
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



/*
7. Cuando se inserta un registro en la tabla FACTURAS_VENTA
a. Verifica que el número de comprobante no sea repetido
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
