#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_UtilesVarios.ksh                                  #
# Descripcion........: Muestra un menu con utiles varios                      #
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#			 Definicion de variables                              #
###############################################################################

NOMB_PROG=`basename $0 | awk -F "_" '{ print $2 }'`
NAME_PROG=${NOMB_PROG%%.ksh}

###############################################################################
#			       Principal                                      #
###############################################################################
        
while true 
do
 $OPERADOR_WRK/encabezado.ksh
 echo "\t                       *** Menu $NAME_PROG ***                    "
 echo ""
 echo "\t  1. - Transferencias de archivos	        2. - Secuencias Backup Central"
 echo ""
 echo "\t  3. - Fixed smit para impresora		4. - Administrar Lista Mail   " 
 echo ""
 echo "\t  5. - Transfer VtaPlu al Odin			6. - Reporte Bines " 
 echo ""
 echo "\t  7. - Listar Impresoras por Ip			8. - Cargar Bines Manual "
 echo ""	
 echo "\t  9. - Chequear DBLINKS				10. - Centrales Telefonicas "
 echo ""
 echo "\t  11. - Impr. de Listados de Cierre Suc.	s. - Salir del Menu                "
 echo ""
 echo " Ingrese su opcion : \c                                             " 
 read opcion
 case $opcion in 
     1)  $OPERADOR_TRANS/MenuTransferencias.ksh
         ;;
     2)  ksh  $OPERADOR_UTL/Secuencia_Bkp_Central.ksh
         ;;
     3)  #$OPERADOR_UTL/COLAS_ODM.SH
         ;;
     4)  $OPERADOR_UTL/UtilesVarios_ListaMail.ksh
         ;;
     5)  $OPERADOR_UTL/TransferVtaplu.ksh
         while true
          do
           $OPERADOR_WRK/encabezado.ksh
           echo "Ver log de Trasferencia (S/N) \c"
           read RESPUESTA
           case $RESPUESTA in 
             S|s) if [ ! -s $OPERADOR_TMP/trf_vtaplu.log ] 
                   then 
                    echo " No existe log de transferencia" 
                    echo " <ENTER> - Continuar"
                    read nada
                   else
                    more -d $OPERADOR_TMP/trf_vtaplu.log
                  fi
                  break
                  ;;
             N|n) break
                  ;;
               *) $OPERADOR_WRK/Incorrecta.ksh
                  ;;
           esac
          done
         ;;
     6) $OPERADOR_UTL/UtilesVarios_Bines.ksh
         ;;
     7)  $OPERADOR_UTL/UtilesVarios_ImpresoraIp.ksh
         ;;
     8)  $OPERADOR_UTL/UtilesVarios_CargarBines.ksh
         ;; 
     9)  $OPERADOR_UTL/UtilesVarios_ChequeaDblink.ksh
         ;; 
     10) $OPERADOR_UTL/adm_CentralTelefonica.ksh
         ;; 
     11) $OPERADOR_UTL/UtilesVarios_MenuImprList.ksh
	 ;;
     S|s)clear
         exit
         ;; 
     *)  $OPERADOR_WRK/Incorrecta.ksh 
         ;;
 esac
done
