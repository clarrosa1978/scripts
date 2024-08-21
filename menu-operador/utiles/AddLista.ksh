###############################################################################
# Autor..............:  C.A.S                                                 #
# Usuario ...........:  root                                                  #
# Objetivo...........:  Agregar un Alias a la Lista                           #
# Nombre del programa:  AddLista.ksh                                          #
# Descripcion........:  Modifica el archivo /etc/aliases                      #
# Modificacion.......:  08/08/2002                                            #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador
ARCH_ALIAS=/home/root/prueba.txt
DOMINIO="coto.com.ar"
A=`tput bold`
B=`tput rmso`

###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
 $OPERADOR_WRK/encabezado.ksh  $0
 echo "		        *** ${A} Alta de un Alias a la LISTA  ${B} *** "
 echo ""
 echo "\t Ingrese el nombre de la lista ==> \c "
           read LISTNAME
 if [ "${LISTNAME:=VACIO}" != "VACIO" ]
  then
   if [ `grep -wc $LISTNAME $ARCH_ALIAS` -gt 0 ]
    then
     echo "\n\t Error - Ya existe la LISTA $LISTNAME en $ARCH_ALIAS"
     echo "\t\t\t <ENTER> - Continuar \c"
     read nada
    else
     while true
      do
       echo "\t Confirma que desea agregar el ALIAS $LISTNAME <S|N> ==> \c"
       read RTA
       case $RTA in
        S|s) echo "\n${LISTNAME}: " >> $ARCH_ALIAS
             if [ $? -ne 0 ]
              then
               echo "\t Error - El $ARCH_ALIAS no pudo ser actualizdo"
               echo "\t\t\t <ENTER> - Continuar \c"
               read nada
              else
               echo "\t Se agrego el Alias $LISTNAME en el $ARCH_ALIAS"
               echo "\t\t\t <ENTER> - Continuar \c"
               read nada
               break
             fi
             ;;
        N|n)  break
             ;;
          *) echo "\t Opcion Incorrecta"
             echo "\t\t\t <ENTER> - Continuar \c"
             read nada
             ;;
       esac
      done
   fi
  else
   break
 fi
done
