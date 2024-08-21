#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza un exportdeftable de la tabla requerida por    #
#                      parametro.                                             #
# Nombre del programa: expordeftable_a_demanda.sh                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export DC=${1}
export TB=${2}
export FECHA="`date +%d%m%Y-%H%M`"
export NOMBRE="expordeftable_a_demanda"
export PATHAPL="/tecnol/backups"
export PATHEXP="/export/xml"
export PF="${PATHAPL}/.ecs.pwd"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
	ARCHARG="${PATHEXP}/${DC}.${TB}.arg"
	`cat > ${ARCHARG}  << OEF 
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE TERMS SYSTEM "terms.dtd">
<TERMS>
	<TERM>
		<PARAM NAME="DATACENTER" OP="EQ" VALUE="${DC}"/>
		<PARAM NAME="TABLE_NAME" OP="LIKE" VALUE="${TB}"/>
	</TERM>
</TERMS>
` <"$FILE"

#GENERANDO XML
if [ -x /home/ecs/bin/exportdeftable ]
then
		EXP="`echo ${ARCHARG} | sed s/.arg/.$FECHA.xml/`"
		Enviar_A_Log "AVISO - Realizando export de ${ARCHARG}." 
		/home/ecs/bin/exportdeftable -pf ${PF} -s EM02 -arg ${ARCHARG} -out ${EXP}
		if [ $? = 0 ]
		then
			echo "AVISO - XML ${EXP} generado OK ." 
			gzip -f ${EXP}
			#rm -f ${ARCHARG}
		else
			echo "ERROR - Error al generar ${EXP}." 
			echo "FINALIZACION - Con ERRORES."
			exit 1
		fi
else
	echo "ERROR - Sin permisos de ejecucion /home/ecs/bin/exportdeftable."
	echo "FINALIZACION - Con ERRORES." 
	exit 88
fi
echo "FINALIZACION - XML's generados OK." 
