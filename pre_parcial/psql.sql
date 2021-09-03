DECLARE
  v_total NUMBER(8) := 0;
BEGIN
  DECLARE
    v_contador NUMBER(2);
  BEGIN
    DBMS_OUTPUT.put_line (v_total);
    SELECT count(cod_banco) into v_total
    FROM d_banco;
    DBMS_OUTPUT.put_line (v_total);
  END;
EXCEPTION
  WHEN OTHERS
  THEN
    DBMS_OUTPUT.put_line 
   (DBMS_UTILITY.format_error_stack);
END;
/