##############################################################################
# Autor..............:  TECNOLOGIA                                           # 
# Usuario ...........:  root                                                 # 
# Objetivo...........:  Mostrar un menu                                      # 
# Nombre del programa:  Ejemplo.ksh                                          # 
# Descripcion........:  Scripts de ejemplo                                   # 
# Modificacion.......:  02/07/2002                                           # 
##############################################################################



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
echo "		    *** ${A} Menu Principal  ${B} *** "
echo ""
echo "			 1. Dar de alta un usuario"
echo "			 2. Baja de Usuario"
echo "			 3. Modificacion de Usuario"
echo ""
echo "		            s. - Salir del Menu                  "
echo ""
echo "	  Ingrese su opcion ==> \c                         "
read opcion
case $opcion in
		  1) echo ""   
		                ;; 
		  2) echo ""   
		                ;; 
		  3) echo ""   
		                ;; 
		  4) echo ""   
		                ;; 
		  5) echo ""   
		                ;; 
		  S|s) break   
		           ;;    
esac
done
