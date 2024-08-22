#!/bin/ksh


echo "#Levanta procesos Samba"
/tecnol/util/up_samba.sh

echo "#Levanta Base de Datos"
su - oracle -c "dbstart"
su - oracle -c "lsnrctl start LSFC"
su - oracle9 -c "dbstart"
su - oracle9 -c "lsnrctl start LCTRLMSF"

echo "#Levanta procesos Sfctrl"
su - sfctrl -c "/sfctrl/bin/scripts/preipl"
su - sfctrl -c "/sfctrl/bin/scripts/postipl"

echo "#Levanta Control-M Agent"
/home/ctmagt/ctm/scripts/start-ag -u ctmagt -p ALL

echo "#Levanta Control-M Server"
su - ctmsrv7 -c "/home/ctmsrv7/ctm_server/scripts/start_ctm"

echo "#Levanta procesos SFcliendo"
su - sfcliendo -c /tecnol/sfcliendo/sfc_online.sh `date +%d`

echo "#Levanta procesos SFvcc"
su - sfvcc -c /tecnol/sfvcc/vcc_online.sh `date +%d`
