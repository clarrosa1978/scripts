#!/bin/ksh

echo "#Baja procesos Samba"
/tecnol/util/down_samba.sh

echo "#Baja procesos SFvcc"
su - sfvcc -c "/tecnol/sfvcc/vcc_offline.sh `date +%d`"

echo "#Baja proceso SFCliendo"
su - sfcliendo -c "/tecnol/sfcliendo/sfc_offline.sh `date +%d`"

echo "#Baja Control-M Server"
su - ctmsrv7 -c "/home/ctmsrv7/ctm_server/scripts/shut_ctm"

echo "#Baja Control-M Agent"
/home/ctmagt/ctm/scripts/shut-ag -u ctmagt -p ALL

echo "#Baja procesos Sfctrl"
su - sfctrl -c "/usr/sbin/killall"

echo "#Baja Base de Datos"
su - oracle -c "lsnrctl stop LSFC"
su - oracle9 -c "lsnrctl stop LCTRLMSF"
/tecnol/util/matalocal
su - oracle -c "dbshut"
su - oracle9 -c "dbshut"

