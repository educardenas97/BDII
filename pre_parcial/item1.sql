
CREATE TABLE estudiantes (
                cedula NUMBER(8) NOT NULL,
                nombre VARCHAR2(45) NOT NULL,
                direccion VARCHAR2(45) NOT NULL,
                apellido VARCHAR2(45) NOT NULL,
                direccion_trabajo VARCHAR2(15),
                e_mail VARCHAR2(45),
                fecha_primera DATE,
                fecha_naciemiento DATE NOT NULL,
                CONSTRAINT CEDULA PRIMARY KEY (cedula)
);


CREATE TABLE acta (
                numero_acta NUMBER(8) NOT NULL,
                fecha_acta DATE NOT NULL,
                tipo_examen VARCHAR2(5) NOT NULL,
                CONSTRAINT ACTA_PK PRIMARY KEY (numero_acta)
);


CREATE SEQUENCE PROFESORES_PROFESOR_SEQ;

CREATE TABLE profesores (
                profesor NUMBER(4) NOT NULL,
                nombre_profesor VARCHAR2(60) NOT NULL,
                direccion_ppprofesor VARCHAR2(45) NOT NULL,
                telefono_profesor VARCHAR2(15) NOT NULL,
                e_mail_profesor VARCHAR2(30) NOT NULL,
                CONSTRAINT PROFESOR PRIMARY KEY (profesor)
);


CREATE SEQUENCE CARRERAS_ID_SEQ;

CREATE TABLE carreras (
                id NUMBER NOT NULL,
                nombre VARCHAR2(30) NOT NULL,
                total_horas NUMBER(2) NOT NULL,
                titulo_habilitante VARCHAR2(30) NOT NULL,
                fecha_habilitacion DATE NOT NULL,
                fecha_cancelacion DATE,
                CONSTRAINT ID_CARRERA PRIMARY KEY (id)
);


CREATE SEQUENCE MATERIAS_ID_MATERIA_SEQ;

CREATE TABLE materias (
                id_materia NUMBER NOT NULL,
                nombre VARCHAR2(45) NOT NULL,
                costo NUMBER(7) NOT NULL,
                CONSTRAINT ID_MATERIA PRIMARY KEY (id_materia)
);


CREATE TABLE programa_curricular (
                id_materia NUMBER NOT NULL,
                id NUMBER NOT NULL,
                electiva VARCHAR2(1) NOT NULL
                CHECK(
                    electiva IN ('E', 'O')
                ),
                carga_horaria NUMBER(1) NOT NULL,
                cant_creditos NUMBER(2) DEFAULT 6 NOT NULL
                CHECK(
                    BETWEEN 6 AND 12
                ),
                CONSTRAINT PROGRAMA_CURRICULAR_PK PRIMARY KEY (id_materia, id)
);


CREATE TABLE materia_seccion (
                id_materia NUMBER NOT NULL,
                id NUMBER NOT NULL,
                seccion VARCHAR2(1) NOT NULL,
                profesor NUMBER(4) NOT NULL,
                CONSTRAINT ID PRIMARY KEY (id_materia, id, seccion)
);


CREATE SEQUENCE MATRICULA_ID_MATRICULA_SEQ_1;

CREATE TABLE matricula (
                id_matricula NUMBER(8) NOT NULL,
                id_materia NUMBER NOT NULL,
                id NUMBER NOT NULL,
                seccion VARCHAR2(1) NOT NULL,
                cedula NUMBER(8) NOT NULL,
                CONSTRAINT ID_MATRICULA PRIMARY KEY (id_matricula)
);


CREATE TABLE calificaciones (
                numero_acta NUMBER(8) NOT NULL,
                id_matricula NUMBER(8) NOT NULL,
                puntaje NUMBER(3) NOT NULL,
                CONSTRAINT ID PRIMARY KEY (numero_acta, id_matricula)
);


ALTER TABLE matricula ADD CONSTRAINT ESTUDIANTES_MATRICULA_FK
FOREIGN KEY (cedula)
REFERENCES estudiantes (cedula)
NOT DEFERRABLE;

ALTER TABLE calificaciones ADD CONSTRAINT ACTA_ID_MATRICULA_FK
FOREIGN KEY (numero_acta)
REFERENCES acta (numero_acta)
NOT DEFERRABLE;

ALTER TABLE materia_seccion ADD CONSTRAINT PROFESORES_MATERIA_SECCION_FK
FOREIGN KEY (profesor)
REFERENCES profesores (profesor)
NOT DEFERRABLE;

ALTER TABLE programa_curricular ADD CONSTRAINT CARRERAS_PROGRAMA_CURRICULA280
FOREIGN KEY (id)
REFERENCES carreras (id)
NOT DEFERRABLE;

ALTER TABLE programa_curricular ADD CONSTRAINT MATERIAS_PROGRAMA_CURRICULA607
FOREIGN KEY (id_materia)
REFERENCES materias (id_materia)
NOT DEFERRABLE;

ALTER TABLE materia_seccion ADD CONSTRAINT PROGRAMA_CURRICULAR_MATERIA865
FOREIGN KEY (id_materia, id)
REFERENCES programa_curricular (id_materia, id)
NOT DEFERRABLE;

ALTER TABLE matricula ADD CONSTRAINT MATERIA_SECCION_MATRICULA_FK
FOREIGN KEY (id_materia, id, seccion)
REFERENCES materia_seccion (id_materia, id, seccion)
NOT DEFERRABLE;

ALTER TABLE calificaciones ADD CONSTRAINT MATRICULA_CALIFICACIONES_FK
FOREIGN KEY (id_matricula)
REFERENCES matricula (id_matricula)
NOT DEFERRABLE;