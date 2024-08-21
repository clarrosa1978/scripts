#!/usr/bin/ksh
##########################################################################################
# Autor..............: Cristian Larrosa                                                  #
# Objetivo...........: Crea una pantalla de menu a apartir de un archivo plano.          #
# Nombre del programa: menu.hdesk                                                        #
# Solicitado por.....: Omar Del Negro                                                    #
# Descripcion........: Recibe como parametro el nombre del archivo donde se encuentran   #
#                      las opciones del menu que se desea generar, junto con el programa #
#                      asociado a esa opcion.                                            #
# Fecha de creacion..: 13/03/2008                                                        #
# Modificacion.......: DD/MM/AAAA                                                        #
# Documentacion......: El parametro que recibe debe ser un string que indica el path abso#
#                      luto y el nombre del archivo con las opciones del menu.           #
#                      Ej: Menu.sh /home/root/opciones_menu.txt                          #
# Estructura.........: El archivo puede tener tantas opciones como uno desee, teniendo en#
#                      cuenta una salvedad, la primer linea del archivo es el Titulo que #
#                      queremos que tenga el menu, y las demas lineas representan las    #
#                      opciones que componen el menu junto con su programa a ejecutar,   #
#                      es decir una linea=una opcion del menu + el programa a ejecutar.  #
#                      Cada linea de opcion debe estar compuesta de la forma:            #
#                                Opcion;Programa                                         #
#                      Donde Opcion es la leyenda que queremos que aparezca en la opcion #
#                      del menu y Programa es un string que representa el programa, junto#
#                      con el path absoluto donde se encuentra el mismo, que queremos que#
#                      se ejecute cuando seleccionan esa opcion.                         #
#                      Ej: Un registro del archivo podria ser de este tipo               #
#                              ALTA DE USUARIO;/home/root/alta_usuario.sh                #
##########################################################################################

##########################################################################################
#                                     VARIABLES                                          #
##########################################################################################
export MENUOP=$1
export TITULO="`head -1 ${MENUOP}`"
export PROGRAMAS=`tail +2 "${MENUOP}"|awk -F ";" ' { print $2 } '`
export PARAMETROS=`tail +2 "${MENUOP}"|awk -F ";" ' { print $NF } '`
export OPCION=""
export PATHAPL="/tecnol/opmayuda"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export USUARIO="`whoami`"
export LOGSCRIPT="${PATHLOG}/logmenu.`date +%A`"

export BOLD=`tput bold`
export REV=`tput smso`
export EREV=`tput rmso`
export END=`tput sgr0`
export BLNK=`tput blink`

export OPCIONES=`tail +2 ${MENUOP}| awk -F ";" ' { $NF=""
                                                         print sprintf("\t\t'${REV}'%02d) '${EREV}' %s", NR, $1)}
                                                        '`
export OPCMAX=`echo "${OPCIONES}"|wc -l|awk ' { print $1 } '`

##########################################################################################
#                                     FUNCIONES                                          #
##########################################################################################
autoload Enviar_A_Log

##########################################################################################
#                                     PRINCIPAL                                          #
##########################################################################################
while true
do
	clear
	${PATHAPL}/encabezado.sh "${TITULO}"
	Enviar_A_Log "${USUARIO} - Ingreso a ${TITULO}." ${LOGSCRIPT}
        echo "${OPCIONES}\n\n\n"
        echo "\t\t${REV}Ingrese su opcion [de 1 a ${OPCMAX}] o [S|s] para salir:${EREV}\c"
        read OPCION
        if [ "${OPCION}" = "s" -o "${OPCION}" = "S" ]
	then
		Enviar_A_Log "${USUARIO} - Salio de ${TITULO}." ${LOGSCRIPT}
		tput sgr0
		exit
	fi
        export NUMVALID=`expr "${OPCION}" : '^\([0-9]*\)$'`
        if [ ${NUMVALID} ] && [ ${NUMVALID} = ${OPCION} ] && [ ${OPCION} -gt 0 ] && [ ${OPCION} -le ${OPCMAX} ]
	then
        	OPCION=`expr ${OPCION} + 0` # Elimina ceros a la izquierda
        	EXECPROG=`echo "${PROGRAMAS}" |awk ' NR == '${OPCION}' { print $0 } '`
        	EXECPARM=`echo "${PARAMETROS}" |awk ' NR == '${OPCION}' { print $0 } '`
		Enviar_A_Log "${USUARIO} - Selecciono Opcion ${OPCION} de ${TITULO}." ${LOGSCRIPT}
        	"${EXECPROG}" "${EXECPARM}"
	else
        	echo "\n\n\t\t\t\t${BLNK}Opcion INVALIDA.  REINGRESE...${END}"
		echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
		read
        	OPCION=""
        	NUMVALID=""
	fi
done
