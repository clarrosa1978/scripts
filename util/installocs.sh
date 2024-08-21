for i in `egrep suc[0-9][0-9]*c /etc/hosts | awk ' { print $2 } ' | sed s/c$//`
do
		echo $i
		scp /instaladores/ocsagent/*rpm $i:/tmp
		scp /instaladores/ocsagent/*tar* $i:/tmp
		ssh $i "rpm -ivh /tmp/perl-5.8.8-6.el4s1_3.i386.rpm --force"
		ssh $i "rpm -ivh /tmp/perl-XML-SAX-0.15-1.noarch.rpm --force"
		ssh $i "rpm -ivh /tmp/perl-XML-Simple-2.18-3.el4.rf.noarch.rpm"
		ssh $i "cd /tmp ; tar xvzf Ocsinventory-Unix-Agent-2.0.5.tar.gz ; rm /tmp/Ocsinventory-Unix-Agent-2.0.5.tar.gz"
		ssh $i "cd /tmp/Ocsinventory-Unix-Agent-2.0.5 ; perl Makefile.PL ; make ; make install"
		ssh $i "mkdir -p /var/log/ocsinventory-agent/"
		ssh $i "cp /usr/bin/ocsinventory-agent /usr/sbin/ocsinventory-agent"
		scp /instaladores/ocsagent/etc/modules.conf $i:/ocsinventory
		scp /instaladores/ocsagent/etc/ocsinventory-agent.cfg $i:/ocsinventory
		ssh $i "/usr/sbin/ocsinventory-agent -f"
		echo
done
