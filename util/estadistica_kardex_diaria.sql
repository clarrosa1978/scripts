set doc off
/******************************************************************************************************************
   Nombre:      estadisticas_kardex_diaria.sql
   Fecha:       02/05/2005
   Autor:       Area de Base de Datos
   Descripcion: Toma las estadisticas de la tabla BT_KARDEX_DIARIA.

    select module, status, logon_time from v$session where module like 'STATS%';

******************************************************************************************************************/
set serveroutput on 
set termout on
set line 300
set verify off
alter session set sort_area_size =  256000 ;
alter session set db_file_multiblock_read_count =  32;
spool &1
DECLARE
/** Cuerpo principal **/
  v_startdate date;
  v_sql VARCHAR2(2000);
  source_cursor        INTEGER;
  ignore               INTEGER;
  vfirstday            DATE;
  vdomingo             DATE;
  vlastday             DATE;
BEGIN
  select ADD_MONTHS(LAST_DAY(sysdate), -1)+10,
     NEXT_DAY(ADD_MONTHS(LAST_DAY(sysdate), -1)+10,'SUNDAY')
    ,ADD_MONTHS(LAST_DAY(sysdate), -1)+20  
  into vfirstday,vdomingo,vlastday FROM DUAL;
  IF trunc(sysdate)=trunc(vdomingo) THEN
    dbms_output.enable (999999);
    source_cursor := dbms_sql.open_cursor;
    v_sql := 'analyze table dssadmin.bt_kardex_diaria delete statistics';
    dbms_sql.PARSE(source_cursor,v_sql,DBMS_SQL.native);
    ignore := DBMS_SQL.EXECUTE(source_cursor); 
    dbms_sql.close_cursor(source_cursor);

    for i in( select owner,table_name from dba_tables  
           where table_name = 'BT_KARDEX_DIARIA')loop

    --Computa estadistica solamente de la tabla
      source_cursor := dbms_sql.open_cursor;
      v_sql := 'ANALYZE TABLE ' || i.owner || '.'||i.table_name || ' estimate statistics sample 20 percent ';
      dbms_sql.PARSE(source_cursor,v_sql,DBMS_SQL.native);
      ignore := DBMS_SQL.EXECUTE(source_cursor); 
      dbms_sql.close_cursor(source_cursor);

    --Computa estadistica de los indices de la tabla
      for j in (select * from dba_indexes b
               where b.owner = i.owner
                 and b.table_name = i.table_name) loop
        source_cursor := dbms_sql.open_cursor;
        v_sql := 'ANALYZE INDEX ' || j.owner || '.'||j.index_name || ' estimate statistics sample 20 percent';
        dbms_sql.PARSE(source_cursor,v_sql,DBMS_SQL.native);
        ignore := DBMS_SQL.EXECUTE(source_cursor); 
        dbms_sql.close_cursor(source_cursor);
      end loop;
    end loop;
  END IF;
  dbms_output.put_line('Fin');
exception
  when others then
   raise_application_error(-20742,sqlerrm||' Error en BT_KARDEX_DIARIA');
END;
/

spool off

exit
