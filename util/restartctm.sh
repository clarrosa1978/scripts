su - ctmsrv -c shut_ctm
su - ctmsrv -c start_ctm
kill -9 "`ps -ef | grep 'root@notty' | grep -v grep  | awk ' { print $2 } '`"
