CREATE MATERIALIZED VIEW V_TARJETA
BUILD IMMEDIATE
REFRESH START WITH TRUNC(SYSDATE) NEXT TRUNC(ADD_MONTHS(SYSDATE,1), 'MONTH')+1/24
AS
    SELECT 
        count(distinct 
            CASE
                WHEN f_pago.desc_forma_pago = 'TARJETA DE LA CASA' 
                THEN persona.id_persona
            END
        ) AS "CLIENTES NUESTRA TARJETA",
        sum(
            CASE
                WHEN f_pago.desc_forma_pago = 'TARJETA DE LA CASA'
                THEN detalle.importe_operacion
            END
        ) AS "MONTO NUESTRA TARJETA",
        count(distinct 
            CASE
                WHEN f_pago.desc_forma_pago NOT LIKE 'TARJETA DE LA CASA' 
                THEN persona.id_persona
            END
        ) AS "CLIENTES OTROS MEDIOS",
        sum(
            CASE
                WHEN f_pago.desc_forma_pago NOT LIKE 'TARJETA DE LA CASA'
                THEN detalle.importe_operacion
            END
        ) AS "MONTO OTROS MEDIOS"
    FROM 
        D_PERSONAS persona
    INNER JOIN 
        D_MOVIMIENTO_OPERACIONES movimiento
        ON persona.ID_PERSONA = movimiento.ID_PERSONA
    INNER JOIN 
        D_DETALLE_OPERACIONES detalle
        ON movimiento.id_operacion = detalle.id_operacion
    INNER JOIN 
        D_PAGO_OPERACION pago
        ON movimiento.id_operacion = pago.id_operacion
    INNER JOIN 
        D_FORMA_PAGO f_pago
        ON pago.cod_forma_pago = f_pago.cod_forma_pago;