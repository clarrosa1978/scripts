/tecnol/scripts/matar sfctrl
su - sfctrl -c "/sfctrl/bin/scripts/preipl 1>/dev/null 2>/dev/null"
su - sfctrl -c "/sfctrl/bin/scripts/postipl 1>/dev/null 2>/dev/null"
kill -9 "`ps -ef | grep 'root@notty' | grep -v grep  | awk ' { print $2 } '`"
