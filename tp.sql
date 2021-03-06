-- https://prod.liveshare.vsengsaas.visualstudio.com/join?11E0BF64C6A8A9917D3CB3085B56AB167AF6
-- SUCURSAL: CASA CENTRAL
SELECT * FROM D_SUCURSAL SUC 
WHERE SUC.DESC_SUCURSAL LIKE '%CASA CENTRAL%' ;


-- OPERACIONES: COMPRA
SELECT * FROM D_OPERACIONES OPE 
WHERE OPE.DESC_OPERACION LIKE '%COMPRA%' ;


-- MOVIMIENTO OPERACIONES: ULTIMA FECHA C/ TIPO REGISTRO = A
SELECT MAX(MVO.FECHA_OPERACION) AS MAX_FECHA
FROM D_MOVIMIENTO_OPERACIONES MVO
WHERE MVO.TIPO_REGISTRO = 'A';


-- ULTIMATE JOIN
SELECT MAX(DEO.ID_OPERACION) AS MAX_ID,
    DEO.ID_PRODUCTO AS ID_PRODUCTO,
    DEO.PRECIO_OPERACION AS PRECIO,
    MVO.FECHA_OPERACION AS FECHA_OPERACION
FROM D_MOVIMIENTO_OPERACIONES MVO
JOIN D_SUCURSAL SUC ON SUC.COD_SUCURSAL = MVO.COD_SUCURSAL
JOIN D_OPERACIONES OPE ON OPE.COD_OPERACION = MVO.COD_OPERACION
JOIN D_DETALLE_OPERACIONES DEO ON DEO.ID_OPERACION = MVO.ID_OPERACION
WHERE SUC.DESC_SUCURSAL LIKE '%CASA CENTRAL%' 
AND MVO.TIPO_REGISTRO = 'A'
GROUP BY 
    DEO.PRECIO_OPERACION, 
    DEO.ID_PRODUCTO, 
    FECHA_OPERACION
ORDER BY  MAX_ID DESC;

-- agregar despues
AND OPE.DESC_OPERACION LIKE '%COMPRA%'

