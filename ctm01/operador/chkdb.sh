#!/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Chequea la base recibida como parametro.               #
# Nombre del programa: chkdb.sh                                               #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 06/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export SUC="`uname -n | sed 's/suc//'`"
export LSN=${1}
export NOMBRE="chkdb"
export PATHAPL="/tecnol/operador"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export FPATH=/tecnol/funciones


###############################################################################
###                            Funciones                                    ###
###############################################################################
typeset -fu Borrar
typeset -fu Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}


verdb_em7 ()
{
#set -x
ORACLE_SID="EM7"
export CHECK_STAT=`ps -ef | grep -v grep | grep EM7 | grep oracle  | grep ora_pmon | wc -l`
ORACLE_NUM=`expr ${CHECK_STAT}`
if [ ${ORACLE_NUM} -lt 1 ]
then
        clear
        echo "-----------------------------------------------------------------"
        echo "                           ATENCION !!!!"
        echo "-----------------------------------------------------------------"
        echo "            La base de datos ${ORACLE_SID} esta DOWN"
	echo "		      en caso de no levantar por favor" 		
        echo "                comuniquese con la guardia DBA."
        echo "-----------------------------------------------------------------"
        echo ""
        sleep 2
        exit 1
else
	echo "-----------------------------------------------------------------"
        echo "            La base de datos ${ORACLE_SID} esta UP"
	echo "-----------------------------------------------------------------"
	echo "`ps -ef | grep -v grep | grep SF | grep oracle  | grep ora_pmon`"
	echo "-----------------------------------------------------------------"
	export BASE="UP"
fi
}


echo  ${BASE}

	
###############################################################################
###                            Principal                                    ###
###############################################################################

export CHKDB=${1}
	if [ ${CHKDB} = "EM7" ] 
	then
		verdb_em7
	fi


if [ ${BASE} = "UP" ]
then
	Enviar_A_Log "La base ${ORACLE_SID} esta en ejecucion en `uname -n`." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
else
        Enviar_A_Log "ERROR - La base de datos ${ORACLE_SID} no esta en ejecucion!!!!." ${LOGSCRIPT}
       	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
fi
echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
read
