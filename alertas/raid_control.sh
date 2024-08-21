#!/bin/bash
set -x
#set -n
#################################################################################
#                               VARIABLES                                       #
#################################################################################


export DIA=`date +%d`
export MES=`date +%m`
export ANO=`date +%Y` 
export MIN=`date +%M`
export HOR=`date +%H`
export HOST=`hostname`
export IP="${1}"

export CANT_MAIL=15

export ARCH_TMP="/tmp/raid.rtf"
>$ARCH_TMP
ARCH_SALI="/tmp/out_raid.out"

#################################################################################
#                               FUNCIONES                                       #
#################################################################################

Enviar_mail_alerta ()
{
export USUARIOS="adminaix"
export MSG_SUBJECT="Control Raid y Mail en `hostname` - `date +%d` `date +%b` `date +%Y`-`date +%H`:`date +%M` "

for USER in $USUARIOS
do
	cat $ARCH_TMP | mutt -s "$MSG_SUBJECT" -b ${USER}@redcoto.com.ar
done
}


# ------------------------------------------------------------------

#Invoco script expect


#/tecnol/check_raid.exp ${IP}

#ESTADO=$(cat ./status_raid | grep -i optimal | awk '{print $6}')
#export ESTADO=$(cat ./status_raid | grep -i optimal | cut -d "B" -f2 | sed 's/,//')

#export ESTADO="`/tecnol/check_raid.exp ${IP}| grep -i optimal | awk '{print $6}'`| sed"
#export ESTADO2="Optimal"

echo "Reviso si tengo conexion con la consola"
ping -c 4 ${IP}
if [ $? -eq 0 ]
then
        echo "Tengo conexion con la consola!"
else
        echo "Consola sin conexion"
        exit 3
fi


/tecnol/alertas/check_raid.exp ${IP}| grep -i optimal | awk '{print $6}' > status_temp.txt
sed -e "s/\r//g" status_temp.txt > status.txt
export ESTADO=$(cat status.txt)


if [ $ESTADO == Optimal ]
	then
	echo "El estado del RAID es OPTIMAL"
	rm -f /tecnol/status_temp.txt
	rm -f /tecnol/status.txt
	exit 0
else
	echo "El estado del RAID es DEGRADADO"
	rm -f /tecnol/status_temp.txt
	rm -f /tecnol/status.txt
	exit 1 
fi

if [ $SALIDA -ne 0 ] 2>/dev/null
then
	Enviar_mail_alerta
fi
