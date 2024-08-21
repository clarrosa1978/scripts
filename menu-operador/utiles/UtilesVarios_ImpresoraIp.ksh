#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Listar los colas de impresion con su numero de IP      #
# Nombre del programa: menu_Aplicaciones.ksh                                  #
# Descripcion........: Chequea por medio del comando host la direccion IP     #
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#                      Definicion de Funciones                                #
###############################################################################

#-----------------------------------------------------------------------------#
#                    Inicio de funcion comunicacion                           #
#-----------------------------------------------------------------------------#

function comunicacion
{ 
ping -c 1 $1 2>&1 >/dev/null
if [ $? -ne 0 ]
 then 
  return 1
fi
}

#-----------------------------------------------------------------------------#
#                     Fin de funcion comunicacion                             #
#-----------------------------------------------------------------------------#

###############################################################################
#                             Principal                                       #
###############################################################################

$OPERADOR_WRK/encabezado.ksh

echo "Ingrese el numero de sucursal ==> \c"
read SUCURSAL
if [ ! -z "$SUCURSAL" ]
 then
  for i in $SUCURSAL
   do 
    comunicacion suc$i
    if [ $? -eq 0 ]
     then
      rsh suc$i '(  for i in `lsallq`
                     do
                      echo " \t\t\t `host ${i}`" 
                      if [ $? -ne 0 ]
                       then 
	                echo " \t\t\t `host ${i}.coto.com.ar`"
                       else 
                        echo "\t\t\t ${i} Conectado en Forma Remota (lpd)" 
                      fi
                     done
                 )' 2>/dev/null
    fi
   done
fi

echo "\t\t\t <ENTER> - Volver al Menu Anterior \c"
read nada
