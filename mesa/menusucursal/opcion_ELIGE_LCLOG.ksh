#!/usr/bin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: sfctrl                                                 #
# Objetivo...........: Mostrar las opciones disponibles de submenu            #
# Nombre del programa: submenu_SFCTRL.ksh                                     #
# Descripcion........: Proviene del menu principal de la opcion Sctrl         #
# Modificacion.......: 23/04/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################


###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $SFSW_MENU/encabezado.ksh 
 echo -e "\t\t ***  S e l e c c i o n e  N r o  d e  C a j a  ***"
 echo -e ""
 echo -e "\t\t  Ingrese Nro. de Caja en 3 Digitos \n\t\t\t (<ENTER> para todas) => \c"
 read opcion

 LISTA_CAJAS=`ls /sfctrl/l/load???.dat | cut -f1 -d"."  | cut -f2 -d"d"`

 if [ $opcion"A" == "A" ]
 then
        $SFSW_MENU/BuscarUltimoLog.ksh lclog /sfctrl/l
 else

        for caja in $LISTA_CAJAS
        do
                if [ $caja == $opcion ] 
                then
                        tail -900f /sfctrl/l/lclog | grep " "$caja" "
                        #return  $caja
                        #exit {CAJA:$caja}
                fi
        done
 fi
 echo -e ""
 echo -e "\t\t\t\t Opcion Incorrecta"
 echo -e "\t\t\t\t <ENTER>-Continuar \c"
 read nada
done