#!/bin/ksh

###########################################################
# Ejecuta LSAT y el post script. Hugo Messina. 19/06/2012 
###########################################################

archivo="scan.$(hostname).$(date +%Y%m%d)"

cd /tecnol/sec

# Hace backup de archivos previos
rm -f *bak
for i in $(ls *gz) ; do mv $i $i.bak ; done

# Ejecuta lsat
lsat -s -x exclude.txt
mv -f lsat.out $archivo

# Ejecuta post script
sh post_script.sh $archivo

#Comprime resultado
gzip -f $archivo

