# Corrige los valores de login individuales y globales para los usuarios en AIX

for i in $(lsuser ALL | awk '{ print $1 }') ; do chuser minage= maxage= maxexpired= minalpha= minother= minlen= mindiff= maxrepeats= loginretries= histsize= $i ; done

chuser loginretries=0 minlen=0 maxage=0 minage=0 maxexpired=0 root

chsec -f /etc/security/user -s default -a minage=1 -a maxage=8 -a maxexpired=2 -a minalpha=4 -a minother=2 -a minlen=7 -a mindiff=3 -a maxrepeats=2 -a loginretries=6 -a histsize=4

chsec -f /etc/security/login.cfg -s usw -a logintimeout=900

