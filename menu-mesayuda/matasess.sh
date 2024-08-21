kill -15 `ps -ef | grep opma | grep -v root | grep -v grep | awk '{ print $2 }' `
