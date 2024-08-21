###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Mostrar las listas disponibles de usuarios            # 
# Nombre del programa:  VerListaUsuario.ksh                                   # 
# Descripcion........:  Modifica el archivo /etc/aliases                      # 
# Modificacion.......:  10/08/2002                                            # 
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador
ARCH_ALIAS=/home/root/prueba.txt
DOMINIO="coto.com.ar"
A=`tput bold`
B=`tput rmso`
LINEAS=1
CANT_LINEAS=10

###############################################################################
#                              Principal                                      #
###############################################################################

$OPERADOR_WRK/encabezado.ksh $0

cat $ARCH_ALIAS | grep -v "#" | grep -v "^$" |more -d 
