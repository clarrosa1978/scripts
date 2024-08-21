set -x
smbcontrol nmbd shutdown
smbcontrol winbind shutdown
smbcontrol smbd shutdown
sleep 5
/opt/pware64/sbin/nmbd -D
/opt/pware64/sbin/smbd -D
/opt/pware64/sbin/winbindd -D
