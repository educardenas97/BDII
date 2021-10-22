CREATE OR REPLACE PROCEDURE P_GENERAR_TRIGGERS IS

TYPE T_CUR IS REF CURSOR;

TYPE R_TAB IS RECORD(
    NOMBRE_TABLA VARCHAR2(2000),
    NOMBRE_PK VARCHAR2(2000)
);

TYPE T_TAB IS TABLE OF 
    R_TAB INDEX BY BINARY_INTEGER;

V_TAB T_TAB;
V_CUR T_CUR;
ind NUMBER;
v_tablas VARCHAR2(2000);
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