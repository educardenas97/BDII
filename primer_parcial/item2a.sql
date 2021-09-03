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
/