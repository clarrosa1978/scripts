###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Borrar un usuario de la lista de mails                # 
# Nombre del programa:  DelListaUsuario.ksh                                   # 
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
 echo "		      *** ${A} Quitar un usuario de una Lista ${B} *** "
 echo ""
 echo "\t Ingrese el nombre del usuario (username) ==> \c"
      read USERNAME 
 if [ "${USERNAME:=VACIO}" != "VACIO" ]
  then
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
       if [ `grep $LISTNAME $ARCH_ALIAS|grep -wc ${USERNAME}@${DOMINIO}` -eq 0 ]
        then
         echo "\n\t Warning- El usuario $USERNAME NO EXISTE en lista $LISTNAME"
         echo "\t\t\t <ENTER> - Continuar \c"
         read nada
        else
         VAR_LISTA1=`grep $LISTNAME $ARCH_ALIAS | awk -F":" '{ print $1 }'`
         VAR_LISTA2=`grep $LISTNAME $ARCH_ALIAS | awk -F":" '{ print $2 }'`
         grep -v "$VAR_LISTA1" $ARCH_ALIAS > ${ARCH_ALIAS}.new
         QUITAR_USER=`echo ${USERNAME}@${DOMINIO},`
         if [ `grep -wc $QUITAR_USER $ARCH_ALIAS` -eq 0 ]
          then
           VAR_LISTA3=`echo $VAR_LISTA2 | sed s/${USERNAME}@${DOMINIO}//g`
           ULTIMO=`echo $VAR_LISTA3 | awk '{ print $NF }'`
           if [ `echo $ULTIMO |grep -c ","` -gt 0 ]
            then
             SINCOMA=`echo $ULTIMO | sed s/,//g`
             VAR_LISTA4=`echo $VAR_LISTA3 | sed s/$ULTIMO/$SINCOMA/g`
             VAR_LISTA3=$VAR_LISTA4 
           fi
          else
           VAR_LISTA3=`echo $VAR_LISTA2 | sed s/${USERNAME}@${DOMINIO},//g`
         fi
         echo "\n${VAR_LISTA1}: $VAR_LISTA3" >> ${ARCH_ALIAS}.new
         mv ${ARCH_ALIAS}.new ${ARCH_ALIAS}
         if [ $? -ne 0 ]
          then 
           echo "\t Error - Al intentar renombrar el archivo ${ARCH_ALIAS}"
           echo "\t\t\t <ENTER> - Continuar \c"
           read nada
          else
           echo "\t Se quito el USUARIO $USERNAME de la LISTA $LISTNAME" 
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
