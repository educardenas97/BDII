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

EXECUTE P_GENERAR_TRIGGERS;

CREATE OR REPLACE PROCEDURE P_GENERAR_TRIGGERS IS

TYPE T_CUR IS REF CURSOR;

TYPE R_TAB IS RECORD(
    NOMBRE_TABLA VARCHAR2(200),
    NOMBRE_PK VARCHAR2(200)
);

TYPE T_TAB IS TABLE OF 
    R_TAB INDEX BY BINARY_INTEGER;

V_TAB T_TAB;
V_CUR T_CUR;
ind NUMBER;
v_tablas VARCHAR2(200);
BEGIN
    v_tablas := 'SELECT cols.table_name, cols.column_name
            FROM all_constraints cons, all_cons_columns cols
            WHERE cols.table_name in (SELECT TABLE_NAME
                            FROM   ALL_TABLES
                            WHERE  OWNER = ' || 'BASEDATOS2' || '
                            AND TABLE_NAME LIKE ' || 'D_%' || ')
            AND cons.constraint_type = ' || 'P' || '
            AND cons.constraint_name = cols.constraint_name
            AND cons.owner = cols.owner
            ORDER BY cols.table_name ASC';
    OPEN V_CUR FOR v_tablas;
    FETCH V_CUR BULK COLLECT INTO V_TAB;
    CLOSE V_CUR;
    ind := v_tab.FIRST;
    WHILE ind <= v_tab.LAST LOOP
        -- si el registro es igual al anterior, concatenar el nombre de la columna
        -- si el registro es diferente al anterior, crear el trigger mediante GENERAR_SENTENCIAS_DML
        IF ind > 1 THEN
            IF v_tab(ind).NOMBRE_TABLA = v_tab(ind-1).NOMBRE_TABLA THEN
                v_tab(ind).NOMBRE_PK := v_tab(ind-1).NOMBRE_PK || ', ' || v_tab(ind).NOMBRE_PK;
            ELSE
                GENERAR_SENTENCIAS_DML(v_tab(ind).NOMBRE_TABLA, v_tab(ind).NOMBRE_PK);
            END IF;
        END IF;
        ind := v_tab.NEXT(ind);
    END LOOP;    
END;


------ Sentencia para triggers
CREATE OR REPLACE PROCEDURE GENERAR_SENTENCIAS_DML
(
    NOMBRE_TABLA IN VARCHAR2,
    CLAVE_PK IN VARCHAR2
) IS
    sentencia_trigger VARCHAR2(2000);
    --nombre_tabla = 'D_DETALLE_OPERACIONES';
BEGIN
    sentencia_trigger := '
    CREATE OR REPLACE TRIGGER T_' || NOMBRE_TABLA ||'
    AFTER INSERT OR UPDATE OR DELETE ON V_TAB(IND).NOMBRE_TABLA
    DECLARE
        OPERACION VARCHAR2;
    BEGIN
        IF INSERTING THEN
            OPERACION = ' || 'INSERT' ||'
        ELSIF UPDATING THEN
            OPERACION = '|| 'UPDATE' ||'
        ELSIF DELETING THEN
            OPERACION = '|| 'DELETE' ||'
        END IF;
            INSERT INTO LOG_TABLAS
            VALUES(TO_DATE(sysdate,'||'yyyy-mm-dd hh24:mi:ss'||'), OPERACION, ' || NOMBRE_TABLA ||', ' || CLAVE_PK ||', (select user from dual)  )
    END;
    ';  
    EXECUTE IMMEDIATE sentencia_trigger ;
END;
/
------

-- ejemplo de sql dinamico
DECLARE
    v_string VARCHAR2(200);
    
BEGIN
    v_string := 'DROP TABLE B_PLAN_PAGO';
    EXECUTE IMMEDIATE '
    DECLARE
        C_TABLAS IS
            SELECT cols.table_name, cols.column_name, cols.owner
            FROM all_constraints cons, all_cons_columns cols
            WHERE cols.table_name in (SELECT TABLE_NAME
                            FROM   ALL_TABLES
                            WHERE  OWNER = 'BASEDATOS2'
                            AND TABLE_NAME LIKE 'D_%')
            AND cons.constraint_type = 'P'
            AND cons.constraint_name = cols.constraint_name
            AND cons.owner = cols.owner
            order by table_name; 
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

select trigger_name, trigger_type,
    triggering_event, table_name,
    status, trigger_body
from ALL_TRIGGERS
WHERE OWNER='BASEDATOS2';