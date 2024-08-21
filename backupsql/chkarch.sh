#!/usr/bin/ksh

set -x
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Chequea la consistencia del archivo bk_tape            #
# Nombre del programa: chkrar.sh                                              #
# Nombre del JOB.....: CPBKPXXX                                               #
# Descripcion........:                                                        #
###############################################################################


###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export ARCHIVO="${2}"
export PATHARCH="${3}"
export PATHARCH2="${4}"
export DATEOLD="`date -d yesterday +%Y%m%d`"
export PATHLOG="/tecnol/util/log"
export LOG="${PATHLOG}/${ARCHIVO}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 4 $@
[ $? != 0 ] && exit 1
if [ -s ${PATHARCH}/${ARCHIVO} ]
then
     Enviar_A_Log "INICIO - Copio el archivo ${ARCHIVO} al /backup_nt." ${LOG}
     cp -p ${PATHARCH}/${ARCHIVO} ${PATHARCH2}
     if [ -s ${PATHARCH2}/${ARCHIVO} ]
    
     then
         
         CHECKSUMSOURCE="$(cksum "${PATHARCH}/${ARCHIVO}" | cut -d' ' -f1)"
         CHECKSUMDEST="$(cksum "${PATHARCH2}/${ARCHIVO}" | cut -d' ' -f1)"
         if [ "$CHECKSUMSOURCE" = "$CHECKSUMDEST" ];
    
         then
              Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} se comprobo bien." ${LOG}
              Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
              find ${PATHARCH2} -name "bk_base_${DATEOLD}.RAR" -exec rm {} \;
              exit 0
     
              else
                  Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} esta corrupto."${LOG}
                  Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
                  exit 1
             fi
        else
              Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} no se copio correctamente al ${PATHARCH2}." ${LOG}
              Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
              exit 1      
        fi
    
      else
         
         Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} no existe en el ${PATHARCH}." ${LOG}
         Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}

fi
