#!/bin/ksh

##############################################################################
# Acá se ejecuta todo lo que uno quiera hacer después del LSAT - VERSION AIX
# Hugo Messina - 21/06/2012
##############################################################################

archivo=$1

cd /tecnol/sec

echo "Ejecutando post script..."
echo "Post script $(date)\n" >> $archivo
echo "\n****************************************\n" >> $archivo

# Obtiene los valores de de usuarios
echo "Datos de seguridad de usuarios\n" >> $archivo

for i in $(cat /etc/passwd | awk -F : '{ print $1 }')
do
	lsuser $i >> $archivo 2>&1
done

echo "\n****************************************\n" >> $archivo


# Obtiene los valores default de password en el login.defs y login.cfg

echo "Valores default en /etc/security/user y /etc/security/login.cfg\n" >> $archivo
grep -p default: /etc/security/user >> $archivo 2>&1
grep -p usw: /etc/security/login.cfg >> $archivo 2>&1

echo "\n****************************************\n" >> $archivo

