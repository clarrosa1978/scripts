###############################################################################
# Autor..............:  C.A.S                                                 #
# Usuario ...........:  root                                                  #
# Objetivo...........:  Controlar las Interfaces del Batch GDM                #
# Nombre del programa:  CheckInterfaces.ksh                                   #
# Descripcion........:  Controla si llegaron las interfaces a las sucursales  #
#                       o al EQUIPO DE CENTRAL                                #
# Modificacion.......:  02/08/2002                                            #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador
OPERADOR_REP=$OPERADOR_WRK/reportes
OPERADOR_TMP=/tecnica/operador/tmp
A=`tput bold`
B=`tput rmso`
REPORTE=$OPERADOR_REP/${0%%.ksh}.`date +%Y%m%d`.rpt
DIR_REMOTO1=/u/usr/sucursal
DIR_REMOTO2=/temporal/inter
DIR_LOCAL=/home/mggdm/intcoto
ARCH_INT="ajucedegdm syf remvalauto tra devprov vencompe pvp sur movgdm cambios"

###############################################################################
#                                 Principal                                   #
###############################################################################

for DESTINO in `echo ${SUCURSAL:=$LISTASUC}`
do
 clear
 echo "\n\n\t      Reporte de Interfaces Sucursal $DESTINO `date +%d/%m/%Y`" \
 | tee -a $REPORTE
 echo "\t      ------- -- ---------- -------- --- ----------" \
 | tee -a $REPORTE
 rsh suc${DESTINO} \
 '(
    FECHA=`date +%Y%m%d`
    if [ -d '${DIR_REMOTO1}' ]
     then
     for i in `echo '${ARCH_INT}'`
     do
       if [ `find '$DIR_REMOTO1' | grep -c ${i}.'${DESTINO}'${FECHA}` -eq 0 ]
        then
         RESULTADO="### ERROR ###"
        else
         RESULTADO="### OK ###"
       fi
       printf "\t %-7s  %-9s %-10s %-3s %-12s %-3s \n" \
       "Archivo" "Interface" ${i} ${RESULTADO}
     done
    fi
 )' | tee -a $REPORTE
 echo "\n\t\t     Fin $DESTINO - <ENTER> - Continuar \c"
 read nada
done
