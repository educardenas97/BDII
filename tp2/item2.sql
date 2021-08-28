CREATE TABLE D_ASIENTO_CABECERA (
    ID_ASIENTO NUMBER(10)  GENERATED ALWAYS AS IDENTITY,
    FECHA_ASIENTO DATE NOT NULL,
    CONCEPTO VARCHAR(500) NOT NULL,
    CONSTRAINT D_ASIENTO_CABECERA_pk PRIMARY KEY (ID_ASIENTO)
);


CREATE TABLE D_PLANTILLA_ASIENTO (
    ID_PLANTILLA NUMBER(10) GENERATED ALWAYS AS IDENTITY,
    NOMBRE VARCHAR2(60) NOT NULL,
    ACTIVA VARCHAR2(1) NOT NULL CONSTRAINT ACT_CONSTRAINT
    CHECK (
        ACTIVA IN ('S', 'N')
    ),
    CONSTRAINT D_PLANTILLA_ASIENTO_PK PRIMARY KEY (ID_PLANTILLA)
);


CREATE TABLE D_CUENTAS_CONTABLES (
    CODIGO_CTA NUMBER(7) NOT NULL,
    CODIGO_EQUIVALENTE NUMBER(8),
    ID_TIPO NUMBER(4) NOT NULL CONSTRAINT IT_CONSTRAINT
    CHECK (
        ID_TIPO IN (1,2,3,4,5)
    ),
    NIVEL NUMBER(1) NOT NULL CONSTRAINT NVL_CONSTRAINT
    CHECK (
        NIVEL IN (1,2,3,4,5)
    ),
    ORDEN VARCHAR2(1) CONSTRAINT ORD_CONSTRAINT
    CHECK (
        ORDEN IN ('D', 'C')
    ),
    NOMBRE_CTA VARCHAR2(40),
    IMPUTABLE VARCHAR2(1) NOT NULL CONSTRAINT IMP_CONSTRAINT
    CHECK (
        IMPUTABLE IN ('S', 'N')
    ),
    FECHA_APERTURA DATE,
    CONSTRAINT D_CUENTAS_CONTABLES_PK PRIMARY KEY (CODIGO_CTA)
);


CREATE TABLE D_PLANTILLA_DETALLE (
    SECUENCIA NUMBER(4) NOT NULL,
    ID_PLANTILLA NUMBER(10) NOT NULL,
    CODIGO_CTA NUMBER(7) NOT NULL,
    CATEGORIA VARCHAR2(20) NOT NULL,
    DEBE_HABER VARCHAR2(20) CONSTRAINT DH_CONSTRAINT
    CHECK (
        DEBE_HABER IN ('D', 'H')
    ),
    IMPORTE NUMBER(9) NOT NULL,
    CONSTRAINT D_PLANTILLA_DETALLE_PK PRIMARY KEY (SECUENCIA, ID_PLANTILLA)
);


CREATE TABLE D_ASIENTO_CABECERA (
    ID_ASIENTO NUMBER(10) NOT NULL,
    FECHA_ASIENTO DATE NOT NULL,
    CONCEPTO VARCHAR2(500) NOT NULL,
    CONSTRAINT D_ASIENTO_CABECERA_PK PRIMARY KEY (ID_ASIENTO)
);


CREATE TABLE D_ASIENTO_DETALLE (
    ID_ASIENTO NUMBER(10)  GENERATED ALWAYS AS IDENTITY,
    SECUENCIA NUMBER(4) NOT NULL,
    DEBE_HABER VARCHAR2(20) CONSTRAINT DHD_CONSTRAINT
    CHECK (
        DEBE_HABER IN ('D', 'H')
    ),
    IMPORTE NUMBER(9) NOT NULL,
    CODIGO_CTA NUMBER(7) NOT NULL,
    CONSTRAINT D_ASIENTO_DETALLE_PK 
    PRIMARY KEY (ID_ASIENTO, SECUENCIA)
);


ALTER TABLE D_PLANTILLA_DETALLE ADD CONSTRAINT D_PLANTILLA_ASIENTO_D_PLANT799
FOREIGN KEY (ID_PLANTILLA)
REFERENCES D_PLANTILLA_ASIENTO (ID_PLANTILLA)
NOT DEFERRABLE;

ALTER TABLE D_PLANTILLA_DETALLE ADD CONSTRAINT D_CUENTAS_CONTABLES_D_PLANT523
FOREIGN KEY (CODIGO_CTA)
REFERENCES D_CUENTAS_CONTABLES (CODIGO_CTA)
NOT DEFERRABLE;

ALTER TABLE D_ASIENTO_DETALLE ADD CONSTRAINT D_CUENTAS_CONTABLES_D_ASIEN635
FOREIGN KEY (CODIGO_CTA)
REFERENCES D_CUENTAS_CONTABLES (CODIGO_CTA)
NOT DEFERRABLE;

ALTER TABLE D_ASIENTO_DETALLE ADD CONSTRAINT D_ASIENTO_CABECERA_D_ASIENT658
FOREIGN KEY (ID_ASIENTO)
REFERENCES D_ASIENTO_CABECERA (ID_ASIENTO)
NOT DEFERRABLE;

alter table D_ASIENTO_CABECERA move tablespace BASECONTABLE;
alter table D_CUENTAS_CONTABLES move tablespace BASECONTABLE;
alter table D_PLANTILLA_ASIENTO move tablespace BASECONTABLE;
alter table D_PLANTILLA_DETALLE move tablespace BASECONTABLE;
alter table D_ASIENTO_DETALLE move tablespace BASECONTABLE;


-- 2a
--se elimina el constraint
ALTER TABLE D_MOVIMIENTO_OPERACIONES DROP COLUMN COD_TIPO_COMPROBANTE CASCADE CONSTRAINTS;
-- se agrega la fk a d_operaciones
ALTER TABLE D_OPERACIONES
ADD COD_TIPO_COMPROBANTE NUMBER(2) DEFAULT 1 NOT NULL;

ALTER TABLE D_OPERACIONES
ADD CONSTRAINT FK_TIPO_COMBROBANTE
    foreign key (COD_TIPO_COMPROBANTE)
    references D_TIPO_COMPROBANTE(COD_TIPO_COMPROBANTE)
    on delete cascade;
-- SE VISUALIZA EL CONSTRAINT
SELECT CONSTRAINT_NAME, TABLE_NAME, R_CONSTRAINT_NAME FROM USER_CONSTRAINTS  where table_name='D_OPERACIONES';

-- SE AGREGA EL CAMPO USO_STOCK
ALTER TABLE D_OPERACIONES
ADD USO_STOCK NUMBER(1) DEFAULT 1 CONSTRAINT CHK_STOCK
    CHECK (
        USO_STOCK IN (1,2)
    ) NOT NULL;
