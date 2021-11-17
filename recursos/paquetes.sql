CREATE PACKAGE PKG_ADM_SOCIOS IS
    TYPE R_VINCULADOS IS RECORD(
        NOMBRES VARCHAR2(220),
        APELLIDOS VARCHAR2(220),
        EDAD NUMBER(3),
        TIPO_VINCULO VARCHAR2(60)
    );

    --CREATE A INDEX TABLE OF R_VINCULADOS
    TYPE T_VINCULADOS IS TABLE OF R_VINCULADOS INDEX BY BINARY_INTEGER;

    --CREATE A FUNCTION F_OBTENER_VINCULADOS TO RETURN THE TABLE OF R_VINCULADOS
    --PARAMETERS: socio_id NUMBER
    --RETURN: T_VINCULADOS
    FUNCTION F_OBTENER_VINCULADOS(socio_id NUMBER) RETURN T_VINCULADOS;
    --CREATE A PROCEDURE P_BAJA_SOCIO
    --PARAMETERS: socio_id NUMBER, fecha_baja DATE
    --RETURN: VOID
    PROCEDURE P_BAJA_SOCIO(socio_id NUMBER, fecha_baja DATE); 
END PKG_ADM_SOCIOS;
/