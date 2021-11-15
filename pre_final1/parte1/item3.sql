SELECT OPE.DESC_OPERACION, 
    -- when tiva.desc_tipo_iva is 'IVA 10%' sum(DET.IMPORTE_OPERACION)
    SUM(CASE 
        WHEN tiva.desc_tipo_iva = 'IVA 10%' THEN DET.IMPORTE_OPERACION
        ELSE 0
    END) AS IMPORTE_OPERACION_10,
    -- when tiva.desc_tipo_iva is 'IVA 10%' sum(DET.IMPORTE_IVA)
    SUM(CASE 
        WHEN tiva.desc_tipo_iva = 'IVA 10%' THEN DET.IMPORTE_IVA
        ELSE 0
    END) AS IMPORTE_IVA_10,
    -- when tiva.desc_tipo_iva is 'IVA 5%' sum(DET.IMPORTE_OPERACION)
    SUM(CASE 
        WHEN tiva.desc_tipo_iva = 'IVA 5%' THEN DET.IMPORTE_OPERACION
        ELSE 0
    END) AS IMPORTE_OPERACION_5,    
    -- when tiva.desc_tipo_iva is 'IVA 5%' sum(DET.IMPORTE_IVA)
    SUM(CASE 
        WHEN tiva.desc_tipo_iva = 'IVA 5%' THEN DET.IMPORTE_IVA
        ELSE 0
    END) AS IMPORTE_IVA_5
    FROM D_MOVIMIENTO_OPERACIONES MO
    INNER JOIN D_DETALLE_OPERACIONES DET ON DET.ID_OPERACION = MO.ID_OPERACION
    INNER JOIN D_OPERACIONES OPE ON OPE.COD_OPERACION = MO.COD_OPERACION
    INNER JOIN D_TIPO_IVA TIVA ON TIVA.COD_TIPO_IVA = DET.COD_TIPO_IVA
    WHERE OPE.DESC_OPERACION LIKE '%VENTA%'
        OR OPE.DESC_OPERACION LIKE '%COMPRA%'
        AND (
            TIVA.DESC_TIPO_IVA LIKE 'IVA 10%' OR
            TIVA.DESC_TIPO_IVA LIKE 'IVA 5%'
        )
    GROUP BY OPE.DESC_OPERACION;