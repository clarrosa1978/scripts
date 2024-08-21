set echo off
set serveroutput on
set verify off
set linesize 132
set timing on
alter session set sort_area_size=33554432;
alter session set db_file_multiblock_read_count=1024;
alter session set sort_multiblock_read_count=128;

spool &1
declare

    snap_owner    dba_snapshots.owner%type :='&2';
    snap_name     dba_snapshots.name%type := '&3';
    zerorowspermited boolean := &4;
    gatherstats   boolean := &5;
 
begin 
        DBMS_SNAPSHOT.REFRESH(
            LIST => snap_owner||'.'||snap_name,
            METHOD => 'C', 
            PUSH_DEFERRED_RPC => false,
            REFRESH_AFTER_ERRORS => true,
            PURGE_OPTION => 0,
            PARALLELISM  => 5,
            HEAP_SIZE  => 0,
            ATOMIC_REFRESH => false );
end;
/

spool off
set timing off
quit
