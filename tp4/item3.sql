/*
3. Objetos.
A. Cree el directorio DIR_VENTA. Copie las imágenes proveídas en el presente
ejercicio.
*/
CREATE DIRECTORY DIR_VENTA AS 'C:\Users\olome\Documents\Facultad\quintoSemestre\BDII\sql\TPs\TP - PARTE 4-20211021\DIR_VENTA' ;
GRANT READ, WRITE ON DIRECTORY DIR_VENTA TO IMP_FULL_DATABASE;
GRANT READ,WRITE ON DIRECTORY DIR_VENTA TO EXP_FULL_DATABASE;

/*
B. Cree el tipo tabla anidada T_STOCK compuesto de los siguientes elementos:
o COD_SUCURSAL NUMBER(2)
o EXISTENCIA NUMBER(10,2)
*/
CREATE OR REPLACE TYPE L_EXIST AS OBJECT (
    COD_SUCURSAL NUMBER(2),
    EXISTENCIA NUMBER(10,2)
);

CREATE TYPE T_STOCK TYPE TABLE OF L_EXIST;



/*
C. Cree el objeto T_PROD con los siguientes elementos:
i. Los atributos:
o ID_PRODUCTO NUMBER(12)
o DESC_ABREVIADO VARCHAR2(20)
o PORCENTAJE_IVA NUMBER(3)
o PRECIO NUMBER(10)
o IMAGEN_PRODUCTO BLOB
o EXISTENCIA T_STOCK

*/
CREATE OR REPLACE TYPE T_PROD IS OBJECT
(
    ID_PRODUCTO NUMBER(12),
    DESC_ABREVIADO VARCHAR2(20),
    PORCENTAJE_IVA NUMBER(3),
    PRECIO NUMBER(10),
    IMAGEN_PRODUCTO BLOB,
    EXISTENCIA T_STOCK,
    MEMBER FUNCTION ASIGNAR_EXISTENCIA,
    STATIC FUNCTION INSTANCIAR_PRODUCTO(ID NUMBER) RETURN T_PROD,
    
);

/*

ii. El método estático INSTANCIAR_PRODUCTO que recibe como parámetro ID de
producto y devuelve un objeto del tipo T_PROD. El método deberá obtener los
datos del producto, el porcentaje de iva, el precio (precio de última compra
adicionando el resultado de aplicar el porcentaje de beneficio). Así mismo,
asignará la imagen a partir del directorio DIR_VENTA. La imagen tiene como
nombre el código del producto rellenado con ceros a la izquierda y la extensión
jpeg.
*/

CREATE OR REPLACE TYPE BODY T_PROD IS
STATIC FUNCTION INSTANCIAR_PRODUCTO(v_id IN D_PRODUCTOS.ID_PRODUCTO%TYPE) RETURN T_PROD IS
retorno T_PROD;
BEGIN
    retorno := T_PROD(SELECT P.ID_PRODUCTO  
    FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id,

    SELECT P.DESC_ABREVIADO 
    FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id,

    SELECT I.PORCENTAJE_IVA 
    FROM D_TIPO_IVA I 
    JOIN D_PRODUCTOS P 
    ON P.COD_TIPO_IVA = I.COD_TIPO_IVA 
    WHERE P.ID_PRODUCTO= v_id,

    SELECT (P.PRECIO_ULTIMA_COMPRA + P.PRECIO_ULTIMA_COMPRA * P.PORCENTAJE_BENEFICIO) PRECIO_COMPRA 
    FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id,

    
    );

    RETURN retorno;

END;

STATIC FUNCTION ASIGNAR_CLIENTE (P_CEDULARYC VARCHAR2) RETURN T_CLIENTE IS 
        V_TIPCLI T_CLIENTE;
        CURSOR C_CLI IS
            SELECT NVL(C.CEDULA, RUC) CEDULA_RUC, C.NOMBRE, C.APELLIDO, C.TELEFONO, C.DIRECCION, SUM(V.MONTO_TOTAL) TOTAL_VENTAS
            FROM B_PERSONAS C 
            JOIN B_VENTAS V 
                ON C.ID=V,ID:CLIENTE
            WHERE (C.CEDULA = P_CEDULARUC OR C.RUC=P_CEDULA_RUC)
            AND C.ESCLIENTE='S'
            GROUP BY NVL(C.CEDULA, RUC), C.NOMBRE, C.APELLIDO, C.TELEFONO, C.DIRECCION;

        R_CLI C_CLI%ROWTYPE; 
        BEGIN
            OPEN C_CLI;
            FETCH C_CLI INTO R_CLI;
            CLOSE C_CLI;
            V_TIPCLI:=T_CLIENTE(R_CLI.NOMBRE, R_CLI.APELLIDO, R_CLI.TELEFONO, R_CLI.DIRECCION, R_CLI.TOTAL_VENTAS); 

            RETURN V_TIPCLI;
        END;

/*
iii. El método miembro ASIGNAR_EXISTENCIA que permitirá asignar la existencia
en todas las sucursales.

*/
MEMBER FUNCTION ASIGNAR_EXISTENCIA RETURN NUMBER IS
BEGIN

END;

 --Cree la tabla de objetos D_PRODUCTOS2 constituida de elementos T_PROD.
    CREATE TABLE D_PRODUCTOS2 OF T_PROD
    NESTED TABLE PRODUCTOS STORE AS PRODUCTOS_TAB;

/*
En un PL/SQL anónimo, recorra los productos, instancie un objeto del tipo T_PROD
con su constructor INSTANCIAR_PRODUCTO pasando como parámetro el
id_producto, e inserte el objeto en la tabla D_PRODUCTOS2.
*/
    DECLARE    
        SELECT ID_PRODUCTO, DESC_PRODUCTO, 