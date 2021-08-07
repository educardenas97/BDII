-- INSERT INTO D_FORMA_PAG
INSERT INTO D_FORMA_PAGO (
    COD_FORMA_PAGO, 
    DESC_FORMA_PAGO, 
    REQUIERE_NRO_COMPROBANTE,
    PORCENTAJE_DESCUENTO,
    PORCENTAJE_RECARGO
) VALUES (
    (SELECT MAX(COD_FORMA_PAGO) FROM D_FORMA_PAGO)+1,
    'CONTADO OUTLET', 
    1, 
    30, 
    0
);

-- INSERT INTO D_PRODUCTOS_MEDIDA_PRECIO
INSERT INTO D_PRODUCTOS_MEDIDA_PRECIO (
    ID_REGISTRO,
    PRECIO_VENTA,
    ID_PRODUCTO,
    COD_MEDIDA,
    COD_SUCURSAL,
    COD_FORMA_PAGO
) VALUES (

)
  


-- CONDICIONALES
-------------------
-- ID_PRODUCTO
SELECT DDO.ID_PRODUCTO FROM D_DETALLE_OPERACIONES DDO
WHERE DDO.ID_PRODUCTO NOT IN ((SELECT DDO.ID_PRODUCTO
FROM D_MOVIMIENTO_OPERACIONES MVO
INNER JOIN D_DETALLE_OPERACIONES DDO ON DDO.ID_OPERACION = MVO.ID_OPERACION
WHERE (SYSDATE - MVO.FECHA_OPERACION) < 30));
-------------------
-- SUBQUERY PARA ARTICULOS
(SELECT DDO.ID_PRODUCTO
FROM D_MOVIMIENTO_OPERACIONES MVO
INNER JOIN D_DETALLE_OPERACIONES DDO ON DDO.ID_OPERACION = MVO.ID_OPERACION
WHERE (SYSDATE - MVO.FECHA_OPERACION) < 365)

-- SUBQUERY PARA ID
-- GET MAX ID FROM D_PRODUCTO_MEDIDA_PRECIO
(SELECT MAX(ID_REGISTRO) + 1 + ID_PRODUCTO FROM D_PRODUCTOS_MEDIDA_PRECIO);


-- SUBQUERY PARA PRECIO_VENTA
SELECT P.PRECIO_ULTIMA_COMPRA FROM D_PRODUCTOS P
WHERE P.ID_PRODUCTO IN 
    (
        SELECT DDO.ID_PRODUCTO FROM D_DETALLE_OPERACIONES DDO
        WHERE DDO.ID_PRODUCTO NOT IN (
            (
            SELECT DDO.ID_PRODUCTO
            FROM D_MOVIMIENTO_OPERACIONES MVO
            INNER JOIN D_DETALLE_OPERACIONES DDO ON DDO.ID_OPERACION = MVO.ID_OPERACION
            WHERE (SYSDATE - MVO.FECHA_OPERACION) < 30
            )
        )
    )



-- GET DESCUENTO FROM D_FORMA_PAGO WHERE COD_DESCRIPCION = 'CONTADO OUTLET'
SELECT FPG.PORCENTAJE_DESCUENTO FROM D_FORMA_PAGO FPG 
WHERE FPG.DESC_FORMA_PAGO = 'CONTADO OUTLET';

