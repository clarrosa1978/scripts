#!/usr/bin/ksh
###############################################################################
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Reportar estado de cierre en sucursales.               #
# Nombre del programa: ctrolcierre.sh                                         #
# Solicitado por.....: Omar Del Negro                                         #
# Descripcion........: Consulta los valores de la columna xsitcier de las     #
#                      tablas t6022600 y t6022400.                            #
# Fecha de creacion..: 30/04/2008                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export SO="${1}"
export PATHAPL="/home/clarrosa/mesa"
export PATHLOG="${PATHAPL}/log"
export SQL="ctrolcierre.sql"
export USUARIO="`whoami`"
export LOG="${PATHLOG}/ctrlcierre.${USUARIO}.`date +%A`"
export BLNK=`tput blink`
export BOLD=`tput bold`
export END=`tput sgr0`
export REV=`tput smso`
export EREV=`tput rmso`
if [ ${SO} = "A" ] 
then
	export COMANDO="/u01/app/oracle/product/734/bin/sqlplus"
	export PATHCON="/tecnol/storeflow/cierre"
	export USUARIODB="u601/u601"
	export SUCURSALES="`echo $LISTASUC`"
	export REMOTO="rsh"
else
	export COMANDO="/u01/app/oracle/product/9.2.0/bin/sqlplus"
	export PATHCON="/tecnol/cierre-sf/sql"
	export USUARIODB="/"
	export SUCURSALES="`echo $LISTALNX`"
	export REMOTO="ssh"
fi
export LCLOG="/sfctrl/l/lclog"
export INFORME="${PATHLOG}/infctrlcierr.${USUARIO}.tmp"

###############################################################################
#                              Funciones                                      #
###############################################################################
function Comunicacion
{
	ping -c1 $1 >/dev/null 2>&1
	if [ $? -ne 0 ]
 	then
  		return 1
	fi
}

###############################################################################
#                              Principal                                      #
###############################################################################
if [ -f ${INFORME} ]
then 
	rm ${INFORME}
fi
${PATHAPL}/encabezado.sh "CONTROL CIERRE SUCURSAL" 
echo "\n\n\n\t\t\t\t\tINFORME DE CIERRE DE SUCURSALES\n" | tee -a  ${INFORME}
for i in `echo ${SUCURSALES}`
do
	SUCURSAL="suc${i}"
	echo "\t\t-----------------------------------------------------------------------------" | tee -a ${INFORME} 
  	Comunicacion ${SUCURSAL}
  	if [ $? -eq 0 ]
   	then
    		CONSULTA=`${REMOTO} ${SUCURSAL} "su - oracle -c '${COMANDO} -s ${USUARIODB} @${PATHCON}/${SQL}'"`
    		TIENDA=`echo ${CONSULTA} |cut -c5`
    		EMPRESA1=`echo ${CONSULTA} |cut -c11`
    		EMPRESA2=`echo ${CONSULTA} |cut -c13`
    		DIRECTOR=`echo ${CONSULTA} |cut -c35`
    		case ${DIRECTOR} in
     			1)	echo "\t\t${SUCURSAL} Director cerrado"               | tee -a ${INFORME}
           			;;
     			2)  	echo "\t\t${SUCURSAL} Director activo"                | tee -a ${INFORME}
           			;;
     			3)  	echo "\t\t${SUCURSAL} Director parado"                | tee -a ${INFORME}
           			;;
     			4)  	echo "\t\t${SUCURSAL} Director preparando ...."       | tee -a ${INFORME}
           			;;
     			5)  	echo "\t\t${SUCURSAL} Sist. Abierto"                  | tee -a ${INFORME}
           			;;
     			6)  	echo "\t\t${SUCURSAL} Act. Director"                  | tee -a ${INFORME}
           			;;
     			7)  	echo "\t\t${SUCURSAL} Solicitud de parada"            | tee -a ${INFORME}
           			;;
     			8)  	echo "\t\t${SUCURSAL} Proc. Director. Copia Cerrada"  | tee -a ${INFORME}
           			;;
    		esac   
    		FLAG=0   ## 0 abierto /  4 cerrado /  intermedio --> hay problemas 
    		if  [ ${TIENDA} -ne 2 ] 
     		then
      			echo "\t\t${SUCURSAL}   LA TIENDA NO ESTA CERRADA (SQL)" | tee -a ${INFORME}
     		else
      			echo "\t\t${SUCURSAL}  Tienda      Cerrada (SQL)" | tee -a ${INFORME}
            		FLAG=`expr ${FLAG} + 1` 
    		fi
    		if [ ${EMPRESA1} -ne 2 ]
     		then
      			echo "\t\t${SUCURSAL}   EMPRESA 1 NO ESTA CERRADA (SQL)" | tee -a ${INFORME}
     		else
      			echo "\t\t${SUCURSAL}  Empresa 1   Cerrada (SQL)"  | tee -a ${INFORME}
      			FLAG=`expr ${FLAG} + 1`
    		fi
    		if [ ${EMPRESA2} -ne 2 ]
     		then
      			echo "\t\t${SUCURSAL}   EMPRESA 2 NO ESTA CERRADA (SQL)" | tee -a ${INFORME}
     		else
      			echo "\t\t${SUCURSAL}  Empresa 2   Cerrada (SQL)" | tee -a ${INFORME}
      			FLAG=`expr ${FLAG} + 1`
    		fi
    		if [ `${REMOTO} ${SUCURSAL} grep -c "'correcta del cierre de empresa'" ${LCLOG}` -ne 2 ]
     		then
      			echo "\t\t${SUCURSAL}  CHEQUEAR CIERRE DE CENTRO Y EMPRESAS" | tee -a ${INFORME}
     		else
      			if [ `${REMOTO} ${SUCURSAL} grep -c "'Cierre terminado correctamente'" ${LCLOG}` -ne 1 ]
       			then
        			echo "\t\t${SUCURSAL}  CHEQUEAR CIERRE DE CENTRO (Mcentro)"| tee -a ${INFORME}
       			else
        			echo "\t\t${SUCURSAL}  Centro y Empresa cerrados ok" | tee -a ${INFORME}
        			FLAG=`expr ${FLAG} + 1`
      			fi
    		fi
    		if [ ${FLAG} -ne 4 ]
     		then
      			if [ ${FLAG} -ne 0 ]
       			then
        			echo "\t\tControlando ${SUCURSAL} .....   $A ATENCION, Suc multempr abierta, o problemas en cierre " 
       			else
        			echo "\t\tControlando ${SUCURSAL} .....   $A Tienda Abierta "
      			fi
     		else
      			echo "\t\tControlando ${SUCURSAL} .....   Tienda Cerrada"
    		fi
   	else 
     		echo "${SUCURSAL}  NO HAY ACCESO A LA SUCURSAL" | tee -a  ${INFORME}
   	fi
done
echo "\n\t\t\t   FIN DEL INFORME"
echo "\t\t\t <ENTER> - CONTINUAR \c"
read nada
