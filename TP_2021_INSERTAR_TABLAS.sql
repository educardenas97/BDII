prompt Created on lunes 26 de julio de 2021 by lauravega
set feedback off
set define off
prompt Loading D_BANCO...
insert into D_BANCO (cod_banco, desc_banco)
values (1, 'BANCO ITAU');
insert into D_BANCO (cod_banco, desc_banco)
values (2, 'BANCO NACIONAL DE FOMENTO');
insert into D_BANCO (cod_banco, desc_banco)
values (3, 'BANCO CONTINENTAL SAECA');
insert into D_BANCO (cod_banco, desc_banco)
values (4, 'BANCO REGIONAL SAECA');
commit;
prompt 4 records loaded
prompt Loading D_BANCO_CUENTA...
insert into D_BANCO_CUENTA (cod_banco, nro_cuenta, saldo_actual)
values (1, '320375832', 3500000);
insert into D_BANCO_CUENTA (cod_banco, nro_cuenta, saldo_actual)
values (1, '320437001', 10000000);
insert into D_BANCO_CUENTA (cod_banco, nro_cuenta, saldo_actual)
values (2, '290423554', 15000000);
insert into D_BANCO_CUENTA (cod_banco, nro_cuenta, saldo_actual)
values (3, '897544654', 550000);
insert into D_BANCO_CUENTA (cod_banco, nro_cuenta, saldo_actual)
values (4, '112658559', 0);
commit;
prompt 5 records loaded
prompt Loading D_TIMBRADO...
insert into D_TIMBRADO (nro_timbrado, establecimiento, punto_expedicion, fecha_desde_timbrado, fecha_hasta_timbrado, desde_numero_factura, hasta_numero_factura, numero_actual_factura)
values (13635156, '001', '001', to_date('01-06-2021', 'dd-mm-yyyy'), to_date('01-06-2022', 'dd-mm-yyyy'), 1, 1000000, 57);
insert into D_TIMBRADO (nro_timbrado, establecimiento, punto_expedicion, fecha_desde_timbrado, fecha_hasta_timbrado, desde_numero_factura, hasta_numero_factura, numero_actual_factura)
values (17895265, '001', '002', to_date('01-06-2021', 'dd-mm-yyyy'), to_date('01-06-2022', 'dd-mm-yyyy'), 1, 1000000, 2);
insert into D_TIMBRADO (nro_timbrado, establecimiento, punto_expedicion, fecha_desde_timbrado, fecha_hasta_timbrado, desde_numero_factura, hasta_numero_factura, numero_actual_factura)
values (20452354, '002', '001', to_date('01-07-2021', 'dd-mm-yyyy'), to_date('01-07-2022', 'dd-mm-yyyy'), 1, 100000, 1);
commit;
prompt 3 records loaded
prompt Loading D_CAJAS...
insert into D_CAJAS (nro_caja, desc_caja, nro_timbrado)
values (1, 'CAJA NRO 1', 13635156);
insert into D_CAJAS (nro_caja, desc_caja, nro_timbrado)
values (2, 'CAJA NRO 2', 13635156);
insert into D_CAJAS (nro_caja, desc_caja, nro_timbrado)
values (3, 'CAJA NRO 3', 13635156);
insert into D_CAJAS (nro_caja, desc_caja, nro_timbrado)
values (4, 'CAJA NRO 1', 17895265);
commit;
prompt 4 records loaded
prompt Loading D_MEDIDA...
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (1, 'UNIDADES', 1);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (2, 'PAQUETE DE 6', 6);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (3, 'PAQUETE DE 12', 12);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (4, 'PAQUETE', 1);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (5, 'CAJA DE 6', 6);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (6, 'CAJA DE 12', 12);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (7, 'PAQUETE DE 3', 3);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (8, 'CAJA', 1);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (9, 'KILOGRAMOS', 1);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (10, 'METROS', 1);
insert into D_MEDIDA (cod_medida, desc_medida, cant_unidades)
values (11, 'LITROS', 1);
commit;
prompt 11 records loaded
prompt Loading D_OPERACIONES...
Insert into D_OPERACIONES (COD_OPERACION,DESC_OPERACION,USO_CAJERO) values ('1','VENTA','1');
Insert into D_OPERACIONES (COD_OPERACION,DESC_OPERACION,USO_CAJERO) values ('2','COMPRA','1');
Insert into D_OPERACIONES (COD_OPERACION,DESC_OPERACION,USO_CAJERO) values ('3','TRASPASO','0');
Insert into D_OPERACIONES (COD_OPERACION,DESC_OPERACION,USO_CAJERO) values ('4','DEVOLUCION','0');
Insert into D_OPERACIONES (COD_OPERACION,DESC_OPERACION,USO_CAJERO) values ('5','ANULACION','0');
commit;
prompt 6 records loaded
prompt Loading D_PERSONAS...
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (1, 'Cinthia Carolina Mayeregger Benitez', 1811805, '1811805-4', null, 'Mariano Roque Alonso', '0984123243');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (2, 'Luz Mercedes Benitez De Alvarez', 1239510, '1239510-2', 'luzbenitez@gmail.com', 'Asuncion', '0981970716');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (3, 'Cesar Daniel Juvinel Kennedy', 2168989, null, null, 'Lambare', '0984915034');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (4, 'Yanini Ybett Touchet Gonzalez', 4862252, '4862252-4', 'yaninit@gmail.com', 'Itaugua', '0981342.046');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (5, 'Rita Librada Ortiz Aranda', 3685017, '3685017-9', null, 'Asuncion', null);
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (6, 'Rosa Isabel Burgos Medina', 4212427, '4212427-1', 'rosabur@hotmail.com', 'Escobar', '0982263069');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (7, 'Aldo Atilio Colman Varela', 617998, '617998-3', 'acolman@hotmail.com', 'Asuncion', null);
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (8, 'Alice Nathalia Rojas Enciso', 4973457, '4973457-1', null, 'Villa Elisa', '0984535850');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (9, 'Ruben David Osorio Franco', 4530419, null, null, 'Lambare', null);
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (10, 'Nancy Juliana Ugarte Morel', 2046752, '2046752-4', 'nmorel@gmail.com', 'Asuncion', '0985676911');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (11, 'Nelson Ever Gamarra Benitez', 2188424, '2188424-2', 'nelsonga@hotmail.com', 'Coronel Oviedo', '0981711649');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (12, 'Jorge Alberto Zarate Salinas', 3770739, '3770739-6', null, 'Capiata', null);
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (13, 'Oscar Ariel Merele Bogado', 4217931, '4217931-9', 'osmerele@hotmail.com', 'Neuland', '0983304008');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (14, 'Gladys Estela Cardenas Espinola', 3484341, '3484341-8', null, 'Fernando De La Mora', null);
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (15, 'Maria Jose Ozorio Colman', 4012755, '4012755-9', 'mj_ozorio@gmail.com', 'Asuncion', '0981148559');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (16, 'Gabriel Sardi Florentin', 806083, '806083-5', null, 'San Lorenzo', '0983227195');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (17, 'Emilio Domaniczky De Amoriza', 1904585, null, 'aviacionpy@gmail.com', 'Asuncion', '0983181559');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (18, 'Hercules De Giacomi Coronel', 2177131, '2177131-6', null, 'Lambare', '0985349657');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (19, 'Mirta Carolina Torres Molinas', 4185388, '4185388-1', 'mirtha.t@gmail.com', 'Itaugua', null);
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (20, 'Laura Beatriz Valdez Orrego', 3643607, '3643607-0', 'lavaldez@hotmail.com', 'Luque', '0984562454');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (21, 'Carlos Ruben Amarilla', 5112778, null, null, 'Itaugua', '0972713026');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (22, 'Jose Simon Gimenez Garcete', 3652544, '3652544', 'jgimenez@hotmail.com', 'Asuncion', '0982443515');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (23, 'Romina Veronica Martinez Palacios', 4492074, null, 'romartinez@gmail.com', 'Lambare', '0961267480');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (24, 'Francisco Gilberto Delacruz Martinez', 2361401, null, null, 'Emboscada', '0981828308');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (25, 'Evelyn Araceli Aquino Ayala', 4682223, null, 'eveaquino@gmail.com', 'Mariano Roque Alonso', '0985144180');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (26, 'Hector David Martinez', 4522179, null, null, 'Capiata', '0983642457');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (27, 'Adolfo Manuel Sanchez Espinoza', 4640188, null, null, 'Villa Elisa', '0985239923');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (28, 'Ana Rosalia Rojas Cabrera', 3954480, '3954480', 'anarojas@hotmail.com', 'Fernando De La Mora', '0984985408');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (29, 'Luis Gabriel Arzamendia Mereles', 5111331, null, null, 'Luque', '0993306052');
insert into D_PERSONAS (id_persona, denominacion, nro_documento, ruc, email, localidad, nro_telefono)
values (30, 'Hector Hugo Escobar Orue', 2557442, null, null, 'Luque', '0984841490');
commit;
prompt 30 records loaded
prompt Loading D_SUCURSAL...
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (1, 'CASA CENTRAL');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (2, 'TIENDA OUTLET');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (3, 'SAN LORENZO');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (4, 'FERNANDO DE LA MORA');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (5, 'LUQUE');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (6, 'CAPIATA');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (7, 'LIMPIO');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (8, 'LOMA PYTA');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (9, 'VILLA MORRA');
insert into D_SUCURSAL (cod_sucursal, desc_sucursal)
values (10, 'ITAGUA');
commit;
prompt 10 records loaded
prompt Loading D_TIPO_COMPROBANTE...
insert into D_TIPO_COMPROBANTE (cod_tipo_comprobante, desc_tipo_comprobante)
values (1, 'FACTURA');
insert into D_TIPO_COMPROBANTE (cod_tipo_comprobante, desc_tipo_comprobante)
values (2, 'REMISION');
commit;
prompt 2 records loaded
prompt Loading D_USUARIOS...
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('RAMP', 'Ramiro Perez', 1);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('VIVQ', 'Viviana Quiñonez', 1);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('PEDC', 'Pedro Cáceres', 0);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('PROM', 'Providenza Mendoza', 1);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('NELZ', 'Nelson Zarza', 0);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('LETO', 'Leticia Ortiz', 1);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('CECC', 'Cecilia Chávez', 1);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('FEDS', 'Federico Serrati', 1);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('CHIF', 'Chiara Frutos', 0);
insert into D_USUARIOS (id_usuario, nombre_usuario, estado)
values ('IVAF', 'Ivana Ferreira', 1);
commit;
prompt 10 records loaded
prompt Loading D_MOVIMIENTO_OPERACIONES...
insert into D_MOVIMIENTO_OPERACIONES (id_operacion, fecha_operacion, cod_sucursal, cod_operacion, id_persona, nro_caja, id_usuario, cod_tipo_comprobante, nro_comprobante, tipo_registro, descripcion_operacion, nro_timbrado, fecha_insert)
values (1, to_date('01-07-2021', 'dd-mm-yyyy'), 1, 1, 4, 1, 'CHIF', 1, '56', 'A', 'VENTA', 13635156, to_date('01-07-2021 12:00:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into D_MOVIMIENTO_OPERACIONES (id_operacion, fecha_operacion, cod_sucursal, cod_operacion, id_persona, nro_caja, id_usuario, cod_tipo_comprobante, nro_comprobante, tipo_registro, descripcion_operacion, nro_timbrado, fecha_insert)
values (2, to_date('05-07-2021', 'dd-mm-yyyy'), 2, 1, 10, null, 'CECC', 1, '1', 'A', 'VENTA', 17895265, to_date('05-07-2021 16:00:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into D_MOVIMIENTO_OPERACIONES (id_operacion, fecha_operacion, cod_sucursal, cod_operacion, id_persona, nro_caja, id_usuario, cod_tipo_comprobante, nro_comprobante, tipo_registro, descripcion_operacion, nro_timbrado, fecha_insert)
values (3, to_date('08-07-2021', 'dd-mm-yyyy'), 1, 1, 7, 1, 'CHIF', 1, '57', 'A', 'VENTA', 13635156, to_date('05-07-2021 16:00:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into D_MOVIMIENTO_OPERACIONES (id_operacion, fecha_operacion, cod_sucursal, cod_operacion, id_persona, nro_caja, id_usuario, cod_tipo_comprobante, nro_comprobante, tipo_registro, descripcion_operacion, nro_timbrado, fecha_insert)
values (4, to_date('10-07-2021', 'dd-mm-yyyy'), 2, 1, 12, null, 'CECC', 1, '2', 'A', 'VENTA', 17895265, to_date('05-07-2021 16:00:00', 'dd-mm-yyyy hh24:mi:ss'));
commit;
prompt 4 records loaded
prompt Loading D_TIPO_IVA...
insert into D_TIPO_IVA (cod_tipo_iva, desc_tipo_iva, porcentaje_iva, divisor_iva_incluido)
values (1, 'IVA 10%', 10, 11);
insert into D_TIPO_IVA (cod_tipo_iva, desc_tipo_iva, porcentaje_iva, divisor_iva_incluido)
values (2, 'IVA 5%', 5, 21);
commit;
prompt 2 records loaded
prompt Loading D_TIPO_PRODUCTO...
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (1, 'FERRETERIA');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (2, 'CUIDADO DE COCINA');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (3, 'CUIDADO DE PRENDAS');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (4, 'HIGIENE PERSONAL');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (5, 'INFUSIONES');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (6, 'BEBIDAS');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (7, 'SALSAS Y ADEREZOS');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (8, 'PRODUCTO DE LIMPIEZA');
insert into D_TIPO_PRODUCTO (cod_tipo_producto, desc_tipo_producto)
values (9, 'ALIMENTOS');
commit;
prompt 9 records loaded
prompt Loading D_PRODUCTOS...
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (1, 'SALSA DE AJO WALLA', 7, 1, null, 0, 'SALSA AJO', to_date('05-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 5350);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (2, 'JUGO DE MANZANA PIL', 6, 1, null, 0, 'JUGO MANZANA', to_date('23-10-2020 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1100);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (3, 'JUGO DE DURAZNO PIL', 6, 1, null, 0, 'JUGO DURAZNO', to_date('17-12-2020 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1100);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (4, 'JUGO DE NARANJA PIL', 6, 1, null, 0, 'JUGO NARANJA', to_date('17-12-2020 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1100);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (5, 'JUGO DE LIMON WALLA', 6, 1, null, 0, 'JUGO LIMON', to_date('05-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 2360);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (6, 'BOLSA RESIDUOS SUPER OXI ECONOMICA', 8, 1, null, 0, 'BOLSA SUPER OXI', to_date('18-12-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1900);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (7, 'DESINFECTANTE P/ PISOS PINO SUPER OXI', 8, 1, null, 0, 'DESIN PISO OXI', to_date('11-06-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 3750);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (8, 'GUANTES DE GOMA PANAMBI', 8, 1, null, 0, 'GUANTES PANAMBI', to_date('29-06-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 2550);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (9, 'DESINFECTANTE P/ PISOS CITRONELLA SUPER OXI', 8, 1, null, 0, 'DESIN SUPER OXI', to_date('15-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 12650);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (10, 'DESENGRASANTE DE COCINA C/ GATILLO SUPER OXI', 8, 1, null, 0, 'DESEN SUPER OXI', to_date('16-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 10980);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (11, 'DESODORANTE DE AMB. FRUTO ROSA SUPER OXI', 8, 1, null, 0, 'DES. AMB. SUPER OXI', to_date('21-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 3000);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (12, 'DESODORANTE DE AMB. GREEN TEA SUPER OXI', 8, 1, null, 0, 'DES. AMB SUPER OXI', to_date('21-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 3000);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (13, 'DETERGENTE LAVA VAJILLAS SUPER OXI', 8, 1, null, 0, 'DET. SUPER OXI', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 3400);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (14, 'SALSA INGLESA WALLA', 7, 1, null, 0, 'SALSA SOJA', to_date('28-12-2020 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1890);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (15, 'SALSA DE SOJA WALLA', 7, 1, null, 0, 'SALSA SOJA', to_date('15-06-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1890);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (16, 'ARVEJA NUAR', 9, 1, null, 0, 'ARVEJA NUAR', to_date('06-01-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 2550);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (17, 'CHOCLO WALLA', 9, 1, null, 0, 'CHOCLO WALLA', to_date('12-02-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 2720);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (18, 'CHAMPIGNON EN TROZOS VACAREL', 9, 1, null, 0, 'CHAMPIG. VACAREL', to_date('17-02-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 5830);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (19, 'ARVEJA MARCOPOLO', 9, 1, null, 0, 'ARVEJA MARCOPOLO', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 2750);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (20, 'CHOCLO MARCOPOLO', 9, 1, null, 0, 'CHOCLO MARCOPOLO', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 2720);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (21, 'TE SUPREMO ENERGIZANTE CON GUARANA', 5, 1, null, 0, 'TE SUPREMO EN. GUARA', to_date('13-05-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 10950);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (22, 'TE SUPREMO ROSA MOSQUETA', 5, 1, null, 0, 'TE SUPREMO ROSA MOS', to_date('17-06-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 10950);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (23, 'TE SUPREMO CEDRON', 5, 1, null, 0, 'TE SUPREMO CEDRON', to_date('05-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 10950);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (24, 'TE NEGRO HORNIMANS', 5, 1, null, 0, 'TE NEGRO HORNIMANS', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 15950);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (25, 'FIDEO RIGATTI MARCOPOLO', 9, 1, null, 0, 'FIDEO RIGATTI', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1980);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (26, 'FIDEO SPAGHETTI MARCOPOLO', 9, 1, null, 0, 'FIDEO RIGATTI S', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1980);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (27, 'FIDEO TALLARIN MARCOPOLO', 9, 1, null, 0, 'FIDEO RIGATTI T', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 1980);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (28, 'EDULCORANTE TRADICIONAL WALLA', 9, 1, null, 0, 'EDULCORANTE TRADICIO', to_date('10-06-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 5699);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (29, 'EDULCORANTE  C/ KA A HE E 250ML. WALLA', 9, 1, null, 0, 'EDULCORANTE C/ KA A', to_date('20-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 7699);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (30, 'CERA ROJA P/ PISOS SUPER OXI', 8, 1, null, 0, 'CERA ROJA P/ PISOS', to_date('08-06-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 54150);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (31, 'AROMATIZADOR HOGAR BEBE INTENSE SUPER OXI', 8, 1, null, 0, 'AROMATIZADOR HOGAR B', to_date('09-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 4550);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (32, 'ALCOHOL  70° C/ GATILLO FRAGANCIA FLORAL SUPER OXI', 4, 1, null, 0, 'ALCOHOL 70 C GATI', to_date('08-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 5780);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (33, 'PAPEL HIGIENICO PANDA HOJA SIMPLE', 4, 1, null, 0, 'PAPEL HIGIENICO PAND', to_date('22-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 5550);
insert into D_PRODUCTOS (id_producto, desc_producto, cod_tipo_producto, cod_tipo_iva, codigo_barra, porcentaje_beneficio, desc_abreviado, fecha_ultima_compra, precio_ultima_compra)
values (34, 'JABON LIQ. P/ MANOS AQUA DI MARE 5L SUPER OXI', 4, 1, null, 0, 'JABON LIQ. P/ MANOS', to_date('20-07-2021 08:30:00', 'dd-mm-yyyy hh24:mi:ss'), 8550);
commit;
prompt 34 records loaded
prompt Loading D_DETALLE_OPERACIONES...
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (1, 1, 2, 1, 6, 1100, 6600, 0, 1, 10, 600, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (2, 1, 6, 1, 1, 1900, 1900, 0, 1, 10, 173, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (3, 1, 30, 1, 1, 54150, 54150, 0, 1, 10, 4923, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (4, 2, 28, 1, 2, 5699, 11398, 0, 1, 10, 1036, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (5, 2, 8, 1, 1, 2550, 2550, 0, 1, 10, 232, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (6, 2, 21, 1, 1, 10950, 10950, 0, 1, 10, 995, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (7, 2, 22, 1, 1, 10950, 10950, 0, 1, 10, 995, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (8, 2, 23, 1, 1, 10950, 10950, 0, 1, 10, 995, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (9, 3, 25, 4, 3, 1980, 5940, 0, 1, 10, 594, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (10, 3, 26, 4, 3, 1980, 5940, 0, 1, 10, 594, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (11, 3, 27, 4, 3, 1980, 5940, 0, 1, 10, 594, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (12, 3, 9, 1, 1, 12650, 12650, 0, 1, 10, 1150, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (13, 3, 13, 1, 1, 3400, 3400, 0, 1, 10, 309, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (14, 3, 31, 1, 1, 4550, 4550, 0, 1, 10, 414, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (15, 4, 17, 1, 3, 2720, 8160, 0, 1, 10, 742, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (16, 4, 19, 1, 1, 2720, 2720, 0, 1, 10, 247, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (17, 4, 20, 1, 2, 2720, 5440, 0, 1, 10, 495, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (18, 4, 18, 1, 2, 5830, 11660, 0, 1, 10, 1060, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (19, 4, 1, 1, 1, 5350, 5350, 0, 1, 10, 486, 0);
insert into D_DETALLE_OPERACIONES (id_registro, id_operacion, id_producto, cod_medida, cantidad_operacion, precio_operacion, importe_operacion, importe_descuento, cod_tipo_iva, porcentaje_iva, importe_iva, importe_recargo)
values (20, 4, 14, 1, 1, 1890, 1890, 0, 1, 10, 172, 0);
commit;
prompt 20 records loaded
prompt Loading D_FORMA_PAGO...
insert into D_FORMA_PAGO (cod_forma_pago, desc_forma_pago, requiere_nro_comprobante, porcentaje_descuento, porcentaje_recargo)
VALUES (1,'EFECTIVO',0,0,0);
insert into D_FORMA_PAGO (cod_forma_pago, desc_forma_pago, requiere_nro_comprobante, porcentaje_descuento, porcentaje_recargo)
 VALUES(2,'EFECTIVO PROMO',0,20,0);
insert into D_FORMA_PAGO (cod_forma_pago, desc_forma_pago, requiere_nro_comprobante, porcentaje_descuento, porcentaje_recargo)
VALUES(3,'TARJETA ITAU',1,10,0);
insert into D_FORMA_PAGO (cod_forma_pago, desc_forma_pago, requiere_nro_comprobante, porcentaje_descuento, porcentaje_recargo)
VALUES(4,'TARJETA DE LA CASA',1,20,0);
insert into D_FORMA_PAGO (cod_forma_pago, desc_forma_pago, requiere_nro_comprobante, porcentaje_descuento, porcentaje_recargo)
VALUES(5,'TARJETA CREDITO',1,0,9);
commit;
prompt 5 records loaded
prompt Loading D_PAGO_OPERACION...
insert into D_PAGO_OPERACION (id_registro, cod_forma_pago, nro_referencia_pago, cod_banco, nro_cuenta, nro_cheque, importe_pago, id_operacion)
values (1, 1, null, null, null, null, 62650, 1);
insert into D_PAGO_OPERACION (id_registro, cod_forma_pago, nro_referencia_pago, cod_banco, nro_cuenta, nro_cheque, importe_pago, id_operacion)
values (2, 3, 741258, 1, '1124923', null, 46798, 2);
insert into D_PAGO_OPERACION (id_registro, cod_forma_pago, nro_referencia_pago, cod_banco, nro_cuenta, nro_cheque, importe_pago, id_operacion)
values (3, 1, null, null, null, null, 38420, 3);
insert into D_PAGO_OPERACION (id_registro, cod_forma_pago, nro_referencia_pago, cod_banco, nro_cuenta, nro_cheque, importe_pago, id_operacion)
values (4, 1, null, null, null, null, 35220, 4);
commit;
prompt 4 records loaded
prompt Loading D_PRODUCTOS_MEDIDA_PRECIO...
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (1, 10550, 34, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (2, 5550, 33, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (3, 8780, 32, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (6, 9699, 29, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (7, 7699, 28, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (8, 2980, 27, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (9, 2980, 26, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (10, 2980, 25, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (11, 17950, 24, 5, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (12, 17950, 23, 5, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (13, 17950, 22, 5, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (14, 3890, 21, 1, 1, 1);
insert into D_PRODUCTOS_MEDIDA_PRECIO (id_registro, precio_venta, id_producto, cod_medida, cod_sucursal, cod_forma_pago)
values (15, 3890, 20, 1, 1, 1);
commit;
prompt 13 records loaded
prompt Loading D_STOCK_SUCURSAL...
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (1, 1, 121, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (2, 1, 111, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (3, 1, 211, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (4, 1, 122, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (5, 1, 130, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (6, 1, 121, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (1, 31, 140, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (2, 31, 144, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (3, 31, 101, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (4, 31, 110, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (2, 27, 180, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (3, 27, 221, 100);
insert into D_STOCK_SUCURSAL (cod_sucursal, id_producto, cantidad_existencia, stock_minimo)
values (4, 27, 124, 100);
commit;
prompt 13 records loaded
prompt Loading D_TIPO_COMPROBANTE_SECUENCIA...
prompt Table is empty
set feedback on
set define on
prompt Done.
