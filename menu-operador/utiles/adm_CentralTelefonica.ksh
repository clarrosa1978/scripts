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
#                           Funciones                                         #
###############################################################################
function ValidarSucursal
{
        typeset -Z3 SUC="${1}"
        typeset -Z1 VALIDA=1
        typeset -fu EsNumerico
        export HOST=${SUC}
        export TIPO=0
        EsNumerico ${SUC}
        [ $? = 1 ] && return 1
        if [ ${SUC} -lt 100 ]
        then
                typeset -Z2 SUC="${1}"
        fi
        for i in `cat /etc/centralestel`
        do
                [ ${SUC} = ${i} ] && VALIDA=0
                if [ ${VALIDA} = 0 ]
                then
                        return 0
                fi
        done
        if [ ${VALIDA} = 1 ]
        then
                return 1
        fi
}

###############################################################################
#			       Principal                                      #
###############################################################################
        
while true 
do
 $OPERADOR_WRK/encabezado.ksh
 echo "\tIngrese la sucursal (S para salir):\c:"
 read suc
 [ $suc = "S" -o $suc = "s" ] && exit
 ValidarSucursal $suc
 if [ $? = 0 ]
 then
	rsh 129.$suc.101.101 -l mtcl ksh /usr2/mtcl/scripts/menu_Ctele.ksh
 else
	echo "\n\n\tESA SUCURSAL NO TIENE CENTRAL TELEFONICA"
	read c
 fi
done
