#!/usr/bin/ksh
###############################################################################
# Grupo..............: UTILS                                                  #
# Autor..............: Pablo Morales                                          #
# Objetivo...........: Genera Informe de usuarios inactivos                   #
#                      Seguridad de la Informacion                            #
# Nombre del programa: usuarios_inactivos.ksh                                 #
# Nombre del JOB.....: REPOSEGINF                                            #
# Solicitado por.....: Seguridad de la Informacion                            #
# Descripcion........: Genera reporte de usuarios inactivos periodo 90 dias  #
#                                                                             #
###############################################################################

set -x
SERVER=`hostname`
TEMPREPODIR=/tmp/reporteseginfo
TMPFILEUSERS=$TEMPREPODIR/usersina-$SERVER.txt
HEADER=$TEMPREPODIR/header.txt
FECHA=`date`
ARCHLOG=/tecnol/util/log/reporte_seginf.log
LOGDIR=/tecnol/util/log
##############


now=`date +%s`
days=90
delta=$(($days*86400))
calculo=$(($now - $delta))

# Verifico que exista el directorio /tmp/reporteseginfo
if  ! -d "${TEMPREPODIR}" ; then
        mkdir $TEMPREPODIR
fi

# Verifico que exista el directorio log:
if  ! -d "${LOGDIR}" ; then
        mkdir  $LOGDIR
fi

# Antes de iniciar un nuevo reporte borro el anterior:
if  -f "${TMPFILEUSERS}" ; then
        rm -f $TMPFILEUSERS
fi


# El Encabezado / Cuerpo Del e-mail:

echo "************************************">$HEADER
echo "     REPORTE TRIMESTRAL USUARIOS INACTIVOS      " >> $HEADER
echo "************************************" >>$HEADER
echo  "Servidor : $SERVER" >>$HEADER
echo  "Fecha y Hora Actual : $FECHA\n" >>$HEADER
#echo "***" >>$HEADER
#echo  "">>$HEADER
echo  "====================================">>$HEADER

echo " Genero Reporte Para Envio al ADM01 " >>$ARCHLOG

lsuser -a time_last_login ALL |
grep -e time_last_login |
while read line
   do
        set $line
        username=$1
        logintime=`echo $2 | awk -F= ' { print $2 } '`

        if [[ $logintime -lt $calculo ]]; then
                usuario=`lsuser -a gecos $username`
                lastlog=$(lsuser -a time_last_login $username | awk -F'=' '{print $NF}')
                lastlogin=`perl -le "print scalar(localtime($lastlog))"`
                echo "$usuario\n"  >>$TMPFILEUSERS
                echo "Ultimo Ingreso: $lastlogin\n" >>$TMPFILEUSERS
                echo "=========================================================">>$TMPFILEUSERS
        fi
   done

echo " Reporte Generado " >>$ARCHLOG
