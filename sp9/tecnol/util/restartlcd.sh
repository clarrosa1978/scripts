#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: LCD                                                    #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Reinicia los video servidores de una sucursal.         #
# Nombre del programa: restartlcd.sh                                          #
# Nombre del JOB.....: RESTLCDXXX                                             #
# Descripcion........:                                                        #
# Modificacion.......: 07/04/2011                                             #
# Solicitado por.....: Administracion NT                                      #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export SUC=${1}
export LISTA="`egrep LCD${SUC} /etc/hosts | awk ' { print $2 } '`"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
for LCD in ${LISTA}
do
	IP="`grep $LCD /etc/hosts | awk ' { print $1 } '`"
	echo "Reiniciando $LCD $IP"
	ssh $LCD 'nohup reboot &'
done
