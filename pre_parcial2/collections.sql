-- 1. El tipo T_CEDULAS como una tabla anidada compuesta de cédulas (números). (5P)
CREATE TYPE T_CEDULAS AS TABLE OF NUMBER;
CREATE TABLE T_CEDULAS (CEDULA T_CEDULAS) NESTED TABLE CEDULA STORE AS CEDULAS;


-- El paquete PCK_JUECES con los siguientes elementos (Especif 5P):
/* 
2.1 (15P) La función F_VALIDAR_JUECES, que recibe como parámetros una CEDULA y un ID_SUMARIO, y devuelve un
BOOLEAN. La función deberá determinar de la tabla REGISTRO_ABOGADOS si un abogado puede ser escogido para un
sumario. En caso que pueda ser escogido retornará TRUE, y en caso contrario retornará FALSE. Para que devuelva TRUE, el
abogado:
     No tiene que estar de permiso en el periodo en el que se inicie el sumario. Eso significa que si permiso ya ha
        iniciado, pero sumando los días de permiso, el mismo concluirá antes de la fecha de inicio efectivo del sumario, se le
        podrá incluir.
     No tiene que estar de JUEZ TITULAR (‘TI’) en un sumario que aún no ha finalizado (que no tiene fecha de fin).
     Su registro no tiene que estar de baja.
*/

CREATE OR REPLACE PACKAGE PCK_JUECES IS
    FUNCTION F_VALIDAR_JUECES(CEDULA NUMBER, ID_SUMARIO NUMBER) RETURN BOOLEAN;

END PCK_JUECES;

CREATE OR REPLACE PACKAGE BODY PCK_JUECES IS 
    FUNCTION F_VALIDAR_JUECES(CEDULA NUMBER, ID_SUMARIO NUMBER) RETURN BOOLEAN IS 
        fecha_inicio_sumario DATE;
        fecha_fin_sumario DATE;
        fecha_inicio_permiso DATE;
        fecha_fin_permiso DATE;
        CURSOR abogados IS SELECT e.cedula FROM EMPLEADOS e
            JOIN REGISTRO_ABOGADOS ra ON ra.cedula = e.cedula
            JOIN PERMISOS p ON p.cedula = e.cedula
            JOIN SUMARIO s ON s.id_sumario = ra.id_sumario;
            JOIN JUECES j ON j.cedula = ra.cedula AND j.id_sumario = ra.id_sumario;
            WHERE 
                e.cedula = CEDULA AND 
                ra.id_sumario = ID_SUMARIO AND
                j.titular_suplente <> 'TI' AND
                ra.fecha_baja IS NULL AND
                (p.fecha_ini + p.dias_permiso) < s.fecha_inicio_efectivo AND;
                s.fecha_fin IS NOT NULL;
    BEGIN
        FOR abogado IN abogados LOOP
            IF abogado%ISNULL THEN
                RETURN FALSE;
            ELSE
                RETURN TRUE;
            END IF;
        END LOOP;
    END;
            
END PCK_JUEVES;