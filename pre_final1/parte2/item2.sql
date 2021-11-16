CREATE TABLE D_ASIENTO_CABECERA(
    id_asiento NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    fecha_asiento DATE DEFAULT SYSDATE,
    concepto VARCHAR2(500) NOT NULL,
    CONSTRAINT PK_ASIENTO_CABECERA PRIMARY KEY (id_asiento)
);

CREATE TABLE D_ASIENTO_DETALLE(
    ID_ASIENTO NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    SECUENCIA NUMBER(4) NOT NULL,
    DEBE_HABER VARCHAR(20) CONSTRAINT CHECK_DEBE_HABER CHECK (
        DEBE_HABER IN ('D','H')
    ),
    IMPORTE NUMBER(9) NOT NULL,
    CODIGO_CTA NUMBER(7) NOT NULL
)