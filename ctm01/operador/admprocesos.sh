#!/bin/sh
exit 0
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
typeset -fu Borrar
typeset -fu Enviar_A_Log

titulo ()
{
MENSAJE=$1
echo -e "-------------------------------------------------------------------------------"
echo -e "$MENSAJE"
echo -e "-------------------------------------------------------------------------------"
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
export USUARIO="ctmsrv"
export LISTAPROC="p_ctmrt p_ctmsu p_ctmns p_ctmsl p_ctmwd p_ctmcd p_ctmco p_ctmtr p_ctmlg p_ctmcs"
CANTIDAD=`echo -e $LISTAPROC | wc -w`
	        verprocesos $LISTAPROC
	echo -e "Informe: \nSe controlaron ${CANTIDAD} procesos del ${USUARIO}, Hay ${CONTADOR} corriendo...\nEn caso de haber menos procesos, verifique la comunicacion en la GUI en unos minutos, \nsino conecta en unos minutos, bajelos y levantelos nuevamente.."
        #echo "Hay ${CONTADOR} procesos levantados de ${CANTIDAD} procesos controlados del usuario ${USUARIO}"
}



###############################################################################
###                            Principal                                    ###
###############################################################################
if [ $SUC -lt 100 ]
then
        SUC=0$SUC
fi
case $OPERACION in
        UPSF)           titulo "Levantando procesos de Storeflow, aguarde por favor.."
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

        UPAGCTRLM)      titulo " Levantando el Agente de Control M, aguarde por favor.."
			ksh /home/ctmagt/ctm/scripts/start-ag -u ctmagt -p ALL
			verprocesos_agctrlm
			;;
        
	DOWNAGCTRLM)    titulo " Bajando el Agente de Control M, aguarde por favor.."
			kill -9 `ps -ef | grep ctm | grep "p_ctmag" | grep -v grep | awk '{ print $2 }'`
			kill -9 `ps -ef | grep ctm | grep "p_ctmat" | grep -v grep | awk '{ print $2 }'`
			verprocesos_agctrlm
                        ;;

	VERAGCTRLM)	titulo " Controlando los procesos del Agente de Control M, aguarde por favor.."
			verprocesos_agctrlm
			;;

        UPSRVCTRLM)     titulo " Levantando el Server de Control M, aguarde por favor.."
			su - ctmsrv -c "ksh /home/ctm/server/ctm/scripts/start_ctm"
			verprocesos_srvctrlm
                        ;;

        DOWNSRVCTRLM)   titulo " Bajando los procesos del Server de Control M, aguarde por favor.."
			su - ctmsrv -c "ksh /home/ctm/server/ctm/scripts/shut_ctm" 
			verprocesos_srvctrlm
                        ;;

	VERSRVCTRLM)	titulo " Controlando los procesos del Server de Control M, aguarde por favor.."
			verprocesos_srvctrlm
			;; 

esac
echo -e "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
read
