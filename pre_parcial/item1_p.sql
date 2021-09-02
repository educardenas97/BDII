SELECT 
    producto.id_producto as id, 
    detalle.precio_operacion as precio, 
    max(movimiento.fecha_operacion) as fecha, 
    movimiento.tipo_registro as registro
FROM 
    d_detalle_operaciones detalle
INNER JOIN 
    d_movimiento_operaciones movimiento
    ON movimiento.id_operacion = detalle.id_operacion 
INNER JOIN 
    d_productos producto
    ON producto.id_producto = detalle.id_producto
INNER JOIN 
    d_sucursal sucursal
    ON sucursal.cod_sucursal = movimiento.cod_sucursal
INNER JOIN 
    d_operaciones operacion
    ON operacion.cod_operacion = movimiento.cod_operacion
WHERE 
    movimiento.tipo_registro = 'A' 
    AND sucursal.desc_sucursal LIKE '%CASA CENTRAL%'
    AND operacion.desc_operacion LIKE 'COMPRA'
GROUP BY 
    producto.id_producto, 
    detalle.precio_operacion, 
    movimiento.tipo_registro
ORDER BY 
    fecha DESC;