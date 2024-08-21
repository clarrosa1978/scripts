#!/bin/bash

IPT='/sbin/iptables'
GREP='/bin/grep'
AWK='/bin/awk'
EXPR='/usr/bin/expr'
WC='/usr/bin/wc'
HOST=`hostname -s`
STAT=0
OUTPUT=''
CHAINS=`$IPT -nvL | $GREP 'Chain' | $AWK '{ print $2 }'`

for CHAIN in $CHAINS ; do
        if [ "$CHAIN" != 'FORWARD' ] && [ "$CHAIN" != 'OUTPUT' ] && [ `$EXPR substr $CHAIN 1 4` != "LOG_" ] ; then
                CNT=`expr $($IPT -nL $CHAIN | $WC -l) '-' 1`

                if [ $CNT -eq 1 ] ; then
                        OUTPUT="<b>${OUTPUT}ERROR $CHAIN $CNT rules!</b><br>"
                        echo "Firewall Desactivado En $HOST" | mailx -s "Alerta IPTables"  adminaix@redcoto.com.ar
                        STAT=2
                #else
                #        OUTPUT="${OUTPUT}OK $CHAIN $CNT rules<br>"

                fi
        fi
done

echo $OUTPUT

exit $STAT
