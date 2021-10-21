/*
2. SQL Dinámico:
A. El siguiente script crea una tabla para auditar las sentencias DML sobre las tablas:
CREATE TABLE LOG_TABLAS
(FECHA_HORA TIMESTAMP,
OPERACION VARCHAR2(10),
NOMBRE_TABLA VARCHAR2(30),
CLAVE VARCHAR2(2000),
USUARIO VARCHAR2(30))
/

i. Cree la tabla con el script proporcionado

ii. Cree el procedimiento P_GENERAR_TRIGGERS que recorrerá las tablas del
esquema y creará dinámicamente un trigger con la denominación
T_<nombre_tabla> que deberá dispararse para todas las tablas después de
la inserción, borrado o modificación de datos. EL trigger deberá grabar la
fecha de operación, la operación que dispara el DML, el nombre de la tabla,
el usuario que generó la operación, y en el campo CLAVE irá la columna
que conforma la PK. Si la PK está conformada por varias columnas, las
mismas irán entre comas
*/

CREATE OR REPLACE
PROCEDURE P_GENERAR_TRIGGERS
IS

TYPE T_CUR IS REF CURSOR;

TYPE R_TAB IS RECOR(
    
    NOMBRE_TABLA VARCHAR2;
);

TYPE T_TAB IS TABLE OF R_TAB INDEX BY BINARY_INTEGER;

V_TAB T_TAB;
V_CUR T_CUR;
ind VARCHAR2;
BEGIN
    OPEN V_CUR FOR
        'SELECT A.TABLE_NAME, 
        (
            SELECT cols.table_name, cols.column_name, cols.position, cons.status, cons.owner
            FROM all_constraints cons, all_cons_columns cols
            WHERE cols.table_name = 'A.TABLE_NAME'
            AND cons.constraint_type = 'P'
            AND cons.constraint_name = cols.constraint_name
            AND cons.owner = cols.owner
        ) 
        FROM ALL_TABLES A WHERE OWNER = 'BASEDATOS2';'
    FETCH V_CUR BULK COLLECT INTO V_TAB;
    CLOSE V_CUR;
    ind := v_tab.FIRST;
    WHILE ind <= v_tab.LAST LOOP
        
    ind:= v_tab.NEXT(ind);
    END LOOP; 
    
END;

-- ejemplo de sql dinamico
DECLARE
    v_string VARCHAR2(200);
BEGIN
    v_string := 'DROP TABLE B_PLAN_PAGO';
    EXECUTE IMMEDIATE '
    DECLARE
        C_TABLAS IS
            SELECT cols.table_name, cols.column_name
            FROM all_constraints cons, all_cons_columns cols
            WHERE cols.table_name in (SELECT TABLE_NAME
                            FROM   ALL_TABLES
                            WHERE  OWNER = "BASEDATOS2"
                            AND TABLE_NAME LIKE "D_%")
            AND cons.constraint_type = "P"
            AND cons.constraint_name = cols.constraint_name
            AND cons.owner = cols.owner; 
    BEGIN
        
    '
END;


-- ejemplo

select table_name from all_tables where owner = 'BASEDATOS2';

-- 
CREATE OR REPLACE TRIGGER T_CONTROL_DML
    AFTER INSERT OR UPDATE OR DELETE ON V_TAB(IND).NOMBRE_TABLA
DECLARE
    OPERACION VARCHAR2;
BEGIN
    IF INSERTING THEN
        OPERACION = 'INSERT'
    ELSIF UPDATING THEN
        OPERACION = 'UPDATE'
    ELSIF DELETING THEN
        OPERACION = 'DELETE'
    END IF;
        INSERT INTO LOG_TABLAS
        VALUES(TO_DATE(sysdate,'yyyy-mm-dd hh24:mi:ss'), OPERACION, V_TAB(IND).NOMBRE_TABLA,V_TAB(IND).CLAVE, )
END T_CONTROL_DML;

------------------------
SELECT cols.table_name, cols.column_name
FROM all_constraints cons, all_cons_columns cols
WHERE cols.table_name in (SELECT TABLE_NAME
                          FROM   ALL_TABLES
                          WHERE  OWNER = 'BASEDATOS2'
                          AND TABLE_NAME LIKE 'D_%')
AND cons.constraint_type = 'P'
AND cons.constraint_name = cols.constraint_name
AND cons.owner = cols.owner;

