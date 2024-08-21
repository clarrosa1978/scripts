#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Enviar los arhivos despues del cierre de CEDECO        #
# Nombre del programa: Aplicaciones_cierre_cedeco.ksh                         #
# Descripcion........: Envia los archivos coto* por medio de un rcp al pucara #
# Modificacion.......: 03/09/2001                                             #
###############################################################################

#set -x
###############################################################################
#                        Definicion de variables                              #
###############################################################################

HOST_REMOTO=$1
DIR_ACDATOS=$2
DIRE_REMOTO=$3
NRO_DEORDEN=$4
TECNICA_BIN=/tecnica/bin
DIR_TRABAJO=/copias
RC=0

#-----------------------------------------------------------------------------#
# Carga la varible LST_VARIABLE que contiene los archivos a ser copiados      # 
#-----------------------------------------------------------------------------#

if [ "${NRO_DEORDEN-VACIO}" != "VACIO" ]
 then 
  if [ $NRO_DEORDEN = "PRIMERO" ]
   then 
    LST_VARIABLE="coto01.dat coto03.dat coto04.dat coto05.dat coto06.dat \
    coto07.dat coto08.dat coto09.dat coto11.dat coto13.dat coto14.dat \
    coto331.dat coto64.dat coto64.dat coto69.dat coto72.dat cotoa0.dat \
    cotoa1.dat cotoa2.dat"
   else
    LST_VARIABLE="coto01.dat coto03.dat coto04.dat coto05.dat coto06.dat \
    coto07.dat coto08.dat coto09.dat coto11.dat coto13.dat coto14.dat \
    coto15.dat coto331.dat coto69.dat coto72.dat cotoa0.dat cotoa1.dat \
    cotoa2.dat cotoa3.dat"
  fi
 else
  RC=5
  echo "Error $RC - Falta parametro Nro 4"
  echo "<ENTER> - Para continuar"
  read nada
fi

###############################################################################
#                              Principal                                      #
###############################################################################
$OPERADOR_WRK/encabezado.ksh
if [ "${DIR_TRABAJO-VACIO}" = "VACIO" ] 
 then
  RC=10
  echo "Error $RC - Variable DIR_TRABAJO is empty"
  echo "<ENTER> - Para continuar"
  read nada
 else
  echo "\t\t\t Inicio del proceso $0" 
  echo "Inicio de depuracion de los archivos coto* del $DIR_TRABAJO"
  rm -f $DIR_TRABAJO/coto* 
  if [ $? -ne 0 ]   
   then 
    RC=20
    echo "Error $RC - Al intentar borrar los archivos coto*"   
    echo "<ENTER> - Para continuar"
    read nada
   else
    echo "Fin de depuracion de los archivos coto* del $DIR_TRABAJO"
    echo "Inicio de Copia de los archivos coto* a $DIR_TRABAJO"
    for i in `echo $LST_VARIABLE`
     do
      cp -p $DIR_ACDATOS/$i $DIR_TRABAJO
      if [ $? -ne 0 ]
       then 
        RC=30
        echo "Error $RC - Al intentar copiar el $i del $DIR_ACDATOS"
        echo "\t\t\tAbortando proceso"
        echo "<ENTER> - Para continuar"
        exit $RC
       else 
#-----------------------------------------------------------------------------#
# En este paso se renombra la variable para copiar el archivo ARCH.dat.idx    # 
#-----------------------------------------------------------------------------#
        VAR_AUXILIAR=${i%%.dat}.dat.idx
        cp -p $DIR_ACDATOS/$VAR_AUXILIAR $DIR_TRABAJO
        if [ $? -ne 0 ] 
         then
          RC=40
          echo "Error $RC - Al intentar copiar $VAR_AUXILIAR del $DIR_ACDATOS"
          echo "\t\t\tAbortando proceso"
          echo "<ENTER> - Para continuar"
          exit $RC
        fi
      fi
     done
    echo "Fin de Copia de los archivos coto* a $DIR_TRABAJO"
    echo "Inicio de compresion de los archivos coto* en coto.zip" 
    cd $DIR_TRABAJO
    $TECNICA_BIN/zip coto.zip coto*
    if [ $? -ne 0 ]
     then 
      RC=50
      echo "Error $RC - Al intentar zipear los archivos $DIR_TRABAJO/coto*"
      echo "<ENTER> - Para continuar"
      read nada
     else
      echo "Fin de compresion de los archivos coto* en coto.zip" 
      echo "Inicio de transferencia de archivos coto* a $HOST_REMOTO"
      rcp -p $DIR_TRABAJO/coto.zip $HOST_REMOTO:$DIRE_REMOTO
      if [ $? -ne 0 ]
         then 
          RC=60
          echo "Error $RC - Al intentar transmitir el archivo a $HOST_REMOTO"
          echo "<ENTER> - Para continuar"
          read nada
         else 
          echo "Fin de transferencia de archivos coto* a $HOST_REMOTO"
      fi 
    fi
  fi
fi
echo "\t\t\t Fin del proceso $0"
echo "\t\t\t <ENTER> - Para continuar"
read nada
exit $RC

###############################################################################
#                                 Fin                                         #
###############################################################################
