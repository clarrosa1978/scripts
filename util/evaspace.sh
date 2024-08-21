export server=$1
for i in `sudo rsh $server lshsv | grep -v CCL | awk ' { print $1 } '`
do
	export space=`sudo rsh $server lspv $i | grep "TOTAL PPs:" | awk ' { print $4 } ' | sed "s/(//"`
	let "sum= $sum+$space"
done
echo "Servir: $server                 Espacio en Gb utilizado en EVA: \c"
echo "scale = 2 ; ${sum}/1024" | bc
