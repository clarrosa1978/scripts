###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Mantener la LISTA de mail en todos los equipos Unix   # 
# Nombre del programa:  ReplicaListaMail.ksh                                  # 
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
echo "			 7. Ver a que LISTA pertenece un usuario"
echo "			 8. Replicar LISTA en equipos           "
echo ""
echo "		            s. - Salir del Menu                 "
echo ""
echo "	  Ingrese su opcion ==> \c                              "
read opcion
case $opcion in
		  1) AddUsuarioLista.ksh
		                ;; 
		  2) DelUsuarioLista.ksh   
		                ;; 
		  3) DelListaUsuario.ksh   
		                ;; 
		  4) AddListaUsuario.ksh   
		                ;; 
		  5) SeeListaUsuario.ksh
		                ;; 
		  6) SeeListaDisponi.ksh
		                ;; 
		  7) FindUsuarioList.ksh
		                ;; 
		  8) ReplicarListas.ksh
		                ;; 
		  S|s) break   
		           ;;    
esac
done
