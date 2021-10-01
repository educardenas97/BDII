CREATE OR REPLACE PACKAGE PCK_PUNTO_VENTA AS
    PROCEDURE P_INSERTAR_MOVIMIENTO(
    cod_sucursal IN D_MOVIMIENTO_OPERACIONES.cod_sucursal%TYPE, 
    fecha_operacion IN D_MOVIMIENTO_OPERACIONES.fecha_operacion%TYPE, 
    cod_operacion IN D_MOVIMIENTO_OPERACIONES.cod_operacion%TYPE, 
    id_persona IN D_MOVIMIENTO_OPERACIONES.id_persona%TYPE, 
    id_usuario IN D_MOVIMIENTO_OPERACIONES.id_usuario%TYPE,
    descripcion_operacion IN D_MOVIMIENTO_OPERACIONES.descripcion_operacion%TYPE, 
    nro_caja IN D_MOVIMIENTO_OPERACIONES.NRO_CAJA%TYPE
    );
    PROCEDURE P_ACTUALIZAR_STOCK(
    v_id_producto IN D_STOCK_SUCURSAL.ID_PRODUCTO%TYPE,
    v_cod_sucursal IN D_STOCK_SUCURSAL.COD_SUCURSAL%TYPE, 
    v_cantidad IN D_STOCK_SUCURSAL.CANTIDAD_EXISTENCIA%TYPE,
    v_uso_stock IN D_OPERACIONES.USO_STOCK%TYPE
    );
/*
a) El tipo tabla indexada T_DETALLE compuesto de los siguientes elementos:
 ID_PRODUCTO
 CANTIDAD
*/
    TYPE r_articulo IS RECORD (
        ID_PRODUCTO D_DETALLE_OPERACIONES.ID_PRODUCTO%TYPE,
        CANTIDAD D_DETALLE_OPERACIONES.CANTIDAD_OPERACION%TYPE
    );
    TYPE t_detalle IS TABLE OF
       r_articulo INDEX BY BINARY_INTEGER;

    FUNCTION F_VER_DETALLE(ID_OPERACION IN NUMBER) RETURN T_DETALLE;

END;

-- AQUI EL CUERPO
CREATE OR REPLACE PACKAGE BODY PCK_PUNTO_VENTA 
IS
    PROCEDURE P_INSERTAR_MOVIMIENTO(
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

    PROCEDURE P_ACTUALIZAR_STOCK(
    v_id_producto IN D_STOCK_SUCURSAL.ID_PRODUCTO%TYPE,
    v_cod_sucursal IN D_STOCK_SUCURSAL.COD_SUCURSAL%TYPE, 
    v_cantidad IN D_STOCK_SUCURSAL.CANTIDAD_EXISTENCIA%TYPE,
    v_uso_stock IN D_DETALLE_OPERACIONES.USO_STOCK%TYPE
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

        
    /*
    d) El procedimiento P_INSERTAR_DETALLE que recibe como parámetros: id_operacion,
    id_producto, cod_medida, cantidad_operacion.
    El procedimiento deberá:
    Recuperar la sucursal, el código de movimiento y el correspondiente uso_stock del
    mismo, a partir de la cabecera D_MOVIMIENTO_OPERACIONES.
    Insertar un registro en la tabla D_DETALLE_OPERACIONES asignando los siguientes
    campos:
    ● precio_operacion = precio de última compra del producto + la aplicación del
    porcentaje de beneficio.
    ● importe_operacion = precio_operacion x cantidad_operacion
    ● cod_tipo_iva se obtiene a partir del producto
    ● porcentaje_iva se obtiene a partir del tipo de iva
    ● importe_iva = (precio_operacion x cantidad_operacion) / divisor_iva_incluido
    ● importe_descuento e importe_recargo se asigna 0
    Actualizar el stock invocando al procedimiento P_ACTUALIZAR_STOCK, enviando los
    parámetros requeridos
    */

    PROCEDURE P_INSERTAR_DETALLE(
        v_id_operacion IN D_MOVIMIENTO_OPERACIONES.ID_OPERACION%TYPE,
        v_id_producto IN D_DETALLE_OPERACIONES.ID_PRODUCTO%TYPE, 
        v_cod_medida IN D_DETALLE_OPERACIONES.COD_MEDIDA%TYPE, 
        v_cantidad_operacion IN D_DETALLE_OPERACIONES.CANTIDAD_OPERACION%TYPE
    )
    IS
        CURSOR C_DETALLE_INSERT IS
            SELECT SUC.DESC_SUCURSAL, SUC.COD_SUCURSAL, DMO.ID_OPERACION, OP.USO_STOCK 
            FROM D_MOVIMIENTO_OPERACIONES DMO 
            JOIN D_SUCURSAL SUC ON DMO.COD_SUCURSAL = SUC.COD_SUCURSAL
            JOIN D_OPERACIONES OP ON DMO.COD_OPERACION = OP.COD_OPERACION
            WHERE DMO.ID_OPERACION = V_ID_OPERACION;
        v_uso_stock  D_OPERACIONES.USO_STOCK%TYPE;
        v_cod_sucursal  D_STOCK_SUCURSAL.COD_SUCURSAL%TYPE;
        v_id_operacion_ D_DETALLE_OPERACIONES.ID_OPERACION%TYPE;
        BEGIN
            FOR REG IN C_DETALLE_INSERT LOOP
                v_uso_stock := REG.USO_STOCK;
                v_cod_sucursal := REG.COD_SUCURSAL;
                v_id_operacion_ := REG.ID_OPERACION;
            END LOOP;
            INSERT INTO D_DETALLE_OPERACIONES (
            ID_REGISTRO, 
            ID_OPERACION, 
            ID_PRODUCTO, 
            COD_MEDIDA,
            CANTIDAD_OPERACION, 
            PRECIO_OPERACION, 
            IMPORTE_OPERACION,
            IMPORTE_DESCUENTO,
            cod_tipo_iva,
            porcentaje_iva,
            importe_iva,
            importe_recargo)
            VALUES(
                (SELECT MAX(ID_REGISTRO) +1 FROM D_DETALLE_OPERACIONES),
                v_id_operacion_,
                V_ID_PRODUCTO,
                v_cod_medida,
                v_cantidad_operacion,
                (SELECT PRECIO_ULTIMA_COMPRA + PRECIO_ULTIMA_COMPRA * PORCENTAJE_BENEFICIO
                FROM D_PRODUCTOS WHERE ID_PRODUCTO = V_ID_PRODUCTO),
                (SELECT (PRECIO_ULTIMA_COMPRA + PRECIO_ULTIMA_COMPRA * PORCENTAJE_BENEFICIO) * v_cantidad_operacion 
                FROM D_PRODUCTOS WHERE ID_PRODUCTO = V_ID_PRODUCTO),
                0,
            (SELECT I.COD_TIPO_IVA 
            FROM D_TIPO_IVA I
            JOIN D_PRODUCTOS P ON I.COD_TIPO_IVA = P.COD_TIPO_IVA
            WHERE P.ID_PRODUCTO = V_ID_PRODUCTO) 
                ,
                (SELECT porcentaje_iva FROM D_TIPO_IVA I
                JOIN D_PRODUCTOS P ON P.COD_TIPO_IVA = I.COD_TIPO_IVA
                WHERE P.ID_PRODUCTO = V_ID_PRODUCTO),
                (SELECT ((P.PRECIO_ULTIMA_COMPRA + P.PRECIO_ULTIMA_COMPRA * P.PORCENTAJE_BENEFICIO) * v_cantidad_operacion )/ I.divisor_iva_incluido
                FROM D_PRODUCTOS P 
                JOIN D_TIPO_IVA I ON I.COD_TIPO_IVA = P.COD_TIPO_IVA
                WHERE P.ID_PRODUCTO = V_ID_PRODUCTO),
                0
            );

            P_ACTUALIZAR_STOCK(V_ID_PRODUCTO, v_cod_sucursal, v_cantidad_operacion, V_USO_STOCK);
    END;
/*
La función F_VER_DETALLE que recibe como parámetro el ID_OPERACION y devuelve
una variable del tipo T_DETALLE. La función deberá
• Verificar que exista la operación correspondiente al ID_OPERACION introducido. Si no
existe, dará error.
• Si existe, recorrerá los movimientos de detalle y llenará una variable del tipo T_DETALLE,
la que será retornada.


TYPE r_articulo IS RECORD (
        ID_PRODUCTO D_DETALLE_OPERACIONES.ID_PRODUCTO%TYPE,
        CANTIDAD D_DETALLE_OPERACIONES.CANTIDAD%TYPE
    );
    TYPE t_detalle IS TABLE OF
       r_articulo INDEX BY BINARY_INTEGER;
*/

    FUNCTION F_VER_DETALLE(ID_OPERACION IN NUMBER)
    RETURN T_DETALLE
    IS
        V_EXISTE_OPERACION BOOLEAN;
        V_EXISTE_MOVIMIENTO BOOLEAN;
        V_INDICE NUMBER;
        V_DETALLE T_DETALLE;

        CURSOR C_MOVIMIENTO IS 
            SELECT ID_OPERACION, FECHA_OPERACION, COD_SUCURSAL 
            FROM D_MOVIMIENTO_OPERACIONES 
            WHERE D_MOVIMIENTO_OPERACIONES.ID_OPERACION = V_ID_OPERACION;
        
        BEGIN
            V_EXISTE_MOVIMIENTO := FALSE;
            V_EXISTE_OPERACION := FALSE;
            
            FOR R_MOVIMIENTO IN C_MOVIMIENTO LOOP
                V_EXISTE_MOVIMIENTO := TRUE;
                V_MOVIMIENTO(V_INDICE) := R_MOVIMIENTO.FECHA_OPERACION;
                DBMS_OUTPUT.PUT_LINE(V_INDICE || ' - ' || V_MOVIMIENTO(V_INDICE));
                V_INDICE := V_INDICE + 1;
            END LOOP;

            IF V_EXISTE_MOVIMIENTO THEN
                V_EXISTE_OPERACION := TRUE;
            END IF;

            IF V_EXISTE_OPERACION THEN
                DBMS_OUTPUT.PUT_LINE('EXISTE OPERACION');
                DECLARE
                    CURSOR C_DETALLE IS
                        SELECT ID_PRODUCTO, CANTIDAD_OPERACION FROM D_DETALLE_OPERACIONES
                        WHERE D_DETALLE_OPERACIONES.ID_OPERACION = V_ID_OPERACION;
                    BEGIN
                        FOR R_DETALLE IN C_DETALLE LOOP
                            V_DETALLE(V_INDICE).ID_PRODUCTO := R_DETALLE.ID_PRODUCTO;
                            V_DETALLE(V_INDICE).CANTIDAD := R_DETALLE.CANTIDAD_OPERACION;
                            V_INDICE := V_INDICE + 1;
                            -- Para ver lo que se carga
                            DBMS_OUTPUT.PUT_LINE(R_DETALLE.ID_PRODUCTO || ' - ' || R_DETALLE.CANTIDAD_OPERACION);
                        END LOOP;
                    RETURN V_DETALLE;
                    END;
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'No existe la operación');
            END IF;
        END;
    END;
