###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: root                                                   #
# Objetivo...........: Menu de auditoria de usuarios                          #
# Nombre del programa: menu_Auditoria.ksh                                     #
# Descripcion........: Menu que muestra las opeciones de auditoria            #
# Modificacion.......: 15/08/2001                                             #
###############################################################################

# set -x
###############################################################################
#                        Definicion de variables                              #
###############################################################################

DIR_LISTADOS=$OPERADOR_TMP 
DIR_SCRIPTS=$OPERADOR_SIS
ARCH_LOG=$OPERADOR_SIS                       
SERVIDOR=`hostname | tr '.' ' ' | tr '_' ' ' | awk ' { print $1 } '`

###############################################################################
#                        Definicion de funciones                              #
###############################################################################

function ordenar_listado
{
clear
echo "\n\n\n\t\t\t- g -----> Ordenados por Grupo\n"
echo "\t\t\t- n -----> Ordenados por Numero\n\n\n"
echo "\t\t\t- ENTER -> Retornar al Menu    \n\n\n"
echo "\t\t\t\t\tOpcion : \c"
read orden
if [ ! "$orden" ]
	then
	return
else
if [ $orden != "g" -a $orden != "n" ]
	then
	print "Opcion Incorrecta. ENTER para Reingresar"
	read nada
	ordenar_listado
else
export orden 
fi
fi
}

#

function mostrar_listado
{
clear
more -d $1
echo "\nTipee ENTER para Continuar"
read nada

echo "\nDesea Imprimir los Datos [ s / n ] : \c"
read opcion
if [ ! "$opcion" ]
	then
	echo "Los datos no Seran Impresos. Aguarde.."
	sleep 5
else
if [ $opcion != "s" -a $opcion != "S" -a $opcion != "n" -a $opcion != "N" ]
	then
	echo "Opcion Incorrecta. Tipee < ENTER > para reintentar"
	read nada
	mostrar_listado
else
if [ $opcion = "s" -o $opcion = "S" ]
	then
	mostrar_impresoras
	qprt -P$impre -p17 $1
fi
fi
fi
}

#
function mostrar_impresoras
{
echo "\t\t\t\tImpresoras Disponibles"
echo "\t\t\t\t----------------------"
lsallq > $DIR_LISTADOS/impresoras 
cat $DIR_LISTADOS/impresoras | while read disp
do
echo "\t\t\t\t$disp"
done
echo "\nImpresora Elegida : \c"
read impre
if [ ! "$impre" ]
	then "Impresora Inexistente. Tipee ENTER para reelegir"
	read nada
	mostrar_impresoras
else
grep $impre $DIR_LISTADOS/impresoras
if [ $? = 1 ]
	then
	echo "\nImpresora Incorrecta. Tipee ENTER para reelegir"
	read nada
	mostrar_impresoras
else
continue
fi
fi
rm -f $DIR_LISTADOS/impresoras

}

#

function usuarios_bloqueados
{
clear
echo "\n\n\n\n\n\n\t\t\tProcesando ............ "
$DIR_SCRIPTS/usr_bloqueados.ksh
mostrar_listado usr_blq_$SERVIDOR.lst
}

#

function login_usuarios
{
clear

echo "\n\n\n\n\t\t\tProcesando ............ "

$IDR_SCRIPTS/login_usuarios.ksh g

mostrar_listado login_usuarios.lst

}

###############################################################################
#                                 Principal                                   #
###############################################################################

while true
do
clear 
$OPERADOR_WRK/encabezado.ksh
#echo "\t******************************************************************** "
#echo "\t*                                                                  * "
#echo "\t*                            AUDITORIA                             * "
#echo "\t*                MENU DE CONTROL DE PERFILES DE USUARIOS           * "
#echo "\t*                                                                  * "
#echo "\t******************************************************************\n "
  echo "             1 - Consulta Perfiles Bloqueados en el Sistema"
  echo " 	     2 - Consulta Historico de Perfiles Bloqueados"
  echo "             3 - Datos de Logins / Passwords de Usuarios"
  echo "             4 - Listado Datos Ultimo Login Usuarios"
  echo "             5 - Chequear accesos fallidos de un usuario"
  echo "             6 - Unificación / Consolidación de Datos"
  echo "             7 - Ver listados totales"
  echo "             8 - Ver log de desbloqueos LOCAL"
  echo "	     9 - Ver ingresos al Sistema"
  echo " 	     s - Volver al menu anterior"
  echo " "
  echo "\n                  Ingrese su opción ==> \c"
  read opcion junk

  case "$opcion" in

# Listado de Usuarios Bloqueados en el Sistema

  1) clear
     $OPERADOR_SIS/usuarios_bloqueados
     ;;

# Listado de Datos de usuarios Bloqueados/Habilitados

  2) clear
     $OPERADOR_SIS/usuarios_bloqueados habilitados
     ;;

# Listado de Datos de Login de Usuarios

  3) clear
     $OPERADOR_SIS/login_usuarios
     ;;
  
#Listado de Datos de Login de Usuarios

  4) clear
     ##DIR_TRABAJO=/local/diradp
     #DIR_TRABAJO=/local/usr
     ##DIR_LISTADO=/local/admuser
     #DIR_LISTADO=/local/auditor/tmp
     #$DIR_TRABAJO/users.login.ksh
     #mostrar_listado $DIR_LISTADO/users_login_`hostname`
     ;;

# Mostrar número de intentos fallidos

  5) clear
     end=0
     while [ $end = 0 ]
     do
     clear
     echo "\n Ingrese usuario a mostrar cantidad de intentos fallidos: \c"
     read usuario
     echo ""
     lsuser $usuario 2>&1 > /dev/null
     if [ $? -eq 0 ]
     then
       echo ""
       echo "\n El usuario $usuario tiene `lssec -f /etc/security/lastlog -s $usuario -a unsuccessful_login_count|cut -f2 -d=` intentos fallidos"
       print "Continua [ s / n ] ? \c :"
       read continua
       if [ ! "$continua" -o "$continua" = "n" ]
		then
		end=1
	else
        continue
	fi
     else
       echo ""
       echo "\n ERROR: El usuario $usuario no existe en el sistema"
     fi
     print "Tipee ENTER para Continuar" 
     read nada
     done
     ;;
 
# Unificación de datos

  6) clear
     #/local/usr/auditor.all.ksh
     echo "Opcion no disponible"
     read nada
     ;;

# Visualización de datos consolidados

  7) clear
    # mostrar_listado $OPERADOR_WRK/usr_blq.uni
     echo "Opcion no disponible"
     read nada
     ;;

  8) clear
     #mostrar_listado $OPERADOR_WRK/habilita_usuario.log
     echo "Opcion no disponible"
     read nada
     ;;

  9) clear
     #/local/usr/ultimodukessa
     echo "Opcion no disponible"
     read nada
     ;; 	

  S|s) clear
     exit        
     ;;
 
  *) echo    
     clear
     return
     ;;

  esac 
done
clear
exit 0
###############################################################################
#                                    end                                      #
###############################################################################
