$ sf000|SFC:/tecnol/util/sql>more ins_aud.sql
SET SERVEROUTPUT ON
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK ON
SET LINES 100

SPOOL &1

EXEC dbms_output.put_line('*****Base: SF065')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf065
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf065
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF078')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf078
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf078
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF085*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf085
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf085
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF090*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf090
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf090
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF091*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf091
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf091
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF092*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf092
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf092
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF107*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf107
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf107
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF129*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200******')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf129
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf129
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF131****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf131
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf131
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF160****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf160
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf160
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF165****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf165
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf165
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF181')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf181
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf181
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF184****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf184
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf184
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf188
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf188
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SF189*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030
   SELECT *
     FROM sts.aud_detalle_ttes0030@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0030@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0100*****')
/
INSERT INTO auditoria.aud_detalle_ttes0100
   SELECT *
     FROM sts.aud_detalle_ttes0100@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0100@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0640*****')
/
INSERT INTO auditoria.aud_detalle_ttes0640
   SELECT *
     FROM sts.aud_detalle_ttes0640@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_detalle_ttes0640@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030
   SELECT *
     FROM sts.aud_maestro_ttes0030@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0030@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0100*****')
/
INSERT INTO auditoria.aud_maestro_ttes0100
   SELECT *
     FROM sts.aud_maestro_ttes0100@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0100@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0640*****')
/
INSERT INTO auditoria.aud_maestro_ttes0640
   SELECT *
     FROM sts.aud_maestro_ttes0640@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM sts.aud_maestro_ttes0640@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041500*****')
/
INSERT INTO auditoria.aud_detalle_t6041500
   SELECT *
     FROM u601.aud_detalle_t6041500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6041900*****')
/
INSERT INTO auditoria.aud_detalle_t6041900
   SELECT *
     FROM u601.aud_detalle_t6041900@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6041900@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6042900*****')
/
INSERT INTO auditoria.aud_detalle_t6042900
   SELECT *
     FROM u601.aud_detalle_t6042900@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6042900@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6052500*****')
/
INSERT INTO auditoria.aud_detalle_t6052500
   SELECT *
     FROM u601.aud_detalle_t6052500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6052500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6197500*****')
/
INSERT INTO auditoria.aud_detalle_t6197500
   SELECT *
     FROM u601.aud_detalle_t6197500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6197500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230200*****')
/
INSERT INTO auditoria.aud_detalle_t6230200
   SELECT *
     FROM u601.aud_detalle_t6230200@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230200@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6230300*****')
/
INSERT INTO auditoria.aud_detalle_t6230300
   SELECT *
     FROM u601.aud_detalle_t6230300@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6230300@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231100*****')
/
INSERT INTO auditoria.aud_detalle_t6231100
   SELECT *
     FROM u601.aud_detalle_t6231100@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231100@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6231200*****')
/
INSERT INTO auditoria.aud_detalle_t6231200
   SELECT *
     FROM u601.aud_detalle_t6231200@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6231200@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6520500*****')
/
INSERT INTO auditoria.aud_detalle_t6520500
   SELECT *
     FROM u601.aud_detalle_t6520500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6520500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741300*****')
/
INSERT INTO auditoria.aud_detalle_t6741300
   SELECT *
     FROM u601.aud_detalle_t6741300@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741300@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741400*****')
/
INSERT INTO auditoria.aud_detalle_t6741400
   SELECT *
     FROM u601.aud_detalle_t6741400@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741400@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t6741500*****')
/
INSERT INTO auditoria.aud_detalle_t6741500
   SELECT *
     FROM u601.aud_detalle_t6741500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t6741500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041500*****')
/
INSERT INTO auditoria.aud_maestro_t6041500
   SELECT *
     FROM u601.aud_maestro_t6041500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6041900*****')
/
INSERT INTO auditoria.aud_maestro_t6041900
   SELECT *
     FROM u601.aud_maestro_t6041900@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6041900@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6042900*****')
/
INSERT INTO auditoria.aud_maestro_t6042900
   SELECT *
     FROM u601.aud_maestro_t6042900@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6042900@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6052500*****')
/
INSERT INTO auditoria.aud_maestro_t6052500
   SELECT *
     FROM u601.aud_maestro_t6052500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6052500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6197500*****')
/
INSERT INTO auditoria.aud_maestro_t6197500
   SELECT *
     FROM u601.aud_maestro_t6197500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6197500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230200*****')
/
INSERT INTO auditoria.aud_maestro_t6230200
   SELECT *
     FROM u601.aud_maestro_t6230200@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230200@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6230300*****')
/
INSERT INTO auditoria.aud_maestro_t6230300
   SELECT *
     FROM u601.aud_maestro_t6230300@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6230300@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231100*****')
/
INSERT INTO auditoria.aud_maestro_t6231100
   SELECT *
     FROM u601.aud_maestro_t6231100@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231100@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6231200*****')
/
INSERT INTO auditoria.aud_maestro_t6231200
   SELECT *
     FROM u601.aud_maestro_t6231200@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6231200@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6520500*****')
/
INSERT INTO auditoria.aud_maestro_t6520500
   SELECT *
     FROM u601.aud_maestro_t6520500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6520500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741300*****')
/
INSERT INTO auditoria.aud_maestro_t6741300
   SELECT *
     FROM u601.aud_maestro_t6741300@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741300@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741400*****')
/
INSERT INTO auditoria.aud_maestro_t6741400
   SELECT *
     FROM u601.aud_maestro_t6741400@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741400@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t6741500*****')
/
INSERT INTO auditoria.aud_maestro_t6741500
   SELECT *
     FROM u601.aud_maestro_t6741500@dwh_sf189
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t6741500@dwh_sf189
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: Sucursales*****')
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf065 a, SYS.v_$database@dwh_sf065 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf065
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf078 a, SYS.v_$database@dwh_sf078 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf078
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf085 a, SYS.v_$database@dwh_sf085 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf085
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf090 a, SYS.v_$database@dwh_sf090 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf090
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf091 a, SYS.v_$database@dwh_sf091 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf091
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf092 a, SYS.v_$database@dwh_sf092 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf092
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf107 a, SYS.v_$database@dwh_sf107 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf107
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf129 a, SYS.v_$database@dwh_sf129 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf129
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf131 a, SYS.v_$database@dwh_sf131 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf131
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf160 a, SYS.v_$database@dwh_sf160 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf160
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf165 a, SYS.v_$database@dwh_sf165 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
DELETE FROM SYS.aud$@dwh_sf165
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf181 a, SYS.v_$database@dwh_sf181 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf181
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf184 a, SYS.v_$database@dwh_sf184 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf184
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf188 a, SYS.v_$database@dwh_sf188 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf188
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@dwh_sf189 a, SYS.v_$database@dwh_sf189 b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@dwh_sf189
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/

-------------------------------------------------------------------------------------------------------------------------------------------------
EXEC dbms_output.put_line('*****Base: SFC*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t0001*****')
/
INSERT INTO auditoria.aud_detalle_t0001
   SELECT *
     FROM cotoacasa.aud_detalle_t0001@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM cotoacasa.aud_detalle_t0001@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t0002*****')
/
INSERT INTO auditoria.aud_detalle_t0002
   SELECT *
     FROM cotoacasa.aud_detalle_t0002@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM cotoacasa.aud_detalle_t0002@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t0002v2*****')
/
INSERT INTO auditoria.aud_detalle_t0002v2
   SELECT *
     FROM cotoacasa.aud_detalle_t0002v2@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM cotoacasa.aud_detalle_t0002v2@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t0001*****')
/
INSERT INTO auditoria.aud_maestro_t0001
   SELECT *
     FROM cotoacasa.aud_maestro_t0001@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM cotoacasa.aud_maestro_t0001@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t0002*****')
/
INSERT INTO auditoria.aud_maestro_t0002
   SELECT *
     FROM cotoacasa.aud_maestro_t0002@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM cotoacasa.aud_maestro_t0002@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t0002v2*****')
/
INSERT INTO auditoria.aud_maestro_t0002v2
   SELECT *
     FROM cotoacasa.aud_maestro_t0002v2@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM cotoacasa.aud_maestro_t0002v2@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ti_ha*****')
/
INSERT INTO auditoria.aud_detalle_ti_ha
   SELECT *
     FROM u601.aud_detalle_ti_ha@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_ti_ha@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0030c*****')
/
INSERT INTO auditoria.aud_detalle_ttes0030c
   SELECT *
     FROM u601.aud_detalle_ttes0030@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_ttes0030@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0101*****')
/
INSERT INTO auditoria.aud_detalle_ttes0101
   SELECT *
     FROM u601.aud_detalle_ttes0101@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_ttes0101@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ttes0770*****')
/
INSERT INTO auditoria.aud_detalle_ttes0770
   SELECT *
     FROM u601.aud_detalle_ttes0770@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_ttes0770@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7740300_sfc*****')
/
INSERT INTO auditoria.aud_detalle_t7740300_sfc
   SELECT *
     FROM u601.aud_detalle_t7740300@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t7740300@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7744000_sfc*****')
/
INSERT INTO auditoria.aud_detalle_t7744000_sfc
   SELECT *
     FROM u601.aud_detalle_t7744000@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t7744000@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7744300_sfc*****')
/
INSERT INTO auditoria.aud_detalle_t7744300_sfc
   SELECT *
     FROM u601.aud_detalle_t7744300@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_t7744300@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ti_ha*****')
/
INSERT INTO auditoria.aud_maestro_ti_ha
   SELECT *
     FROM u601.aud_maestro_ti_ha@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_ti_ha@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0030c*****')
/
INSERT INTO auditoria.aud_maestro_ttes0030c
   SELECT *
     FROM u601.aud_maestro_ttes0030@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_ttes0030@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0101*****')
/
INSERT INTO auditoria.aud_maestro_ttes0101
   SELECT *
     FROM u601.aud_maestro_ttes0101@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_ttes0101@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ttes0770*****')
/
INSERT INTO auditoria.aud_maestro_ttes0770
   SELECT *
     FROM u601.aud_maestro_ttes0770@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_ttes0770@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7740300_sfc*****')
/
INSERT INTO auditoria.aud_maestro_t7740300_sfc
   SELECT *
     FROM u601.aud_maestro_t7740300@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t7740300@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7744000_sfc*****')
/
INSERT INTO auditoria.aud_maestro_t7744000_sfc
   SELECT *
     FROM u601.aud_maestro_t7744000@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t7744000@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7744300_sfc*****')
/
INSERT INTO auditoria.aud_maestro_t7744300_sfc
   SELECT *
     FROM u601.aud_maestro_t7744300@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_t7744300@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('***** Tabla: AUD_DETALLE_TITHISTORY *****')
/
INSERT INTO AUDITORIA.AUD_DETALLE_TITHISTORY
   SELECT *
     FROM GENCF.AUD_DETALLE_TITHISTORY@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM GENCF.AUD_DETALLE_TITHISTORY@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('***** Tabla: AUD_MAESTRO_TITHISTORY *****')
/
INSERT INTO AUDITORIA.AUD_MAESTRO_TITHISTORY
   SELECT *
     FROM GENCF.AUD_MAESTRO_TITHISTORY@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM GENCF.AUD_MAESTRO_TITHISTORY@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('***** Tabla: AUD_DETALLE_TITPUNTOS *****')
/
INSERT INTO AUDITORIA.AUD_DETALLE_TITPUNTOS
   SELECT *
     FROM GENCF.AUD_DETALLE_TITPUNTOS@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM GENCF.AUD_DETALLE_TITPUNTOS@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('***** Tabla: AUD_MAESTRO_TITPUNTOS *****')
/
INSERT INTO AUDITORIA.AUD_MAESTRO_TITPUNTOS
   SELECT *
     FROM GENCF.AUD_MAESTRO_TITPUNTOS@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM GENCF.AUD_MAESTRO_TITPUNTOS@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('***** Tabla: AUD_DETALLE_H_PUNTOS *****')
/
INSERT INTO AUDITORIA.AUD_DETALLE_H_PUNTOS
   SELECT *
     FROM GENCF.AUD_DETALLE_H_PUNTOS@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM GENCF.AUD_DETALLE_H_PUNTOS@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('***** Tabla: AUD_MAESTRO_H_PUNTOS *****')
/
INSERT INTO AUDITORIA.AUD_MAESTRO_H_PUNTOS
   SELECT *
     FROM GENCF.AUD_MAESTRO_H_PUNTOS@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha_1) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM GENCF.AUD_MAESTRO_H_PUNTOS@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha_1) < TRUNC (SYSDATE)
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@PT01ESQ1_PT01SFC a, SYS.v_$database@PT01ESQ1_PT01SFC b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@PT01ESQ1_PT01SFC
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: SIT*****')
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_descuentos*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_descuentos
   SELECT *
     FROM mcca.aud_detalle_ctcii_descuentos@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_descuentos@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_desc_debita*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_desc_debita
   SELECT *
     FROM mcca.aud_detalle_ctcii_desc_debita@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_desc_debita@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_desc_pos_for*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_desc_pos_for
   SELECT *
     FROM mcca.aud_detalle_ctcii_desc_pos_for@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_desc_pos_for@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_desc_quiero*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_desc_quiero
   SELECT *
     FROM mcca.aud_detalle_ctcii_desc_quiero@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_desc_quiero@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_liquid*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_liquid
   SELECT *
     FROM mcca.aud_detalle_ctcii_liquid@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_liquid@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_liquid_buf*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_liquid_buf
   SELECT *
     FROM mcca.aud_detalle_ctcii_liquid_buf@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_liquid_buf@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_liquid_hist*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_liquid_hist
   SELECT *
     FROM mcca.aud_detalle_ctcii_liquid_hist@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_liquid_hist@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_liq_cuotitas*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_liq_cuotitas
   SELECT *
     FROM mcca.aud_detalle_ctcii_liq_cuotitas@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_liq_cuotitas@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_liq_tci_seg*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_liq_tci_seg
   SELECT *
     FROM mcca.aud_detalle_ctcii_liq_tci_seg@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_liq_tci_seg@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_ventas*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_ventas
   SELECT *
     FROM mcca.aud_detalle_ctcii_ventas@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_ventas@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_ctcii_ventas_hist*****')
/
INSERT INTO auditoria.aud_detalle_ctcii_ventas_hist
   SELECT *
     FROM mcca.aud_detalle_ctcii_ventas_hist@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_detalle_ctcii_ventas_hist@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_descuentos*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_descuentos
   SELECT *
     FROM mcca.aud_maestro_ctcii_descuentos@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_descuentos@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_desc_debita*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_desc_debita
   SELECT *
     FROM mcca.aud_maestro_ctcii_desc_debita@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_desc_debita@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_desc_pos_for*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_desc_pos_for
   SELECT *
     FROM mcca.aud_maestro_ctcii_desc_pos_for@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_desc_pos_for@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_desc_quiero*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_desc_quiero
   SELECT *
     FROM mcca.aud_maestro_ctcii_desc_quiero@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_desc_quiero@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_liquid*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_liquid
   SELECT *
     FROM mcca.aud_maestro_ctcii_liquid@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_liquid@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_liquid_buf*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_liquid_buf
   SELECT *
     FROM mcca.aud_maestro_ctcii_liquid_buf@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_liquid_buf@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_liquid_hist*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_liquid_hist
   SELECT *
     FROM mcca.aud_maestro_ctcii_liquid_hist@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_liquid_hist@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_liquid_hist2*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_liquid_hist2
   SELECT *
     FROM mcca.aud_maestro_ctcii_liquid_hist2@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_liquid_hist2@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_liq_cuotitas*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_liq_cuotitas
   SELECT *
     FROM mcca.aud_maestro_ctcii_liq_cuotitas@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_liq_cuotitas@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_liq_tci_seg*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_liq_tci_seg
   SELECT *
     FROM mcca.aud_maestro_ctcii_liq_tci_seg@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_liq_tci_seg@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_ventas*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_ventas
   SELECT *
     FROM mcca.aud_maestro_ctcii_ventas@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_ventas@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_ctcii_ventas_hist*****')
/
INSERT INTO auditoria.aud_maestro_ctcii_ventas_hist
   SELECT *
     FROM mcca.aud_maestro_ctcii_ventas_hist@PT01ESQ1_PT01SIT
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM mcca.aud_maestro_ctcii_ventas_hist@PT01ESQ1_PT01SIT
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@PT01ESQ1_PT01SIT a, SYS.v_$database@PT01ESQ1_PT01SIT b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@PT01ESQ1_PT01SIT
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Base: DWH*****')
/
EXEC dbms_output.put_line('*****Tabla: auditoria.aud_maestro_t7744000*****')
/
INSERT INTO auditoria.aud_maestro_t7744000
   SELECT *
     FROM dssadm.aud_maestro_t7744000@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7744000@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: auditoria.aud_detalle_t7744000*****')
/
INSERT INTO auditoria.aud_detalle_t7744000
   SELECT *
     FROM dssadm.aud_detalle_t7744000@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7744000@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7740300_backup*****')
/
INSERT INTO auditoria.aud_maestro_t7740300_backup
   SELECT *
     FROM dssadmin.aud_maestro_t7740300_backup@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadmin.aud_maestro_t7740300_backup@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7744300_backup*****')
/
INSERT INTO auditoria.aud_detalle_t7744000_backup
   SELECT *
     FROM dssadm.aud_detalle_t7744000_backup@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7744000_backup@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7744000_backup*****')
/
INSERT INTO auditoria.aud_maestro_t7744000_snap
   SELECT *
     FROM dssadm.aud_maestro_t7744000_snap@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7744000_snap@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7744300_backup*****')
/
INSERT INTO auditoria.aud_detalle_t7744300_backup
   SELECT *
     FROM dssadm.aud_detalle_t7744300_backup@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7744300_backup@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7744300_backup*****')
/
INSERT INTO auditoria.aud_maestro_t7744300_backup
   SELECT *
     FROM dssadm.aud_maestro_t7744300_backup@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7744300_backup@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7740300*****')
/
INSERT INTO auditoria.aud_maestro_t7740300
   SELECT *
     FROM dssadm.aud_maestro_t7740300@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7740300@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7740300_backup*****')
/
INSERT INTO auditoria.aud_detalle_t7740300_backup
   SELECT *
     FROM dssadmin.aud_detalle_t7740300_backup@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadmin.aud_detalle_t7740300_backup@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7740300*****')
/
INSERT INTO auditoria.aud_detalle_t7740300
   SELECT *
     FROM dssadm.aud_detalle_t7740300@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7740300@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7740300_snap*****')
/
INSERT INTO auditoria.aud_detalle_t7740300_snap
   SELECT *
     FROM dssadm.aud_detalle_t7740300_snap@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7740300_snap@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7740300_snap*****')
/
INSERT INTO auditoria.aud_maestro_t7744000_backup
   SELECT *
     FROM dssadm.aud_maestro_t7744000_backup@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7744000_backup@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7740300_snap*****')
/
INSERT INTO auditoria.aud_maestro_t7740300_snap
   SELECT *
     FROM dssadm.aud_maestro_t7740300_snap@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7740300_snap@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_t7744300_snap*****')
/
INSERT INTO auditoria.aud_maestro_t7744300_snap
   SELECT *
     FROM dssadm.aud_maestro_t7744300_snap@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_maestro_t7744300_snap@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7744000_snap*****')
/
INSERT INTO auditoria.aud_detalle_t7744000_snap
   SELECT *
     FROM dssadm.aud_detalle_t7744000_snap@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7744000_snap@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_t7744300_snap*****')
/
INSERT INTO auditoria.aud_detalle_t7744300_snap
   SELECT *
     FROM dssadm.aud_detalle_t7744300_snap@PT01ESQ1_ECNDWH
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM dssadm.aud_detalle_t7744300_snap@PT01ESQ1_ECNDWH
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_detalle_cred_trx_hist*****')
/
INSERT INTO auditoria.aud_detalle_cred_trx_hist
   SELECT *
     FROM u601.aud_detalle_cred_trx_hist@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_detalle_cred_trx_hist@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud_maestro_cred_trx_hist*****')
/
INSERT INTO auditoria.aud_maestro_cred_trx_hist
   SELECT *
     FROM u601.aud_maestro_cred_trx_hist@PT01ESQ1_PT01SFC
    WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
DELETE FROM u601.aud_maestro_cred_trx_hist@PT01ESQ1_PT01SFC
      WHERE TRUNC (fecha) < TRUNC (SYSDATE)
/
COMMIT
/
EXEC dbms_output.put_line('*****Tabla: aud*****')
/
INSERT INTO auditoria.aud
   (SELECT a.sessionid, a.entryid, a.STATEMENT, a.timestamp#, a.userid,
           a.userhost, a.terminal, a.action#, a.returncode, a.obj$creator,
           a.obj$name, a.auth$privileges, a.auth$grantee, a.new$owner,
           a.new$name, a.ses$actions, a.ses$tid, a.logoff$lread,
           a.logoff$pread, a.logoff$lwrite, a.logoff$dead, a.logoff$time,
           a.comment$text, a.clientid, a.spare1, a.spare2, a.obj$label,
           a.ses$label, a.priv$used, a.sessioncpu, SYSTIMESTAMP, b.NAME
      FROM SYS.aud$@PT01ESQ1_ECNDWH a, SYS.v_$database@PT01ESQ1_ECNDWH b
     WHERE TRUNC (a.timestamp#) < TRUNC (SYSDATE))
/
COMMIT
/
DELETE FROM SYS.aud$@PT01ESQ1_ECNDWH
      WHERE TRUNC (timestamp#) < TRUNC (SYSDATE)
/
COMMIT
/
SPOOL OFF
EXIT
$ sf000|SFC:/tecnol/util/sql>