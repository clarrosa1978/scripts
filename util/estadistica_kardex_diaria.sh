###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: ORACLE                                                 #
# Autor..............: Claudia Franco                                         #
# Objetivo...........:                                                        #
# Nombre del programa: estadistica_kardex_diaria.sh                           #
# Nombre del JOB.....: ESTKDXDIA                                              #
# Solicitado por.....: Claudia Franco                                         #
# Descripcion........: Toma las estadisticas de la tabla BT_KARDEX_DIARIA.    #
# Creacion...........: 24/01/2008                                             #
# Modificacion.......:                                                        #
###############################################################################
set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="estadistica_kardex_diaria"
export PATHAPL="/tecnica/util"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/estadisticas.${FECHA}_KD_running.log"

###############################################################################
###                            Principal                                    ###
###############################################################################
if [ ! -s ${SQLGEN} ]
then
    echo "No existe el SQL a ejecutar ${SQLGEN}"
    exit 5
fi

## Si existe algun archivo estadisticas_running*, se para el script
if [ -f ${PATHLOG}/estadisticas.${FECHA}_KD_running* ]    
then
    echo Error, existen archivos ${PATHLOG}/estadisticas.${FECHA}_KD_running*, verifique que no este corriendo el procedimiento.
    exit 10
fi

## Si existe algun archivo estadisticas_ERROR*, se borra antes de comenzar a ejecutar
if [ -f ${PATHLOG}/estadisticas.${FECHA}_KD_ERROR* ]
then
   rm ${PATHLOG}/estadisticas.${FECHA}_KD_ERROR*
fi

## Si existe algun archivo estadisticas_ok*, se borra antes de comenzar a ejecutar
if [ -f ${PATHLOG}/estadisticas.${FECHA}_KD_ok* ]
then
   rm ${PATHLOG}/estadisticas.${FECHA}_KD_ok*
fi

## Se lanzan los procesos de toma de estadisticas en paralelo ($SQL).
sqlplus ${USUARIO} @${SQLGEN} ${LSTSQLGEN} 

## Si falla el grep sera porque el archivo no tiene la cadena ORA- o porque no existe.
grep "ORA" ${LSTSQLGEN}
EST="$?"
if [ "$EST" = 0 ]   ### si no falla el grep
  then
  echo ERROR durante la ejecucion de $SQL Proceso 
  mv ${LSTSQLGEN} ${PATHLOG}/estadisticas.${FECHA}_KD_ERROR.log
fi

## Si no falla el grep sera porque se encuentra el archivo running con la marca de fin, y
## se procedera a renombrar el archivo.
## Si falla será porque no se encuentra el archivo (ya se renombro).
grep "Fin" ${LSTSQLGEN}
EST="$?"
if [ "$EST" = 0 ]
  then
  mv ${LSTSQLGEN} ${PATHLOG}/estadisticas${FECHA}_KD_ok.log
fi

## Si existe algun archivo estadisticas_ERROR*, se detiene el procedimiento.
if [ -f ${PATHLOG}/estadisticas.${FECHA}_KD_ERROR* ]
then
   echo Error, existen archivos estadisticas_KD_ERROR*
   exit 10
fi
