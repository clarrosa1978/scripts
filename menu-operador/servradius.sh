echo "Reiniciando service RADIUS en $i"
ssh $1 "/etc/init.d/freeradius restart"
echo "\n\t\tPresione una tecla para continuar"
read
