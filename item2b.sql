SELECT 
    P.ID_PRODUCTO + 
        (SELECT (MAX(ID_REGISTRO) + 1) 
            FROM D_PRODUCTOS_MEDIDA_PRECIO) 
        AS ID_REGISTRO, 
    (P.PRECIO_ULTIMA_COMPRA + 
        (P.PRECIO_ULTIMA_COMPRA * (P.PORCENTAJE_BENEFICIO/100)) - 
        (P.PRECIO_ULTIMA_COMPRA * 
            (
                (SELECT FPG.PORCENTAJE_DESCUENTO 
                FROM D_FORMA_PAGO FPG 
                WHERE FPG.DESC_FORMA_PAGO = 'CONTADO OUTLET'
                )/100
            )
        )
    ) AS PRECIO_VENTA,
    P.ID_PRODUCTO 
        AS ID_PRODUCTO,
    (SELECT MED.COD_MEDIDA FROM D_MEDIDA MED
        WHERE MED.DESC_MEDIDA = 'UNIDADES')
        AS COD_MEDIDA,
    (SELECT SUC.COD_SUCURSAL FROM D_SUCURSAL SUC
        WHERE SUC.DESC_SUCURSAL = 'TIENDA OUTLET')
        AS COD_SUCURSAL,
    (SELECT FP.COD_FORMA_PAGO FROM D_FORMA_PAGO FP
        WHERE FP.DESC_FORMA_PAGO = 'CONTADO OUTLET')
        AS FORMA_PAGO
FROM D_PRODUCTOS P
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
    );


