#################################################################################
#                                                                               #
# SCRIPT: control_fs.sh                                                         #
#                                                                               #
# DESCRIPCION: Controla que los filesystem mas importantes no superen cierto    #
#              porcentaje de ocupacion e informa via mail si esto ocurriese     #
#                                                                               #
# AUTOR: Cerizola Hugo - Administracion Aix                                     #
#                                                                               #
#################################################################################
#!/bin/sh
#set -x
##set -n 
#################################################################################
#				FUNCIONES					#
#################################################################################

Crea_dat ()  
{
#set -x
export ARCH_DAT="$DIR_SCRIPT/control.dat"
export SO=`uname`
export SRV=`hostname`
export NRO_SUC=`echo $SRV | cut -c4-`
export PORC_LIM=90
export SHELL=""
if  [ $NRO_SUC -le 100 ] 
then 
NRO_SUC_3D=0$NRO_SUC
else
NRO_SUC_3D=$NRO_SUC
fi
#################################################
#Lista de Filesystem a controlar
#################################################
export FS_OS="/home:90 /tmp:90 /usr:90 /var:90 /opt:95 /usr/local:90 /proc:90 /expora:90 /ctm:90 /provisorio:95 /sfctrl:90 /sts:90 /tecnol:90 /transfer:90 /vtareserva:85 /avirus:90 /rman:95 /dbfs_SF${NRO_SUC_3D}_archive:80 /u01:95"
#################################################
#Lista de Filesystem exceptuados               #INCLUIR ACA LOS FS QUE SE DESEAN EXCEPTUAR 
#################################################
export FS_NO="/u02/oradata/CTRLM${NRO_SUC_3D} /u02/oradata/SF${NRO_SUC_3D} /files" 

export TOPE_OS=90

if [ $SO = "Linux" ]
        then
        export LST_FS=`df -k | awk '{  print $5 }' | grep /`  
        else
        export LST_FS=`df -k | grep -v "Mounted" | awk '{print $7}'`
fi
>$ARCH_DAT
OK=""
for FS in $LST_FS
do
if [ $FS = "/" ] 
then
PORC_LIM=$TOPE_OS
else
      	for OS in $FS_OS
       	do
	BSC=`echo $OS | cut -d":" -f1`
	TOPE=`echo $OS | cut -d":" -f2`
       	echo $FS | grep "^$BSC$" 
                if [ $? = 0 ] 
                then 
                 PORC_LIM=$TOPE ; OK=0 ; break
                else
                OK=1 ; PORC_LIM=$TOPE_OS
                fi
        done
fi

echo $FS_NO | grep $FS
if [ $? != 0 ]
then
	echo "$SRV  $FS  $SO  $PORC_LIM " >>$ARCH_DAT
fi
done
}

export ARCH_DAT="$DIR_SCRIPT/control.dat"
export SO=`uname`
export SRV=`hostname`

Enviar_mail_alerta ()
{
	#set -x
	export USUARIOS="operaciones"
	export SERVIDOR=`hostname`
	export L_FS=$2
	export L_PP=$4
	export ARC_SAL=$5
	export FILE_ALERTAS="alertas_filesystems.log"
	export MSG_SUBJECT="ATENCION !!!! $SERVIDOR Controlar Filesystem"
	export MSG_BODY="Controlar Filesystem $L_FS del servidor $SERVIDOR que superan los $L_PP% " 

	echo "\t Controle los Fs del serv $SERVIDOR que superen los Porcentajes Permitidos" >>$ARC_SAL
	echo "\t Vea que puede depurar o bien informe a la guardia correspondiente"  >>$ARC_SAL
	echo "\t para que le indique que accion tomar. Este mail seguira saliendo"  >>$ARC_SAL 
	echo "\t hasta que sea solucionado"  >>$ARC_SAL     
	echo " "	>>$ARC_SAL

	for USER in $USUARIOS 
        do	
	if [ $SO = "Linux" ]	
		then
		cat $ARC_SAL | mutt -s "$MSG_SUBJECT" -b ${USER}@redcoto.com.ar
	else
		cat $ARC_SAL |  mhmail ${USER}@redcoto.com.ar -subject "$MSG_SUBJECT"  
	fi
	done
}

Control_fs_aix ()
{
#set -x
	export CONTROLO=$1
	export HOST=$2
	df -k $CONTROLO | grep -v Used |awk '{print $4 "\t" $6 "\t$HOST"}'
}

Control_fs_linux ()
{
#set -x
        export CONTROLO=$1
        export HOST=$2
        df -k $CONTROLO | grep -v Mounted | awk '{print $2,$4 }' | grep -v " "
}

Chequear_filesystem ()
{
#set -x
	export HOST_DESTINO=$1
	export FS_CONTROL=$2
	export PORC_PERMITIDO=$4
	export OS=$3
	export HOST_LOCAL=`hostname -s` # Host donde corre este proceso
	export TEMPORAL="/tmp/chk.$$"
	if [ "$HOST_LOCAL" != "$HOST_DESTINO" ]
	then
		case $OS in
			AIX )  df -k $FS_CONTROL | grep -v Used |awk '{print $2,$4 "\t$HOST_DESTINO"}' > $TEMPORAL;;
	 	       Linux) df -k | grep -w $FS_CONTROL |awk '{print $4 "\t\t" "\t$HOST_DESTINO"}' > $TEMPORAL;;
		esac
	else
        	case $OS in
                	AIX ) Control_fs_aix $FS_CONTROL $HOST_DESTINO > $TEMPORAL;;
	               Linux) Control_fs_linux $FS_CONTROL $HOST_DESTINO > $TEMPORAL;;		
        	esac
	fi
	export PORCENTAJE="`cat $TEMPORAL |awk '{print $1}'|sed s/%//g`"
	if [ $PORCENTAJE -gt $PORC_PERMITIDO ]
	then
		echo "$FS_CONTROL $HOST_DESTINO"|awk '{printf "%30s|%9s|\t",$1,$2}'  
		echo "$PORCENTAJE $PORC_PERMITIDO " |awk '{printf  "%4s|%4s|",$1,$2}'
        	export INFORMO=SI
		echo " !! CONTROLAR !!"
                export ESTADO="SI"
	fi
}

Check_reg ()
{
        #set -x
        export HOST_DESTINO=$1
        export FS_CONTROL=$2
        export OS=$3
        export CHECK_REG="OK"
                if [ "$OS" = "AIX" ]
                then
                        if [ `df -k $FS_CONTROL |  grep -v Mounted 1> /dev/null 2> /dev/null;echo $?` -ne 0 ]
                        then
                                export CHECK_REG="MAL"
                        fi
                else
                        if [ "$OS" = "Linux" ]
                        then
                                if [ `df -k $FS_CONTROL  1> /dev/null 2> /dev/null;echo $?` -ne 0 ]
                                then
                                export CHECK_REG="MAL"
                                else
                                export CHECK_REG="OK"
                                fi
                        fi
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
export DIR_SCRIPT="/tecnol/alertas"
export ARCH_DAT="$DIR_SCRIPT/control.dat"
export SO=`uname`
export SRV=`hostname`
export FILE_DATA="$DIR_SCRIPT/control.dat"
export CUERPO="$DIR_SCRIPT/salida.txt"
export INFORMO=NO
export CHECK_REG=OK
if [ ${SO} = 'AIX' ]
then
	ECHOS="echo"
else
	ECHOS="echo -e"
fi
#################################################################################

>$CUERPO
export ESTADO=""
	clear
	Crea_dat
	Leo_reg $FILE_DATA 
	export j=1
	export REG_TOTAL=$i
        ${ECHOS} "        `date`\t$DIR_SCRIPT"					>>$CUERPO
	${ECHOS} "\t##########################################################################"	>>$CUERPO
        ${ECHOS} "\tFILESYSTEM\t\t\t | NODO    |\t    |    | PA | PP | STATUS"			>>$CUERPO
        ${ECHOS} "\t##########################################################################"	>>$CUERPO
	until [ $j -eq $REG_TOTAL ]  
	do
		export RECORD=${VEC_RG[$j]}
		Check_reg $RECORD
		if [ $CHECK_REG = OK ]
		then
			Chequear_filesystem $RECORD $INFORMO >>$CUERPO
			if [ INFORMO = SI ] 2> /dev/null
			then
			ESTADO="SI"
			fi
		else
			${ECHOS} "\t ERROR EN UN REGISTRO, CHEQUEAR $FILE_DATA !!!"  >>$CUERPO
		fi
	let "j=j + 1"
	done
        ${ECHOS} "\t##########################################################################" >>$CUERPO
	 if [ $ESTADO = ""]
	 then
		rm $ARCH_DAT $CUERPO /tmp/chk.*	
		exit 0 
         else
		if [ $ESTADO = "SI" ]
        	then
       			Enviar_mail_alerta $RECORD $DESTINATARIO $CUERPO             
			rm $ARCH_DAT $CUERPO /tmp/chk.* 
			exit 0
	        else
 	       		rm $ARCH_DAT $CUERPO /tmp/chk.*
			exit 0
         	 fi
	fi
