#!/usr/bin/ksh
###########################################################################################
#NOMBRE DEL SCRIPT: DesactivarColas.sh                                                    #
#DESCRIPCION: Desactiva una cola de impresion seleccionada de una sucursal                #
#AUTOR: CFL                                                                               #
#FECHA DE MODIFICACION: 24-01-2002                                                        #
###########################################################################################

###########################################################################################
#                                     FUNCIONES                                           #
###########################################################################################

function PTecla {
         echo "\n\n\n\n\n\tPresione una tecla para continuar \c"
         read Opc
}
typeset -fx PTecla

###########################################################################################
#                                     PRINCIPAL                                           #
###########################################################################################
clear
echo "\n\n\n\n\n"
mandalarma.sh "Desactivando $ColaImpCent en $Nodo"
echo "\tDesactivando cola de impresion $ColaImpCent"
rsh $Nodo qadm -K $ColaImpCent
if [ $? -eq 0 ]
then
    echo "\n\tDesactivación completa"
    echo "\tVerificando:"
    rsh $Nodo lpstat -a$ColaImpCent
else
    echo "\n\tError desactivando cola de impresion $ColaImpCent"
    mandalarma.sh "Error desactivando la cola $ColaImpCent"
fi
PTecla
