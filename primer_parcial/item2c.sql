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