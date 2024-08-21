#!/bin/ksh
##############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............: 	                                                      #
# Autor..............:  		                                      #
# Objetivo...........:                                                        #
# Nombre del programa:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 18/04/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
##############################################################################
#set -n

#set -x

##############################################################################
##                            Variables                                    ###
##############################################################################
export FECHA="`date +%Y%m%d`"
export FECHA_HORA="`date '+%d-%m-%Y_%H:%M'`"
export OPERACION=${1}
export PATHAPL="/tecnol/operador"
export FPATH="/tecnol/funciones"
export PATH_ORI="/imple_atg"
export USER_EXEC="`whoami`"
export PATH_TMP="/tmp"
export MENU_TMP="${PATH_TMP}/list_menu"
export ARCH_IMPLE="${PATH_TMP}/imple_${FECHA}"
export HOST_DES="scdigi01"

variable_xml()
{
export PATH_ORI_IMPLE="${PATH_ORI}/xml"
export PATH_DES_IMPLE="/imple/importsXML"
export PATH_PROCE="${PATH_ORI_IMPLE}/procesados"
export PATH_LOGS="${PATH_ORI_IMPLE}/logs"
export ARCH_IMPLE_ATG_LOGS="${PATH_LOGS}/${NOMBRE_SELECCION}.log"
export ARCH_EXE_XML="/ATG/import_clientes.sh"
export XML="Y" 
}

variable_deploy()
{
export PATH_ORI_IMPLE="${PATH_ORI}/deploy"
export PATH_DES_IMPLE="/imple/deploy"
export PATH_PROCE="${PATH_ORI_IMPLE}/procesados"
export PATH_LOGS="${PATH_ORI_IMPLE}/logs"
export ARCH_IMPLE_ATG_LOGS="${PATH_LOGS}/${NOMBRE_SELECCION}.log"
export DEPLOY="Y"
}

variable_war()
{
export PATH_ORI_IMPLE="${PATH_ORI}/deploy"
export PATH_DES_IMPLE="/imple/deploy"
export PATH_PROCE="${PATH_ORI_IMPLE}/procesados"
export PATH_LOGS="${PATH_ORI_IMPLE}/logs"
export ARCH_IMPLE_ATG_LOGS="${PATH_LOGS}/${NOMBRE_SELECCION}.log"
export WAR="Y"
}

export BOLD=`tput bold`               #  Coloca la pantalla en modo de realce
export REV=`tput smso`                #  Coloca la pantalla en modo de vío inverso
export EREV=`tput rmso`                 
export END=`tput sgr0`                #  Despuéde usar uno de los atributos de arriba, se usa este para restaurar la pantalla a su modo normal
export BLNK=`tput blink`              #  Los caracteres tecleados apareceráintermitentes
export SVCRSR=`tput sc`        	#	Save Cursor position - Graba la posicióel cursor
export RSTCSR=`tput rc`         #	Restore Cursor position - Coloca el cursor en la posicióarcada por el úo sc
export RST=`tput reset`         	#Limpia la pantalla y restaura sus definiciones de acuerdo con el terminfo o sea, la pantalla vuelve al patróefinido x la variab $TERM
export UNDER=`tput smul`       	#	Habilita underline en la terminal
export EUNDER=`tput rmul`       	#Deshabilita underline en la terminal


##############################################################################
##                            Funciones                                    ###
##############################################################################
typeset -fu Borrar
typeset -fu Enviar_A_Log


titulo ()
{
#set -x
MENSAJE=$1
echo  "\t-------------------------------------------------------------------------------"
echo  "\t$MENSAJE"
echo  "\t-------------------------------------------------------------------------------"
echo  " "
}

function PTecla
{
#set -x
        echo "\tPresione una tecla para continuar"
        read cont
}

#---------------------------------------------------------------------------------
#  Funcion para ver el archivo o directorio a enviar al scdigi01
#---------------------------------------------------------------------------------


crealista()
{
#set -x

>${ARCH_IMPLE}
>${MENU_TMP}

export PATHDIR=$1

if [ "${XML}" = "Y" ]
then
        IMPLEMENTA="Archivo xml"
        ls -1 ${PATHDIR} | grep -i xml >> ${ARCH_IMPLE}

else
        if [ "${DEPLOY}" = "Y" ]
        then
                ls -1 ${PATHDIR} | grep "^COTODIGITAL_STORE$" >> ${ARCH_IMPLE}
                IMPLEMENTA="Directorio COTODIGITAL_STORE"
        else
                if [ "${WAR}" = "Y" ]
                then
                        ls -1 ${PATHDIR}/*.war | cut -d"/" -f4  >> ${ARCH_IMPLE} 
                fi              
        fi
fi


if [ -s ${ARCH_IMPLE} ]  2>/dev/null
then
        echo  "\t============================================================================================"
        echo  "\t Archivos/Directorio a implementar en ATG en el directorio ${PATHDIR} "
        echo  "\t--------------------------------------------------------------------------------------------"
 	echo  " " 
        LISTAR=`cat ${ARCH_IMPLE} | awk '{print sprintf("\t%02d)%s", NR , $1)}'`
        CANT_COL=4
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
	echo  "`ls -lt ${PATHDIR}`"
	echo  " "

	EXITE=0
        cat ${ARCH_IMPLE} | awk '{print sprintf("\t%02d)%s", NR , $1)}' >>${MENU_TMP}
else
        echo  "Atencion no existe en el path ${PATHDIR} algun ${IMPLEMENTA} a implementar"
        echo  " "
	echo  "NOTA: Solicitar que vuelvan a copiar en el `hostname` via samba el ${IMPLEMENTA} a implementar"
	EXIST=1
        echo " "
        echo " "
        echo  "Pulse una tecla para continuar..." 
        read
	exit 1
fi
}

#---------------------------------------------------------------------------------
#   Funcion para seleccionar de una lista el archivo / Directorio a enviar al scdigi01
#---------------------------------------------------------------------------------

selecciono()
{
#set -x
export PATH_IMPLE=$1

tput ed ; tput sc

until [ ${SELECCION} ]
do
echo  "\t--------------------------------------------------------------------------------------------"
echo  "\tIngrese el nro del archivo xml que desee administrar:    "
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
                                        export SELECCION=`grep "${CTROL})" ${MENU_TMP} | cut -c1-3`
                                        export NOMBRE_SELECCION=`grep "${CTROL})" ${MENU_TMP} | cut -c5-`
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

#---------------------------------------------------------------------------------
#       Funcion para enviar archivos al scdigi01
#---------------------------------------------------------------------------------

scp_scdigi01()
{
#set -x
export ENVIA_ARC=$1

# verifico usuario y grupo
if [ ${EXISTE} = 0 ]
then
        titulo "Comprimiendo archivos/directorio ${ENVIA_ARC}"

        if [ "${XML}" = "Y" ]
        then
                IMPLEMENTA="Archivo xml"
                CMD_ZIP="gzip"
                CMD_UNZIP="gzip -df"
                ENVIA_ZIP="${ENVIA_ARC}.gz"
                cd ${PATH_ORI_IMPLE} ; ${CMD_ZIP} ${ENVIA_ARC}
        fi 
       		if [ $? = 0 ]
        	then
                	echo "\tSe comprimio correctamente ${ENVIA_ZIP}"
                	echo "`ls -lt ${PATH_ORI_IMPLE}/${ENVIA_ZIP}`"
                	echo " "
                	titulo "Copiando el archivo ${ENVIA_ZIP} a ${HOST_DES}:${PATH_DES_IMPLE}/${ENVIA_ZIP}"
                	scp -pr ${PATH_ORI_IMPLE}/${ENVIA_ZIP} ${HOST_DES}:${PATH_DES_IMPLE}/${ENVIA_ZIP}

                	if [ $? = 0 ]
                	then
                        	mv ${PATH_ORI_IMPLE}/${ENVIA_ZIP} ${PATH_PROCE}/${ENVIA_ZIP}
                        	export CHECK_ARCH_ORI="$(sum ${PATH_PROCE}/${ENVIA_ZIP} | cut -d' ' -f1)"
                        	export CHECK_ARCH_DES="$(ssh ${HOST_DES} "sum ${PATH_DES_IMPLE}/${ENVIA_ZIP}" | cut -d' ' -f1)"

                        	if [ "$CHECK_ARCH_ORI" = "$CHECK_ARCH_DES" ];
                        	then
                                	ssh ${HOST_DES} "cd ${PATH_DES_IMPLE} ; gunzip -f ${ENVIA_ZIP}"
                                	echo  "\tLa copia se realizo con exito, vaya al servidor ${HOST_DES}. Continua la operacion"
                       		else
                                	echo  "\tverificar !!! el archivo no se copio correctamente."
                        	fi
                	else
                      		echo  "\tNo termino de realizarse la copia, verificar!."
                	fi
       		else
               		echo "\tFallo la compresion del archivo..., verificar"
       		fi
else
       	echo  "\tVerifique ya que no se encuentra el archivo a Copiar"
fi

}

scp_deploy_war()
{
#set -x
export ENVIA_ARC=$1

# verifico usuario y grupo
if [ ${EXISTE} = 0 ]
then
        titulo "Comprimiendo archivos/directorio ${ENVIA_ARC}"
	if [ "${WAR}" = "Y" ]
   	then
		IMPLEMENTA="Archivo WAR AtgServiceWS.war"
		CMD_ZIP="gzip"
                CMD_UNZIP="gzip -df"
                ENVIA_ZIP="${ENVIA_ARC}.gz"
                cd ${PATH_ORI_IMPLE} ; ${CMD_ZIP} ${ENVIA_ARC}
        fi

                if [ $? = 0 ]
                then
                        echo "\tSe comprimio correctamente ${ENVIA_ZIP}"
                        echo "`ls -lt ${PATH_ORI_IMPLE}/${ENVIA_ZIP}`"
                        echo " "
                        titulo "Copiando el archivo ${ENVIA_ZIP} a ${HOST_DES}:${PATH_DES_IMPLE}/${ENVIA_ZIP}"
                        scp -pr ${PATH_ORI_IMPLE}/${ENVIA_ZIP} ${HOST_DES}:${PATH_DES_IMPLE}/${ENVIA_ZIP}

                        if [ $? = 0 ]
                        then
                                mv ${PATH_ORI_IMPLE}/${ENVIA_ZIP} ${PATH_PROCE}/${ENVIA_ZIP}
                                export CHECK_ARCH_ORI="$(sum ${PATH_PROCE}/${ENVIA_ZIP} | cut -d' ' -f1)"
                                export CHECK_ARCH_DES="$(ssh ${HOST_DES} "sum ${PATH_DES_IMPLE}/${ENVIA_ZIP}" | cut -d' ' -f1)"

                                if [ "$CHECK_ARCH_ORI" = "$CHECK_ARCH_DES" ];
                                then
                                        ssh ${HOST_DES} "cd ${PATH_DES_IMPLE} ; gunzip -f ${ENVIA_ZIP}"
                                        echo  "\tLa copia se realizo con exito, vaya al servidor ${HOST_DES}. Continua la operacion"
                                else
                                        echo  "\tverificar !!! el archivo no se copio correctamente."
                                fi
                        else
                                echo  "\tNo termino de realizarse la copia, verificar!."
                        fi
                else
                        echo "\tFallo la compresion del archivo..., verificar"
                fi
else
        echo  "\tVerifique ya que no se encuentra el archivo a Copiar"
fi

}


scp_deploy_scdigi01()
{
#set -x
export ENVIA_ARC=$1

# verifico usuario y grupo
if [ ${EXISTE} = 0 ]
then
        titulo "Comprimiendo archivos/directorio ${ENVIA_ARC}"

        if [ "${DEPLOY}" = "Y" ]
        then
                IMPLEMENTA="Directorio COTODIGITAL_STORE"
                CMD_ZIP="tar -cvf"
                CMD_UNZIP="tar -xvf"
                TAR_ARCH="${ENVIA_ARC}.tar"
                ENVIA_ZIP="${ENVIA_ARC}.tar.gz"
                cd ${PATH_ORI_IMPLE} ; ${CMD_ZIP} ${TAR_ARCH} ./${ENVIA_ARC} ; gzip -f ${TAR_ARCH} 
                if [ $? = 0 ]
                then
                        echo "\tSe comprimio correctamente ${ENVIA_ZIP}"
                        echo "`ls -lt ${PATH_ORI_IMPLE}/${ENVIA_ZIP}`"
                        echo " "
                        titulo "Copiando el archivo ${ENVIA_ZIP} a ${HOST_DES}:${PATH_DES_IMPLE}/${ENVIA_ZIP}"
                        scp -pr ${PATH_ORI_IMPLE}/${ENVIA_ZIP} ${HOST_DES}:${PATH_DES_IMPLE}/${ENVIA_ZIP}

                        if [ $? = 0 ]
                        then
                                mv ${PATH_ORI_IMPLE}/${ENVIA_ZIP} ${PATH_PROCE}/${ENVIA_ZIP}
                                export CHECK_ARCH_ORI="$(sum ${PATH_PROCE}/${ENVIA_ZIP} | cut -d' ' -f1)"
                                export CHECK_ARCH_DES="$(ssh ${HOST_DES} "sum ${PATH_DES_IMPLE}/${ENVIA_ZIP}" | cut -d' ' -f1)"

                                if [ "$CHECK_ARCH_ORI" = "$CHECK_ARCH_DES" ];
                                then
                                        ssh ${HOST_DES} "cd ${PATH_DES_IMPLE} ; gunzip -f ${ENVIA_ZIP} ; ${CMD_UNZIP} ${TAR_ARCH} ; rm -f ${PATH_DES_IMPLE}/${ENVIA_ZIP}"
                                        echo  "\tLa copia se realizo con exito, vaya al servidor ${HOST_DES}. Continua la operacion"
                                else
                                        echo  "\tverificar !!! el archivo no se copio correctamente."
                                fi
                        else
                                echo  "\tNo termino de realizarse la copia, verificar!."
                        fi
                else
                        echo "\tFallo la compresion del archivo..., verificar"
                fi
	fi
else
        echo  "\tVerifique ya que no se encuentra el archivo a Copiar"
fi

}


mv_deploy_scdigi01()
{
#set -x
# verifico usuario y grupo
if [ ${EXISTE} = 0 ]
then
       export ARCH_OLD="COTODIGITAL_STORE"
       export PATH_OLD="/ATG/ATG11.1"
       export PATH_BACKUP="/imple/deploy/backups"

       echo  "\tRealizo backup carpeta ${ENVIA_ZIP} en el ${PATH_BACKUP}"
       ssh ${HOST_DES} "mv -f ${PATH_OLD}/${ARCH_OLD} ${PATH_BACKUP}/${ARCH_OLD}_${FECHA_HORA}"
	if [ $? = 0 ]
   	    	then
                echo "\tCopiando Modulo ${ARCH_OLD} al directorio ${PATH_OLD}"
                ssh ${HOST_DES} "cd ${PATH_DES_IMPLE} ; cp -pr ${ARCH_OLD} ${PATH_OLD} ; chown -R oraatg:oinstall ${PATH_OLD}/${ARCH_OLD}"
        else
             echo "\tNo se pudo realizar la copia del modulo ${ENVIA_ZIP} al directorio {PATH_OLD}"
        fi
else
        echo  "\tVerifique ya que no se encuentra el archivo a Copiar"
fi

}


##############################################################################
##                            Principal                                    ###
##############################################################################


case $OPERACION in

####################################################################################
#      FLAGS PARA EL ADM01
####################################################################################

         VER_XML_IMPLE) titulo " Ver archivo XML Implementar.. Aguarde por Favor.."
                        variable_xml
                        crealista ${PATH_ORI_IMPLE}
                        ;;

         SCP_XML_IMPLE) titulo " Copiando el XML al scdigi01.. Aguardar por favor"
                        variable_xml
                        crealista ${PATH_ORI_IMPLE}
                        selecciono ${NOMBRE_SELECCION}
                        scp_scdigi01 ${NOMBRE_SELECCION}
                        ;;

      VER_DEPLOY_IMPLE) titulo " Ver Deploy a Implementar.. Aguarde por Favor.."
                        variable_deploy
                        crealista ${PATH_ORI_IMPLE}
                        ;;
      VER_DEPLOY_WAR) 	titulo " Ver Deploy a Implementar.. Aguarde por Favor.."
                        variable_war
                        crealista ${PATH_ORI_IMPLE}
                        ;;

      SCP_DEPLOY_IMPLE) titulo " Copiando el COTODIGITAL_STORE al scdigi01.. Aguardar por favor"
                        variable_deploy
                        crealista ${PATH_ORI_IMPLE}
                        selecciono ${NOMBRE_SELECCION}
                        scp_deploy_scdigi01 ${NOMBRE_SELECCION}
                        mv_deploy_scdigi01
                        ;;
      SCP_DEPLOY_WAR) titulo " Copiando el WAR AtgServiceWS al scdigi01.. Aguardar por favor"
                        variable_war
                        crealista ${PATH_ORI_IMPLE}
                        selecciono ${NOMBRE_SELECCION}
                        scp_deploy_war ${NOMBRE_SELECCION}
                        ;;

esac

rm ${ARCH_IMPLE} 1>/dev/null 2>/dev/null 
rm ${MENU_TMP} 1>/dev/null  2>/dev/null

echo

PTecla
