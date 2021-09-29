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
El procedimiento P_INSERTAR_MOVIMIENTO que recibe como parámetros:
cod_sucursal, fecha_operacion, cod_operacion, id_persona, id_usuario,
descripcion_operacion, nro_caja.
*/
CREATE OR REPLACE PROCEDURE P_INSERTAR_MOVIMIENTO(
    cod_sucursal%TYPE, 
    fecha_operacion, 
    cod_operacion, 
    id_persona, 
    id_usuario,
    descripcion_operacion, 
    nro_caja
)
IS
    BEGIN
        IF extract(year from fecha_operacion) <= extract(year from SYSDATE) THEN

            IF cod_operacion IN (
                SELECT cod_operacion FROM
                D_OPERACIONES WHERE USO_CAJERO = 1;
            ) THEN
                IF NRO_CAJA IS NOT NULL AND NRO_CAJA EXISTS(
                    SELECT NRO_CAJA FROM D_CAJAS;
                ) THEN
                    DECLARE
                        CURSOR C_TIMBRADO IS
                            SELECT C.NRO_TIMBRADO, T.NUMERO_ACTUAL_FACTURA FROM D_CAJAS  C
                            JOIN D_TIMBRADO T ON T.NRO_TIMBRADO = C.NRO_TIMBRADO 
                            WHERE C.NRO_CAJA = NRO_CAJA
                            AND T.FECHA_HASTA_TIMBRADO > fecha_operacion
                            AND T.NUMERO_ACTUAL_FACTURA < T.HASTA_NUMERO_FACTURA;
                        V_NRO_COMPROBANTE D_MOVIMIENTO_OPERACIONES.NRO_COMPROBANTE%TYPE;
                        V_NRO_TIMBRADO D_MOVIMIENTO_OPERACIONES.TIMBRADO%TYPE;
                    BEGIN
                        FOR REG IN C_TIMBRADO LOOP
                            V_NRO_COMPROBANTE := REG.NUMERO_ACTUAL_FACTURA;
                            V_NRO_TIMBRADO := REG.NRO_TIMBRADO;
                        END LOOP;
                        UPDATE D_TIMBRADO SET NUMERO_ACTUAL_FACTURA = NUMERO_ACTUAL_FACTURA + 1
                            WHERE NRO_TIMBRADO = V_NRO_TIMBRADO AND NUMERO_ACTUAL_FACTURA <= HASTA_NUMERO_FACTURA;
                    EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        DBMS_OUTPUT.PUT_LINE('Ocurrio un error');
                    END; 
                END IF;
            ELSE
                SELECT NRO_COMPROBANTE_ACTUAL INTO V_NRO_COMPROBANTE 
                FROM D_TIPO_COMPROBANTE_SECUENCIA TCS 
                JOIN D_TIPO_COMPROBANTE TC ON TC.COD_TIPO_COMPROBANTE = TCS.COD_TIPO_COMPROBANTE
                JOIN D_MOVIMIENTO_OPERACIONES DMO ON TC.COD_TIPO_COMPROBANTE = DMO.COD_TIPO_COMPROBANTE
                WHERE DMO.cod_operacion = cod_operacion;
            END IF;
        END IF;
    END;
    


    
                
                   



    