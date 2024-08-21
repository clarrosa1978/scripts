#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Monitorear los demonios de ventas por reservas en SUCS #
# Nombre del programa: menu_Operador.ksh                                      #
# Descripcion........: Monitoreas los procesos en forma remota                #
# Modificacion.......: 08/02/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

LISTAMAIL="operadoresUX@coto.com.ar;hprofitos@coto.com.ar;crsoria@coto.com.ar;cburhardt@coto.com.ar"

###############################################################################
#                              Principal                                      #
###############################################################################
while true
do
 /tecnica/operador/encabezado.ksh
 for i in `echo $LISTASUC`
 do
 if [ $i -ne 45 -a $i -ne 78 -a $i -ne 90 -a $i -ne 51 -a $i -ne 56 -a $i -ne 60 -a $i -ne 61 -a $i -ne 63 -a $i -ne 64 -a $i -ne 65 ]
  then 
  rsh suc$i '( lsuser vprctrl
               if [ $? -eq 0 ]
                then
                 if [ `ps -fu vprctrl | grep ELE | wc -l` -eq 0 ]
                  then
                   echo "\t\t WARNING !!! EL DEMONIO ESTA BAJO EN suc'${i}' !!!"
          mhmail "operadoresUX@coto.com.ar,hprofitos@coto.com.ar,crsoria@coto.com.ar,cburhardt@coto.com.ar,tpaz@coto.com.ar" \
                   -subject "DEMONIO SUC$i ESTA BAJO!!!!!!"  \
                   -body "`date +%A:%H:%M:%S` EL DEMONIO SUC'${i}' ESTA BAJO"
                    read nada
                  else
                   echo "\t\t ** suc'${i}' EL DEMONIO SE ENCUENTRA CORRIENDO !!"
                 fi
               fi
            )' 2> /dev/null |grep -v vprctrl
  if [ "suc$i" = "suc85" ]
   then 
    sleep 2
    /tecnica/operador/encabezado.ksh
  fi
 fi
 done
done
