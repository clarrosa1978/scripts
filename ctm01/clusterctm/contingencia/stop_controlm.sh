#!/bin/ksh
${MENU_CTM}/contingencia/stop_ctmsrv.sh
${MENU_CTM}/contingencia/stop_ctmem.sh
${MENU_CTM}/contingencia/stop_ctmagt.sh
su - ctmsrv -c /usr/sbin/killall
