#!/usr/bin/ksh
###############################################################################
# Autor..............:                                                        #
# Usuario ...........: root                                                   #
# Objetivo...........: Muestra e imprime las secuencias del día actual         #
# Nombre del programa: Secuencia_Bkp_Central.ksh                              #
# Descripcion........:                                                        #
# Modificacion.......: 01/07/2002                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################
DIA=`date +%d`
MES=`date +%m`
ANIO=`date +%Y`
INFORME=$OPERADOR_UTL/Sec_Bkp_Central.$DIA$MES$ANIO.lst
COLA=ctec00

###############################################################################
#                              Principal                                      #
###############################################################################
clear
echo "\nSecuencias del dia $DIA/$MES/$ANIO para servidores de Central\n" 
echo " SAP1 (brarchive)   -->  ""\c"
LISTA="`ssh sap1 su - prdadm -c 'brarchive -q -u /' 2>/dev/null |grep PRDA`"
echo $LISTA| awk '{print $8 }' 
echo " SAP1 (brbackup)    -->  ""\c" 
LISTA="`ssh sap1 'su - prdadm -c 'brbackup -p initPRDBACK.sap -q -u /' 2>/dev/null |grep PRDB`"
echo $LISTA| awk '{print $8 }' 
echo "\n\t\tPresione una tecla para continuar\c"
read TECLA
