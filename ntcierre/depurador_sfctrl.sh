#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE                                               #
# Grupo..............: CADENA005                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Depurar el directorio /sfctrl de acuerdo a los         #
#                      criterios establecidos por StoreFlow.                  #
# Nombre del programa: depurador_sfctrl.sh                                    #
# Nombre del JOB.....: DEPURA-SFCTRL                                          #
# Descripcion........:                                                        #
# Modificacion.......: 24/08/2010                                             #
###############################################################################
set -x

##############################################################################
#            DESRIPCION DE CRITERIOS                                         
#----------------------------------------------------------------------------
# Criterio 1: Directorio /sfctrl/, Archivos: *.img.err Dias: 10
# Criterio 2: Directorio /sfctrl/data/carga, Archivos: Todos, Dias: 20
# Criterio 3: Directorio /sfctrl/data/descarga, Archivos: Todos, Dias 20
# Criterio 4: Directorio /sfctrl/tmp sin incluir directorios price y release
# Criterio 5: Directorio /sfctrl/tmp/price, Archivos *.err.????????, Dias 7
# Criterio 6: Directorio /sfctrl/s01, Archivos Todos, Dias 0
# Criterio 7: Directorio /sfctrl/s02, Archivos Todos, Dias 0
# Criterio 8: Directorio /sfctrl/, Archivos *.img excluyebdo carga.img, Dias 10
# Criterio 9: Directorio /sfctrl/d, Archivos CAMBIO.ERR, Dias 10
# Criterio 10: Directorio /sfctrl/interface/in/procesados Archivos todos,Dias 15
# Criterio 11: Directorio /sfctrl, Archivos RFAR*
# Criterio 12: directorio /sfctrl, Archivos *.tar
# Criterio 13: Directorio /sfctrl, Archivos s?0?.*
# Criterio 14: Directorio /sfctrl, Archivos nohup.out, dias 2
# Criterio 15: Directorio /sfctrl, Archvio distribu.*
# Criterio 16: Directorio /sfctrl/l, Archivos *.Z Dias 60
# Criterio 17: Directorio /sfctrl/reports/semanal, archivos todos, Dias 20
# Criterio 18: Directorio /sfctrl/tmp/price, archivos trx, comprime todos
# Criterio 19: Directorio /sfctrl/tmp, archivos vcc2tpv, comprime todos deja 15 dias
# Criterio 20: Directorio /sfctrl/tmp, archivos ts030372, comprime todos deja 15 dias
# Criterio 21: Directorio /sfctrl/f01, archivos r70* deja 1 dia
#-----------------------------------------------------------------------------
###############################################################################




###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export PATHDEP=""
export DIAS=0
export ARCHIVO=""
export NOMBRE="depurador"
export EXCLUYE=""
export PATHLOG="/tecnol/ntcierre/log"
export ARCHLOG="$PATHLOG/sfctrl_depu.log"
export EXIT=""
export MSJ=""

###############################################################################
###                            Funciones                                    ###
###############################################################################
#  2) Carga informe
#------------------------------------------------------------------------------
carga_inf ()
(
MENSAJE=${1}
echo $MENSAJE
echo "`date +%d` `date +%b` `date +%Y` - `date +%R` : $MENSAJE" | tee -a $ARCHLOG
echo "---------------------------------------------------------------------" | tee -a $ARCHLOG
)

elimina_archivos_ina ()
(
export PATHDEP_k=${1}
export DIAS_k=${2}
export ARCHIVO_k=${3}

echo "$PATHDEP_k" 
echo "$DIAS_k" 
echo "$ARCHIVO_k"
if [ -d ${PATHDEP_k} ]
then
        cd ${PATHDEP_k}
        if [ $? = 0 ]
        then
	  if [ "${ARCHIVO_k}" ]
	   then
echo "entre al if"
set -x
                find . -name "${ARCHIVO_k}" -mtime +${DIAS_k} -exec ls {} \;|tee -a $ARCHLOG

                find . -name "${ARCHIVO_k}" -mtime +${DIAS_k} -exec rm {} \;
		echo find . -name "${ARCHIVO_k}" -mtime +${DIAS_k} -exec ls {}
                        EXIT=$?
	   else
		echo "por por el NO"
                find . -mtime +${DIAS_k} -exec ls {} \;|tee -a $ARCHLOG
		find . -mtime +${DIAS_k} -exec rm  {} \;
		echo "find . -mtime +${DIAS_k} -exec ls {} \;"
          fi
	fi
else
        exit 6
fi

)

elimina_archivos_exa ()
(
export PATHDEP_k=${1}
export DIAS_k=${2}
export ARCHIVO_k=${3}
export EXCLUYE_k=${4}

if [ -d ${PATHDEP_k} ]
then
        cd ${PATHDEP_k}
        if [ $? = 0 ]
        then
          if [ ${ARCHIVO_k} ]
           then
             if [ ${EXCLUYE_k} ]
              then
                 find . -name "${ARCHIVO_k}" -not -name "${EXCLUYE_k}" -mtime +${DIAS_k} -exec ls {} \;|tee -a $ARCHLOG 
		echo "find . -name "${ARCHIVO_k}" -not -name "${EXCLUYE_k}" -mtime +${DIAS_k}"
 	         find . -name "${ARCHIVO_k}" -not -name "${EXCLUYE_k}" -mtime +${DIAS_k} -exec rm {} \; 
	      else
		 find . -not -name "${EXCLUYE_k}" -mtime +${DIAS_k} -exec ls {} \;|tee -a $ARCHLOG
		echo "find . -not -name "${EXCLUYE_k}" -mtime +${DIAS_k}"
 
                find . -not -name "${EXCLUYE_k}" -mtime +${DIAS_k} -exec rm {} \;
                        EXIT=$?
             fi
          fi
	   	
        fi
else
        exit 6
fi
)


###############################################################################
###                            Principal                                    ###
###############################################################################
set -x
>$ARCHLOG
MSJ="Criterio a depurar: Directorio /sfctrl/, Archivos: *.img.err, Dias 15"
carga_inf "$MSJ"

PATHDEP="/sfctrl"
DIAS=15
ARCHIVO="*.img.err"


elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"


MSJ="Criterio a depurar: Directorio /sfctrl/data/carga, Archivo Todos, Dias 20"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/data/carga"
export DIAS=20
export ARCHIVO=""
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/data/descarga, Archivo Todos, Dias 20"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/data/descarga"
export DIAS=20
export ARCHIVO=""
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/d, Archivo CAMBIO.ERR, Dias 20"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/d"
export DIAS=10
export ARCHIVO="CAMBIO.ERR"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"


MSJ="Criterio a depurar: Directorio /sfctrl/tmp, Archivo Todos,menos diectorios Dias 15"

carga_inf "$MSJ"

export PATHDEP="/sfctrl/tmp"
export DIAS=15
export ARCHIVO=""
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"


MSJ="Criterio a depurar: Directorio /sfctrl/tmp/price, Archivo *.err.????????, Dias 7"

carga_inf "$MSJ"

export PATHDEP="/sfctrl/tmp/price"
export DIAS=7
export ARCHIVO="*.err.????????"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/l,  Archivo *.Z, Dias 60"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/l"
export DIAS=60
export ARCHIVO="*.Z"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/reports/semanal, Archivo Todos, Dias 20"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/reports/semanal"
export DIAS=20
export ARCHIVO=""
export EXCLUYE=""
# Cambio permisos de listados en /sfctrl/reports porque el umask es 022
chmod -R 644 /sfctrl/reports
chmod 775 /sfctrl/reports
chmod 775 /sfctrl/reports/semanal

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/s01, Archivo Todos, Dias 0"

carga_inf "$MSJ"

export PATHDEP="/sfctrl/s01"
export DIAS=0
export ARCHIVO=""
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"


MSJ="Criterio a depurar: Directorio /sfctrl/s02, Archivo Todos, Dias 0"
carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/s02"
export DIAS=0
export ARCHIVO=""
export EXCLUYE=""


elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/, Archivo *.img menos el archivo carga.img, Dias 7"

carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/"
export DIAS=7
export ARCHIVO="*.img"
export EXCLUYE="carga.img"

elimina_archivos_exa "$PATHDEP" "$DIAS" "$ARCHIVO" "$EXCLUYE"

MSJ="Criterio a depurar: Directorio /sfctrl/ Archivo: RFAR*, Dias 0"
carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/"
export DIAS=0
export ARCHIVO="RFAR*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/ Archivo: nohup.out, Dias 5"
carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/"
export DIAS=5
export ARCHIVO="nohup.out"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/ Archivo: *.tar, Dias 0"
carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/"
export DIAS=0
export ARCHIVO="*.tar"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/, Archivo s?0?.*, Dias 0"
carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/"
export DIAS=0
export ARCHIVO="s?0?.*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl, Archivo distribu.*, Dias 0"
carga_inf "$MSJ"
 
export PATHDEP="/sfctrl/"
export DIAS=0
export ARCHIVO="distribu.*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"



MSJ="Criterio a depurar: Directorio /sfctrl/tmp/price, Archivo trx_*, Dias 15"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/tmp/price"
export DIAS=15
export ARCHIVO="trx_*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"


MSJ="Criterio a depurar: Directorio /sfctrl/tmp, Archivo vcc2tpv*, Dias 15"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/tmp"
export DIAS=15
export ARCHIVO="vcc2tpv*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar: Directorio /sfctrl/tmp, Archivo ts030372*, Dias 15"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/tmp"
export DIAS=15
export ARCHIVO="ts030372*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"


MSJ="Criterio a depurar: Directorio /sfctrl/interface/in/procesados, *, Dias 7"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/interface/in/procesados"
export DIAS=7
export ARCHIVO="*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"

MSJ="Criterio a depurar 21: Directorio /sfctrl/f01, *, Dias 1"
carga_inf "$MSJ"

export PATHDEP="/sfctrl/f01"
export DIAS=1
export ARCHIVO="r*.*"
export EXCLUYE=""

elimina_archivos_ina "$PATHDEP" "$DIAS" "$ARCHIVO"
