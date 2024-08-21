#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Descomprimir los archivos en el equipo remoto          #
# Nombre del programa: Aplicaciones_remoto_cedeco.ksh                         #
# Descripcion........: Descomprime los archivos por medio de un rsh           #
# Modificacion.......: 04/09/2001                                             #
###############################################################################

#set -x

###############################################################################
#                        Definicion de variables                              #
###############################################################################

DIR_REMOTO=$1
HOST_REMOTO=pucara
RC=0

###############################################################################
#                              Principal                                      #
###############################################################################

$OPERADOR_WRK/encabezado.ksh
echo "Inicio de proceso $0"
echo "Comprobando comunicacion con $HOST_REMOTO"
ping -c 3 $HOST_REMOTO 2>/dev/null 1>/dev/null
if [ $? -ne 0 ] 
 then 
  RC=10
  echo "Error $RC - No existe comunicacion con $HOST_REMOTO"
  echo "<ENTER> - Para continuar"
  read nada
 else
  rsh $HOST_REMOTO \
  '( if [ ! -f '$DIR_REMOTO'/coto.zip ]
      then 
       echo "Error - No existe el archivo coto.zip"
      else
       echo "Ok - El archivo existe"
     fi
  )' | if [ `grep -ic Error` -eq 1 ]
        then 
         RC=20
         echo "Error $RC - No existe el archivo coto.zip en $HOST_REMOTO" 
         echo "Error $RC - Asegurese de haber corrido el paso anterior" 
         echo "Abortando proceso"
         echo "<ENTER> - Para continuar"
         read nada
         exit  $RC
        else
         echo "Avisar que se va a descomprimir el archivo coto.zip" 
         echo "<ENTER> - Para continuar"
         read nada
         #while true 
         # do
           #echo "Matar los usuarios d09|d08|d04"
           #echo "Confirma (S/N)"
           #read respuesta
           #case $respuesta in
           #     S|s) rsh $HOST_REMOTO /tecnica/operador/Mata_Usuario_db9.ksh
           #          break
           #          ;;
           #     N|n) echo "Abortando proceso $0"
           #          exit
           #          ;;
           #       *) echo "Opcion incorrecta"
           #          ;;
           #esac
         # done
          echo "Inicio de descompresion remota del archivo coto.zip"
          rsh $HOST_REMOTO \
          '( touch '$DIR_REMOTO'/.envio_archivos
          if [ $? -ne 0 ]
           then 
            RC=20
            echo "Error $RC - No pudo generar el archivo .envio_archivos"
            echo "<ENTER> - Para continuar"
            read nada
           else 
            cd '$DIR_REMOTO'
            '$DIR_REMOTO'/unzip -o '$DIR_REMOTO'/coto.zip 
            if [ $? -ne 0 ]
             then
              RC=30
              echo "Error $RC - Al intentar descomprimir el coto.zip"
              echo "<ENTER> - Para continuar"
              read nada
             else 
              rm -f '$DIR_REMOTO'/.envio_archivos
            fi 
          fi
          )'
       fi     
fi 

echo "\t\t\t Fin del proceso $0"
echo "\t\t\t <ENTER> - Para continuar"
read nada
exit $RC

###############################################################################
#                                 Fin                                         #
###############################################################################
