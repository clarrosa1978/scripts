#!/bin/ksh
export AUTORESPONSE=YES
${MENU_CTM}/contingencia/start_database.sh
${MENU_CTM}/contingencia/start_ctmagt.sh
${MENU_CTM}/contingencia/start_ctmem.sh
${MENU_CTM}/contingencia/start_ctmsrv.sh
