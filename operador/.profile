PATH=/usr/local/bin:$PATH:/tecnol/operador
export PS1=`uname -n`:'${PWD}>'
export PATH
alias menu='cd /tecnol/operador;menu.operador menu.operador.txt'
alias menuserv='cd /tecnol/operador;sudo /tecnol/operador/menu.operador.suc menu.operador.suc.txt'
set -o vi
