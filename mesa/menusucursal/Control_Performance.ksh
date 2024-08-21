#!/usr/bin/ksh
$SFSW_MENU/encabezado.ksh 
 echo -e "\t\t ***  P e r f o r m a n c e  T e r m i n a l e s  *** "
 echo -e""
/sfctrl/bin/monmovs|more
echo -e ""
echo -e "\t Presione <ENTER> para continuar\c";read a
