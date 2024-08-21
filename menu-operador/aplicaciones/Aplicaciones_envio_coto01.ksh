#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Enviar el archivo coto01.dat y el coto.dat.idx a pucara#
# Nombre del programa: Aplicaciones_envio_negtick.ksh                         #
# Descripcion........: Envia los archivos por medio de un rcp                 #
# Modificacion.......: 23/07/2001                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

#set -x
ACDATOS=/ac/DATOS
COPIAS=/copias
BALANCE=/u/usr/balance
HOST_REMOTO=pucara


###############################################################################
#                              Funciones                                      #
###############################################################################

###############################################################################
#                              Principal                                      #
###############################################################################

ping -c3 pucara 2>&1 >/dev/null 
if [ $? -ne 0 ]
   then 
    $OPERADOR_WRK/encabezado.ksh
    echo " Error - No hay comunicacion con el servidor destino"
    echo " Precione cualquier tecla para Continuar "
    read nada
    exit
   else
    if [ -f $ACDATOS/coto01.dat -a -f $ACDATOS/coto01.dat.idx ]
       then 
        $OPERADOR_WRK/encabezado.ksh
        tar -cf $COPIAS/COTO01.TMP $ACDATOS/coto01.dat $ACDATOS/coto01.dat.idx
        if [ $? -ne 0 ]
         then 
          echo "Error - No pudo copiar los archivos al $COPIAS"
         else 
          
        
           
       else 
        $OPERADOR_WRK/encabezado.ksh
        echo " Error - No existe los archivos coto01"
        echo " Precione cualquier tecla para Continuar "
        read nada
        exit
    fi
fi
    


###############################################################################
#                                 Fin                                         #
###############################################################################

