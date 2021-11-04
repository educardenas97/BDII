--Create a new Package

CREATE PACKAGE PACK_PER IS
    TYPE registro IS RECORD(
        MONTO_VENTAS NUMBER, 
        MONTO_COMISION NUMBER
    );
    -- La definición de un tipo tabla asociativa cuyos componentes son del tipo de registro creado,
       

END PACK_PER;
/
