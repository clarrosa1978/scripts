echo "Generando lvjail"
lvcreate -L 10M -n lvjail rootvg

echo "Generando fs /jail"
mkfs -t ext3 /dev/rootvg/lvjail

echo "Agregando fs a /etc/fstab"
echo "/dev/rootvg/lvjail      /jail           ext3    defaults        1 2" >> /etc/fstab

echo "Montando fs /jail"
mkdir -p /jail
mount /jail

echo "Generando usuario ftpcam"
mkdir -p /jail/ftpcam
useradd -g ftp -d "/jail/ftpcam" -s "/sbin/nologin" -c "ftp Camaras IPAD" ftpcam
chown ftpcam.ftp /jail/ftpcam

echo "Reiniciando servicios ftp"
service vsftpd restart
