#!/usr/bin/ksh
set -x
/usr/IBMAHS/bin/apachectl start
echo -e "\n\n Levantando servicio httpd(apache), pulse una tecla"
read tecla
