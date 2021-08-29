-- Enunciado 4
-- Item A
SPOOL temp.sql;
SELECT 'CREATE SYNONYM "' || SUBSTR(a.table_name, 3)  || '" FOR "' || a.owner || '"."' || a.table_name || '";'
FROM   dba_tables a
WHERE TABLESPACE_NAME ='BASECONTABLE'
AND a.table_name LIKE 'D_%';
SPOOL OFF;
@temp.sql

--- Item B
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE ROLE R_CONS;
ALTER SESSION SET "_ORACLE_SCRIPT"=false;

--- Item D
SPOOL temp.sql;
SELECT 'GRANT SELECT ON ' || a.table_name  || ' TO R_CONS;'
FROM   dba_tables a
WHERE TABLESPACE_NAME ='BASECONTABLE'
AND a.table_name LIKE 'D_%';
SPOOL OFF;
@temp.sql
--- Comprobación de que se han creado los roles
SELECT TABLE_NAME, privilege FROM ROLE_TAB_PRIVS WHERE ROLE = 'R_CONS';



-- move d_tables to tablespace BASE_CONTABLE
alter table D_ASIENTO_CABECERA move tablespace BASECONTABLE;
alter table D_CUENTAS_CONTABLES move tablespace BASECONTABLE;
alter table D_PLANTILLA_ASIENTO move tablespace BASECONTABLE;
alter table D_PLANTILLA_DETALLE move tablespace BASECONTABLE;
alter table D_ASIENTO_DETALLE move tablespace BASECONTABLE;
------------------------------------------------