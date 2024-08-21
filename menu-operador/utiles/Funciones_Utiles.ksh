###############################################################################
# Autor..............:  C.A.S                                                 # 
# Usuario ...........:  root                                                  # 
# Objetivo...........:  Evitar codigo al divino Saddan                        # 
# Nombre del programa:  Funciones_Utiles.ksh                                  # 
# Descripcion........:  Chequea comunicacion y si las sucu abre el Domingo    # 
# Modificacion.......:  11/04/2003                                            # 
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

#-----------------------------------------------------------------------------#
#                         Funcion Comunicacion                                #
#-----------------------------------------------------------------------------#

function Comunicacion
{
ping -c 3 $1 >/dev/null 2>&1
if [ $? -ne 0 ]
 then
  return 1 
fi 
}


#-----------------------------------------------------------------------------#
#                        Funcion AbreDomingo                                  #
#-----------------------------------------------------------------------------#

function AbreDomingo
{
DOMINGO=`rsh $1 grep -w DOMINGO /tecnol/ntcierre/cierre.prm | grep -v PARM7 \
| awk -F"=" '{ print $2 }`
if [ -z "$DOMINGO" ]
 then 
  return 1 
 else
  if [ "$DOMINGO" = "YES" ]
   then
    return 0
   else 
    return 1 
  fi
fi
}
