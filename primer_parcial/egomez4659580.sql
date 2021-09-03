-- ENUNCIADO 1
-- ITEM 1
CREATE TABLESPACE BDHISTORICO
    DATAFILE 'C:\app\eduar\product\18.0.0\oradata\BDHISTORICO.dbf' SIZE 100M 
    DEFAULT STORAGE (INITIAL 100M NEXT 50K)
ONLINE;

-- ITEM 2
-- Create a new relational table called "D_COMPRAS_X_ANIO"
CREATE TABLE D_COMPRAS_X_ANIO 
(
    ANIO NUMBER(4) NOT NULL,
    ID_PRODUCTO NUMBER(12) NOT NULL,
    CANTIDAD NUMBER(12,2) DEFAULT 0 NOT NULL,
    MONTO NUMBER(15) DEFAULT 0 NOT NULL,
    USUARIO_ACT VARCHAR2(30) DEFAULT USER NOT NULL,
    FECHA_ACT DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT D_COMPRAS_X_ANIO_PK PRIMARY KEY (ANIO, ID_PRODUCTO)
) TABLESPACE BDHISTORICO;

ALTER TABLE D_COMPRAS_X_ANIO ADD CONSTRAINT D_COMPRAS_X_ANIO_FK
FOREIGN KEY (ID_PRODUCTO)
REFERENCES D_PRODUCTOS (ID_PRODUCTO)
NOT DEFERRABLE;


-- Create a new relational table called "D_VENTAS_X_ANIO"
CREATE TABLE D_VENTAS_X_ANIO 
(
    ANIO NUMBER(4) NOT NULL,
    ID_PRODUCTO NUMBER(12) NOT NULL,
    CANTIDAD NUMBER(12,2) DEFAULT 0 NOT NULL,
    MONTO NUMBER(15) DEFAULT 0 NOT NULL,
    USUARIO_ACT VARCHAR2(30) DEFAULT USER NOT NULL,
    FECHA_ACT DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT D_VENTAS_X_ANIO_PK PRIMARY KEY (ANIO, ID_PRODUCTO)
) TABLESPACE BDHISTORICO;

ALTER TABLE D_VENTAS_X_ANIO ADD CONSTRAINT D_VENTAS_X_ANIO_FK
FOREIGN KEY (ID_PRODUCTO)
REFERENCES D_PRODUCTOS (ID_PRODUCTO)
NOT DEFERRABLE;



-- ITEM 3
ALTER TABLE D_PERSONAS ADD
(
    fecha_nacimiento date,
    fecha_alta date 
        DEFAULT SYSDATE NOT NULL, 
    monto_deuda  NUMBER(12) 
        DEFAULT 0 NOT NULL,
    limite_credito NUMBER(12) 
        DEFAULT 5000000 NOT NULL,
    tipo_persona varchar2(1) 
        DEFAULT 'F' NOT NULL
        CONSTRAINT tipo_persona_check
        CHECK (tipo_persona IN ('F', 'J'))
);

alter table D_PERSONAS 
    add constraint fecha_alta_check 
        check(fecha_nacimiento is not null and (fecha_alta > fecha_nacimiento))
    ENABLE NOVALIDATE;

-- ITEM 4
ALTER TABLE D_PERSONAS ADD
CONSTRAINT if_unique UNIQUE (ruc);

ALTER TABLE D_PERSONAS ADD CONSTRAINT persona_j 
    CHECK (tipo_persona = 'J' AND ruc is not null)
    ENABLE NOVALIDATE;

/*
* ENUNCIADO 2
*
*/
-- ITEM 2.A
BEGIN
    INSERT ALL
    WHEN tipo_operacion = 'COMPRA' THEN
        -- Cuando el tipo de operacion es COMPRA
        INTO D_COMPRAS_X_ANIO(ANIO, ID_PRODUCTO, CANTIDAD, MONTO)
        VALUES(ANHO, ID_PRODUCTO, CANTIDAD, MONTO)
    WHEN tipo_operacion = 'VENTA' THEN
        -- Cuando el tipo de operacion es VENTA
        INTO D_VENTAS_X_ANIO(ANIO, ID_PRODUCTO, CANTIDAD, MONTO)
        VALUES(ANHO, ID_PRODUCTO, CANTIDAD, MONTO)
    SELECT 
        to_number(to_char(movimiento.fecha_operacion, 'YYYY')) AS ANHO,
        producto.id_producto AS ID_PRODUCTO,
        sum(detalle.cantidad_operacion) AS CANTIDAD,
        sum(detalle.importe_operacion) AS MONTO,
        operacion.desc_operacion as tipo_operacion -- Tipo de operacion
    FROM 
        D_PRODUCTOS producto
    INNER JOIN 
        D_DETALLE_OPERACIONES detalle 
        ON producto.id_producto = detalle.id_producto
    INNER JOIN 
        D_MOVIMIENTO_OPERACIONES movimiento
        ON detalle.id_operacion = movimiento.id_operacion
    INNER JOIN 
        D_OPERACIONES operacion
        ON movimiento.cod_operacion = operacion.cod_operacion
    GROUP BY
        producto.id_producto,
        to_number(to_char(movimiento.fecha_operacion, 'YYYY')),
        operacion.desc_operacion
    ORDER BY
        to_number(to_char(movimiento.fecha_operacion, 'YYYY'));
END;

-- ITEM 2.B Y 2.C
DECLARE
    /*
    * Primer anio de compra => pa_anio_compra
    * Ultimo anio de compra => ua_anio_compra
    */
    pa_compras NUMBER(4) := 0;
    ua_compras NUMBER(4) := 0;
    pa_ventas NUMBER(4) := 0;
    ua_ventas NUMBER(4) := 0;
BEGIN
    -- Seleccionar anios de compras y ventas
    SELECT 
        nvl(min(compras.anio), 0),
        nvl(max(compras.anio), 0),
        nvl(min(ventas.anio), 0),
        nvl(max(ventas.anio), 0) 
        INTO 
            pa_compras, 
            ua_compras, 
            pa_ventas, 
            ua_ventas
    FROM D_VENTAS_X_ANIO ventas
    FULL OUTER JOIN D_COMPRAS_X_ANIO compras
    ON compras.anio = ventas.anio;

    -- Loop para compras
    FOR anio_actual IN pa_compras..ua_compras
    LOOP
        -- View anio
        DBMS_OUTPUT.put_line (anio_actual);

        DECLARE
            cantidad_compras NUMBER(4) := 0;
            producto_id VARCHAR2(100);
            producto_desc VARCHAR2(100);
        BEGIN
            -- Select cantidad de compras
            SELECT 
                id_producto,
                sum(cantidad)
            INTO 
                producto_id,
                cantidad_compras
            FROM 
                D_COMPRAS_X_ANIO
            WHERE 
                anio = anio_actual
            GROUP BY 
                id_producto
            ORDER BY 
                sum(cantidad) DESC
            fetch first 1 row only;

            -- Select descripcion del producto
            SELECT 
                desc_producto 
            INTO 
                producto_desc       
            FROM 
                D_PRODUCTOS
            WHERE 
                id_producto = producto_id;

            -- Muestra el mensaje
            DBMS_OUTPUT.put_line ('Mas comprado: '||producto_desc||': '||cantidad_compras);
        EXCEPTION
            -- Si no hay compras para el anio
            WHEN no_data_found THEN 
                dbms_output.put_line('No hubo compras en el año '||anio_actual); 
            WHEN others THEN 
                dbms_output.put_line('Error!'); 
        END;
    END LOOP;

    -- Loop para ventas
    FOR anio_actual IN pa_ventas..ua_ventas
    LOOP
        -- View anio
        DBMS_OUTPUT.put_line (anio_actual);

        DECLARE
            cantidad_ventas NUMBER(4) := 0;
            producto_id VARCHAR2(100);
            producto_desc VARCHAR2(100);
        BEGIN
            -- Select cantidad de ventas
            SELECT 
                id_producto,
                sum(cantidad)
            INTO 
                producto_id,
                cantidad_ventas
            FROM 
                D_VENTAS_X_ANIO
            WHERE 
                anio = anio_actual
            GROUP BY 
                id_producto
            ORDER BY 
                sum(cantidad) DESC
            fetch first 1 row only;

            -- Select descripcion del producto
            SELECT 
                desc_producto 
            INTO 
                producto_desc       
            FROM 
                D_PRODUCTOS
            WHERE 
                id_producto = producto_id;

            -- Muestra el mensaje
            DBMS_OUTPUT.put_line ('Mas vendido: '||producto_desc||': '||cantidad_ventas);
        EXCEPTION
            -- Si no hay ventas para el anio
            WHEN no_data_found THEN 
                dbms_output.put_line('No hubo ventas en el año '||anio_actual); 
            WHEN others THEN 
                dbms_output.put_line('Error!'); 
        END;
    END LOOP;
END;


/*
* ENUNCIADO 3
*
*/
-- vista materializada
CREATE MATERIALIZED VIEW V_TARJETA
BUILD IMMEDIATE
REFRESH START WITH TRUNC(SYSDATE) NEXT TRUNC(ADD_MONTHS(SYSDATE,1), 'MONTH')+1/24
AS
    SELECT 
        count(distinct 
            CASE
                WHEN f_pago.desc_forma_pago = 'TARJETA DE LA CASA' 
                THEN persona.id_persona
            END
        ) AS "CLIENTES NUESTRA TARJETA",
        sum(
            CASE
                WHEN f_pago.desc_forma_pago = 'TARJETA DE LA CASA'
                THEN detalle.importe_operacion
            END
        ) AS "MONTO NUESTRA TARJETA",
        count(distinct 
            CASE
                WHEN f_pago.desc_forma_pago NOT LIKE 'TARJETA DE LA CASA' 
                THEN persona.id_persona
            END
        ) AS "CLIENTES OTROS MEDIOS",
        sum(
            CASE
                WHEN f_pago.desc_forma_pago NOT LIKE 'TARJETA DE LA CASA'
                THEN detalle.importe_operacion
            END
        ) AS "MONTO OTROS MEDIOS"
    FROM 
        D_PERSONAS persona
    INNER JOIN 
        D_MOVIMIENTO_OPERACIONES movimiento
        ON persona.ID_PERSONA = movimiento.ID_PERSONA
    INNER JOIN 
        D_DETALLE_OPERACIONES detalle
        ON movimiento.id_operacion = detalle.id_operacion
    INNER JOIN 
        D_PAGO_OPERACION pago
        ON movimiento.id_operacion = pago.id_operacion
    INNER JOIN 
        D_FORMA_PAGO f_pago
        ON pago.cod_forma_pago = f_pago.cod_forma_pago;

-- 4659580 - Eduardo Gomez - 02/09/2021