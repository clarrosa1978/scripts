#!/bin/sh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............:                                                        #
# Objetivo...........:                                                        #
# Nombre del programa:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 18/04/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export OPERACION=${1}
export PATHAPL="/tecnol/operador"
export FPATH=/tecnol/funciones
export PATH_IMPLE="/imple/importsXML"
export PATH_ORI="/expora"
export PATH_DES="/export"
export PATHBACKEAR="/imple/backups"
export PATH_WAR="/ATG/Ears"
export PATH_PROCE="${PATH_IMPLE}/procesados"
export PATH_LOGS="${PATH_IMPLE}/logs"
export ARCH_IMPLE_ATG_LOGS="${PATH_LOGS}/${NOMBRE_XML}.log"
export USER_EXEC="`whoami`"

export PATH_TMP="/tmp"
export MENU_TMP="${PATH_TMP}/list_menu"
export ARCH_XML="${PATH_TMP}/imple_xml_${FECHA}"
export ARCH_EAR="${PATH_TMP}/rollback_ear_${FECHA}"

export BOLD=`tput bold`                 #Coloca la pantalla en modo de realce
export REV=`tput smso`                  #Coloca la pantalla en modo de vío inverso
export EREV=`tput rmso`                 #
export END=`tput sgr0`                  #Despuéde usar uno de los atributos de arriba, se usa este para restaurar la pantalla a su modo normal
export BLNK=`tput blink`                #Los caracteres tecleados apareceráintermitentes
export SVCRSR=`tput sc`                 #Save Cursor position - Graba la posicióel cursor
export RSTCSR=`tput rc`                 #Restore Cursor position - Coloca el cursor en la posicióarcada por el úo sc
export RST=`tput reset`                 #Limpia la pantalla y restaura sus definiciones de acuerdo con el terminfo o sea, la pantalla vuelve al patróefinido x la variab $TERM
export UNDER=`tput smul`                #Habilita underline en la terminal
export EUNDER=`tput rmul`               #Deshabilita underline en la terminal

 
###############################################################################
###                            Funciones                                    ###
###############################################################################
typeset -fu Borrar
typeset -fu Enviar_A_Log

titulo ()
{
MENSAJE=$1
echo  "\t-------------------------------------------------------------------------------"
echo  "\t$MENSAJE"
echo  "\t-------------------------------------------------------------------------------"
echo  " "
}

function PTecla
{
        echo  "\tPresione una tecla para continuar"
        read cont
}


crealista()
{
#set -x

export PATHDIR=$1

>${ARCH_XML}
>${MENU_TMP}
ssh transfer@gdm "ls -1 ${PATHDIR} | grep dmp" >> ${ARCH_XML}

if [ -s ${ARCH_XML} ]  2>/dev/null
then
        echo  "\t============================================================================================"
	echo  "\t Archivos en el directorio ${PATHDIR} de gdm."
        echo  "\t--------------------------------------------------------------------------------------------"
        echo  " "
        LISTAR=`cat ${ARCH_XML} | awk '{print sprintf("\t%02d)%s", NR , $1)}'`
        CANT_COL=1
        COUNT=1
                for LIST in ${LISTAR}
                do
                        if [ $COUNT = $CANT_COL ]
                        then
                                COUNT=1
                                echo  "\t${LIST}\t\n"
                        else
                                COUNT=`expr $COUNT '+' 1`
                                echo  "\t${LIST}\t\c"
                        fi
                done
        echo  " "
        EXITE=0
        cat ${ARCH_XML} | awk '{print sprintf("\t%02d)%s", NR , $1)}' >>${MENU_TMP}
else
        echo  "Atencion no existe en el path ${PATHDIR}."
        EXIST=1
        exit 1
fi
}

selecciono_arch()
{

export PATH_IMPLE=$1
#set -x

tput ed
tput sc

until [ ${NUME_TAR} ]
do
echo  "\t--------------------------------------------------------------------------------------------"
echo  "\tIngrese el nro del archivo/carperta que desee administrar:    "
echo  "\t(Por ejemplo: 01 02 04 10 11) o [s-S] Salir del Menu[s]:\c"
read L
echo  "\t--------------------------------------------------------------------------------------------"

CTRLINPUT=`echo ${L} | wc -c`  1>/dev/null 2>/dev/null
CANT_LIST=`cat ${MENU_TMP} | wc -l`

for CTROL in $L
do
        if [ ${CTROL} = "s" ]  2>/dev/null || [ ${CTROL} = "S" ]  2>/dev/null
        then
                clear
                exit
        else
                if [ ${CTROL} = " " ] || [ ${CTROL} = "" ] || [ ${CTRLINPUT} -ne 3 ] 2>/dev/null || [ ${CTROL} -gt ${CANT_LIST} ] 2>/dev/null
                then
                        echo  "\tError!!!  el dato ingresado es incorrecto.. Verifique y vuelvalo a intentar!!!"
                        echo  "\tPor ejemplo: 01 02 04 10 11 y vuelva a intentarlos"
                        PTecla
                        tput rc ; tput ed
                 else
                        if [ ${CTROL} -gt 0 ]  2>/dev/null && [ ${CTROL} -le ${CANT_LIST} ]  2>/dev/null
                        then
				 NUME_TAR=`grep "${CTROL})" ${MENU_TMP} | cut -c1-3`
                                 NOMBRE_XML=`grep "${CTROL})" ${MENU_TMP} | cut -c5-`
                                 EXISTE=0
                                 tput ed
                         else
                                 echo  "\t$CTROL opcion incorrecta reingrese la opcion por favor"
                                 PTecla
                                 tput rc ; tput ed
                         fi
                 fi
          fi
done

done

}

scp_arch()
{
#set -x

export PATH_DIR=$1

tput ed
tput sc

# verifico usuario y grupo
if [ ${EXISTE} = 0 ]
then
        echo  "\tTransfiero el archivo ${NOMBRE_XML} al tmp del ADM01."
	scp -pr transfer@gdm:$PATH_DIR/${NOMBRE_XML} /tmp/
        if [ $? = 0 ]
        then
		echo  "\tTransfiero el archivo ${NOMBRE_XML} al /export del gdmtest."
		scp -pr /tmp/${NOMBRE_XML} transfer@gdmtest:/export
		if [ $? = 0 ]
		then
                	echo  "\tSe realizo la transferencia de forma exitosa."
                	ssh transfer@gdmtest "sudo chown oracle10.oinstall /export/${NOMBRE_XML}"
			ssh transfer@gdmtest "ls -ltr /export/${NOMBRE_XML}"
        	else
                	echo  "\tNo se pudo transferir el archivo ${NOMBRE_XML} al servidor gdmtest. Verificar."
                	exit 1
		fi
	else
		echo  "\tNo se pudo transferir el archivo ${NOMBRE_XML} al servidor ADM01. Verificar."
		exit 1
        fi

else
echo  "\tVerifique ya que no se encuentra el archivo a Implementar"
fi
}




###############################################################################
###                            Principal                                    ###
###############################################################################
case $OPERACION in

       GDM )
                        crealista ${PATH_ORI}
			selecciono_arch
			scp_arch ${PATH_ORI}
                        ;;

esac

if [ -s ${ARCH_XML} ]
then
        rm ${ARCH_XML}
fi
if [ -s ${MENU_TMP} ]
then
        rm ${MENU_TMP}
fi

if [ -s ${ARCH_EAR} ]
then
        rm ${ARCH_EAR}
fi


echo
echo
echo

PTecla
