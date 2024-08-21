#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Concentrar las tareas de operaciones en un menu        #
# Nombre del programa: menu_Operador.ksh                                      #
# Descripcion........: Muestra un menu con opciones a ejecutar por el operador#
# Modificacion.......: 17/10/2001                                             #
###############################################################################

# set -x
###############################################################################
#                        Definicion de variables                              #
###############################################################################

DIR_TRABAJO=/etc
ARCH_TRABAJO=passwd
LISTADO=login_usuarios.lst         
LISTADO1=list_logins.lst         
DIR_LOGIN_FAILED=/etc/security
ARCH_LOGIN_FAILED=failedlogin
DIR_LOG=/var/adm
ARCH_LOG=wtmp
DIR_LAST_LOG=/etc/security
ARCH_LAST_LOG=lastlog
LETRAS=9

###############################################################################
#                                  Principal                                  #
###############################################################################

> $OPERADOR_TMP/$LISTADO1

echo "Fecha   : `date +"%d"/"%m"/"%y"`\t\t\t\t\t\t\t\tHora     : `date +"%H":"%M"`" > $OPERADOR_TMP/$LISTADO
echo "Usuario : `whoami`\t\t\t\t\t\t\t\t\t\tTerminal : `tty`\n" >> $OPERADOR_TMP/$LISTADO
echo "\n! : Password Habilitada" >> $OPERADOR_TMP/$LISTADO
echo "* : Password Inhabilitada" >> $OPERADOR_TMP/$LISTADO
echo "- : Usuario sin Password" >> $OPERADOR_TMP/$LISTADO
echo "\n\t\t\tListado de Logins de Usuarios del Sistema" >> $OPERADOR_TMP/$LISTADO
echo "\t-------------------------------------------------------\n" >> $OPERADOR_TMP/$LISTADO
echo "Grupo\t\tUsuario\t\tPassword\tFecha Ult. Login\tDescripcion" >> $OPERADOR_TMP/$LISTADO
echo "-----\t\t-------\t\t--------\t----------------\t-----------\n" >> $OPERADOR_TMP/$LISTADO

# Obtiene la lista de usuarios del Sistema a partir del id 100
#
cat $DIR_TRABAJO/$ARCH_TRABAJO | cut -f 1-3 -d : | tr ":" " " | while read usuario clave id 
do
if [ $id -lt 100 ]
	then
	continue
else
if [ -s "$clave" ]
	then
	clave="-"
fi
grupo=`lsuser -a pgrp $usuario | tr "=" " " | awk '{print $3}'`
desc=`lsuser -a gecos $usuario | cut -f 2,2 -d =`

count_login=`lssec -f $DIR_LAST_LOG/$ARCH_LAST_LOG -s $usuario -a unsuccessful_login_count | tr "=" " " | awk '{print $3}'`
if [ ! "$count_login" ]
	then
	count_login=0
fi 
if [ `echo $grupo | wc -c` -lt $LETRAS ]
	then
	dif1=`echo $grupo | wc -c`
        dif=`expr $LETRAS - $dif1` 
        while [ $dif != 0 ]
	do
	grupo=`echo $grupo.`
 	dif=`expr $dif - 1`
        done
fi
if [ `echo $usuario | wc -c` -lt $LETRAS ]
	then
	dif1=`echo $usuario | wc -c`
        dif=`expr $LETRAS - $dif1` 
        while [ $dif != 0 ]
	do
	usuario=`echo $usuario.`
 	dif=`expr $dif - 1`
        done
fi
if [ $count_login -lt 3 ] 
	then
	fecha_login=`who $DIR_LOG/$ARCH_LOG | egrep -w $usuario | tail -1 | awk '{print $3,$4,$5}'`
	echo $grupo "   "$usuario"              "$clave"         " $fecha_login "                 " $desc >> $OPERADOR_TMP/$LISTADO1
else
fecha_login=`who $DIR_FAILED_LOGIN/$ARCH_FAILED_LOGIN | egrep -w $usuario | tail -1 | awk '{print $3,$4,$5}'`
echo $grupo "   "$usuario"              "$clave"         " $fecha_login "                 " $desc >> $OPERADOR_TMP/$LISTADO1
fi
fi
done
cat $OPERADOR_TMP/$LISTADO1 | sort -k 1.1 >> $OPERADOR_TMP/$LISTADO
#-----------------------------------End--------------------------------------
