alter session set sort_area_size=33554432;
alter session set db_file_multiblock_read_count=1024;
alter session set sort_multiblock_read_count=128;

DBMS_SNAPSHOT.REFRESH(&1,&2,&3,&4,&5,&6,&7,&8)
