#!/bin/ksh

############################################################################
#                                                                          #
# Script con la intencion de controlar la ejecucion de otros scripts y     #
# notificar en el caso de una falla.                                       #
#      ~                                                                   #
#     . .     Demian Barlaro                                               #
#     /V\     Administrador UNIX                                           #
#    // \\    COTO C.I.C.S.A.                Version: Mar 2008             #
#   /(   )\   dbarlaro@coto.com.ar                                         #
#    ^ ~ ^    int. 5462                                                    #
#                                                                          #
############################################################################

if [[ $# -lt 1 ]]
then
	echo '\nUsage: scriptControl.sh <script_name> [<arg1>] [<arg2>] [<arg3>] [<arg4>] [<arg5>] [<arg6>] [<arg7>] [<arg8>]' 
	echo 'El script a controlar debe devolver por stdout o stderr "Status:0" cuando finaliza correctamente,\nde forma que scriptControl detecte la correcta ejecucion\n'
	exit 0
fi

## Seteo de variables

hostname=$(uname -n)
date=$(date +%H%M%S-%d%m%Y)
scriptPathAndName=$1
scriptName=$(echo $1|awk -F'/' '{print $NF}')
arg[0]=$2
arg[1]=$3
arg[2]=$4
arg[3]=$5
arg[4]=$6
arg[5]=$7
arg[6]=$8
arg[7]=$9
args=0
bin='/tecnol/alertas'
log='/tecnol/alertas/log'

## Verifico cantidad de parametros

for nmbr in 0 1 2 3 4 5 6 7
do
	if [[ ${arg[$nmbr]} != '' ]]
	then
		args=$(expr $args + 1)
	else
		break
	fi
done	

## Armo la cadena conteniendo todos los parametros

argString=''
aux=''
if [[ args -ge 1 ]]
then
	for i in $(${bin}/seq.sh 0 $(expr $args - 1))
	do
		aux=$argString
		argString="$aux ${arg[$i]}"
	done
fi

## Ejecuto el script y grabo en el log si se ejecuta correctamente o no.

echo "###################################################################################\n\
Ejecucion de $scriptName con los argumentos$argString iniciada $(date)" >> $log/scriptControl.log

$scriptPathAndName$argString > ${log}/$scriptName.$date 2>&1 

if [[ $(grep "Status:0" ${log}/$scriptName.$date) = '' ]]
then
	echo "El proceso $scriptName no pudo correr en $hostname. Revisar $log/$scriptName.$date"| \
	/bin/mailx -s "Error $scriptName en $hostname" operaciones@redcoto.com.ar
	echo "--------------------\n|FINALIZO CON ERROR|\n--------------------" >> $log/scriptControl.log
	exit 0
else
	rm -fr $log/$scriptName.$date
	echo "--------------------\n|Finalizo con exito|\n--------------------" >> $log/scriptControl.log
fi
