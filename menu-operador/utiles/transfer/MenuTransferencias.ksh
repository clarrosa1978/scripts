###############################################################################
#                        Definicion de variables                              #
###############################################################################

export OPERADOR_TRANS=$OPERADOR_UTL/transfer
export AX=`tput bold`
export BX=`tput rmso`
export CX=`tput smso`

###############################################################################
#                              Principal                                      #
###############################################################################

while true 
do 
 $OPERADOR_WRK/encabezado.ksh
 echo "\t                       *** ${AX}Menu de Transferencias${BX} ***        "
 echo ""
 echo "\t            1. - Transferencias entre Servidores              " 
 echo ""
 echo "\t            2. - Transferencia de Interfaces GDM a Sucursales " 
 echo ""
 echo "\t            3. - Transferencia de CTLs comprimidas            " 
 echo ""
 echo "\t            4. - Transferencia de archivo: WFTR01             " 
 echo ""
 echo "\t            s. - Salir del Menu                               " 
 echo ""
 echo " Ingrese su opcion : \c                                       " 
 read opcion
 case $opcion in 
     1)  $OPERADOR_TRANS/Transfer_pprod.ksh      
         ;; 
     2)  #$OPERADOR_TRANS/Envia-interfaces-gdm.ksh
         ;; 
     3)  $OPERADOR_TRANS/Transfer_CTLs.ksh 
         ;; 
     4)  $OPERADOR_TRANS/envio_wftr01.ksh
         ;; 
     S|s)  clear
         exit
         ;; 
     *)  $OPERADOR_WRK/Incorrecta.ksh
         ;; 
 esac
done
