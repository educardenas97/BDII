/*
2. SQL Din�mico:
A. El siguiente script crea una tabla para auditar las sentencias DML sobre las tablas:
CREATE TABLE LOG_TABLAS
(FECHA_HORA TIMESTAMP,
OPERACION VARCHAR2(10),
NOMBRE_TABLA VARCHAR2(30),
CLAVE VARCHAR2(2000),
USUARIO VARCHAR2(30))
/

i. Cree la tabla con el script proporcionado

ii. Cree el procedimiento P_GENERAR_TRIGGERS que recorrer� las tablas del
esquema y crear� din�micamente un trigger con la denominaci�n
T_<nombre_tabla> que deber� dispararse para todas las tablas despu�s de
la inserci�n, borrado o modificaci�n de datos. EL trigger deber� grabar la
fecha de operaci�n, la operaci�n que dispara el DML, el nombre de la tabla,
el usuario que gener� la operaci�n, y en el campo CLAVE ir� la columna
que conforma la PK. Si la PK est� conformada por varias columnas, las
mismas ir�n entre comas
*/

EXECUTE P_GENERAR_TRIGGERS;

CREATE OR REPLACE PROCEDURE "P_GENERAR_TRIGGERS" 
AUTHID CURRENT_USER AS

    TYPE T_CUR IS REF CURSOR;

    TYPE R_TAB IS RECORD(
        NOMBRE_TABLA VARCHAR2(200),
        NOMBRE_PK VARCHAR2(200)
    );

    TYPE T_TAB IS TABLE OF 
        R_TAB INDEX BY BINARY_INTEGER;
    l_sql VARCHAR2(4000);
    l_dummy NUMBER;
    l_trigger_name VARCHAR2(30);
    V_TAB T_TAB;
    V_CUR T_CUR;
    ind NUMBER;
    v_tablas VARCHAR2(2000);
    ind_ante NUMBER;
    CURSOR C_TABLAS IS 
        SELECT cols.table_name, LISTAGG( cols.column_name, ',') 
                                        WITHIN GROUP(
                                        ORDER BY cols.column_name) AS COLUMN_NAME
            FROM all_constraints cons, all_cons_columns cols
            WHERE cols.table_name in (SELECT T.TABLE_NAME
                            FROM   ALL_TABLES T
                            WHERE  T.OWNER = 'BASEDATOS2'
                            AND T.TABLE_NAME LIKE 'D_%')
            AND cons.constraint_type = 'P'
            AND cons.constraint_name = cols.constraint_name
            AND cons.owner = cols.owner
            GROUP BY COLS.TABLE_NAME
            order by table_name; 
        
BEGIN
    FOR REG IN C_TABLAS LOOP
                l_trigger_name := 'T_' || REG.TABLE_NAME;
                l_sql :=
                    'CREATE OR replace TRIGGER ' || l_trigger_name ||
                    '  BEFORE INSERT OR UPDATE OR DELETE ON ' || TO_CHAR(REG.TABLE_NAME) ||
                    '  FOR EACH ROW 
                    DECLARE
                    OPERACION VARCHAR2(100);
                    BEGIN 
                         IF INSERTING THEN
                            OPERACION := ' || q'['INSERTAR']' || ';
                        ELSIF UPDATING THEN
                            OPERACION := ' || q'['ACTUALIZAR']' || ';
                        ELSIF DELETING THEN
                            OPERACION := ' || q'['BORRADO']' || ';
                        END IF;
                        INSERT INTO LOG_TABLAS(FECHA_HORA, OPERACION, NOMBRE_TABLA, CLAVE, USUARIO)
                            VALUES(sysdate, OPERACION, ''' || TO_CHAR(REG.TABLE_NAME) ||''', ''' || TO_CHAR(REG.COLUMN_NAME) ||''', user );
                    END;';
                    DBMS_OUTPUT.PUT_LINE(l_sql);
                    EXECUTE IMMEDIATE l_sql;
    END LOOP;
END;
/


-----------------------------------------------------------------------------------
CREATE OR REPLACE
PROCEDURE "TRIGGER_CALL" (p_table_name   IN VARCHAR2, CLAVE_PK IN VARCHAR2) 
AUTHID CURRENT_USER                          
AS 
  l_sql VARCHAR2(4000);
  l_dummy NUMBER;
  l_trigger_name VARCHAR2(30);
BEGIN
  -- Validate if a p_table_name is a valid object name
  -- If you have access you can also use DBMS_ASSERT.SQL_OBJECT_NAME procedure
  SELECT '1'
    INTO l_dummy
    FROM all_tables
   WHERE table_name = UPPER(p_table_name);

  l_trigger_name := 'T_' || p_table_name; 

  l_sql :=
    'CREATE OR replace TRIGGER ' || to_char(l_trigger_name) ||
    '  BEFORE INSERT ON ' || p_table_name ||
    '  FOR EACH ROW 
     BEGIN 
       IF INSERTING THEN
            OPERACION = ' || q'['INSERTAR']' || ';
        ELSIF UPDATING THEN
            OPERACION = ' || q'['ACTUALIZAR']' || ';
        ELSIF DELETING THEN
            OPERACION = ' || q'['BORRADO']' || ';
        END IF;
        INSERT INTO LOG_TABLAS(FECHA_HORA, OPERACION, NOMBRE_TABLA, CLAVE, USUARIO)
            VALUES(CURRENT_TIMESTAMP, OPERACION, ' || p_table_name ||', ' || CLAVE_PK ||', (select user from dual)  );
     END;';

  EXECUTE IMMEDIATE l_sql;
END; 
/
-- listagg
SELECT
    job_title,
    LISTAGG(
        first_name,
        ','
    ) WITHIN GROUP(
    ORDER BY
        first_name
    ) AS employees
FROM
    employees
GROUP BY
    job_title
ORDER BY
    job_title;

--
/*v_tablas := 'SELECT cols.table_name ,LISTAGG( cols.column_name, ' || q'[',']' || ' ) 
                                        WITHIN GROUP(
                                        ORDER BY cols.column_name) AS COLUMN_NAME
                FROM all_constraints cons, all_cons_columns cols
                WHERE cols.table_name in (SELECT T.TABLE_NAME
                                FROM   ALL_TABLES T
                                WHERE  T.OWNER = ' || q'['BASEDATOS2']' || '
                                AND T.TABLE_NAME LIKE ' || q'['D_%']' || ')
                AND cons.constraint_type =  ' || q'['P']' || '
                AND cons.constraint_name = cols.constraint_name
                AND cons.owner = cols.owner
                GROUP BY COLS.TABLE_NAME
                ORDER BY cols.table_name ASC';
    OPEN V_CUR FOR v_tablas;
    FETCH V_CUR BULK COLLECT INTO V_TAB;
    CLOSE V_CUR;
    ind := v_tab.FIRST;
    DBMS_OUTPUT.PUT_LINE(v_tab(ind).NOMBRE_PK);
    ind_ante := ind - 1;*/