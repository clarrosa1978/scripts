#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Transferir via ftps el archivo liq1251.                #
# Nombre del programa: ftps.sh                                                #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export OPER=$1
export SERVER="$2"
export PATHORI="$3"
export PATHDES="$4"

##### Preparo lista para bajar archivo######

ls -ltr /tarjetas/pagomiscuentas/LIQ1251* | sed s/.gz// |awk -F/ '{print $4}' > /tmp/lista1.tmp

/usr/bin/curl --disable-eprt -n -k --ftp-ssl ftps://${SERVER}/${PATHORI}/ --list-only | grep "LIQ1251.P" > /tmp/lista2.tmp 

join -v2 /tmp/lista1.tmp /tmp/lista2.tmp > /tmp/liq1251.tmp
 
for ARCH in $(cat /tmp/liq1251.tmp)
do
export ARCHORI=$ARCH
export ARCHDES=$ARCH
done
