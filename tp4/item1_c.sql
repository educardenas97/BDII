DECLARE
    TYPE TIPO_IVA IS TABLE OF D_TIPO_IVA%ROWTYPE;

    porcentaje TIPO_IVA;
    consulta VARCHAR(190);
    v_id_tipo_iva NUMBER;
BEGIN
    v_id_tipo_iva := 1;

    consulta := 'SELECT *
                    FROM d_tipo_iva WHERE cod_tipo_iva = :1';
    EXECUTE IMMEDIATE consulta 
    BULK COLLECT INTO porcentaje
    USING v_id_tipo_iva;
    
    DBMS_OUTPUT.PUT_LINE(porcentaje(porcentaje.first).divisor_iva_incluido);
END;