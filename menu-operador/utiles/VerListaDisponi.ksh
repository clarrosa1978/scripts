###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Mostrar las listas disponibles de usuarios            # 
# Nombre del programa:  VerListaDisponi.ksh                                   # 
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

###############################################################################
#                              Principal                                      #
###############################################################################

$OPERADOR_WRK/encabezado.ksh $0

cat $ARCH_ALIAS |grep -v "#" |grep -v "^$" |awk -F ":" '{ print $1 }' |more -d 
