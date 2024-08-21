FECHA_AUX=$1
for i in `cat lista3`
do
        . /tecnol/bin/suc3to2.lib
        SUC2=`suc3to2 "$i"`
        # /---------------------------------------------------------------------------------------------\
        #          CML - NOCTM tiene la lista de las sucursales que corren el backup por crontab.
        #          Por este motivo es necesario modificar la variable FECHA con la que se busca el
        #          resultado de la ejecucion del backup de la noche anterior.                     
        # \---------------------------------------------------------------------------------------------/
        NOCTM="01 07 08 13 14 15 21 27 29 30 31 32 34 35 36 73 87"
        for j in $NOCTM
        do
          if [ "$SUC2" = "$j" ]
          #  then
            #    FECHA=`date +%Y%m%d`    
            #    break
           # else
           then
                FECHA=$FECHA_AUX
          fi
        done
       # /------- Fin de la modificacion - CML---------------------------------------------------------\

        if [ ! -f /tecnol/ntcierre/mail/backup.$i.$FECHA ]
        then
                rcp suc$SUC2:/tecnol/ntcierre/log/backup.$FECHA /tecnol/ntcierre/mail/backup.$i.$FECHA
        fi
        if [ -f /tecnol/ntcierre/mail/backup.$i.$FECHA ]
        then
                grep -v "BACKUP FINALIZO OK" /tecnol/ntcierre/mail/backup.$i.$FECHA
                STATUS="$?"
                if [ "$STATUS" -eq 0 ]
                then
                        echo "SUCURSAL $i" >> /tecnol/ntcierre/backup.tecnol
                        echo "------------" >> /tecnol/ntcierre/backup.tecnol
                        cat /tecnol/ntcierre/mail/backup.$i.$FECHA >> /tecnol/ntcierre/backup.tecnol
                        echo "\n" >> /tecnol/ntcierre/backup.tecnol
                fi      
        fi
done

echo "mail from: operaciones@coto.com.ar" >> msg
echo "rcpt to: admunix@ecs.coto.com.ar" >> msg
echo "data" >> msg
echo "subject: Detalle de Backups Finalizados con errores el dia $FECHA" >> msg
echo "to: Administracion de Sistemas;" >> msg
echo ""
cat /tecnol/ntcierre/backup.tecnol >> msg
echo "." >> msg
echo "quit" >> msg
telnet ecs 25 < msg
rm msg
rm /tecnol/ntcierre/backup.tecnol
find /tecnol/ntcierre/mail -mtime 15  -print -exec rm {} \;
find /tecnol/ntcierre/log -mtime 15 -print -exec rm {} \;
exit 0
