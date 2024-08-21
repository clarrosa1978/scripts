###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Borrar una Lita del archivo /etc/aliases              # 
# Nombre del programa:  DelLista.ksh                                          # 
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
 echo "\t *** ${A} Eliminar un Alias de la Lista de Distribucion ${B} *** "
 echo ""
 echo "\t Ingrese el nombre de la lista ==> \c "
           read LISTNAME
 if [ "${LISTNAME:=VACIO}" != "VACIO" ]
  then
   if [ `grep -wc "${LISTNAME}:" $ARCH_ALIAS` -eq 0 ]
    then
     echo "\n\t Error - No existe la LISTA $LISTNAME en $ARCH_ALIAS"
     echo "\t\t\t <ENTER> - Continuar \c"
     read nada
    else
     grep -v $LISTNAME $ARCH_ALIAS > ${ARCH_ALIAS}.new
     if [ $? -ne 0 ]
      then 
       echo "Error - No pudo generar el archivo ${ARCH_ALIAS}.new"
       echo "\t\t\t <ENTER> - Continuar \c"
       read nada
      else
       mv ${ARCH_ALIAS}.new $ARCH_ALIAS
       if [ $? -ne 0 ]
        then 
         echo "\t Error - Al intentar renombrar el archivo ${ARCH_ALIAS}"
         echo "\t\t\t <ENTER> - Continuar \c"
         read nada
        else
         echo "\t Se Elimino la LISTA $LISTNAME" 
         echo "\t\t\t <ENTER> - Continuar \c"
         read nada
       fi
     fi
   fi
  else 
   break
 fi
done
