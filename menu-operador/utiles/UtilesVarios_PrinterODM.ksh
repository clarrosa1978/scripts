cp /usr/lpp/printers.rte/inst_root/var/spool/lpd/pio/@local/smit/* /var/spool/lp
d/pio/@local/smit
cd /var/spool/lpd/pio/@local/custom

for FILE in `ls`
do
        QUEUENAME=`echo $FILE | cut -d ':' -f1`
        DEVICE=`echo $FILE | cut -d ':' -f2`
        chvirprt -q $QUEUENAME -d $DEVICE
done
