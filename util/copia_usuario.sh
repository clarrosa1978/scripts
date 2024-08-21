set -x

if [ $# -ne 2 ]
then
	echo "Error en cantidad de parametros"
	exit
fi
export SERVIDOR=$1
export USUARIO=$2
grep ${USUARIO} /etc/passwd && EXISTE=SI || EXISTE=NO
if [ "${EXISTE}" = 'SI' ]
then
	echo "El usuario ya existe"
	exit 1
fi
export COMANDO=`lsuser -a id -a pgrp -a groups -a home  gecos ${USUARIO} | sed "s/${USUARIO} //" |sed "s/shell=/shell=\'/" | sed "s/ gecos=/' gecos=\'/" `
echo "mkuser -a $COMANDO ${USUARIO}" >creausr.sh
#ksh creausr.sh
EXIT=$?
if [ $EXIT = 0 ]
then
	scp ~${USUARIO}/.profile ${SERVIDOR}:~${USUARIO}
else
	if [ $EXIT = 17 ]
	then
		echo "saco el numero de id de usuario en el origen"
		ID_ORIG=`ssh ${SERVIDOR} lsuser -a -f id ${USUARIO} | grep id | cut -d "=" -f2"`
		sed s/id=${ID_ORIG}//g creausr.sh >creausr.sh.tmp
		mv creausr.sh.tmp creausr.sh
		#ksh creausr.sh
	fi
fi
#rm creausr.sh
