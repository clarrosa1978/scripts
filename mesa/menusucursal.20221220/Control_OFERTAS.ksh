#!/usr/bin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: sfctrl                                                 #
# Objetivo...........: Mostrar las opciones disponibles de submenu            #
# Nombre del programa: submenu_SFCTRL.ksh                                     #
# Descripcion........: Proviene del menu principal de la opcion Sctrl         #
# Modificacion.......: 23/04/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################


###############################################################################
#                              Principal                                      #
###############################################################################

 $SFSW_MENU/encabezado.ksh 
 echo "\t\t ***  B u s c a d o r  d e  O f e r t a s   ***"
 echo ""
 echo "\t\t  Ingrese valor a buscar (<ENTER> todo) => \c"
 read opcion

 clear

 if [ $opcion"A" == "A" ]
 then
        more /sfctrl/d/cfgofer.dat
 else
	
	head -n2 /sfctrl/d/cfgofer.dat
	grep -i $opcion /sfctrl/d/cfgofer.dat
 fi
 echo ""
 echo "\t\t\t\t <ENTER>-Continuar \c"
 read nada
