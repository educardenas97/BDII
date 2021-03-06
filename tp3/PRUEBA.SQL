/*
La función F_VER_DETALLE que recibe como parámetro el ID_OPERACION y devuelve
una variable del tipo T_DETALLE. La función deberá
• Verificar que exista la operación correspondiente al ID_OPERACION introducido. Si no
existe, dará error.
• Si existe, recorrerá los movimientos de detalle y llenará una variable del tipo T_DETALLE,
la que será retornada.
*/
DECLARE
    TYPE T_DETALLE IS TABLE OF
    varchar2(15) INDEX BY BINARY_INTEGER;

    V_ID_OPERACION NUMBER;
    V_DETALLE T_DETALLE;
    V_MOVIMIENTO T_DETALLE;
    V_INDICE NUMBER;
    V_EXISTE_OPERACION BOOLEAN;
    V_EXISTE_MOVIMIENTO BOOLEAN;
BEGIN
    V_ID_OPERACION := 2;
    V_EXISTE_OPERACION := FALSE;
    V_EXISTE_MOVIMIENTO := FALSE;
    V_INDICE := 1;

    DECLARE
    CURSOR C_MOVIMIENTO IS 
        SELECT ID_OPERACION, FECHA_OPERACION, COD_SUCURSAL 
        FROM D_MOVIMIENTO_OPERACIONES 
        WHERE D_MOVIMIENTO_OPERACIONES.ID_OPERACION = V_ID_OPERACION;
    
    BEGIN
        FOR R_MOVIMIENTO IN C_MOVIMIENTO LOOP
            V_EXISTE_MOVIMIENTO := TRUE;
            V_MOVIMIENTO(V_INDICE) := R_MOVIMIENTO.FECHA_OPERACION;
            DBMS_OUTPUT.PUT_LINE(V_INDICE || ' - ' || V_MOVIMIENTO(V_INDICE));
            V_INDICE := V_INDICE + 1;
        END LOOP;

        IF V_EXISTE_MOVIMIENTO THEN
            V_EXISTE_OPERACION := TRUE;

        END IF;

        IF V_EXISTE_OPERACION THEN
            DBMS_OUTPUT.PUT_LINE('EXISTE OPERACION');
            DECLARE
                CURSOR C_DETALLE IS
                    SELECT ID_PRODUCTO, CANTIDAD_OPERACION FROM D_DETALLE_OPERACIONES
                    WHERE D_DETALLE_OPERACIONES.ID_OPERACION = V_ID_OPERACION;
                BEGIN
                    FOR R_DETALLE IN C_DETALLE LOOP
                        V_DETALLE(V_INDICE) := R_DETALLE.ID_PRODUCTO || ' - ' || R_DETALLE.CANTIDAD_OPERACION;
                        DBMS_OUTPUT.PUT_LINE(R_DETALLE.ID_PRODUCTO || ' - ' || R_DETALLE.CANTIDAD_OPERACION);
                        V_INDICE := V_INDICE + 1;
                    END LOOP;
                END;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'No existe la operación');
        END IF;
    END;
END;
/