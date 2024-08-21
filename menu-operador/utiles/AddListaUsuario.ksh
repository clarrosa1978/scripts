###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Agregar un usuario a la lista de mails                # 
# Nombre del programa:  AddListaUsuario.ksh                                   # 
# Descripcion........:  Modifica el archivo /etc/aliases                      # 
# Modificacion.......:  06/08/2002                                            # 
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
 echo "		        *** ${A} Alta de un usuario de Mails  ${B} *** "
 echo ""
 echo "\t Ingrese el nombre del usuario (username) ==> \c"
      read USERNAME 
 if [ "${USERNAME:=VACIO}" != "VACIO" ]
  then
   echo "\t Ingrese el nombre de la lista ==> \c "
           read LISTNAME
   if [ "${LISTNAME:=VACIO}" != "VACIO" ]
    then
     if [ `grep -wc $LISTNAME $ARCH_ALIAS` -eq 0 ]
      then
       echo "\n\t Error - No existe la LISTA $LISTNAME en $ARCH_ALIAS"
       echo "\t\t\t <ENTER> - Continuar \c"
       read nada
      else
       if [ `grep $LISTNAME $ARCH_ALIAS|grep -wc ${USERNAME}@${DOMINIO}` -gt 0 ]
        then
         echo "\n\t Warning- Ya existe el usuario $USERNAME en lista $LISTNAME"
         echo "\t\t\t <ENTER> - Continuar \c"
         read nada                
        else
         VAR_LISTA1=`grep $LISTNAME $ARCH_ALIAS | awk -F":" '{ print $1 }'`
         VAR_LISTA2=`grep $LISTNAME $ARCH_ALIAS | awk -F":" '{ print $2 }'`    
         grep -v "$VAR_LISTA1" $ARCH_ALIAS > ${ARCH_ALIAS}.new 
         echo "\n${VAR_LISTA1}: ${VAR_LISTA2}, ${USERNAME}@${DOMINIO}" \
         >> ${ARCH_ALIAS}.new
         mv ${ARCH_ALIAS}.new ${ARCH_ALIAS}
         if [ $? -ne 0 ]
          then 
           echo "\t Error - Al intentar renombrar el archivo ${ARCH_ALIAS}"
           echo "\t\t\t <ENTER> - Continuar \c"
           read nada
          else
           echo "\t Se agrego el USUARIO $USERNAME a la LISTA $LISTNAME" 
           echo "\t\t\t <ENTER> - Continuar \c"
           read nada
         fi
       fi
     fi
    else
     break
   fi
  else
   break
 fi
done
