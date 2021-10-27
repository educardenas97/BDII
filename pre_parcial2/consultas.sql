CREATE OR REPLACE PROCEDURE P_ABM_AREAS (
    id_area IN NUMBER,
    nombre IN VARCHAR2,
    id_area_superior IN NUMBER,
    operacion VARCHAR2
) IS BEGIN
    IF operacion = 'A' THEN
        BEGIN
            INSERT INTO B_AREAS (NOMBRE_AREA, ID_AREA_SUPERIOR) VALUES (nombre, id_area_superior);
        EXCEPTION WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ya existe un área con el nombre ingresado.');
        END;
    ELSIF operacion = 'M' THEN
        BEGIN
            UPDATE B_AREAS SET NOMBRE_AREA = nombre, ID_AREA_SUPERIOR = id_area_superior WHERE ID = id_area;
        EXCEPTION WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error al modificar el área');
        END;
    ELSIF operacion = 'B' THEN
        BEGIN
            DELETE FROM B_AREAS WHERE ID = id_area;
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END IF;
END;