#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ETIQUETAS                                              #
# Grupo..............: JAVA                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecuta proceso actualizacion etiquetas de gondola.    #
# Nombre del programa: etiquetas.sh                                           #
# Nombre del JOB.....: PETIQUETAS                                             #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 27/10/2010                                             #
# Modificacion.......: 27/10/2010                                             #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export NOMBRE="procesaEtiquetas"
export PATHAPL="/tecnol/java/etiquetas"

###############################################################################
###                            Principal                                    ###
###############################################################################

cd ${PATHAPL} || exit 1
java -Xms32m -Xmx96m -jar ${PATHAPL}/${NOMBRE}.jar
if [ $? != 0 ]
then
	echo "Error al generar novedades de etiquetas."
	exit 1
else
	echo "El proceso finalizo OK."
	find ${PATHAPL}/historico -name "*.dat" -mtime +60 -exec rm {} \;
	find ${PATHAPL}/historico -name "*.dat.gz" -exec gzip {} \;
	exit 0
fi
