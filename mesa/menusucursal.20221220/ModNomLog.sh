#!/usr/bin/ksh
###############################################################################
# Autor..............:                                                        #
# Usuario ...........: sfctrl                                                 #
# Objetivo...........: Permitir a mesa de ayuda reasignar archivos de nombres #
#                      logicos a la caja         s                            #
# Modificacion.......: 27/04/2010                                             #
###############################################################################
export SFSW_HOME=/tecnol/mayuda
export SFSW_MENU=$SFSW_HOME
ARCH_LOG="/sfctrl/tmp/menam.log"
#CORREO=sortiz@coto.com.ar
CORREO=mesadeayuda@coto.com.ar
CORREOCCO=soportestoreflow@coto.com.ar
BODYMESSAGE=" "
PATHBODY="/sfctrl/tmp/body.tmp"
SUC=`hostname`
USUARIOIP=`who -m | awk '{print ($1,$6)}'`
B=$(tput bold)
N=$(tput sgr0)
R="\033[31m"
BL="\033[0m"
V="\033[32m"
BLINK="\033[1;5m"
NOBLINK="\033[0;0m"
MAX=""
OLDNOMLOG=""
ESTADO=""
CAJA=""
DIGIT=""
while true
do
SALIDAOK=0
        while [ $SALIDAOK -eq 0 ]
        do
        	$SFSW_MENU/encabezado.ksh
		echo "\t   *** ARCHIVO DE NOMBRES LOGICOS - Reasignacion de variables ***"
        	echo "\t       ${BLINK}< 000 = Salir || 999 = Ver cajas liberadas por soft >${NOBLINK}"
		echo "\n\t\tIngrese Caja(3 digitos) a Consultar/Modificar:\c"
        	read CAJA
        	DIGIT=`echo $CAJA | awk '{print length($1)}'`
        	NUMERICO=`echo $CAJA | egrep '^[0-9]+$' | wc -l`
		#Control 
        		if [ $NUMERICO -eq 1 ]
				then
					if [ $DIGIT -eq 3 ]
						then
						SALIDAOK=1
						else
						echo "\v\v\t\t\t ${B} CANTIDAD DE DIGITOS INCORRECTA ${N}"
        					echo "\t\t\t    <ENTER>-Volver a ingresar \c"
        					read nada		
					fi
				else
				echo "\v\v\t\t\t  ${B} EL INGRESO DEBE SER NUMERICO ${N}"
        			echo "\t\t\t    <ENTER>-Volver a ingresar \c"
        			read nada
			fi
        done
	if [ $CAJA -eq 000 ]
                then
                exit
        fi
	if [ $CAJA -eq 999 ]
                then
                NINGUNA=`lteset | grep "e00003.nam" | wc -l`
                if [ $NINGUNA -ne 0 ]
                        then
                        $SFSW_MENU/encabezado.ksh
                        echo "\t   *** ARCHIVO DE NOMBRES LOGICOS - Reasignacion de variables ***\v"
                        echo "\n\t\tCAJA/S LIBERADA/S"
                        echo "\t\t----------------${V}${B}\v"
                        lteset | grep "e00003.nam" | awk '{ printf "\t\t| caja:"($1) " |\n"}'
                        echo "\v\v\t\t\t\t${BL}${N}  <ENTER>-Fin \c"
                        read a
                        exit
                                else
                                $SFSW_MENU/encabezado.ksh
                                echo "\t   *** ARCHIVO DE NOMBRES LOGICOS - Reasignacion de variables ***\v"
                                echo "\n\t\t\t     ${V}${B} NO HAY CAJAS LIBERADAS ${BL}${N}"
                                echo "\v\t\t\t\t${BL}${N}  <ENTER>-Fin \c"
                                read a
                                exit    
                fi                      
        fi
	#Control de existencia de cajas
	LOAD=`ls /sfctrl/l/load???.dat | cut -f1 -d. | cut -f4 -d/ | cut -f2 -d"d"`
	MARCA=1
	for NRO in $LOAD
	do
                        if [ $NRO -eq $CAJA ]
                                then
                                #Marca de Caja existente
                                MARCA=0
                        fi
        done 
	   #Salida de Error
          if [ $MARCA != 0 ]
		then
		echo "\v\v\t\t${B}CAJA INEXISTENTE${N}"
                echo "\t\tEn caso de estar seguro y el error persista, verifique"
                echo "\t\tcon Soporte de Storeflow el load de la caja"
                echo "\v\t\t\t\t  <ENTER>-Fin \c"
		read a
                exit
          fi
	  OLDNOMLOG=`lteset | awk -v cj=$CAJA '{if($1 == cj) {print $3}}' | cut -c 7-16`
	  ESTADO=`lteset | awk -v cj=$CAJA '{if($1 == cj) print $3}' | cut -c 7-16 | awk '{if ($1 == "e00002.nam") print "1"; else print "2"}'` 
          if [ $ESTADO -eq 1 ]
                then
		echo "\v\t\t\t ${B} LA CAJA $CAJA PERTENECE A EMPRESA 2${N}\n\t\t\t Verificar con soporte de storeflow!\v"
                echo "\t\t\t\t <ENTER>-Fin \c"
                read nada
                ESTADO=""
                exit
          fi
	  echo "\t\t "
	  echo "\t\tla caja $CAJA tiene asignado el archivo: ${B}$OLDNOMLOG${N}"
          echo "\t\tRealiza modificacion (s/n)?: \c"
          read RESP
                case $RESP in
                        s|S)
                        ESTADO=`lteset | awk -v cj=$CAJA '{if($1 == cj) print $3}' | cut -c 7-16 | awk '{if ($1 == "e00003.nam") print "1"; else print "2"}'`
                                if [ $ESTADO -eq 1 ]
                                        then
                                        NEWNOMLOG="e00001.nam"
                                        lteset $CAJA-$CAJA ltdat:$NEWNOMLOG >/dev/null
                                        HORA=`date +'%H:%M:%S'"hs"`
					LT=`lteset | grep "$CAJA = ltdat:$NEWNOMLOG" | wc -l`
                                                if [ $LT != 0 ]
                                                        then
							$SFSW_MENU/encabezado.ksh
							echo "\t\t\t${B} * * Modificacion realizada * * ${N}"
							echo "\t\tse envia mail informativo a soporte de storeflow\v"
							echo "Usuario - IP: $USUARIOIP  Hora modificacion: $HORA \v"  > $PATHBODY
							echo "\t\tCaja             : $CAJA"
							echo "Caja                : $CAJA" >> $PATHBODY
							echo "\t\t${B}${V}Nuevo Archivo    : $NEWNOMLOG${N}${BL}"
                                                        echo "Nuevo Archivo       : $NEWNOMLOG" >> $PATHBODY
							echo "\t\tArchivo anterior : $OLDNOMLOG"
							echo "Archivo anterior    : $OLDNOMLOG" >> $PATHBODY
							echo "\t\tUsuario - IP     : $USUARIOIP\v"
							echo "--------------------------------" >> $ARCH_LOG
							cat $PATHBODY >> $ARCH_LOG
							cat $PATHBODY > $BODYMESSAGE
						mail -c $CORREOCCO -s "ARCHIVO DE NOMBRES LOGICOS: Reasignacion de variables realizada en $SUC" $CORREO < $BODYMESSAGE
							echo "\v\v\t ${BLINK}${B}Recuerde:${N}${NOBLINK} Para aplicar los cambios debe reiniciar la caja\v"
							echo "\t\t\t\t  <ENTER>-Fin \c"
							read a
							exit
                                                                else
                                                                $SFSW_MENU/encabezado.ksh
                                                                echo "\t\t\t${B} Error! ${N}"
                                                                lteset $CAJA-$CAJA ltdat:$OLDNOMLOG
                                                                echo " Fallo al intentar reasignar archivo de nombres logicos   " > $PATHBODY
								echo " a la caja $CAJA.     " >> $PATHBODY
								echo " Hora: $HORALEVANTA \v\v" >> $PATHBODY
								echo " Verificar con soporte de Storeflow" >> $PATHBODY
								echo "-----------------------" >> $ARCH_LOG
								cat $PATHBODY >> $ARCH_LOG
								cat $PATHBODY > $BODYMESSAGE
								mail -c $CORREOCCO -s "ARCHIVO DE NOMBRES LOGICOS: Fallo en $SUC" $CORREO < $BODYMESSAGE
								echo "\t\t\t${B} No se pudo realizar el cambio correctamente ! ${N}\v"
                                                                echo "\t\t\t se intenta dejar la caja $CAJA asociada al archivo $OLDNOMLOG"
								echo "\t\t\t " `lteset | grep "$CAJA" | awk '{print ($3)}'`
                                                                echo "\t\t"
								echo "\t\t${R}Solicitar revision de soporte de storeflow!${BL}"
								echo "\t\t\t\t   <ENTER>-Fin \c"
								read a
								exit
                                                fi
                                        else
					NEWNOMLOG="e00003.nam"
                                        lteset $CAJA-$CAJA ltdat:$NEWNOMLOG >/dev/null
                                        HORA=`date +'%H:%M:%S'"hs"`
					LT=`lteset | grep "$CAJA = ltdat:$NEWNOMLOG" | wc -l`
                                                if [ $LT -ne 0 ]
                                                        then
                                                        $SFSW_MENU/encabezado.ksh
                                                        echo "\t\t\t${B} * * Modificacion realizada * * ${N}"
                                                        echo "\t\tse envia mail informativo a soporte de storeflow\v\v"
							echo "Usuario - IP: $USUARIOIP  Hora modificacion: $HORA\v"  > $PATHBODY
							echo "\t\tCaja             : $CAJA"
                                                        echo "Caja                : $CAJA" >> $PATHBODY
							echo "\t\t${B}${V}Nuevo Archivo    : $NEWNOMLOG${N}${BL}"
                                                        echo "Nuevo Archivo       : $NEWNOMLOG" >> $PATHBODY
                                                        echo "\t\tArchivo anterior : $OLDNOMLOG"
                                                        echo "Archivo anterior    : $OLDNOMLOG" >> $PATHBODY
                                                        echo "\t\tUsuario - IP     : $USUARIOIP\v"
                                                        echo "---------------------------" >> $ARCH_LOG
                                                        cat $PATHBODY >> $ARCH_LOG
                                                        cat $PATHBODY > $BODYMESSAGE
                                                mail -c $CORREOCCO -s "ARCHIVO DE NOMBRES LOGICOS: Reasignacion de variables realizada en $SUC" $CORREO < $BODYMESSAGE
                                                        echo "\v\v\t    ${BLINK}${B}Recuerde:${N}${NOBLINK} Para aplicar los cambios debe reiniciar la caja\v"
                                                        echo "\t\t\t\t  <ENTER>-Fin \c"
							read a
                                                        exit
								else
                                                               	$SFSW_MENU/encabezado.ksh
                                                                echo "\t\t\t${B} Error! ${N}"
                                                                lteset $CAJA-$CAJA ltdat:$OLDNOMLOG
                                                                echo " Fallo al intentar reasignar archivo de nombres logicos   " > $PATHBODY
                                                                echo " a la caja $CAJA.     " >> $PATHBODY
                                                                echo " Hora: $HORA \v\v" >> $PATHBODY
                                                                echo " Verificar con soporte de Storeflow" >> $PATHBODY
                                                                echo "-----------------------" >> $ARCH_LOG
                                                                cat $PATHBODY >> $ARCH_LOG
                                                                cat $PATHBODY > $BODYMESSAGE
                                                                mail -c $CORREOCCO -s "ARCHIVO DE NOMBRES LOGICOS: Fallo en $SUC" $CORREO < $BODYMESSAGE
                                                                echo "\t\t\t${B} No se pudo realizar el cambio correctamente ! ${N}\v"
                                                                echo "\t\t\t se intenta dejar la caja $CAJA asociada al archivo $OLDNOMLOG"
                                                                echo "\t\t\t "`lteset | grep "$CAJA" | awk '{print ($3)}'`
                                                                echo "\t\t"
                                                                echo "\t\t${R}Solicitar revision de soporte de storeflow!${BL}"
                                                                echo "\t\t\t\t   <ENTER>-Fin \c"
                                                                read a
								exit
						fi
				fi
                         ;;
                        n|N)
                        echo ""
                        exit
                        ;;
                *)    $SFSW_MENU/encabezado.ksh
                        echo ""
                        echo "\t\t\t\t Opcion Incorrecta"
                        echo "\t\t\t\t <ENTER>-Continuar \c"
                        read nada
                        ;;
                esac
done
