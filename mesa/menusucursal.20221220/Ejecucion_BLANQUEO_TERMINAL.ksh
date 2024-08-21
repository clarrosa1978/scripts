#!/usr/bin/ksh
$SFSW_MENU/opcion_ELIGE_TERMINAL.ksh
CAJA=`echo $?`
actmini $CAJA
$SFSW_MENU/encabezado.ksh
echo ""
echo "\t\t\t Caja $CAJA Actualizada Correctamente"
echo ""
echo "\t\t\t\t <ENTER>-Continuar \c"
read nada
