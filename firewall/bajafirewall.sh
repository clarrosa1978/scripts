#!/bin/bash
#
# Autor: Pablo Morales pmorales@redcoto.com.ar 2012'
# Departamento de Sistemas
# Administracion AIX

# COTO C.I.C.S.A
#
# Borra las reglas del firewall Sucursal 74

#################################################################
# Control de Programa.

set -e

CheckPrograma() {
   # Programas usados
   IFCONFIG='/sbin/ifconfig'
   #IPTABLES='/usr/sbin/iptables'
   IPTABLES="/sbin/iptables"
   echo -en  '- Control de Ejecutables'
   if ! [ -x $IPTABLES ] ; then
        clear
	echo
	echo 'ERROR : IPTABLES no existe o no tiene permisos para ejecutarlo!'
	exit 1
   fi
   echo ''
}


###################################################################
#
#
ActivarLimpiaReglas(){
  echo -en '- Deshabilitando el Firewall'
  # Borrar Reglas anteriores y Contadores
  $IPTABLES -F
  $IPTABLES -Z 
  $IPTABLES -X
  
  $IPTABLES -P INPUT  ACCEPT
  $IPTABLES -P OUTPUT  ACCEPT
  $IPTABLES -P FORWARD ACCEPT

 echo ' [Done]'
}


###################################################################

sleep 2

  CheckPrograma
  ActivarLimpiaReglas
  

echo ''
echo '[Firewall Deshabilitado]'
