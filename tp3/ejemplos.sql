DECLARE 
 CURSOR C_AREA IS
 SELECT NOMBRE_AREA FROM B_AREAS;
 V_NOMBRE B_AREAS.NOMBRE_AREA%TYPE;
BEGIN
 OPEN C_AREA;
 LOOP
   FETCH C_AREA INTO V_NOMBRE;
   IF    C_AREA%FOUND THEN
         DBMS_OUTPUT.PUT_LINE (V_NOMBRE); 
   ELSE 
        EXIT; 
   END IF;
 END LOOP;
 CLOSE C_AREA;
END;
/


--EJEMPLO 2
DECLARE
   CURSOR C_VEN1 IS
      SELECT * FROM B_VENTAS;
   CURSOR C_VENTAS(PID NUMBER) IS 
       SELECT v.id_articulo, a.nombre, v.cantidad
       FROM   b_Detalle_ventas v, b_articulos a
       WHERE  a.id = v.id_articulo 
	   AND v. id_venta = PID;
  V_VEN   C_VEN1%ROWTYPE;
  V_VAR   C_VENTAS%ROWTYPE; 
BEGIN
  OPEN C_VEN1;
  LOOP
    FETCH C_VEN1 INTO V_VEN;
	IF    C_VEN1%NOTFOUND THEN
	      EXIT;
	ELSE
	   DBMS_OUTPUT.PUT_LINE('Factura '|| V_VEN.ID);
       OPEN C_VENTAS(V_VEN.ID);
       LOOP
        FETCH C_VENTAS INTO V_VAR;
  	     IF    C_VENTAS%NOTFOUND THEN
	           EXIT;
	     END IF;
	     DBMS_OUTPUT.PUT_LINE('Articulo: '||V_VAR.ID_ARTICULO||'-'||v_VAR.NOMBRE||'-'||v_VAR.CANTIDAD);
        END LOOP;
       CLOSE C_VENTAS;
	END IF;
  END LOOP;
  CLOSE C_VEN1;
END;
/


--EJEMPLO 3
DECLARE
    CURSOR C_VENTAS(PID NUMBER) IS 
       SELECT v.id_articulo, a.nombre, v.cantidad
       FROM   b_Detalle_ventas v, b_articulos a
       WHERE  a.id = v.id_articulo 
	   AND v. id_venta = PID;
BEGIN
    FOR V_VEN IN (SELECT * FROM B_VENTAS) LOOP
	   DBMS_OUTPUT.PUT_LINE('Factura '|| V_VEN.ID);
       FOR  V_VAR IN C_VENTAS(V_VEN.ID) LOOP
  	 	     DBMS_OUTPUT.PUT_LINE('Articulo: '||V_VAR.ID_ARTICULO||'-'||v_VAR.NOMBRE||'-'||v_VAR.CANTIDAD);
        END LOOP;
     END LOOP;
END;
/
-- EJEMPLO 4
DECLARE 
 CURSOR C_AREA IS
 SELECT * FROM B_AREAS;
BEGIN
  FOR REG IN C_AREA LOOP
      UPDATE B_AREAS SET NOMBRE_AREA = NOMBRE_AREA || ' Modificada'
	  WHERE ID = REG.ID;
  END LOOP;
END;
/


--ejercicio 1
1.	Desarrolle un PL/SQL anónimo que calcule la liquidación  de salarios del mes de Agosto del 2011. El PL/SQL deberá realizar lo siguiente:
•	Insertar un registro de cabecera de LIQUIDACIÓN correspondiente a agosto del 2011.
•	Recorrer secuencialmente el archivo de empleados y calcular la liquidación de cada empleado de la siguiente manera: 
­	salario básico = asignación correspondiente a la categoría de la posición vigente
­	descuento por IPS = 9,5% del salario
­	bonificaciónxventas=  a la suma de la bonificación obtenida a partir de las ventas realizadas por ese empleado en el mes de agosto del 2011 (la bonificación es calculada de acuerdo a los artículos vendidos).
­	líquido = salario básico – descuento x IPS + bonificación (si corresponde).
•	Insertar la liquidación calculada en la PLANILLA  con el ID de la  cabecera de liquidación creada

DECLARE 
  CURSOR C_EMP IS
     SELECT P.CEDULA, C.ASIGNACION, (SELECT  SUM(D.CANTIDAD * D.PRECIO * A.PORC_COMISION)  
	                                 FROM B_DETALLE_VENTAS D JOIN B_VENTAS V
									 ON   V.ID = D.ID_VENTA
									 JOIN  B_ARTICULOS A
									 ON    A.ID = D.ID_ARTICULO
									 WHERE  EXTRACT (YEAR FROM V.FECHA) = 2018
									 AND    EXTRACT (MONTH FROM V.FECHA) = 8
									 AND    V.CEDULA_VENDEDOR = P.CEDULA) BONIFICACION	 
	   FROM B_POSICION_ACTUAL P JOIN B_CATEGORIAS_SALARIALES C
	   ON   P.COD_CATEGORIA = C.COD_CATEGORIA
	   WHERE P.FECHA_FIN IS NULL
	   AND   C.FECHA_FIN IS NULL;
   V_ID NUMBER;
   V_DESCUENTO NUMBER;
   V_LIQUIDO   NUMBER;
BEGIN
   SELECT NVL(MAX(ID),0) + 1 INTO V_ID
   FROM B_LIQUIDACION; 
   INSERT INTO B_LIQUIDACION VALUES
    (V_ID, SYSDATE, 2018,8);
   FOR  REG IN C_EMP LOOP
        V_DESCUENTO := REG.ASIGNACION * 0.095;
		V_LIQUIDO   := REG.ASIGNACION - V_DESCUENTO + NVL(REG.BONIFICACION,0);
        INSERT INTO B_PLANILLA(ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO) 
        VALUES (V_ID, REG.CEDULA, REG.ASIGNACION, V_DESCUENTO, NVL(REG.BONIFICACION,0), V_LIQUIDO);		
   END  LOOP;
   COMMIT;
END;
/


DECLARE
    CURSOR C_SALARARIO IS
        SELECT * FROM B_PLANILLA;

    V_TOTAL_PAGAR NUMBER;
BEGIN
    V_TOTAL_PAGAR := 0;
    FOR REG IN C_SALARARIO LOOP
        V_TOTAL_PAGAR := V_TOTAL_PAGAR + REG.LIQUIDO_COBRADO + REG.BONIFICACION_X_VENTAS + REG.SALARIO_BASICO;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('El total a pagar es: '|| V_TOTAL_PAGAR);
END;
/
