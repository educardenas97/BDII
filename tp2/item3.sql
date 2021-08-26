create materialized view <mview_name>
refresh on demand 
start with sysdate next sysdate + 1
-------

-------
SELECT TO_CHAR(ROUND(SYSDATE - 1 ) + 20/24,'MM-DD-YYYY HH24:MI:SS') AS CURRENT_HOUR FROM DUAL;
---------
REFRESH START WITH ROUND(SYSDATE) + 20/24
NEXT ROUND(SYSDATE + 1) + 16/24
--------------
CREATE MATERIALIZED VIEW mi_vista_materializada
    TABLESPACE BASECONTABLE
    BUILD IMMEDIATE
    REFRESH START WITH ROUND(SYSDATE-1)+20/24 NEXT ROUND(SYSDATE+1)+20/24
    AS
        SELECT 
            FP.DESC_FORMA_PAGO AS FORMA_PAGO,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 1
                        THEN PO.IMPORTE_PAGO 
                    ELSE 0
                END
            ) AS CAJA1,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 2
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS CAJA2,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 3
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS CAJA3,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 4
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS CAJA4
        FROM D_FORMA_PAGO FP
        LEFT JOIN D_PAGO_OPERACION PO ON FP.COD_FORMA_PAGO = PO.COD_FORMA_PAGO 
        LEFT JOIN D_MOVIMIENTO_OPERACIONES MVO ON MVO.ID_OPERACION = PO.ID_OPERACION
        LEFT JOIN D_CAJAS CJ ON CJ.NRO_CAJA = MVO.NRO_CAJA
        GROUP BY FP.DESC_FORMA_PAGO
        UNION ALL
        SELECT 'TOTAL' AS FORMA_PAGO,
            SUM(CAJA1) AS CAJA1, 
            SUM(CAJA2) AS CAJA2, 
            SUM(CAJA3) AS CAJA3, 
            SUM(CAJA4) AS CAJA4
        FROM (
            SELECT 
            FP.DESC_FORMA_PAGO AS FORMA_PAGO,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 1
                        THEN PO.IMPORTE_PAGO 
                    ELSE 0
                END
            ) AS CAJA1,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 2
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS CAJA2,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 3
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS CAJA3,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA = 4
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS CAJA4,
            SUM(
                CASE 
                    WHEN CJ.NRO_CAJA IN (1,2,3,4)
                        THEN PO.IMPORTE_PAGO
                    ELSE 0
                END
            ) AS TOTAL
            FROM D_FORMA_PAGO FP
            LEFT JOIN D_PAGO_OPERACION PO ON FP.COD_FORMA_PAGO = PO.COD_FORMA_PAGO 
            LEFT JOIN D_MOVIMIENTO_OPERACIONES MVO ON MVO.ID_OPERACION = PO.ID_OPERACION
            LEFT JOIN D_CAJAS CJ ON CJ.NRO_CAJA = MVO.NRO_CAJA
            GROUP BY FP.DESC_FORMA_PAGO
            ORDER BY FP.DESC_FORMA_PAGO    
        );
