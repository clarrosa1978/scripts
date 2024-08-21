#!/usr/bin/ksh
$SFSW_MENU/opcion_ELIGE_TERMINAL.ksh
CAJA=`echo -e $?`
actmini $CAJA
$SFSW_MENU/encabezado.ksh
echo -e ""
echo -e "\t\t\t Caja $CAJA Actualizada Correctamente"
echo -e ""
echo -e "\t\t\t\t <ENTER>-Continuar \c"
read nada
