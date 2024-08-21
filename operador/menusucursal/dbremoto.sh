#!/bin/sh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecutar el script dbsec.sh en el servidor secundario  #
# Nombre del programa: dbremoto.sh                                            #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 05/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x 

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export NOMBRE="dbremoto"
export PARAMETRO="${1}"
export SERVREM="nodo2"
export PATHAPL="/tecnol/operador"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export FPATH="/tecnol/funciones"


###############################################################################
###                            Funciones                                    ###
###############################################################################

verdb_sf ()
{
#set -x
ORACLE_SID="SF${SUC}"
export CHECK_STAT=`ssh ${SERVREM} "ps -ef | grep -v grep | grep SF | grep oracle  | grep ora_pmon | wc -l"`
ORACLE_NUM=`expr ${CHECK_STAT}`
if [ ${ORACLE_NUM} -lt 1 ]
then
        clear
        echo "-----------------------------------------------------------------"
        echo "                           ATENCION !!!!"
        echo "-----------------------------------------------------------------"
        echo "                 La base de datos ${ORACLE_SID} "
	echo "               en el servidor Secundario esta DOWN"
        echo "                en caso de no levantar por favor" 
        echo "                comuniquese con la guardia DBA."
        echo "-----------------------------------------------------------------"
        echo ""
        sleep 5
        exit 1
else
        echo "-----------------------------------------------------------------"
        echo "             La base de datos ${ORACLE_SID}"
	echo "            en el servidor Secundario esta UP"
        echo "-----------------------------------------------------------------"
        ssh ${SERVREM} "ps -ef | grep -v grep | grep SF | grep oracle  | grep ora_pmon "
        echo "-----------------------------------------------------------------"
        export BASE="UP"
fi
}


###############################################################################
###                            Principal                                    ###
###############################################################################
#set -x
SUC="`uname -n | sed 's/suc//' | sed 's/c$//'`"
case ${PARAMETRO} in
UPSF)		export OPERACION="UP"
		if [ $SUC -lt 100 ]
		then
			export BASE="SF0`uname -n | sed 's/suc//' | sed 's/c$//'`"
		else
			export BASE="SF`uname -n | sed 's/suc//' | sed 's/c$//'`"
		fi
		ssh ${SERVREM} "ksh ${PATHAPL}/dbsec.sh $OPERACION $BASE"
		;;

DOWNSF)		export OPERACION="DOWN"
                if [ $SUC -lt 100 ]
                then
                        export BASE="SF0`uname -n | sed 's/suc//' | sed 's/c$//'`"
                else
                        export BASE="SF`uname -n | sed 's/suc//' | sed 's/c$//'`"
                fi
		ssh ${SERVREM} "ksh ${PATHAPL}/dbsec.sh $OPERACION $BASE"
		;;
CHKDBSF)	verdb_sf
		;;
UPCTM)		export OPERACION="UP"
                if [ $SUC -lt 100 ]
                then
                        export BASE="CTRLM0`uname -n | sed 's/suc//' | sed 's/c$//'`"
                else
                        export BASE="CTRLM`uname -n | sed 's/suc//' | sed 's/c$//'`"
                fi
		ssh ${SERVREM} "ksh ${PATHAPL}/dbsec.sh $OPERACION $BASE"
		;;

DOWNCTM)	export OPERACION="DOWN"
                if [ $SUC -lt 100 ]
                then
                        export BASE="CTRLM0`uname -n | sed 's/suc//' | sed 's/c$//'`"
                else
                        export BASE="CTRLM`uname -n | sed 's/suc//' | sed 's/c$//'`"
                fi
		ssh ${SERVREM} "ksh ${PATHAPL}/dbsec.sh $OPERACION $BASE"
		;;
esac

echo "Presione una tecla para continuar\c"
read
