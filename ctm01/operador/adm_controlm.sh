#!/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES ONLINE1                               #
# Grupo..............:                                                        #
# Autor..............: Cerizola Hugo                                          #
# Objetivo...........: Levanta o baja el listener local.                      #
# Nombre del programa: admprocesos.sh                                         #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 20/10/2014                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export OPERACION=${1}
export NOMBRE="admprocesos"
export PATHAPL="/tecnol/operador"
export FPATH="/tecnol/funciones"

###############################################################################
###                            Funciones                                    ###
###############################################################################
ksh autoload Borrar
ksh autoload Enviar_A_Log

titulo ()
{
#set -x
tput ed
MENSAJE=${1}
echo "\t\t" 
echo "\t\t-------------------------------------------------------------------------------"
echo "\t\t$MENSAJE"
echo "\t\t-------------------------------------------------------------------------------"

}

teclacontinuar()
{
#set -x
tput ed
echo  "\t\t${REV}Presione una tecla para continuar...${EREV}"
read
}

ValidarIngreso()
{
#set -x
DATOOK=""
export OPCION3=${1}
if [ -Z ${OPCION3} ] 2>/dev/null
then
	DATOOK=0
	continue
else
        echo "\t\t${BLNK}Ingrese un valor.. para continuar...${END}"
	DATOOK=1
        break
fi
}


verprocesos ()
{
#set -x 
PROCESOS=$*
CONTADOR=0
FILE_PROC_RUN="/tmp/proc_run"
FILE_PROC_NORUN="/tmp/proc_norun"
>${FILE_PROC_RUN}
>${FILE_PROC_NORUN}

for PROC in $PROCESOS
do

CANT_PROC=`ps -fu ${USUARIO} | grep -v grep | grep -i "${PROC}" | wc -l`
if [ ${CANT_PROC} -ge 1 ]
then
	ps -fu ${USUARIO} | grep -v grep | grep -i "${PROC}" >>${FILE_PROC_RUN}
	CONTADOR=`expr ${CONTADOR} "+" 1`
else
        echo  "Atencion el proceso ${PROC} No esta corriendo.." >>${FILE_PROC_NORUN}
fi
done

if [ -s ${FILE_PROC_RUN} ] || [ -s ${FILE_PROC_NORUN} ]
then
	if [ -s ${FILE_PROC_RUN} ] 
	then
		echo  "Procesos UP"
		cat ${FILE_PROC_RUN}
		echo  " "
		echo  "-------------------------------------------------"
		if [ -s ${FILE_PROC_NORUN} ]
		then
			echo  "Procesos DOWN.."
			cat ${FILE_PROC_NORUN}
		fi
	else
                        echo  "Procesos DOWN.."
                        cat ${FILE_PROC_NORUN}
	fi
else
	echo "Atencion !!! No hay procesos del usuario ${USUARIO} corriendo."
	echo "\t\t"
	echo "-------------------------------------------------"
fi

rm ${FILE_PROC_RUN} ${FILE_PROC_NORUN}

}
	

verprocesos_agctrlm ()
{
#set -x
export USUARIO="root"
export LISTAPROC="p_ctmag p_ctmat"
CANTIDAD=`echo $LISTAPROC | wc -w`
	verprocesos $LISTAPROC
	echo "Informe: \nSe controlaron ${CANTIDAD} procesos del usuario ${USUARIO}, \nHay ${CONTADOR} corriendo...\n Deben haber solamante 2 y deberian estar corriendo con ${USUARIO}, caso contrario bajar y volver a levantar"
}

verprocesos_srvctrlm ()
{ 
#set -x
export USUARIO="ctmsrv"
export LISTAPROC="p_ctmrt p_ctmsu p_ctmns p_ctmsl p_ctmwd p_ctmcd p_ctmco p_ctmtr p_ctmlg p_ctmcs"
CANTIDAD=`echo $LISTAPROC | wc -w`
	        verprocesos $LISTAPROC
	echo "Informe: \nSe controlaron ${CANTIDAD} procesos del ${USUARIO}, Hay ${CONTADOR} corriendo...\nEn caso de haber menos procesos, verifique la comunicacion en la GUI en unos minutos, \nsino conecta en unos minutos, bajelos y levantelos nuevamente.."
        #echo "Hay ${CONTADOR} procesos levantados de ${CANTIDAD} procesos controlados del usuario ${USUARIO}"
}



listaragectm()
{
#set -x
ARCH_TMP="/tmp/lista_ag_ctm.txt"
MENU_TMP="/tmp/menu_ag_ctm.txt"
>${ARCH_TMP}
>${MENU_TMP}
su - ctmsrv -c "/home/ctmsrv/ctm_server/exe_AIX/ctm_agstat -list \"*\"" | grep '^Agent ' | cut -d' ' -f2 >${ARCH_TMP}
if [ -s ${ARCH_TMP} ]  2>/dev/null
then
	echo "\t\t--------------------------------------------------------------------------------------------"
	echo "\t\t Lista de Agentes creados en este servidor"
	echo "\t\t--------------------------------------------------------------------------------------------"
        LISTAR=`cat ${ARCH_TMP} | awk '{print sprintf("\t%02d)%s", NR , $1)}'`
        CANT_COL=2
        COUNT=1
                for LIST in ${LISTAR}
                do
                        if [ $COUNT = $CANT_COL ]
                        then
       	        	        COUNT=1
        	                echo "\t${LIST}\t\n"
                        else
                        	COUNT=`expr $COUNT '+' 1`
                        	echo "\t${LIST}\t\c"
                        fi
                done
	cat ${ARCH_TMP} | awk '{print sprintf("\t%02d)%s", NR , $1)}' >>${MENU_TMP}
fi

echo "\t\t--------------------------------------------------------------------------------------------"
echo "\t\tSeleccione el agente a actualizar.." 
echo "\t\t(Por ejemplo: 01, 02) o [s-S] Salir del Menu[s]:\c"
read AGE
echo "\t--------------------------------------------------------------------------------------------"

if [ ${AGE} = "s" ]  2>/dev/null || [ ${AGE} = "S" ]  2>/dev/null || [ ${AGE} = "" ]  2>/dev/null
then
	exit
else 
	CANT_CARA=`echo ${AGE} | awk ' {print length }'`
	if [ ${CANT_CARA} = 2 ]  2>/dev/null 
        then 
       		 grep "${AGE})" ${MENU_TMP} 2>/dev/null 1>/dev/null
                 if [ $? = 0 ]
                 then
               		export AGENTE=`grep "${AGE})" ${MENU_TMP} | cut -c5-`
                        >${ARCH_TMP}
	         else
			echo "\t\t Opcion incorrecta ${AGE}"
			>${ARCH_TMP}
			teclacontinuar
        	        exit
                 fi
	else
 		echo "\t\t Opcion incorrecta ${AGE}"
                >${ARCH_TMP}
		teclacontinuar
		exit
        fi
fi
}

###############################################################################
###                            Principal                                    ###
###############################################################################

tput sc         # Marco la posicion del cursor
tput ed         # Borro todo lo que esta debajo


case $OPERACION in

# -------------------------------------------------------------------------------------------
# MENU DE APLICACIONES 
# -------------------------------------------------------------------------------------------

        UPAGCTRLM)      titulo " Levantando el Agente de Control M, aguarde por favor.."
                        #ksh /home/ctmagt/ctm/scripts/start-ag -u ctmagt -p ALL
			/home/ctmsrv/ctm_agent/ctm/scripts/start-ag -u ctmsrv -p ALL
                        verprocesos_agctrlm
			teclacontinuar
                        ;;
        
        DOWNAGCTRLM)    titulo " Bajando el Agente de Control M, aguarde por favor.."
                        kill -9 `ps -ef | grep ctm | grep "p_ctmag" | grep -v grep | awk '{ print $2 }'`
                        kill -9 `ps -ef | grep ctm | grep "p_ctmat" | grep -v grep | awk '{ print $2 }'`
                        verprocesos_agctrlm
			teclacontinuar
                        ;;

        VERAGCTRLM)     titulo " Controlando los procesos del Agente de Control M, aguarde por favor.."
                        verprocesos_agctrlm
			teclacontinuar
                        ;;

        UPSRVCTRLM)     titulo " Levantando el Server de Control M, aguarde por favor.."
                        su - ctmsrv -c "ksh /home/ctmsrv/ctm_server/scripts/start_ctm"
                        verprocesos_srvctrlm
			teclacontinuar
                        ;;

        DOWNSRVCTRLM)   titulo " Bajando los procesos del Server de Control M, aguarde por favor.."
                        su - ctmsrv -c "ksh /home/ctmsrv/ctm_server/scripts/shut_ctm" 
                        verprocesos_srvctrlm
			teclacontinuar
                        ;;

        VERSRVCTRLM)    titulo " Controlando los procesos del Server de Control M, aguarde por favor.."
                        verprocesos_srvctrlm
			teclacontinuar
                        ;;	

        UPCACTRLM)      titulo " Subir Conexion con el CCM , aguarde por favor.."
                        su - ctmsrv -c "shut_ca"
                        su - ctmsrv -c "start_ca"
                        teclacontinuar
                        ;;

        DOWNCACTRLM)    titulo " Bajando Conexion con el CCM , aguarde por favor.."
                        su - ctmsrv -c "shut_ca"
                        teclacontinuar
                        ;;

        VERCACTRLM)     titulo " Controlando Conexion con el CCM , aguarde por favor.."
                        su - ctmsrv -c "show_ca"
                        teclacontinuar
                        ;;

	UPAGINSTAL)     titulo "Levantado agentes creados en el servidor"
			listaragectm
			echo "Actualizando el agente ${AGENTE}"
			su - ctmsrv -c "/home/ctmsrv/ctm_server/exe_AIX/ctm_agstat -UPDATE ${AGENTE} AVAILABLE" 
			teclacontinuar
			;;

	DOWNAGINSTAL)	titulo "Bajando agentes creados en el servidor"
			listaragectm
			echo "Actualizando el agente ${AGENTE}"
			su - ctmsrv -c "/home/ctmsrv/ctm_server/exe_AIX/ctm_agstat -UPDATE ${AGENTE} DISABLED" 
			teclacontinuar
			;;

        VERAGINSTAL)    titulo " Ver agentes creados en el servidor"
			listaragectm
                        su - ctmsrv -c "/home/ctmsrv/ctm_server/exe_AIX/ctm_agstat -list \"*\" " | grep ${AGENTE}
			teclacontinuar
                        ;;
	VERAGINSTALTODOS)    titulo " Ver agentes creados en el servidor"
                        su - ctmsrv -c "/home/ctmsrv/ctm_server/exe_AIX/ctm_agstat -list \"*\" "
                        teclacontinuar
                        ;;

	
                
# -------------------------------------------------------------------------------------------
	
esac
