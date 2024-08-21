LOG=`basename ${0%%.ksh}.log`
echo $LOG
echo $LOG
echo $LOG
echo $LOG
echo $LOG
echo $LOG
echo $LOG
cat datos | awk '{ sum[$1] += $2 } 
                  END { for ( nombre in sum )
                          print nombre, sum[nombre] }'
