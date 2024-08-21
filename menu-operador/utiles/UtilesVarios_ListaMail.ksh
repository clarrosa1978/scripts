###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Mantener la LISTA de mail en todos los equipos Unix   # 
# Nombre del programa:  UtilesVarios_ListaMail.ksh                            # 
# Descripcion........:  Replica el archivo /etc/aliases en los equipos        # 
# Modificacion.......:  31/07/2002                                            # 
###############################################################################



###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador
A=`tput bold`
B=`tput rmso`



###############################################################################
#                              Principal                                      #
###############################################################################

while true
do
$OPERADOR_WRK/encabezado.ksh  $0
echo "		        *** ${A} Administracion de Mails  ${B} *** "
echo ""
echo "			 1. Alta de usuario en una LISTA        "
echo "			 2. Baja de usuario de una LISTA        "
echo "			 3. Baja de una LISTA de usuarios       "
echo "			 4. Alta de una LISTA de usuarios       "
echo "			 5. Ver usuarios por LISTA              "
echo "			 6. Ver LISTA disponibles               "
echo "			 7. Replicar LISTA en equipos           "
echo ""
echo "		            s. - Salir del Menu                 "
echo ""
echo "	  Ingrese su opcion ==> \c                        "
read opcion
case $opcion in
     1) $OPERADOR_UTL/AddListaUsuario.ksh 
		                ;;
     2) $OPERADOR_UTL/DelListaUsuario.ksh
		                ;;
     3) $OPERADOR_UTL/DelLista.ksh
		                ;;
     4) $OPERADOR_UTL/AddLista.ksh
		                ;;
     5) $OPERADOR_UTL/VerListaUsuario.ksh
		                ;;
     6) $OPERADOR_UTL/VerListaDisponi.ksh
		                ;;
     7) $OPERADOR_UTL/ReplicarListas.ksh
		                ;;
   S|s) break
                                ;;
esac
done
