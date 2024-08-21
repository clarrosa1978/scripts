#!/usr/bin/ksh
cd `dirname $0`
DIR_NAME=${MENU_CTM}/funciones
. $DIR_NAME/dynamic_menu.lib
. $DIR_NAME/dynamic_menu.var
trap "" 2
#Verificacion de Parametros
test_param $# 1
#Definicion de Variables
MENU_OPTIONS=${MENU_CTM}/$1
2>&1
  while [ 1 ]
  do
	MFECHA=`date '+%e/%m/%y'`
	MHORA=`date '+%H:%M:%S'`
  	clear
  	echo "---------------------------------------------------------------------"
  	echo " Fecha $MFECHA $MHORA                                                "
  	echo " Server: ${SERVER}                                                  "
  	echo " Funcion: $FUNCION                                                  "
  	echo "---------------------------------------------------------------------\n"
	MENU_TITLE=`grep ^0 ${MENU_OPTIONS} | cut -f3 -d:`
	echo ${MENU_TITLE}
	echo  "\n\n"
	MENU_FUNC=`grep ^0 ${MENU_OPTIONS} | cut -f4 -d: `
	. ${MENU_FUNC}
	for menu_line in `cat ${MENU_OPTIONS}|grep -v ^0 | sed s/' '/'_-_'/g`
	do
		
		LINE_NUMBER=`echo ${menu_line} | cut -f1 -d: | sed s/'_-_'/' '/g`
		LINE_NAME=`echo  ${menu_line} | cut -f3 -d: |  sed s/'_-_'/' '/g `
		echo  "\t${LINE_NUMBER} ) ${LINE_NAME} "
		echo  
	done
  	echo  "Ingrese Opcion:  \c"
  	read opcion
		for menu_line in $(cat ${MENU_OPTIONS}|grep -v ^0 | sed s/' '/'_-_'/g) 
		do
			LINE_CASE=$(echo  ${menu_line} | cut -f2 -d: | sed s/'_-_'/' '/g)
			LINE_NUMBER=$(echo  ${menu_line} | cut -f1 -d: | sed s/'_-_'/' '/g)
			LINE_NAME=$(echo  ${menu_line} | cut -f3 -d: |  sed s/'_-_'/' '/g )
			LINE_COMMAND=$(echo  ${menu_line} | cut -f4 -d: | sed s/'_-_'/' '/g)
			if [ "#${LINE_CASE}" = "#$opcion" -o "#${LINE_NUMBER}" = "#$opcion" ]
			then
				log "${MENU_TITLE}" "${LINE_NAME}"
				echo  "${LINE_COMMAND}" | grep ';' >> /dev/null
				STATUS=$?
				if [ ${STATUS} = 0 ]
				then
					COM_NUM=1
					COM_STR=$(echo  ${LINE_COMMAND} | cut -f${COM_NUM} -d';')
					while [ -n "${COM_STR}" ]
					do
						${COM_STR}
						COM_NUM=`expr ${COM_NUM} + 1`
						COM_STR=$(echo  ${LINE_COMMAND} | cut -f${COM_NUM} -d';' )
					done
				else 
					${LINE_COMMAND}
				fi
				press_enter
			fi
		done
  done
