-- create table ERRORES_ORACLE with the following columns:
-- MENSAJE_ERROR VARCHAR2(4000)
CREATE TABLE ERRORES_ORACLE
(
  MENSAJE_ERROR VARCHAR2(4000)
);

-- Cree el procedimiento P_OBTENER_ERRORES
CREATE OR REPLACE PROCEDURE P_OBTENER_ERRORES
(
  p_cursor_error_oracle OUT SYS_REFCURSOR
) IS
-- Crear un ciclo y lanzar errores con RAISE_APPLICATION_ERROR(nro_error, ‘texto’);
DECLARE
    i NUMBER;
    v_error_code VARCHAR2(10);
    v_error_message VARCHAR2(4000);
BEGIN
    FOR i IN 1..9999 LOOP
        BEGIN
            RAISE_APPLICATION_ERROR(i, 'Error '||i);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_code := SQLCODE;
                v_error_message := SQLERRM;
                DBMS_OUTPUT.PUT_LINE (TO_CHAR(v_error_code)||': '|| v_error_message);

                INSERT INTO ERRORES_ORACLE VALUES(v_error_message);
        END;
    END LOOP;
END;
/

-- Crear la tabla ERRORES_ORACLE con el campo MENSAJE_ERROR
CREATE TABLE ERRORES_ORACLE
(
  MENSAJE_ERROR VARCHAR2(4000)
);

-- Seleccionar todos los campos de la tabla ERRORES_ORACLE
SELECT * FROM ERRORES_ORACLE;

-- seleccionar todos los registros de la tabla ERRORES_ORACLE que empiecen con la letra 'E'
SELECT * FROM ERRORES_ORACLE WHERE MENSAJE_ERROR LIKE 'E%';

