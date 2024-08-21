###########################################################################################
#NOMBRE DEL SCRIPT: VerColasImp.sh                                                        #
#DESCRIPCION: Chequea el estado de una cola de impresion de seleccionada de una sucursal  #
#AUTOR: CFL                                                                               #
#FECHA DE MODIFICACION: 23-01-2002                                                        #
###########################################################################################

###########################################################################################
#        I                            PRINCIPAL                                           #    
###########################################################################################

clear
echo "\n\n\n\n\n"
for i in `rsh suc${Sucnro} lsallq`
do
  echo "\t$i\c"
done
echo "\n\n\tIngrese la cola de impresion a chequear: \c"
read ColaImp
Esta=no
for i in `rsh suc${Sucnro} lsallq`
do
  if [ "$i" = "$ColaImp" ]
  then
      Esta=si
  fi
done
if [ "$Esta" = "no" ]
then
    echo "\n\n"
    echo "\t                             ************************"
    echo "\t                             *   COLA INEXISTENTE   *"
    echo "\t                             ************************"
    echo "\n\n\n\n\n"
else
    echo "\n"
    rsh suc${Sucnro} lpstat -a$ColaImp
fi
PTecla
