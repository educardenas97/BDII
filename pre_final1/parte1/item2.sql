INSERT INTO D_PRODUCTOS_MEDIDA_PRECIO(
    id_registro,
    precio_venta,
    id_producto,
    cod_medida,
    cod_sucursal,
    cod_forma_pago
)
SELECT 
    max(PMP.id_registro)+1+PRO.id_producto,
    PRO.precio_ultima_compra*((PRO.porcentaje_beneficio/100)+1),
    CASE WHEN (YEAR(SYSDATE()) - YEAR(PRO.fecha_ultima_compra))>=1
        THEN PRO.id_producto
    END,
    CASE WHEN (SUC.desc_sucursal = 'TIENDA OUTLET')
        THEN SUC.cod_sucursal
    END,
    


FROM D_PRODUCTOS_MEDIDA_PRECIO PMP

