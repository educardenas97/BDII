CREATE OR replace TRIGGER T_D_ASIENTO_CABECERA  BEFORE INSERT OR UPDATE OR
DELETE ON D_ASIENTO_CABECERA  FOR EACH ROW
                    DECLARE

OPERACION VARCHAR2(100);
                    BEGIN
                         IF
INSERTING THEN
                            OPERACION := 'INSERTAR';

ELSIF UPDATING THEN
                            OPERACION := 'ACTUALIZAR';

ELSIF DELETING THEN
                            OPERACION := 'BORRADO';

END IF;
                        INSERT INTO LOG_TABLAS(FECHA_HORA, OPERACION,
NOMBRE_TABLA, CLAVE, USUARIO)
                            VALUES(sysdate,
OPERACION, D_ASIENTO_CABECERA, ID_ASIENTO, user );
                    END;