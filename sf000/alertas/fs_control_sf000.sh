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
export SRV=`hostname -s`
export PORC_LIM=90

#################################################
#Lista de Filesystem a controlar
#################################################

export FS_OS="/usr:95 /var:90 /tmp:90 /home:90 /opt:95 /u01:95 /11G:98 /tecnol:90 /sfctrl:90 /home/ctm:90 /reproceso:90 /codigos:90
/expora:95"

#################################################
#Lista de Filesystem exceptuados               #INCLUIR ACA LOS FS QUE SE DESEAN EXCEPTUAR
#################################################
export FS_NO="/mkcd/cd_images /mkcd/cd_fs /u02/oradata/SFC /backup"


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
	export SERVIDOR=`hostname -s`
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
		cat $ARC_SAL | mail -s "$MSG_SUBJECT"  ${USER}@redcoto.com.ar 
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
        df -k $CONTROLO | grep -v Mounted | awk '{print $4 }' | grep -v " "
}

Chequear_filesystem ()
{
#set -x
	export HOST_LOCAL=$1
	export FS_CONTROL=$2
	export PORC_PERMITIDO=$4
	export OS=$3
	export HOST_LOCAL=`hostname -s` # Host donde corre este proceso
	export TEMPORAL="/tmp/chk.$$"
        case $OS in
             AIX )  df -k $FS_CONTROL | grep -v Used |awk '{print $4 "\t$HOST_LOCAL" "\t" $3 }' > $TEMPORAL;;
             Linux) df -k | grep -w $FS_CONTROL$ |awk '{print $4 "\t" "\t$HOST_LOCAL" "\t" $2 }' > $TEMPORAL;;
        esac
	export PORCENTAJE="`cat $TEMPORAL |awk '{print $1}'|sed s/%//g`"
	export ESP_LIBRE="`cat $TEMPORAL | awk '{print $3}'`"	
	if [ $PORCENTAJE -ge $PORC_PERMITIDO ]
	then
	        if [ $PORC_PERMITIDO = 100 ]
                then
                        if [ $ESP_LIBRE -le $ESP_LIMI ]
                        then
        	                echo "$FS_CONTROL $HOST_LOCAL" | awk '{printf "%30s|%9s|",$1,$2}'
                	        echo "$PORCENTAJE $PORC_PERMITIDO $ESP_LIBRE"  | awk '{printf "%8s|%4s|%10s|",$1,$2,$3}'
                        	export INFORMO=SI
                        	echo " !! CONTROLAR !!"
                        	export ESTADO="SI"
                        fi
                else
                        echo "$FS_CONTROL $HOST_LOCAL" | awk '{printf "%30s|%9s|",$1,$2}'
                        echo "$PORCENTAJE $PORC_PERMITIDO  $ESP_LIBRE" | awk '{printf  "%8s|%4s|%10s|",$1,$2,$3}'
                        export INFORMO=SI
                        echo " !! CONTROLAR !!"
                        export ESTADO="SI"
                fi
	fi
}

Check_reg ()
{
        #set -x
        export HOST_LOCAL=$1
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
export ESP_LIMI=800000
#export DUERMO=300
#################################################################################

>$CUERPO
export ESTADO=""
	clear
	Crea_dat
	Leo_reg $FILE_DATA 
	export j=1
	export REG_TOTAL=$i
        echo "\t `date`\t$DIR_SCRIPT/$0"                                        >>$CUERPO
        echo "\t################################################################################" >>$CUERPO
        printf "%30s|%9s|%8s|%4s|%10s|%10s\n" FILESYSTEM NODO PA PP "ESP LIBRE" STATUS  >>$CUERPO
        echo "\t################################################################################" >>$CUERPO
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
			echo "\t ERROR EN UN REGISTRO, CHEQUEAR $FILE_DATA !!!"  >>$CUERPO
		fi
	let "j=j + 1"
	done
        echo "\t############################################################################" >>$CUERPO
	 if [ $ESTADO = ""] 2> /dev/null
	 then
	        rm $ARCH_DAT $CUERPO /tmp/chk.*	
		exit 0 
         else
		if [ $ESTADO = "SI" ] 2> /dev/null
        	then
       			Enviar_mail_alerta $RECORD $DESTINATARIO $CUERPO             
		rm $ARCH_DAT $CUERPO /tmp/chk.* 
			exit 0
	        else
	       	rm $ARCH_DAT $CUERPO /tmp/chk.*
			exit 0
         	 fi
	fi
	
