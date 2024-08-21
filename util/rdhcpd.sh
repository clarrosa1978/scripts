#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: UNIX                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: rdhcpd.sh                                              #
# Nombre del JOB.....: RDHCPD                                                 #
# Solicitado por.....:                                                        #
# Descripcion........: Reinicia el servidor dhcpd.                            #
# Solicitado por.....:                                                        #
# Creacion...........: 16/01/2013                                             #
# Modificacion.......:                                                        #
###############################################################################

#set -x

###############################################################################
###                            Principal                                    ###
###############################################################################
if [ -x /usr/sbin/dhcpd ]
then
	service dhcpd restart
	if [ $? = 0 ]
	then
		echo "El service dhcpd fue reinicado en forma exitosa"
		exit 0
        else
                echo "ERROR - Fallo el reinicio del servicio dhcpd - Avisar a la guardia Unix."  
                exit 1
        fi
else
        echo "En este servidor el servicio dhcpd no esta instalado."
        exit 0 
fi
