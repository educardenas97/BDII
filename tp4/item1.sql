--create trigger item1 after insert on item1
CREATE OR REPLACE TRIGGER item1 
    AFTER INSERT ON D_PAGO_OPERACION
    DECLARE
        v_id_pago_operacion integer;

        -- ii. Recorre la tabla D_DETALLE_OPERACIONES correspondiente a la operación que se paga
        CURSOR detalle_operaciones IS 
            SELECT * FROM D_DETALLE_OPERACIONES
            WHERE id_operacion = :NEW.id_operacion;

    BEGIN
        v_id_pago_operacion := NEW.id_operacion;
        -- Verifica si ya se ha aplicado algún pago con el mismo ID de operación. Si ya se
        -- ha aplicado un pago, se muestra el mensaje “La operación ya ha sido pagada”,
        -- y se aborta la operación.
        IF EXISTS (SELECT * FROM D_PAGO_OPERACION WHERE id_operacion = v_id_pago_operacion) THEN
            RAISE EXCEPTION 'La operación ya ha sido pagada';
        END IF;

        for registro in detalle_operaciones loop -- Se recorre el cursor de detalle_operaciones
            
            dbms_output.put_line('registro test');
        end loop; 

END item1;



