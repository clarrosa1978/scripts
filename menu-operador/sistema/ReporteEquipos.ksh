#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: ReporteEquipos.ksh                                     #
# Descripcion........: Imprime por pantalla el reporte de espacio disponible  #
#                      por discos y totalizando por VG                        #
# Modificacion.......: 09/01/2002                                             #
###############################################################################

###############################################################################
#                          Definicion de Variables                            #
###############################################################################


###############################################################################
#                                Principal                                    #
###############################################################################

for i in `lsvg -o`
 do
 VG_PP_SIZE=`lsvg $i|grep "PP SIZE"|awk -F":" '{ print $3 }'|awk '{ print $1 }'`
 lsvg -p $i | grep hdisk | \
     awk ' { CantidadTotalPPs += $3, FreePPs += $4, CantidadTotal++, DiscosPorSize[$3]++ }
           END {  for ( Size in Discos_Por_Size )
                      print Size, Discos_Por_Size[Size], CantidadTotal_PPs, Free_PPs, CantidadTotal } '
    done
