#!/usr/bin/ksh
$SFSW_MENU/encabezado.ksh 
 echo "\t\t ***  P e r f o r m a n c e  T e r m i n a l e s  *** "
 echo""
/sfctrl/bin/monmovs|more
echo ""
echo "\t Presione <ENTER> para continuar\c";read a
