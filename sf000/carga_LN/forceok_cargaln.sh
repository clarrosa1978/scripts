#! /bin/ksh
#set -x
##############################################################################
#
# Fuerza al estado "OK" todos los jobs ciclicos que quedaron en espera de
# una nueva ejecucion, para que sean borrados por el "New Day Procedure"
#
#
# Cesar Lopez  -  15/04/2003
#
##############################################################################

# Este script no ejecuta en agentes, pues los mennames de los jobs en el agente
# son iguales a los memnames de los jobs de la cadena en el server.
# Como las cadenas CARGA_NOV_LN (server) y CARGA_NOV_LN-ZE (agente) son iguales,
# mismos jobs y scripts, este programa no puede ejecutar para el agente.
# Para no modificar la cadena en Linux, alteamos este proceso con exit

exit 0

###############################################################################

ODATE=${1}
NODEGRP=${2}
APPLIC=${3}

SQL << eof
create procedure forceok @memname char(30), @odate char(8), @nodegrp char(50), @applic char(20) as
	update CMR_AJF
	set STATE = '8', STATUS = 'Y'
	where MEMNAME = @memname
	and ODATE = @odate
	and NODEGRP = @nodegrp
	and APPLIC = @applic
go
eof

SQL << eof
exec forceok "launch_actualizo.sh", "${ODATE}", "${NODEGRP}", "${APPLIC}"
go
exec forceok "launch_actulistaneg", "${ODATE}", "${NODEGRP}", "${APPLIC}"
go
drop procedure forceok
go
eof

exit 0
