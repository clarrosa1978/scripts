#############################################################################
# /bin/ksh/usuarios_bloqueados.ksh
# Fecha    : 13-05-97
# Autor    : C.A.S
# Objetivo : Arma el archivo a listar con todos los usuarios bloqueados en el
#            Sistema por nombre o passwd ingresada erroneamente
# Modificaciones :
#############################################################################

#############################################################################
# Definicion de Variables
#############################################################################


# set -x

DIR_LISTADOS=/local/auditor
DIR_SCRIPTS=/local/usr
ARCH_TRABAJO="/etc/security/lastlog"
SERVIDOR=`hostname | tr '.' ' ' | tr '_' ' ' | awk ' { print $1 } '`
LISTADO=$DIR_LISTADOS/usr_blq_$SERVIDOR.lst
CANT_LOGINS=3
DIR_LOGIN_FAILED=/etc/security
ARCH_LOGIN_FAILED=failedlogin
MAQUINA=`echo $SERVIDOR | tr ´a-z´ ´A-Z´`

# Realiza el encabezado del listado               
#

> $LISTADO

echo "Fecha   : `date +"%d"/"%m"/"%y"`\t\t\t\t\tHora     : `date +"%H":"%M"`" >> $LISTADO

control1=`echo $bucle | cut -f2- -d@|tr ´A-Z´ ´a-z´`
echo "\n\tListado de los Usuarios Actualmente Bloqueados en: $MAQUINA" >> $LISTADO
echo "\t-----------------------------------------------------------\n" >> $LISTADO
echo "Nombre\tIntentos Fallidos\tUltimo Intento\tDescripcion" >> $LISTADO
echo "------\t-----------------\t--------------\t-----------\n" >> $LISTADO

# Obtiene la lista de usuarios del Sistema a partir del id 100
#
lsuser -a id pgrp gecos ALL | tr "=" " " | while read nombre ley1 numero ley2 grupo ley3 texto
do
if [ $numero -lt 100 ]
then
  continue
else
 logins=`lssec -f $ARCH_TRABAJO -s $nombre -a unsuccessful_login_count | tr "=" " " | awk '{print $3}'`
  if [ ! "$logins" ] 
    then
    continue
  else
    if [ $logins = $CANT_LOGINS -o $logins -gt $CANT_LOGINS ]
    then
     if [ $# -eq 0 ]
      then 
      fecha=`who $DIR_LOGIN_FAILED/$ARCH_LOGIN_FAILED | grep $nombre | tail -1| awk '{print $3" "$4" "$5}'`
      echo "$nombre\t\t$logins\t$fecha\t$texto" >> $LISTADO
    fi
  fi
fi
done

echo "\n\n" >> $LISTADO
echo "===============================================================================">> $LISTADO
echo "\n\n" >> $LISTADO

nohup /bin/ksh /local/usr/auditor.ftp.ksh &

#-----------------------------------End-----------------------------------------
