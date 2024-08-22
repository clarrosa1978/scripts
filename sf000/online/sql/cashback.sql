set head off
set pagesize 50000
set line 100
set feedback off
set verify off
spool cashback
SELECT
to_char(to_date(FEC_TRX,'DD/MM/YY'),'YYYYMMDD') || ';' ||
'1' || ';' ||
lpad(NRO_CAJ_SF, 5, '0')        || ';' ||
lpad(NRO_CAJ, 5, '0')           || ';' ||
lpad(NRO_TRX,5, '0')            || ';' ||
MONTO/100                       || ';' ||
lpad(RTRIM(NRO_TAR), 20, '0')   || ';' ||
RETIRO/100                      || ';' 
FROM CRED_TRX
WHERE   FEC_TRX   = to_char(to_date('&1','YYYYMMDD'),'DD-MON-YY')
and     COD_TAR  = '08'
and     COD_EST  in ('02','04')
and     RETIRO     > 0
/
spool off
exit 
