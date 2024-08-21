set -x
#SCRIPT DE FINALIZACION DE CADENA 05
#PARA AGREGAR PROCESOS DE ULTIMO MOMENTO PARA ATENCION A SUCURSALES
#NO SE CONTROLA EL STATUS DEL SCRIPT
fecha=$2
export PROC_DATE=`echo "$fecha"|awk ' { print sprintf("%s%s%s", substr( $1, 7, 2 ), substr( $1, 3, 2 ), substr( $1, 1, 2 )) } '`

if [ -s /sfctrl/data/carga/visabine.dkt ]
  then
    nohup CargaBines V 04 /sfctrl/data/carga/visabine.dkt    /sfctrl/data/mess_f1.dat

    echo "`date +"%d/%m/%Y"` - $0: Se despacho el proceso CargaBines"|tee -a /tecnol/ntcierre/log/CargaBines.log
    sleep 30

    export CTRL_DATE=`cat CargaBines.err|grep "Fecha Proceso"|awk ' { print $NF } '` 

    if [ "$CTRL_DATE" != "$PROC_DATE" ]
    then
           echo "`date +"%d/%m/%Y"` - $0: El log del CargaBines tiene fecha incorrecta:$CTRL_DATE"|tee -a /tecnol/ntcierre/log/CargaBines.log
          # exit 0
    else
           export CTRL_STAT=`cat CargaBines.err|egrep "Total"`
           echo "$CTRL_STAT"|tee -a /tecnol/ntcierre/log/CargaBines.log
    fi
  else
    echo "`date +"%d/%m/%Y"` - $0: No hay novedades para actualizar los Bines de Visa"|tee -a /tecnol/ntcierre/log/CargaBines.log
fi

exit 0
