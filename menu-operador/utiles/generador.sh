#!/usr/bin/ksh
###############################################################################
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Usuario ...........: root                                                   #
# Objetivo...........: Generar menu en shell scripts                          #
# Nombre del programa: generador.ksh                                          #
# Descripcion........: Plantilla generadora de menu                           #
# Modificacion.......: 23/04/2002                                             #
###############################################################################


###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador

###############################################################################
#                              Principal                                      #
###############################################################################
$OPERADOR_WRK/encabezado.ksh
echo "\t\t Ingrese el autor del Scripts ==> \c"
read AUTOR 
echo "\t\t Ingrese el usuario de ejecucion del Scripts ==> \c"
read USUARIO
echo "\t\t Objetivo del script ==> \c" 
read OBJETIVO
echo "\t\t (*) Nombre del scripts ==> \c" 
read SCRIPTS 
if [ "${SCRIPTS:=VACIO}" = "VACIO" ]
 then
  echo "El nombre del scripts es campo obligatorio"
  echo "Abortando el proceso"
  exit
fi
echo "\t\t Breve descripcion ==> \c" 
read DESCRIPCION 
echo "\t\t Fecha Modificacion ==>  \c" 
read MODIFICA     
echo "\t\t Ingrese titulo del Menu ==>  \c" 
read TITULO       

OP=0
while true
do
  OP=`expr $OP + 1`
  echo "\t\t Ingrese Opcion $OP ==> \c"
  read OPCION[$OP]
  if [ "${OPCION[OP]}" = "" ]
   then
    break
  fi
done

echo "##############################################################################" \
> $SCRIPTS
printf "%-1s %-21s %-52s %-1s \n" "#" "Autor..............:" "$AUTOR" "#"       >> $SCRIPTS
printf "%-1s %-21s %-52s %-1s \n" "#" "Usuario ...........:" "$USUARIO" "#"     >> $SCRIPTS
printf "%-1s %-21s %-52s %-1s \n" "#" "Objetivo...........:" "$OBJETIVO" "#"    >> $SCRIPTS
printf "%-1s %-21s %-52s %-1s \n" "#" "Nombre del programa:" "$SCRIPTS" "#"     >> $SCRIPTS
printf "%-1s %-21s %-52s %-1s \n" "#" "Descripcion........:" "$DESCRIPCION" "#" >> $SCRIPTS
printf "%-1s %-21s %-52s %-1s \n" "#" "Modificacion.......:" "$MODIFICA" "#"    >> $SCRIPTS
echo "##############################################################################" \
>> $SCRIPTS

echo "\n\n" >> $SCRIPTS

echo "###############################################################################" \
>> $SCRIPTS
echo "#                        Definicion de variables                              #" \
>> $SCRIPTS
echo "###############################################################################" \
>> $SCRIPTS

echo 'OPERADOR_WRK=/tecnica/operador' >> $SCRIPTS
echo 'A=`tput bold`' >> $SCRIPTS
echo 'B=`tput rmso`' >> $SCRIPTS

echo "\n\n" >> $SCRIPTS

echo "###############################################################################" \
>> $SCRIPTS
echo "#                              Principal                                      #" \
>> $SCRIPTS
echo "###############################################################################" \
>> $SCRIPTS


echo "while true" >> $SCRIPTS
echo "do" >> $SCRIPTS
echo "\$OPERADOR_WRK/encabezado.ksh  \$0" >> $SCRIPTS
echo 'echo "\t\t    *** ${A} '`echo $TITULO`'  ${B} *** "' >> $SCRIPTS
echo 'echo ""' >> $SCRIPTS

TOTAL=`expr $OP + 1`
while [ $OP -ge 2 ]
do
 NUMERO=`expr $TOTAL - $OP`
 OP=`expr $OP - 1`
 echo 'echo "\t\t\t '${NUMERO}'. '${OPCION[NUMERO]}'"' >>$SCRIPTS
done
echo 'echo ""' >> $SCRIPTS
echo 'echo "\t\t            s. - Salir del Menu                  "' >> $SCRIPTS
echo 'echo ""' >> $SCRIPTS
echo 'echo "\t  Ingrese su opcion ==> \\c                         "' >> $SCRIPTS
echo 'read opcion' >> $SCRIPTS
echo 'case $opcion in' >> $SCRIPTS

TOTALX=`expr $TOTAL + 1`
while [ $TOTAL -ge 1 ]
do
 NUMEROX=`expr $TOTALX - $TOTAL`
 TOTAL=`expr $TOTAL - 1`
 echo '\t\t  '${NUMEROX}') echo ""   ' >>$SCRIPTS
 echo '\t\t                ;; ' >>$SCRIPTS
done
 echo '\t\t  S|s) break   ' >>$SCRIPTS
 echo '\t\t           ;;    ' >>$SCRIPTS
echo 'esac' >> $SCRIPTS
echo 'done' >> $SCRIPTS
