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

CREATE TYPE T_STOCK AS TABLE OF L_EXIST;



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
    MEMBER FUNCTION ASIGNAR_EXISTENCIA RETURN T_PROD,
    STATIC FUNCTION INSTANCIAR_PRODUCTO(v_id IN D_PRODUCTOS.ID_PRODUCTO%TYPE) RETURN T_PROD
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
dir_img varchar2(1000);
nom_img varchar2(100);
v_id_prod D_PRODUCTOS.ID_PRODUCTO%TYPE;
v_cant_existencia D_STOCK_SUCURSAL.CANTIDAD_EXISTENCIA%TYPE;
v_desc_abrv D_PRODUCTOS.DESC_ABREVIADO%TYPE;
v_porcentaje_iva D_TIPO_IVA.PORCENTAJE_IVA%TYPE;
v_precio NUMBER(10,2);
TYPE existencias  IS TABLE OF T_STOCK;
l_existencia existencias;
BEGIN
    SELECT ID_PRODUCTO INTO v_id_prod FROM D_PRODUCTOS  WHERE ID_PRODUCTO = v_id;

    SELECT CANTIDAD_EXISTENCIA INTO v_cant_existencia FROM D_STOCK_SUCURSAL WHERE ID_PRODUCTO = v_id;

    SELECT P.DESC_ABREVIADO  INTO v_desc_abrv
    FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id;

    SELECT I.PORCENTAJE_IVA  INTO v_porcentaje_iva
    FROM D_TIPO_IVA I 
    JOIN D_PRODUCTOS P 
    ON P.COD_TIPO_IVA = I.COD_TIPO_IVA 
    WHERE P.ID_PRODUCTO= v_id;

    SELECT (P.PRECIO_ULTIMA_COMPRA + P.PRECIO_ULTIMA_COMPRA * P.PORCENTAJE_BENEFICIO) PRECIO_COMPRA INTO v_precio
    FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id;

    SELECT LPAD(TO_CHAR(P.ID_PRODUCTO), 2, '0') ID INTO nom_img FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO <= 20 AND P.ID_PRODUCTO = v_id;
    nom_img := nom_img || '.jpg';
    dir_img := 'C:\Users\olome\Documents\Facultad\quintoSemestre\BDII\sql\TPs\TP - PARTE 4-20211021\DIR_VENTA\' || nom_img;
    l_existencia := existencias (v_id_prod, v_cant_existencia);

    retorno := T_PROD( v_id_prod, v_desc_abrv, v_porcentaje_iva, v_precio, dir_img, l_existencia );

    RETURN retorno;
    END INSTANCIAR_PRODUCTO;
END;

/*
iii. El método miembro ASIGNAR_EXISTENCIA que permitirá asignar la existencia
en todas las sucursales.

*/
MEMBER FUNCTION ASIGNAR_EXISTENCIA RETURN T_PROD IS
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
        CURSOR C_PRODUCTOS IS    
            SELECT ID_PRODUCTO FROM D_PRODUCTOS
            WHERE ID <= 20;
    BEGIN
        FOR I IN C_PRODUCTOS LOOP
            INSERT INTO D_PRODUCTOS2 VALUES(INSTANCIAR_PRODUCTO(I.ID_PRODUCTO));
        END LOOP;
    END;