#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: EspacioDisco.ksh                                       #
# Descripcion........: Imprime por pantalla el reporte de espacio disponible  #
#                      por discos y totalizando por VG                        #
# Modificacion.......: 09/01/2002                                             #
###############################################################################

###############################################################################
#                          Definicion de Variables                            #
###############################################################################
export WHERE=$1

###############################################################################
#                                Funciones                                    #
###############################################################################
#-----------------------------------------------------------------------------#
#                        Inicio funcion comunicacion                          # 
#-----------------------------------------------------------------------------#

function comunicacion 
{
ping -c 3 $m >/dev/null 2>&1
if [ $? -ne 0 ]
 then 
  RC=10 
  echo "Error $RC -* No existe comunicacion con $m"
  return 1
fi
}

#-----------------------------------------------------------------------------#
#                          Fin funcion comunicacion                           # 
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                        Inicio funcion AnalizaParametro                      # 
#-----------------------------------------------------------------------------#

function AnalizaParametro
{
case $WHERE in 
     SUCURSALES) LISTAEQUIPOS="" 
                 for numero in `echo $LISTASUC`
                   do 
                    LISTAEQUIPOS=`echo "$LISTAEQUIPOS suc${numero}"`
                   done
                   ;;
     CENTRODIST) export LISTAEQUIPOS=`echo "pampa_boot pucara mirage wftesting gdm01"`
                   ;;
     COMCENTRAL) LISTAEQUIPOS="H70-KARDEX S80-FNCL amscentral asterix campana \
                 ctefte  ctefte2 cws1 dccoto  escala1 escala2_boot europa \
                 j40gdm nodo5 obelix oft01 patrol sft01 sp1 sp10 sp17 \
                 sp9 suc260 suc76"
                   ;;
     ESPECIALES) $OPERADOR_WRK/encabezado.ksh
                 echo "\t\t\t Ingresar la lista de equipos ===> \c" 
                 read LISTAEQUIPOS
                 if [ "${LISTAEQUIPOS:=VACIO}" = "VACIO" ]
                  then 
                   exit
                 fi
                   ;;
esac
}

#-----------------------------------------------------------------------------#
#                          Fin funcion AnalizaParametro                       # 
#-----------------------------------------------------------------------------#

###############################################################################
#                                Principal                                    #
###############################################################################
AnalizaParametro
clear
for m in `echo $LISTAEQUIPOS`
do 
 echo "******************************************************"
 printf "%-6s %-30s %-10s %-5s \n"\
 "*****" "Reporte de espacio disponible" $m "*****"
 echo "******************************************************\n"
 comunicacion
 if [ $? -eq 0 ] 
  then 
   rsh $m '( TOTAL_EQUIPO=0 ;
   for i in `lsvg -o`
    do
     echo " Volume group    Disco    Total    Usado    Libre"
     echo "-------------    -----    -----    -----    -----"
     totaldisponible=0
     lsvg -p $i | grep hdisk | while read a b c d e
      do
       ESPACIO=`lspv $a | cut -f 2 -d : | cut -f 2 -d "(" |grep megab \
       | tr -d ")" | tr -d "A-Z|a-z"`
       suma=0
       for cont in `echo $ESPACIO`
        do
         suma=`expr $suma + 1`
         vtx[$suma]=`echo $cont`
        done
        totaldisponible=`expr $totaldisponible + ${vtx[2]}`
        printf " %-15s %-8s %-8s %-8s %-10s \n" \
        $i $a ${vtx[1]} ${vtx[3]} ${vtx[2]}
      done
      echo "                                            _____"
      printf " %-35s %-5s %-6s %-2s \n\n"\
      "" Total=  $totaldisponible Mb 
        TOTAL_EQUIPO=`expr $TOTAL_EQUIPO + $totaldisponible`
    done
   echo "\t Total en el equipo  '$m' ==> $TOTAL_EQUIPO Mbytes"
   MEMORIA_KBYTES=`bootinfo -r`
   MEMORIA_MBYTES=`expr $MEMORIA_KBYTES / 1024`
   if [ $MEMORIA_MBYTES -eq 0 ] 
    then 
     echo "\t Memoria del equipo  '$m' ==> $MEMORIA_KBYTES Kbytes"
    else
     echo "\t Memoria del equipo  '$m' ==> $MEMORIA_MBYTES Mbytes"
   fi
   echo "\t Modelo ==> $MODELO"
   echo "\t `bindprocessor -q`"
   )'
   if [ "${WHERE}" = "SUCURSALES" ] 
    then
     CODIGO=`rsh $m uname -m | cut -c9,10`
     case $CODIGO in 
       48) MODELO=C10 
           ;;
       90) MODELO=C20 
           ;;
       4C) MODELO=43P
           ;;
       C0) MODELO=E30
           ;;
        *) MODELO=NNN
      esac
      echo "\t Modelo ==> $MODELO"
      echo "\t Direccion ==> `rsh $m head -4 /etc/security/login.cfg |\
      awk '{ print ( substr( $0, 675, 50 ))  }'`"
   fi
 fi 
done
echo "\t <ENTER> - Para volver al menu\c"
read nada
