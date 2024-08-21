# Chequeo de equipo para tener una muestra 
# de mediados de Agosto 2005 - Dario Machado
#
date +%d:%m:%H:%M
# vmstat 2 6 |tail -5
vmstat 2 26 |tail -23 |grep -v p |grep -v '-'
echo : 
