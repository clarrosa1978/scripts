#!/usr/bin/ksh
#
#desmonta filesystems "abiertos" del volume group ingresado como parametro 1.
# HDP 8/9/2005
################################################################################

if [ $# =! 1 ]
then
	echo "Error ingresar volume group a tratar como paramtro #1"
	exit
else
	VGNAME=$1
fi

clear
echo "\nVolume group a tratar\n"

lsvg -o | grep ${VGNAME}
if [ $? -ne 0 ]
then
	echo "El Volume group no existe, o esta inactivo"
	exit 
fi

##Aca desmonto los fs

#for i in `lsvg -l ${VGNAME} | grep "open/" | grep -v "N/A" | awk ' { print $7 } '`
for i in `lsvg -l ${VGNAME} | grep "closed/" | grep -v "N/A" | awk ' { print $7 } '`
do
	echo "chequeando ${i} \n"
	#unmount ${i}
	fsck ${i}
done
