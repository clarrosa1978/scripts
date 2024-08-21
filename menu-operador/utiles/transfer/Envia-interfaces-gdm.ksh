###########################################################################################
#NOMBRE DEL SCRIPT: envia-interfaces-gdm.sh                                               #
#DESCRIPCION: Envia las interfaces de GDM generadas en el SP17 a una sucursal determinada #
#AUTOR: CFL                                                                               #
#FECHA DE MODIFICACION: 19-07-2002                                                        #
###########################################################################################

###########################################################################################
#                                     VARIABLES                                           #    
###########################################################################################
DirDestCent=/temporal/inter
DirOrig=/home/mggdm/intcoto
#DirDestSuc=/backup
DirDestSuc=/u/usr/sucursal


###########################################################################################
#                                     FUNCIONES                                           #
###########################################################################################

function PTecla {
         echo "\n\n\n\n\n\tPresione una tecla para continuar \c"
         read Opc
}

function Opcion {
         clear
         MenuPrin
         echo "\tIngrese una opcion: \c"
         read Opc
}

function OpcionInx {
         clear
         echo "\n\n\n\n\n\n\n\n\n\n\n"
         echo "\t                             ************************"
         echo "\t                             *  OPCIÓN INEXISTENTE  *"
         echo "\t                             ************************"
         echo "\n\n\n\n\n"
         PTecla
}

function Titulo {
         echo "\n\t#########################################################################################"
         echo "\t#                       TRANSFERENCIA DE INTERFACES DE GDM                              #"
         echo "\t#########################################################################################"
}

function MenuPrin {
         Titulo
	 echo "\t#########################################################################################"
         echo "\t#                                                                                       #"
	 echo "\t#      1)  Ajuste de CEDECO                                                             #"
	 echo "\t#      2)  Sobrantes y faltantes                                                        #"
	 echo "\t#      3)  Remitos valorizados                                                          #"
	 echo "\t#      4)  Traspasos                                                                    #"
	 echo "\t#      5)  Devoluciones a proveedor                                                     #"
	 echo "\t#      6)  Movimientos compensatorios                                                   #"
	 echo "\t#      7)  Pvp                                                                          #"
	 echo "\t#      8)  Surtidos                                                                     #"
	 echo "\t#      9)  Decomisos / Devoluciones                                                     #"
         echo "\t#      10) Cambios                                                                        #"
         echo "\t#      11) Ingresar otra fecha                                                          #"
	 echo "\t#      12) Ingresar otra sucursal                                                       #"
	 echo "\t#      99)  Salida                                                                      #"
	 echo "\t#                                                                                       #"
	 echo "\t#########################################################################################\n"
}
	 
function IngFech {
	 clear
  	 echo "\n\n\n\n\tIngrese el dia de la interface: \c"
         read Dia
         echo "\tIngrese el mes de la interface: \c"
         read Mes
         export Dia Mes
}

function IngSuc {
	 echo "\n\n\tIngrese la sucursal (XX para sucursales menores a 100):\c"
         read Nrosuc
         if [ "$Nrosuc" -lt "100" ]
         then
            Nrosuc3d=0$Nrosuc
         else
	    Nrosuc3d=$Nrosuc
         fi
}

function ChkCom {
    ping -c2 suc$Nrosuc >/dev/null 2>/dev/null
    if [ $? != 0 ]
    then
        clear
        echo "\n\n\n\n\n\n\n\n\n\n\n"
        echo "\t                             *******************************"
        echo "\t                             *  PROBLEMAS DE COMUNICACION  *"
        echo "\t                             *      INTENTE MAS TARDE      *"
        echo "\t                             *******************************"
        echo "\n\n\n\n\n"
        PTecla
        exit
    else
        Esta=`rsh sp17 \
        '(if [ ! -s '$DirOrig'/'$1'/'$2' ]
        then
            echo "Error"
        else
            echo "Ok"
        fi
        )'` 
        if [ "$Esta" = "Error" ]
        then
            clear
            echo "\n\n\n\n\n\n\n\n\n\n\n"
            echo "\t                             *************************"
            echo "\t                             *  ARCHIVO INEXISTENTE  *"
	    echo "\t                             *    O TIENE TAMAÑO 0   *"
            echo "\t                             *************************"
            echo "\n\n\n\n\n"
	else
		Transmitir $Dir $Arch 
        fi
    fi
    PTecla
}
          
function Transmitir {
	 clear
         echo "\n\n\n\tComienza trasmision al amscentral"
	 rcp sp17:/$DirOrig/$1/$2 $DirDestCent
         echo "\n\tFinaliza transmision al amscentral"
         echo "\n\n\n\tComienza transmision de $2 a la sucursal"
         rcp $DirDestCent/$2 suc$Nrosuc:/$DirDestSuc
	 if [ $? = 0 ]
	 then
		echo "\n\tFinaliza transmision a la sucursal"
         	rm $DirDestCent/$2
         	echo "\n\tCambiando permisos, dueño y grupo al archivo"
         	rsh suc$Nrosuc chmod 660 $DirDestSuc/$2
         	rsh suc$Nrosuc chown contable.group $DirDestSuc/$2
	 else
		echo "\n\tError en transmision a la sucursal"
	 fi
}

function TransmitirDat {
         clear
         echo "\n\n\n\tComienza trasmision al amscentral"
         rcp sp17:/$DirOrig/$1/$2 $DirDestCent
         echo "\n\tFinaliza transmision al amscentral"
         echo "\n\n\n\tComienza transmision de $2.dat a la sucursal"
         rcp $DirDestCent/$2 suc$Nrosuc:/$DirDestSuc/$2.dat
	 if [ $? = 0 ]
         then
                echo "\n\tFinaliza transmision a la sucursal"
                rm $DirDestCent/$2
                echo "\n\tCambiando permisos, dueño y grupo al archivo"
                rsh suc$Nrosuc chmod 660 $DirDestSuc/$2.dat
                rsh suc$Nrosuc chown contable.group $DirDestSuc/$2.dat
         else
                echo "\n\tError en transmision a la sucursal"
         fi
}

 	 
###########################################################################################
#                                     PRINCIPAL                                           #
###########################################################################################

set -x
IngFech
IngSuc
while true
do
  Opcion
  if [ "$Opc" -gt "0" -a "$Opc" -lt "13" -o "$Opc" -eq "99" ] 
  then
      case "$Opc" in
	  1) Arch=ajucedegdm.$Nrosuc3d`date +%Y`$Mes$Dia
	     Dir=ajucedegdm
	     ChkCom $Dir $Arch  ;;
          2) Arch=syf.$Nrosuc3d`date +%Y`$Mes$Dia 
	     Dir=syf
	     ChkCom $Dir $Arch ;;
	  3) Arch=remvalauto.$Nrosuc3d`date +%Y`$Mes$Dia
	     Dir=remito
	     ChkCom $Dir $Arch  ;;
	  4) Arch=tra.$Nrosuc3d`date +%Y`$Mes$Dia
	     Dir=traspasos
             ChkCom $Dir $Arch ;;
          5) Arch=devprov.$Nrosuc3d`date +%Y`$Mes$Dia
	     Dir=devoluciones
             ChkCom $Dir $Arch  ;;
	  6) Arch=vencompe.$Nrosuc3d`date +%Y`$Mes$Dia
             Dir=vencompe
             ChkCom $Dir $Arch ;;
	  7) Arch=pvp.$Nrosuc3d`date +%Y`$Mes$Dia
             Dir=pvp
             ChkCom $Dir $Arch ;;
	  8) Arch=sur.$Nrosuc3d`date +%Y`$Mes$Dia
             Dir=surtidos
             ChkCom $Dir $Arch ;;
	  9) Arch=movgdm$Nrosuc3d$Mes$Dia.dat
             Dir=sucursales
             ChkCom $Dir $Arch ;;
	  10) Arch=cambios.$Nrosuc3d$Mes$Dia
              Dir=cambios
              ChkCom $Dir $Arch  ;;
          11) IngFech     ;;
	  12) IngSuc	  ;;
          99) exit	  ;;
      esac
  else
      OpcionInx
  fi
done
