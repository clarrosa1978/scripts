set -x
##############################################################################
#
# Comprime los LOGS generados por la base de datos.
#
#
# exit status:
#    0  - OK
#    10 - Ver mensaje de error.
#
#
# Cesar Lopez  -  12/02/2003
#
##############################################################################

PATHARCH="/dbfs_archive"

cd ${PATHARCH}
if [ $? != 0 ]
then
	echo "No se pudo acceder a ${PATHARCH}"
	exit 10
fi
if [ -s arch*.log ]
then
	#for LOG in `ls -1t |grep "\.log" |grep -v "\.Z" |tail +2`
	for LOG in `ls -1t |grep ^arch | grep -v .log.Z | tail +2 | sort`
	do
		compress -f ${LOG}
		if [ $? != 0 ]
		then
			echo "Error comprimiendo LOG ${LOG}"
			exit 10
		fi
	done
fi
exit 0



