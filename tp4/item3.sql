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
    MEMBER FUNCTION ASIGNAR_EXISTENCIA RETURN T_STOCK,
    STATIC FUNCTION INSTANCIAR_PRODUCTO(v_id IN NUMBER) RETURN T_PROD
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

/*creamos una tabla que contedra las imagenes de los productos para luego insertar dentro del metodo estatico y
a su vez seleccionar dicha imagen para pasar como parametro del atributoto IMAGEN_PRODUCTO*/
CREATE TABLE imagenes (
  id        NUMBER,
  blob_data BLOB
);

CREATE OR REPLACE TYPE BODY T_PROD IS
    STATIC FUNCTION INSTANCIAR_PRODUCTO(v_id IN NUMBER) RETURN T_PROD IS
    retorno T_PROD;
    nom_img varchar2(100);
    v_id_prod NUMBER;
    v_cod_sucursal NUMBER(2);
    v_cant_existencia NUMBER(10,2);
    v_desc_abrv D_PRODUCTOS.DESC_ABREVIADO%TYPE;
    v_porcentaje_iva D_TIPO_IVA.PORCENTAJE_IVA%TYPE;
    v_precio NUMBER(10,2);
    l_existencia T_STOCK:= T_STOCK();
    indice NUMBER(8);
    v_bfile  BFILE;
    v_blob   BLOB;
    r_blob  BLOB;
    CURSOR c_cod_suc is
        SELECT COD_SUCURSAL, CANTIDAD_EXISTENCIA FROM D_STOCK_SUCURSAL  WHERE ID_PRODUCTO = 1 AND ID_PRODUCTO <= 20;
    BEGIN
        SELECT ID_PRODUCTO INTO v_id_prod FROM D_PRODUCTOS  WHERE ID_PRODUCTO = v_id AND ID_PRODUCTO <= 20;
       -- SELECT COD_SUCURSAL INTO v_cod_sucursal FROM D_STOCK_SUCURSAL  WHERE ID_PRODUCTO = v_id AND ID_PRODUCTO <= 20;   
       -- SELECT CANTIDAD_EXISTENCIA INTO v_cant_existencia FROM D_STOCK_SUCURSAL WHERE ID_PRODUCTO = v_id AND ID_PRODUCTO <= 20;

        SELECT P.DESC_ABREVIADO  INTO v_desc_abrv
        FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id AND P.ID_PRODUCTO <= 20;

        SELECT I.PORCENTAJE_IVA  INTO v_porcentaje_iva
        FROM D_TIPO_IVA I 
        JOIN D_PRODUCTOS P 
        ON P.COD_TIPO_IVA = I.COD_TIPO_IVA 
        WHERE P.ID_PRODUCTO= v_id AND P.ID_PRODUCTO <= 20;

        SELECT (P.PRECIO_ULTIMA_COMPRA + P.PRECIO_ULTIMA_COMPRA * P.PORCENTAJE_BENEFICIO) PRECIO_COMPRA INTO v_precio
        FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO = v_id AND P.ID_PRODUCTO <= 20;

        SELECT LPAD(TO_CHAR(P.ID_PRODUCTO), 2, '0') ID INTO nom_img FROM D_PRODUCTOS P WHERE P.ID_PRODUCTO <= 20 AND P.ID_PRODUCTO = v_id;
        nom_img := nom_img || '.jpg';
        indice := 0;
        
        for i in c_cod_suc loop
            if(indice <= l_existencia.LAST) THEN
                l_existencia.EXTEND;
                l_existencia(indice) := L_EXIST(i.COD_SUCURSAL, i.CANTIDAD_EXISTENCIA);
                indice := indice + 1;
            end if;
        end loop;

        INSERT INTO imagenes (id, blob_data)
        VALUES (v_id, empty_blob())
        RETURNING blob_data INTO v_blob;
        v_bfile := BFILENAME('DIR_VENTA', nom_img);
        DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
        DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, DBMS_LOB.GETLENGTH(v_bfile) );
        DBMS_LOB.FILECLOSE(v_bfile);

        SELECT blob_data INTO r_blob FROM imagenes WHERE id = v_id;
        retorno := T_PROD( v_id_prod, v_desc_abrv, v_porcentaje_iva, v_precio, r_blob ,  l_existencia );
        RETURN retorno;
    END INSTANCIAR_PRODUCTO;
/*
iii. El método miembro ASIGNAR_EXISTENCIA que permitirá asignar la existencia
en todas las sucursales.
*/
    MEMBER FUNCTION ASIGNAR_EXISTENCIA RETURN T_STOCK IS
        CURSOR C_SUCURSAL IS
            SELECT * FROM D_STOCK_SUCURSAL;
        TYPE existencias  IS TABLE OF T_STOCK;
        l_existencia T_STOCK:= T_STOCK();
    BEGIN
        FOR SUC IN C_SUCURSAL LOOP
            l_existencia := T_STOCK(L_EXIST(SUC.COD_SUCURSAL, SUC.CANTIDAD_EXISTENCIA) );
            RETURN l_existencia;
        END LOOP;
    END ASIGNAR_EXISTENCIA;
END;


 --Cree la tabla de objetos D_PRODUCTOS2 constituida de elementos T_PROD.
    CREATE TABLE D_PRODUCTOS2 OF T_PROD
    NESTED TABLE EXISTENCIA STORE AS PRODUCTOS_TAB;
/*
En un PL/SQL anónimo, recorra los productos, instancie un objeto del tipo T_PROD
con su constructor INSTANCIAR_PRODUCTO pasando como parámetro el
id_producto, e inserte el objeto en la tabla D_PRODUCTOS2.
*/
     DECLARE 
        CURSOR C_PRODUCTOS IS    
            SELECT ID_PRODUCTO FROM D_PRODUCTOS
            WHERE ID_PRODUCTO <= 20;
        valores T_PROD;
    BEGIN
        FOR I IN C_PRODUCTOS LOOP
             valores := T_PROD.INSTANCIAR_PRODUCTO(i.ID_PRODUCTO);
            INSERT  INTO D_PRODUCTOS2 VALUES( valores );
        END LOOP;
    END;
/
   
CREATE TABLE ordenes_tab OF T_PROD
NESTED TABLE productos STORE AS productos_tab ;
