#!/usr/bin/ksh
###############################################################################
# Autor..............: C.A.S                                                  #
# Usuario ...........: auditor                                                #
# Objetivo...........: Mostrar un menu que permita las consultas remotas      #
# Nombre del programa: UsuariosDelDia.ksh                                     #
# Descripcion........: Ejecuta el script usuarios_bloqueados.ksh              #
# Modificacion.......: 22/08/2001                                             #
###############################################################################
      
###############################################################################
#			 Definicion de variables                              #
###############################################################################

USUARIOS=$1
TODAY=`date +"%b %d"`
LISTADO=/tecnica/operador/sistema/a.lst

###############################################################################
#			 Definicion de Funciones                              #
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
#----------------------- Fin funcion ordenar_listado -----------------------#
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
#----------------------- Fin funcion mostrar_listado -----------------------#

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
#----------------------- Fin funcion mostrar_impresoras --------------------#
function listado
{
echo "Fecha   : `date +"%d"/"%m"/"%y"`\t\t\t\t\tHora     : `date +"%H":"%M"`" >> $LISTADO

control1=`echo $bucle | cut -f2- -d@|tr  A-Z   a-z `
echo "\n\tListado de Usuarios Logueados en el dia $TODAY: $MAQUINA" >> $LISTADO
echo "\t-----------------------------------------------------------\n" >> $LISTADO
echo "Nombre\tWorkstation\tDireccion IP\t\tFecha\tInicio\tFin\tTiempo" \
>> $LISTADO
echo "------\t-----------\t------------\t\t-----\t------\t---\t------\n" \
>> $LISTADO
}
#----------------------- Fin funcion listado -------------------------------#

###############################################################################
#			        Principal                                     #
###############################################################################

if [ $# -eq 0 ] 
 then 
  echo "Error - Usage $0 {/TODOS/ALGUNOS}"
  echo "Presione Cualquier tecla para continuar"
  read nada
 else 
  for i in `cat $DIRECTORIO/maquinas`
   do 
    MAQUINA=$i
    ping -c 3 $i 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ] 
     then 
      echo "Error - No existe comunicacion con $i" 
      echo "Presione Cualquier tecla para continuar"
      read nada
     else
      case $USUARIOS in 
       TODOS)   listado
                rsh $i last | grep "${TODAY}" >> $LISTADO  
                    ;;
       ALGUNOS) listado
                echo "Ingrese los Usuarios que desea Auditar:\c "
                      read USUARIOS 
                rsh $i last `echo $USUARIOS` |grep "${TODAY}" >> $LISTADO
                    ;;
      esac
    fi
   done
   mostrar_listado $LISTADO
fi
