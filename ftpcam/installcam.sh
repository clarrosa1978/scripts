SUC=suc9129
ssh ${SUC} "rm /etc/vsftpd.*"
scp user_list_local ${SUC}:/etc/vsftpd
scp vsftpd.ftpusers ${SUC}:/etc
scp vsftpd.conf ${SUC}:/etc/vsftpd
scp vsftpd.chroot_list ${SUC}:/etc
scp creaent.sh ${SUC}:/root
ssh ${SUC} "chmod 540 /root/creaent.sh"
ssh ${SUC} "/root/creaent.sh ${1}"
echo "Cambiando password usuario ftpcam"
cd /home/root
./massPassSet.exp ftpcam ftpcam ${SUC}
