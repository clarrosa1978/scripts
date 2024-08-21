cd /ac/DATOS

date > /ac/DATOS/cotoap.$$

mmdd=`date +%m%d`

cobrun cotoap07

rcp apint$mmdd.dat S80-FNCL:/u08/appl/107/financl/ac/datos
if [ $? = 0 ]
  then 
	mv apint$mmdd.dat* /ac/DATOS/interface
  else
	echo "\n  ATENCION FALLO la copia del archivo apint$mmdd.dat al S80-FNCL \n"
fi

rsh S80-FNCL "cd /u08/appl/107/financl/ac/datos; chown financl.dba apint$mmdd.dat; chmod 644 apint$mmdd.dat"
if [ $? != 0 ]
  then 
	 echo "\n  ATENCION FALLO modificacion de atributos en S80-FNCL del arch. apint$mmdd.dat* \n"
fi

date >> /ac/DATOS/cotoap.$$

echo "Proceso finalizado. "



