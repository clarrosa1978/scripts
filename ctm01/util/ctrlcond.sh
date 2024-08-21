set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export CONDICION="${2}"
CONDCTM01=$(su - ctmsrv -c ctmcontb -list "$CONDICION" "$FECHA" | tail -1 |awk '{print $1}')
CONDGDM=$(ssh gdm su - ctmsrv -c ctmcontb -list "$CONDICION" "$FECHA" | tail -1 |awk '{print $1}')
TEXTO="La condicion "$CONDICION" aun sigue activa, controla la cadena de COSTO_SIMAP." 
DESTINATARIO="galonso@redcoto.com.ar"

###############################################################################
###                            Principal                                    ###
###############################################################################

if [ "$CONDCTM01" = "$CONDGDM" ];
then    
    echo "La condicion no esta activa en los nodos"
    exit 0
else
    echo "La condicion esta activa, verificar cadena costo_simap."
    echo ${TEXTO} | mailx -s "Demora ejecucion job COSTO_SIMAP" ${DESTINATARIO}
    exit 0

fi
