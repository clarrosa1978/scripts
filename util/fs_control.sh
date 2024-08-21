#################################################################################
#                                                                               #
# SCRIPT: control_fs.sh                                                         #
#                                                                               #
# DESCRIPCION: Controla que los filesystem mas importantes no superen cierto    #
#              porcentaje de ocupacion e informa via mail si esto ocurriese     #
#                                                                               #
# AUTOR: Andres Bruzzese - Operaciones                                          #
#                                                                               #
#################################################################################

#set -x
#################################################################################
#				FUNCIONES					#
#################################################################################

Enviar_mail_alerta ()
{
	#set -x
	export USUARIOS="adminaix hcerizola clarrosa abruzzese jdalzotto $5"
	export SERVIDOR=$1
	export L_FS=$2
	export L_PP=$3
	export FILE_ALERTAS="alertas_filesystems.log"
	export MSG_SUBJECT="ATENCION !!!! controlar filesystem"
	export MSG_BODY="Controlar el filesystem $L_FS del servidor $SERVIDOR que supera los $L_PP% " 

	for USER in $USUARIOS 
	do
        	mhmail "${USER}"@coto.com.ar -subject "$MSG_SUBJECT" -body "$MSG_BODY"
	done
}

Control_fs_aix ()
{
#set -x
	export CONTROLO=$1
	export HOST=$2
	df -k $CONTROLO | grep -v Used |awk '{print $4 "\t" $6 "\t$HOST"}'
}

Control_fs_irix ()
{
#set -x
	export CONTROLO=$1
	export HOST=$2
	df -k |grep -v Used | grep $CONTROLO |awk '{print $6 "\t" $4 "\t$HOST"}'
}

Chequear_filesystem ()
{
#set -x
	export HOST_DESTINO=$1
	export FS_CONTROL=$2
	export PORC_PERMITIDO=$3
	export OS=$4
	export HOST_LOCAL=`hostname -s` # Host donde corre este proceso
	export TEMPORAL="/tmp/chk.$$"
	echo "$FS_CONTROL $HOST_DESTINO"|awk '{printf "\t%35s|%14s|\t",$1,$2}'  
	if [ "$HOST_LOCAL" != "$HOST_DESTINO" ]
	then
		case $OS in
			AIX ) rsh $HOST_DESTINO df -k $FS_CONTROL | grep -v Used |awk '{print $4 "\t" $6 "\t$HOST_DESTINO"}' > $TEMPORAL;;
			IRIX) rsh $HOST_DESTINO df -k |grep $FS_CONTROL |awk '{print $6 "\t" $4 "\t$HOST_DESTINO"}' > $TEMPORAL;;
		esac
	else
        	case $OS in
                	AIX ) Control_fs_aix $FS_CONTROL $HOST_DESTINO > $TEMPORAL;;
                	IRIX) Control_fs_irix $FS_CONTROL $HOST_DESTINO > $TEMPORAL;;
        	esac
	fi
	export PORCENTAJE="`cat $TEMPORAL |awk '{print $1}'|sed s/%//g`"
	echo "$PORCENTAJE $PORC_PERMITIDO " |awk '{printf "%4s|%4s|",$1,$2}'
	if [ $PORCENTAJE -gt $PORC_PERMITIDO ]
	then
        	export INFORMO=SI
		echo " `tput rev` !! CONTROLAR !! `tput rmso`"
	else
		echo " --> OK "
	fi
}

Check_reg ()
{
#	set -x
        export HOST_DESTINO=$1
        export FS_CONTROL=$2
        export OS=$4
	export CHECK_REG="OK"
	if [ `ping -c1 $HOST_DESTINO 1> /dev/null 2> /dev/null;echo $? ` -eq 0 ]
	then
		if [ "$OS" = "AIX" -o "$OS" = "IRIX" ]
		then
			if [ `rsh $HOST_DESTINO df -k $FS_CONTROL |  grep -v Used 1> /dev/null 2> /dev/null;echo $?` -ne 0 ]
			then
				export CHECK_REG="MAL"
			fi
		else
			export CHECK_REG="MAL"
		fi
	else
		export CHECK_REG="MAL"
	fi
}
	



Leo_reg ()
{
#set -x
	export F_DATA=$1
	export i=1
	export VEC_RG='' 
	while read RG
	do
        	VEC_RG[$i]=$RG
        	let "i=i + 1"
	done < $F_DATA
}

#################################################################################
#				   PRINCIPAL                                    #
#################################################################################
#################################################################################
#                               VARIABLES                                       #
#################################################################################
export DESTINATARIO=$1
export DIR_HOME=/tecnol/util
export FILE_DATA=$DIR_HOME/control.dat
export INFORMO=NO
export CHECK_REG=OK
export DUERMO=300
#export DUERMO=30
#################################################################################


while true
do
	clear
	Leo_reg $FILE_DATA 
	export j=1
	export REG_TOTAL=$i
	echo "					`date`"
	echo "\t##########################################################################"	
        echo "\tFILESYSTEM\t\t\t   | NODO\t  |\t PA | PP | STATUS"
        echo "\t##########################################################################"
	until [ $j -eq $REG_TOTAL + 1 ] 
	do
		export RECORD=${VEC_RG[$j]}
		Check_reg $RECORD
		if [ $CHECK_REG = OK ]
		then
			Chequear_filesystem $RECORD $INFORMO
			if [ $INFORMO = SI ]
			then
				Enviar_mail_alerta $RECORD $DESTINATARIO
				export INFORMO=NO
			fi
		else
			echo " `tput rev`\t ERROR EN UN REGISTRO, CHEQUEAR $FILE_DATA !!!`tput rmso`"
		fi
		let "j=j + 1"
	done 
	echo "\t##########################################################################"
	echo "\n\t\tEspero $DUERMO segundos para la proxima corrida"
	sleep $DUERMO
done
