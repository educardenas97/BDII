DECLARE
    number_v number;
    modulo number;    
    nuevo_numero varchar(20);
    viejo_numero number;
    divisor number;
BEGIN
    divisor := 10;
    number_v := 2882;
    viejo_numero := number_v;
    nuevo_numero := ' ';
    -- determinar si el numero es palindromo
    modulo := MOD(number_v, divisor);
    WHILE number_v > 1 LOOP
        modulo := MOD(number_v, divisor);
        nuevo_numero := nuevo_numero || modulo;
        modulo := modulo/divisor;
        number_v := number_v/divisor;
        number_v := number_v-modulo;
    END LOOP;

    IF to_number(nuevo_numero) = viejo_numero THEN
        dbms_output.put_line('Es palindromo');
    ELSE
        dbms_output.put_line('No es palindromo');
    END IF;

END;