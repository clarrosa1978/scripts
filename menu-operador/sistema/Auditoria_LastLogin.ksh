#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: Auditoria_LastLogin.ksh                                #
# Descripcion........: Mostrar el ultimo login del usuario                    #
# Modificacion.......: 17/10/2001                                             #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################
#set -x
###############################################################################
#                              Funciones                                      #
###############################################################################

###############################################################################
#                              Principal                                      #
###############################################################################

for i in `lsuser -a ALL`
do
last $i | head -1 | grep -v root | awk ' { print $1 " " $4 " "  $5 " " $6 " " $8 " " $9 } ' << EOF 
sort -k 3 >> $OPERADOR_TMP/UltimoLogin.tmp
EOF
done
exit

#=============================================================================
# Ordeno el archivo por fecha (campo 3 )
# --------------------------------------
cat $file_sort1 | grep Jan | sort -k 3  >  $file_sort2
#cat $outfile | grep ene | sort -k 3  >> $file_sort

cat $file_sort1 | grep Feb | sort -k 3  >> $file_sort2
#cat $outfile | grep feb | sort -k 3  >> $file_sort

cat $file_sort1 | grep Mar | sort -k 3  >> $file_sort2
#cat $outfile | grep mar | sort -k 3  >> $file_sort

cat $file_sort1 | grep Apr | sort -k 3  >> $file_sort2
#cat $outfile | grep abr | sort -k 3  >> $file_sort

cat $file_sort1 | grep May | sort -k 3  >> $file_sort2
#cat $outfile | grep may | sort -k 3  >> $file_sort

cat $file_sort1 | grep Jun | sort -k 3  >> $file_sort2
#cat $outfile | grep jun | sort -k 3  >> $file_sort

cat $file_sort1 | grep Jul | sort -k 3  >> $file_sort2
#cat $outfile | grep jul | sort -k 3  >> $file_sort
 
cat $file_sort1 | grep Aug | sort -k 3  >> $file_sort2
#cat $outfile | grep ago | sort -k 3  >> $file_sort
     
cat $file_sort1 | grep Sep | sort -k 3  >> $file_sort2
#cat $outfile | grep sep | sort -k 3  >> $file_sort

cat $file_sort1 | grep Oct | sort -k 3  >> $file_sort2
#cat $outfile | grep oct | sort -k 3  >> $file_sort

cat $file_sort1 | grep Nov | sort -k 3  >> $file_sort2
#cat $outfile | grep nov | sort -k 3  >> $file_sort

cat $file_sort1 | grep Dec | sort -k 3  >> $file_sort2
#cat $outfile | grep dic | sort -k 3  >> $file_sort


cat $file_sort2 | while read usuario mes dia hora_ini hora_fin tiempo_login
do
txt=""
txt=`lsuser -a gecos $usuario  | tr '=' ' ' | awk ' { print $3 " " $4 " " $5 " " $6  " " $7 " " $8 " " $9 " " $10  } `
echo $usuario $mes $dia $hora_ini $hora_fin $tiempo_login $txt |printf " %-10s %-3s %-3s %-7s %-8s %-s %-s %-s %-s %-s\n" $usuario $mes $dia $hora_ini $hora_fin $tiempo_login $txt >> $$OPERADOR_WRK/wlogin 
done 

echo "Instalacion: $hlocal                                                 $fecha">$outfile
echo >> $outfile
echo "                   Lista de usuarios por ultima fecha de login" >> $outfile
echo >> $outfile
echo " Usuario    Fecha   Start   End       Durac. ----------- Texto -----------" >> $outfile
echo "                                      hh:mm" >> $outfile
echo >> $outfile

cat $$OPERADOR_WRK/wlogin  >> $outfile
chown admuser.security $outfile             

#rm -f $$OPERADOR_WRK/wlogin
#rm -f $file_sort1 $file_sort2 
