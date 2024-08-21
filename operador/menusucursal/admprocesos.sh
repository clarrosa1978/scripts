#!/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Levanta o baja el listener local.                      #
# Nombre del programa: admsf.sh                                               #
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
export SUC="`uname -n | sed 's/suc//'`"
export OPERACION=${1}
export NOMBRE="admsf"
export PATHAPL="/tecnol/operador"
export FPATH=/tecnol/funciones

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Enviar_A_Log

teclacontinuar()
{
#set -x
tput ed
echo -e "\t\t${REV}Presione una tecla para continuar...${EREV}"
read
}

titulo ()
{
MENSAJE=$1
echo -e "\t\t==============================================================================="
echo -e "\t\t$MENSAJE"
echo -e "\t\t==============================================================================="
}


verdb_ctrlm ()
{
#set -x
ORACLE_SID="CTRLM${SUC}"
ps -ef | grep -v grep | grep CTRLM | grep oracle  | grep ora_pmon  1>/dev/null 2>/dev/null
if [ $? = 0 ]
then
	export BASE="UPDBCTM"
	export USER_CTM="ctmsrv"
	export PATH_CTM="/home/ctm/server/ctm"
	export PATH_CTM_SCR="${PATH_CTM}/scripts"
	export PATH_CTM_EXE="${PATH_CTM}/exe_RedHat"
        sleep 2
else
	ORACLE_SID="CTM7${SUC}"
	ps -ef | grep -v grep | grep CTM7 | grep oracle  | grep ora_pmon 1>/dev/null 2>/dev/null
	if [ $? = 0 ]
	then
		export BASE="UPDBCTM"
	        export USER_CTM="ctmsrv7"
		export PATH_CTM="/home/ctmsrv7/ctm_server"
	        export PATH_CTM_SCR="${PATH_CTM}/scripts"
        	export PATH_CTM_EXE="${PATH_CTM}/exe_RedHat"
	        sleep 2
	else
		echo "-----------------------------------------------------------------"
	        echo "            La base de datos de CONTROLM esta DOWN"
		echo "		    Verifique nuevamente, caso contrario"
	        echo "                comuniquese con la guardia DBA."	
        	echo "-----------------------------------------------------------------"
        	echo "-----------------------------------------------------------------"
	        export BASE="DOWNDBCTM"
		teclacontinuar
		exit 1
	fi
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
        echo -e "Atencion el proceso ${PROC} No esta corriendo.." >>${FILE_PROC_NORUN}
fi
done

if [ -s ${FILE_PROC_RUN} ] || [ -s ${FILE_PROC_NORUN} ]
then
	if [ -s ${FILE_PROC_RUN} ] 
	then
		echo -e "Procesos UP"
		cat ${FILE_PROC_RUN}
		echo -e " "
		echo -e "-------------------------------------------------"
		if [ -s ${FILE_PROC_NORUN} ]
		then
			echo -e "Procesos DOWN.."
			cat ${FILE_PROC_NORUN}
		fi
	else
                        echo -e "Procesos DOWN.."
                        cat ${FILE_PROC_NORUN}
	fi
else
	echo -e "Atencion !!! No hay procesos del usuario ${USUARIO} corriendo."
	echo -e " "
	echo -e "-------------------------------------------------"
fi

rm ${FILE_PROC_RUN} ${FILE_PROC_NORUN}

}
	
verprocesos_sf () 
{
#set -x
export USUARIO="sfctrl"
export LISTAPROC="EnvioDom enviotlog ts004101 ts021003 ts029001 ts090403 ServerDTM ServidorTPV btd checktpv filtro floadd fudpsrvd levtcp napafsrd napamand napaspyd onGDMsuc pipe2socket prefiltro price socket2pipe sucsock tpv2vcc ts001072 ts018001 ts018003 ts034101 ts090403 vcc2tpv" # procesos no importantes ts005005 demoeft
CANTIDAD=`echo $LISTAPROC | wc -w` 
	verprocesos $LISTAPROC
	echo -e "Informe: \n Se controlaron ${CANTIDAD} procesos del ${USUARIO}, Hay ${CONTADOR} corriendo...\n puede haber procesos con mas de una corrida.."
}

verprocesos_vpr ()
{
#set -x
export USUARIO="vprctrl"
export LISTAPROC=`cat /vtareserva/daemon/vpr_daemon.cfg | grep '^elenv*' | awk '{ print $1}'`
CANTIDAD=`cat /vtareserva/daemon/vpr_daemon.cfg | grep '^elenv*' | awk '{ print $1}' | wc -w`
        verprocesos $LISTAPROC
	echo -e "Informe: \n Se controlaron ${CANTIDAD} procesos del ${USUARIO}, Hay ${CONTADOR} corriendo...\n Deben estar todos los procesos arriba, caso contrario bajar y volver a levantar"
}

verprocesos_agctrlm ()
{
#set -x
export USUARIO="root"
export LISTAPROC="p_ctmag p_ctmat"
CANTIDAD=`echo $LISTAPROC | wc -w`
	verprocesos $LISTAPROC
	echo -e "Informe: \nSe controlaron ${CANTIDAD} procesos del usuario ${USUARIO}, \nHay ${CONTADOR} corriendo...\n Deben haber solamante 2 y deberian estar corriendo con ${USUARIO}, caso contrario bajar y volver a levantar"
}




verprocesos_srvctrlm ()
{ 
#set -x
verdb_ctrlm
export USUARIO="${USER_CTM}"
export LISTAPROC="p_ctmrt p_ctmsu p_ctmns p_ctmsl p_ctmwd p_ctmcd p_ctmco p_ctmtr p_ctmlg p_ctmcs"
CANTIDAD=`echo -e $LISTAPROC | wc -w`
	        verprocesos $LISTAPROC
	echo -e "Informe: \nSe controlaron ${CANTIDAD} procesos del ${USUARIO}, Hay ${CONTADOR} corriendo...\nEn caso de haber menos procesos, verifique la comunicacion en la GUI en unos minutos, \nsino conecta en unos minutos, bajelos y levantelos nuevamente.."
        #echo "Hay ${CONTADOR} procesos levantados de ${CANTIDAD} procesos controlados del usuario ${USUARIO}"
}

ca_procesos ()
{
verdb_ctrlm
if [ ${USER_CTM} = "ctmsrv7" ]
then
	export USER_CTM="ctmsrv7"
else
	echo "Este equipo tiene ControlM 6.2, No utiliza CA Configuration Agent"
	teclacontinuar
	exit
fi 
}


listaragectm()
{
#set -x
ARCH_TMP="/tmp/lista_ag_ctm.txt"
MENU_TMP="/tmp/menu_ag_ctm.txt"
>${ARCH_TMP}
>${MENU_TMP}			 

su - ${USER_CTM} -c "${PATH_CTM_EXE}/ctm_agstat -list \"*\"" | grep '^Agent ' | cut -d' ' -f2 >${ARCH_TMP}

if [ -s ${ARCH_TMP} ]  2>/dev/null
then
        echo -e "\t\t--------------------------------------------------------------------------------------------"
        echo -e "\t\t Lista de Agentes de CONTROLm creados en este servidor"
        echo -e "\t\t--------------------------------------------------------------------------------------------"
        LISTAR=`cat ${ARCH_TMP} | awk '{print sprintf("\t%02d)%s", NR , $1)}'`
        CANT_COL=2
        COUNT=1
                for LIST in ${LISTAR}
                do
                        if [ $COUNT = $CANT_COL ]
                        then
                                COUNT=1
                                echo -e "\t\t${LIST}\t\c"
                        else
                                COUNT=`expr $COUNT '+' 1`
                                echo -e "\t\t${LIST}\t\n"
                        fi
                done
        cat ${ARCH_TMP} | awk '{print sprintf("\t%02d)%s", NR , $1)}' >>${MENU_TMP}
fi

echo -e "\t\t--------------------------------------------------------------------------------------------"
echo -e "\t\tSeleccione el agente a actualizar.." 
echo -e "\t\t(Por ejemplo: 01, 02) o [s-S] Salir del Menu[s]:\c"
read AGE
echo -e "\t\t\t--------------------------------------------------------------------------------------------"

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
                        echo -e "\t\t Opcion incorrecta ${AGE}"
                        >${ARCH_TMP}
                        teclacontinuar
                        exit
                 fi
        else
                echo -e "\t\t Opcion incorrecta ${AGE}"
                >${ARCH_TMP}
                teclacontinuar
                exit
        fi
fi
}




###############################################################################
###                            Principal                                    ###
###############################################################################
#if [ $SUC -lt 100 ]
#then
#        SUC=0$SUC
#fi
case $OPERACION in
        UPSF)           titulo "Reiniciando procesos de Storeflow, aguarde por favor.."
			su - sfctrl -c "mata sfctrl"
			su - sfctrl -c "preipl" ; su - sfctrl -c "postipl"
			verprocesos_sf
                        ;;

        DOWNSF)        	titulo "Bajando procesos de Storeflow, aguarde por favor.." 
			su - sfctrl -c "mata sfctrl"
			verprocesos_sf
                        ;;
	
	VERSF)		titulo "Controlando procesos de Storeflow, aguarde por favor.."	
			verprocesos_sf
			;;

        UPVPR)         	titulo " Levantando procesos de Ventas por Reserva, quedan levantandose en background, \n Aguarde Por favor.. y controle luego si levantaron todos los procesos"
			su - vprctrl -c "ksh /vtareserva/daemon/sube_demonio.sh" &
			verprocesos_vpr
                        ;;
	
        DOWNVPR)        titulo " Bajando procesos de Ventas por Reserva, aguarde por favor.."
			su - vprctrl -c "ksh /vtareserva/daemon/baja_demonio.sh"
			verprocesos_vpr
                        ;;

	VERVPR)		titulo "Controlando procesos de Ventas por Reserva, aguarde por favor.."
			verprocesos_vpr
			;;

        UPAGCTRLM)      titulo " Levantando procesos del Agente de Control M, aguarde por favor.."
			ksh /home/ctmagt/ctm/scripts/start-ag -u ctmagt -p ALL
			verprocesos_agctrlm
			;;
        
	DOWNAGCTRLM)    titulo " Bajando procesos del Agente de Control M, aguarde por favor.."
			kill -9 `ps -ef | grep ctm | grep "p_ctmag" | grep -v grep | awk '{ print $2 }'`
			kill -9 `ps -ef | grep ctm | grep "p_ctmat" | grep -v grep | awk '{ print $2 }'`
			verprocesos_agctrlm
                        ;;

	VERAGCTRLM)	titulo " Controlando procesos del Agente de Control M, aguarde por favor.."
			verprocesos_agctrlm
			;;

        UPSRVCTRLM)     titulo " Levantando los procesos del Server de Control M, aguarde por favor.."
			verdb_ctrlm
			su - ${USER_CTM} -c "ksh ${PATH_CTM_SCR}/start_ctm"
			verprocesos_srvctrlm
                        ;;

        DOWNSRVCTRLM)   titulo " Bajando los procesos del Server de Control M, aguarde por favor.."
			verdb_ctrlm
			su - ${USER_CTM} -c "ksh ${PATH_CTM_SCR}/shut_ctm" 
			verprocesos_srvctrlm
                        ;;

	VERSRVCTRLM)	titulo " Controlando los procesos del Server de Control M, aguarde por favor.."
			verdb_ctrlm
			verprocesos_srvctrlm
			;; 
	UPPCHECKER)	titulo " Levantando procesos de Verificadores de Precios (priceDaemon_nquire.jar)" 
			ksh admproc_pchecker.sh UPPROC
			;; 

	UPCACTRLM)      titulo " Subir Conexion con el CCM , aguarde por favor.."
			ca_proceso
                        su - ctmsrv7 -c "shut_ca"
                        su - ctmsrv7 -c "start_ca"
                        ;;
        DOWNCACTRLM)    titulo " Bajando Conexion con el CCM , aguarde por favor.."
			ca_procesos
                        su - ctmsrv7 -c "shut_ca"
                        ;;
        VERCACTRLM)     titulo " Controlando Conexion con el CCM , aguarde por favor.."
			ca_procesos
                        su - ctmsrv7 -c "show_ca"
                        ;;

        UPAGINSTAL)     titulo "Levantado agentes creados de CONTROLM en el servidor"
			titulo "Verifique que queden en estado \"Available\""
			verdb_ctrlm ; listaragectm
                        echo "Actualizando el agente ${AGENTE}"
                        su - ${USER_CTM} -c "${PATH_CTM_EXE}/ctm_agstat -UPDATE ${AGENTE} AVAILABLE"
                        ;;

        DOWNAGINSTAL)   titulo "Bajando agentes creados de CONTROLM en el servidor"
			titulo "Verifique que queden en estado \"Disabled\""
                        verdb_ctrlm ; listaragectm
                        echo "Actualizando el agente ${AGENTE}"
                        su - ${USER_CTM} -c "${PATH_CTM_EXE}/ctm_agstat -UPDATE ${AGENTE} DISABLED"
                        ;;

        VERAGINSTAL)    titulo " Ver agentes de CONTROLM creados en el servidor"
                        verdb_ctrlm ; liGstaragectm
                        su - ${USER_CTM} -c "${PATH_CTM_EXE}/ctm_agstat -list \"*\" "
                        ;;

        DOWNPCHECKER)   titulo " Levantando procesos de Verificadores de Precios (priceDaemon_nquire.jar)"
			ksh admproc_pchecker.sh DOWNPROC
                        ;;

        VERPCHECKER)    titulo " Controlando los procesos de Verificadores de Precios (priceDaemon_nquire.jar)"
			ksh admproc_pchecker.sh VERPROC
                        ;;

         UPETIQSES)     titulo " Levantando procesos de Etiquetas SES (Etiquetas Electronicas)"
                        ksh admproc_etiquetas.sh UPPROC
                        ;;

         DOWNETIQSES)   titulo " Bajando procesos Etiquetas SES (Etiquetas Electronicas)"
                        ksh admproc_etiquetas.sh DOWNPROC
                        ;;

         VERETIQSES)    titulo " Controlando los procesos de Etiquetas SES (Etiquetas Electronicas)"
                        ksh admproc_etiquetas.sh VERPROC
                        ;;

        VERALLPROC)     clear ; titulo " Controlando Procesos, sfctrl, vprctrl, ctmagt, ctmsrv/x"
                        titulo " Controlando Procesos SFCTRL"
                        verprocesos_sf ; echo -e "\n\n"
                        titulo " Controlando Procesos VPRCTRL"
                        verprocesos_vpr ; echo -e "\n\n"
			titulo " Controlando Procesos pricechecker (Verificadores)"
			ksh admproc_pchecker.sh VERPROC ; echo -e "\n\n"
			titulo " Controlando los procesos de Etiquetas SES (Etiquetas Electronicas)"
                        ksh admproc_etiquetas.sh VERPROC ; echo -e "\n\n"
			titulo " Controlando Procesos CTMAGT"
                        verprocesos_agctrlm ; echo -e "\n\n"
                        titulo " Controlando Procesos CTMSRV/X"
                        verprocesos_srvctrlm ; echo -e "\n\n"
			titulo " Controlando Procesos CCM de CONTROLM que crean la conexion con EM02"
			ca_procesos
			su - ctmsrv7 -c "show_ca" ; echo -e "\n\n"
			titulo " Controlando los agentes de CONTROLM creados en este servidor"
			su - ${USER_CTM} -c "${PATH_CTM_EXE}/ctm_agstat -list \"*\" " ; echo -e "\n\n"
                        ;;

	UPALLPROCCTRLM) titulo " Levantando los procesos del Server de Control M, aguarde por favor.."
                        verdb_ctrlm
                        su - ${USER_CTM} -c "ksh ${PATH_CTM_SCR}/start_ctm"
                        verprocesos_srvctrlm
			titulo " Levantando procesos del Agente de Control M, aguarde por favor.."
                        ksh /home/ctmagt/ctm/scripts/start-ag -u ctmagt -p ALL
                        verprocesos_agctrlm
			titulo " Subir Conexion con el CCM , aguarde por favor.."
                        ca_procesos
                        su - ctmsrv7 -c "shut_ca"
                        su - ctmsrv7 -c "start_ca"
			titulo "Levantado agentes creados de CONTROLM en el servidor"
                        titulo "Verifique que queden en estado \"Available\""
                        verdb_ctrlm ; listaragectm
                        ;;

	DOWNALLPROCCTRLM) titulo " Bajando procesos del Agente de Control M, aguarde por favor.."
                        kill -9 `ps -ef | grep ctm | grep "p_ctmag" | grep -v grep | awk '{ print $2 }'`
                        kill -9 `ps -ef | grep ctm | grep "p_ctmat" | grep -v grep | awk '{ print $2 }'`
                        verprocesos_agctrlm
			titulo " Bajando los procesos del Server de Control M, aguarde por favor.."
                        verdb_ctrlm
                        su - ${USER_CTM} -c "ksh ${PATH_CTM_SCR}/shut_ctm"
                        verprocesos_srvctrlm
			titulo " Bajando Conexion con el CCM , aguarde por favor.."
                        ca_procesos
                        su - ctmsrv7 -c "shut_ca"
			;;

	VERALLPROCCTRLM) titulo " Controlando Procesos CTMAGT"
                        verprocesos_agctrlm ; echo -e "\n\n"
                        titulo " Controlando Procesos CTMSRV/X"
                        verprocesos_srvctrlm ; echo -e "\n\n"
			titulo " Controlando Procesos CCM de CONTROLM que crean la conexion con EM02"
                        ca_procesos
                        su - ctmsrv7 -c "show_ca" ; echo -e "\n\n"
                        titulo " Controlando los agentes de CONTROLM creados en este servidor"
                        su - ${USER_CTM} -c "${PATH_CTM_EXE}/ctm_agstat -list \"*\" " ; echo -e "\n\n"
                        ;;

        UPDEMONTICK) 	titulo " Levanta Proceso DEMONTIK"
                        ksh admproc_demotick.sh UPPROC
                        ;; 
        DOWNDEMONTICK)   titulo " Bajo Proceso DEMOTICK"
                        ksh admproc_demotick.sh DOWNPROC
                        ;;
        VERDEMONTICK)   titulo " Controla Proceso DEMONTIK"
                        ksh admproc_demotick.sh VERPROC          

esac
teclacontinuar
read
