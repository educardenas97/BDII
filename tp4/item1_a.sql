CREATE OR REPLACE TRIGGER item1_a
    AFTER INSERT ON D_PAGO_OPERACION
    FOR EACH ROW
    DECLARE 
        TYPE pago_operacion IS TABLE OF d_pago_operacion%ROWTYPE; 
        v_pago_operacion pago_operacion; 

    BEGIN
        SELECT * 
        BULK COLLECT INTO v_pago_operacion 
        FROM d_pago_operacion
        WHERE id_operacion = :new.id_operacion;

        IF v_pago_operacion.COUNT > 0 THEN
            dbms_output.put_line('Movimiento ya pagado');
        END IF;

END item1_a;
/