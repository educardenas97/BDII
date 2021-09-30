/*
a) El tipo tabla indexada T_DETALLE compuesto de los siguientes elementos:
 ID_PRODUCTO
 CANTIDAD
*/
DECLARE 
    TYPE r_articulo IS RECORD (
        ID_PRODUCTO D_DETALLE_OPERACIONES.ID_PRODUCTO%TYPE,
        CANTIDAD D_DETALLE_OPERACIONES.CANTIDAD%TYPE
    );
    TYPE t_detalle IS TABLE OF
       r_articulo INDEX BY BINARY_INTEGER;
BEGIN

END;
    
    
/*
b)  El procedimiento P_INSERTAR_MOVIMIENTO que recibe como parámetros:
cod_sucursal, fecha_operacion, cod_operacion, id_persona, id_usuario,
descripcion_operacion, nro_caja.
*/
CREATE OR REPLACE PROCEDURE P_INSERTAR_MOVIMIENTO(
    cod_sucursal IN D_MOVIMIENTO_OPERACIONES.cod_sucursal%TYPE, 
    fecha_operacion IN D_MOVIMIENTO_OPERACIONES.fecha_operacion%TYPE, 
    cod_operacion IN D_MOVIMIENTO_OPERACIONES.cod_operacion%TYPE, 
    id_persona IN D_MOVIMIENTO_OPERACIONES.id_persona%TYPE, 
    id_usuario IN D_MOVIMIENTO_OPERACIONES.id_usuario%TYPE,
    descripcion_operacion IN D_MOVIMIENTO_OPERACIONES.descripcion_operacion%TYPE, 
    nro_caja IN D_MOVIMIENTO_OPERACIONES.NRO_CAJA%TYPE
)
IS 
        V_DESC_OPERACION D_MOVIMIENTO_OPERACIONES.DESCRIPCION_OPERACION%TYPE;
        V_NRO_COMPROBANTE D_MOVIMIENTO_OPERACIONES.NRO_COMPROBANTE%TYPE;
        V_NRO_TIMBRADO D_MOVIMIENTO_OPERACIONES.NRO_TIMBRADO%TYPE;
        v_codigo_operacion D_OPERACIONES.COD_OPERACION%TYPE;
        v_numero_caja D_CAJAS.NRO_CAJA%TYPE;
    BEGIN
    /*
        Verificar la fecha_operacion, la cual debe ser del año actual y anterior o igual a la
        fecha del sistema. No se admiten fechas adelantadas.
    */
        IF fecha_operacion <= SYSDATE THEN
        /*
            Verificar el código de operación, si el código de operación es de uso cajero:
        */
    
            SELECT OP.cod_operacion into v_codigo_operacion FROM 
                D_OPERACIONES OP WHERE USO_CAJERO = 1 AND OP.cod_operacion = cod_operacion fetch first  rows only;

            IF v_codigo_operacion IS NOT NULL THEN
            /*
                Debe verificar que el nro de caja sea not null y corresponda a una caja existente.
            */
                    SELECT C.NRO_CAJA into v_numero_caja FROM D_CAJAS C WHERE C.NRO_CAJA = NRO_CAJA FETCH FIRST ROWS ONLY;

                IF v_numero_caja IS NOT NULL THEN
            /*
                Obtener el número de timbrado de la caja, a partir de dicho número, acceder a la tabla D_TIMBRADO 
                para obtener el número actual de factura.
                Verificar que el timbrado esté vigente con respecto a la fecha_operacion introducida, 
                y que el numero_actual_factura sea inferior al campo hasta_nro_factura. Si alguna de estas condiciones 
                no se cumple, deberá abortar la operación lanzando un error personalizado.
            */
                    DECLARE
                        CURSOR C_TIMBRADO IS
                            SELECT C.NRO_TIMBRADO, T.NUMERO_ACTUAL_FACTURA FROM D_CAJAS  C
                            JOIN D_TIMBRADO T ON T.NRO_TIMBRADO = C.NRO_TIMBRADO 
                            WHERE C.NRO_CAJA = NRO_CAJA
                            AND T.FECHA_HASTA_TIMBRADO > fecha_operacion
                            AND T.NUMERO_ACTUAL_FACTURA < T.HASTA_NUMERO_FACTURA;
                    BEGIN
                    /*
                        Si el numero_actual_factura pasó la validación anterior, asigna con dicho
                        valor el campo nro_comprobante, y también se asigna el nro_timbrado,
                    */
                        FOR REG IN C_TIMBRADO LOOP
                            V_NRO_COMPROBANTE := REG.NUMERO_ACTUAL_FACTURA;
                            V_NRO_TIMBRADO := REG.NRO_TIMBRADO;
                        END LOOP;
                    /*
                        Finalmente actualiza la tabla D_TIMBRADO incrementando el campo
                        numero_actual_factura en 1, siempre que dicho incremento no supere el
                        campo hasta_numero_factura.
                    */
                        UPDATE D_TIMBRADO SET NUMERO_ACTUAL_FACTURA = NUMERO_ACTUAL_FACTURA + 1
                            WHERE NRO_TIMBRADO = V_NRO_TIMBRADO AND NUMERO_ACTUAL_FACTURA <= HASTA_NUMERO_FACTURA;
                    EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('Ocurrio un error');
                    END; 
                END IF;
            ELSE
                /*
                    ● Si el código de operación no es de uso cajero, entonces:
                    - Acceder a la tabla D_TIPO_COMPROBANTE_SECUENCIA correspondiente
                    al tipo de comprobante de la operación, correspondiente al año vigente, y
                    obtener el campo nro_comprobante_actual, y asignar al número de
                    comprobante. La columna timbrado queda nulo.
                    - Actualizar la tabla D_TIPO_COMPROBANTE_SECUENCIA incrementando el
                    campo nro_comprobante_actual en 1.
                */
                SELECT NRO_COMPROBANTE_ACTUAL INTO V_NRO_COMPROBANTE 
                FROM D_TIPO_COMPROBANTE_SECUENCIA TCS 
                JOIN D_TIPO_COMPROBANTE TC ON TC.COD_TIPO_COMPROBANTE = TCS.COD_TIPO_COMPROBANTE
                JOIN D_MOVIMIENTO_OPERACIONES DMO ON TC.COD_TIPO_COMPROBANTE = DMO.COD_TIPO_COMPROBANTE
                WHERE DMO.cod_operacion = cod_operacion AND ANHO = extract(year from SYSDATE);
                
                UPDATE D_TIPO_COMPROBANTE_SECUENCIA SET NRO_COMPROBANTE_ACTUAL = NRO_COMPROBANTE_ACTUAL + 1
                            WHERE COD_TIPO_COMPROBANTE = (
                                SELECT TCS.COD_TIPO_COMPROBANTE
                                    FROM D_TIPO_COMPROBANTE_SECUENCIA TCS
                                    JOIN D_TIPO_COMPROBANTE TC ON TC.COD_TIPO_COMPROBANTE = TCS.COD_TIPO_COMPROBANTE
                                    JOIN D_MOVIMIENTO_OPERACIONES DMO ON TC.COD_TIPO_COMPROBANTE = DMO.COD_TIPO_COMPROBANTE
                                      WHERE DMO.cod_operacion = cod_operacion AND ANHO = extract(year from SYSDATE)
                                
                            ) AND ANHO = (
                                SELECT TCS.ANHO 
                                FROM D_TIPO_COMPROBANTE_SECUENCIA TCS 
                                JOIN D_TIPO_COMPROBANTE TC ON TC.COD_TIPO_COMPROBANTE = TCS.COD_TIPO_COMPROBANTE
                                JOIN D_MOVIMIENTO_OPERACIONES DMO ON TC.COD_TIPO_COMPROBANTE = DMO.COD_TIPO_COMPROBANTE
                                WHERE DMO.cod_operacion = cod_operacion AND ANHO = extract(year from SYSDATE)
                            );
            END IF;
            IF descripcion_operacion IS NULL THEN
               SELECT DESC_OPERACION INTO V_DESC_OPERACION FROM D_OPERACIONES OP WHERE OP.COD_OPERACION = cod_operacion;
            ELSE
                V_DESC_OPERACION := descripcion_operacion;
            END IF;
            INSERT INTO D_MOVIMIENTO_OPERACIONES (
                ID_OPERACION,
                fecha_operacion, 
                cod_sucursal, 
                cod_operacion, 
                id_persona, 
                nro_caja,
                id_usuario,
                cod_tipo_comprobante,
                NRO_COMPROBANTE,
                TIPO_REGISTRO,
                DESCRIPCION_OPERACION,
                NRO_TIMBRADO,
                FECHA_INSERT
            ) VALUES(
                (SELECT MAX(ID_OPERACION)+1 FROM D_MOVIMIENTO_OPERACIONES),
                fecha_operacion,
                cod_sucursal,
                cod_operacion,
                id_persona,
                nro_caja,
                id_usuario,
                1,
                V_NRO_COMPROBANTE,
                'A',
                V_DESC_OPERACION,
                V_NRO_TIMBRADO,
                SYSDATE
            );

        ELSE
            DBMS_OUTPUT.PUT_LINE('FECHA INCORRECTA');
        END IF;
        
    END;

/*
c) El procedimiento P_ACTUALIZAR_STOCK que recibe como parámetros id_producto,
cod_sucursal, cantidad, uso_stock
El procedimiento debe actualizar la tabla D_STOCK_SUCURSAL, que almacena el stock de
un producto en una sucursal, en base a los parámetros recibidos.
• Si el valor del parámetro USO_STOCK es 2 (sumar), debe aumentar la
CANTIDAD_EXISTENCIA en la tabla D_STOCK_SUCURSAL del producto dado por el
ID_PRODUCTO, y en la sucursal determinada por el COD_SUCURSAL.
• Si el valor del parámetro USO_STOCK es 1 (restar), debe disminuir la
CANTIDAD_EXISTENCIA en la tabla D_STOCK_SUCURSAL del producto dado por el
ID_PRODUCTO, y en la sucursal determinada por el COD_SUCURSAL. Ello siempre que la
(CANTIDAD_EXISTENCIA - CANTIDAD_OPERACION) >= STOCK_MINIMO. Si no se cumple
*/

CREATE OR REPLACE PROCEDURE P_ACTUALIZAR_STOCK(
v_id_producto IN D_STOCK_SUCURSAL.ID_PRODUCTO%TYPE,
v_cod_sucursal IN D_STOCK_SUCURSAL.COD_SUCURSAL%TYPE, 
v_cantidad IN D_STOCK_SUCURSAL.CANTIDAD_EXISTENCIA%TYPE,
v_uso_stock NUMBER
)
IS
    BEGIN
        IF V_USO_STOCK = 2 THEN
            UPDATE D_STOCK_SUCURSAL SET CANTIDAD_EXISTENCIA = CANTIDAD_EXISTENCIA + V_CANTIDAD
            WHERE ID_PRODUCTO = V_ID_PRODUCTO 
            AND COD_SUCURSAL = v_cod_sucursal;
        ELSIF V_USO_STOCK = 1 THEN
            UPDATE D_STOCK_SUCURSAL SET CANTIDAD_EXISTENCIA = CANTIDAD_EXISTENCIA - V_CANTIDAD
            WHERE ID_PRODUCTO = V_ID_PRODUCTO 
            AND COD_SUCURSAL = v_cod_sucursal   
            AND (CANTIDAD_EXISTENCIA - V_CANTIDAD) >= STOCK_MINIMO; 
        ELSE
            DBMS_OUTPUT.PUT_LINE('***USO STOCK NO VALIDO***');
        END IF;
    END;



    