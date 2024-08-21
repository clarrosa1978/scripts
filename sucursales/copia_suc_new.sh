#!/bin/bash
clear
echo "#####################################################"
echo "     Vamos a COPIAR los FS desde el Server VIEJO:    "
echo "#####################################################"
echo "Los FS a copiar son: (transfer, vtareserva, tecnol, sts, home, sfctrl, expora, files, u011, rman, digital, multimedia, backup_nt)"
echo""

read -ep "Ingrese la IP O Hostname del servidor VIEJO: " IP
SF=$(df -h|grep "/oradata/SF"|awk '{print $5}'|cut -c14-20)
CTM=$(df -h|grep "/oradata/CTM"|awk '{print $5}'|cut -c14-20)

sleep 1

cd /
rsync -r -a -v -e 'ssh -l root'  $IP:/transfer /
rsync -r -a -v -e 'ssh -l root'  $IP:/vtareserva /
rsync -r -a -v -e 'ssh -l root'  $IP:/tecnol /
rsync -r -a -v -e 'ssh -l root'  $IP:/sts /
rsync -r -a -v -e 'ssh -l root'  $IP:/home  /
rsync -r -a -v -e 'ssh -l root'  $IP:/sfctrl /
rsync -r -a -v -e 'ssh -l root'  $IP:/expora /
rsync -r -a -v -e 'ssh -l root'  $IP:/files /
rsync -r -a -v -e 'ssh -l root'  $IP:/u011  /
rsync -r -a -v -e 'ssh -l root'  $IP:/rman  /
rsync -r -a -v -e 'ssh -l root'  $IP:/digital /
rsync -r -a -v -e 'ssh -l root'  $IP:/multimedia /
rsync -r -a -v -e 'ssh -l root'  $IP:/backup_nt /
	scp -pr $IP:/etc/sysconfig/iptables /etc/sysconfig/iptables
	scp -pr $IP:/etc/hosts /etc/hosts
	scp -pr $IP:/etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg
	scp -pr $IP:/etc/sudoers /etc/sudoers
	scp -pr $IP:/etc/snmpd.conf /etc/snmpd.conf
	scp -pr $IP:/etc/rsyncd.conf /etc/rsyncd.conf
echo "Traigo las llaves desde el servidor $IP:"
ssh $IP "tar cvf /etc/ssh/ssh_host.tar /etc/ssh/ssh_host_*"
scp -p $IP:/etc/ssh/ssh_host.tar  /etc/ssh/
cd /
tar xvf /etc/ssh/ssh_host.tar
chkconfig rsync on && chkconfig nrpe on
usermod -aG sys,sfsw,dba,oinstall sysadm && usermod -g root sysadm && usermod -aG root,sys,sfsw,dba transfer && usermod -g root transfer
echo "Checkeo si las DB estan arriba..."
ssh $IP "ps -ef|grep pmon|grep -v grep"
if [ $? != 0 ]
 then
        rsync -r -a -v -e 'ssh -l root'  $IP:/u02/oradata/$SF/  /u02/oradata/$SF
        rsync -r -a -v -e 'ssh -l root'  $IP:/u02/oradata/$CTM/  /u02/oradata/$CTM
	echo "Termino de copiar las bases."
	exit 0
 else
        echo "Las bases estan arriba.Vuelva a ejecutarlo cuando baje las bases."
        exit 2
fi
