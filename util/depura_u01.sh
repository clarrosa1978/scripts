set -x
#Depuramos los filesystems /u011
FECHA=`date +%Y%m%d`
ORACLE_HOME=/u011/app/oracle/product/11.2.0
SUC="`uname -n`"

#Pedido por Claudio Panuccio

echo "Borrando datos de auditoria del usuario SYS ...."
find ${ORACLE_HOME}/rdbms/audit -name "*.aud" -mtime +90 -exec rm {} \;
find ${ORACLE_HOME}/log/${SUC}/client -name "clsc[0-9][0-9].log" -exec rm {} \;
find /u011/app/oracle/diag/tnslsnr/${SUC}/*/alert -name "log*.xml" -mtime +7 -exec rm {} \;
find /u011/app/oracle/diag/tnslsnr/${SUC} -name "listener*.log" | xargs -i cp {} {}.${FECHA}
find /u011/app/oracle/diag/tnslsnr/${SUC} -name "listener*.log" -exec rm {} \;
find /u011/app/oracle/diag/tnslsnr/${SUC} -name "listener*.log.*" -mtime +2 -exec rm {} \;
find /u011/app/oracle/diag/tnslsnr/${SUC} -name "listener*.log.*" | xargs -i chown oracle.oinstall {}
df -k /u011 2>/dev/null
