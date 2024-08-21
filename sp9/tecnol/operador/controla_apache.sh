#!/usr/bin/ksh
echo -e "\n\n Estado de servicio httpd(apache)"
ps -ef | grep httpd
echo "Pulse una tecla para continuar ..."
read tecla
