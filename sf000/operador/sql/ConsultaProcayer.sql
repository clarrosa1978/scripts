select Max(noffsetl) DIR_GDM from t5450700 where frctproc = to_char(sysdate - 1,'DD-MON-YY')
/
select max(noffsetl) DIR_VTA from t7750700 where frctproc = to_char(sysdate - 1,'DD-MON-YY')
/
select max(noffsetl) DIR_ONLINE from t6700900 where frctproc = to_char(sysdate - 1,'DD-MON-YY')
/
exit
