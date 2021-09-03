SELECT 
    min(compras.anio) as primer_anio_compras,
    max(compras.anio) as ultimo_anio_compras,
    min(ventas.anio) as primer_anio_ventas,
    max(ventas.anio) as ultimo_anio_ventas
FROM D_VENTAS_X_ANIO ventas
FULL OUTER JOIN D_COMPRAS_X_ANIO compras
ON compras.anio = ventas.anio;