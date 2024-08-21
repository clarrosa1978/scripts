###############################################################################
# Autor..............:  C.A.S                                                 #
# Usuario ...........:  root                                                  #
# Objetivo...........:  Mantener la misma Lista en todos los equipos de CTRAL #
# Nombre del programa:  ReplicarListas.ksh                                    #
# Descripcion........:  Modifica el archivo /etc/aliases                      #
# Modificacion.......:  10/08/2002                                            #
###############################################################################

###############################################################################
#                        Definicion de variables                              #
###############################################################################

OPERADOR_WRK=/tecnica/operador
LISTA_EQUIPOS="sp17 sap1 sap2 sp1 sp9 sp10 S80-FNCL H70-KARDEX"
ARCH_ALIAS=/etc/alises
DOMINIO="coto.com.ar"
A=`tput bold`
B=`tput rmso`

#-----------------------------------------------------------------------------#
#                          Funcion Comunicacion                               #
#-----------------------------------------------------------------------------#

function Comunicacion
{
ping -c 3 $i 2>&1 >/dev/null
if [ $? -ne 0 ]
 then 
  return 1
fi
}

#-----------------------------------------------------------------------------#
#                          Funcion Comunicacion                               #
#-----------------------------------------------------------------------------#
 
###############################################################################
#                              Principal                                      #
###############################################################################

$OPERADOR_WRK/encabezado.ksh $0

for i in `echo $LISTA_EQUIPOS`
 do
  Comunicacion $i
  if [ $? -ne 0 ]
   then 
    echo "\t Lista no replicada en $i"
    sleep 1
   else
    cat $ARCH_ALIAS |grep -v "^#" |grep -v "^$" | awk -F":" '{ print $1, $2 }'\
    | while read FIELD1 FIELD2
      do
       rsh $i \ 
        '( if [ -f '$ARCH_ALIAS' -a `grep -wc $FIELD1 '$ARCH_ALIAS'` -eq 0 ]
            then
             echo "'$FIELD1': '$FIELD2'" >> '$ARCH_ALIAS'
           fi
        )'
      done
      rsh $i '( 
                if [ -r /usr/sbin/newaliases ]
                 then
                  /usr/sbin/newaliases
                 else
                  if [ -r /usr/sbin/sendmail ]
                   then 
                    /usr/sbin/sendmail -bi 
                  fi
                fi
             )'
          
  fi
done
