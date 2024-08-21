groupadd -g 300 oper
groupadd -g 90 sfsw
groupadd -g 503 ctmagt
groupadd -g 501 dba
groupadd -g 506 vtareser
useradd -u 501 -g dba -c "Administrador de base de datos" -d /home/oracle -s /bin/ksh oracle
useradd -u 502 -g ctmagt -c "Agente de Control-M" -d /home/ctmagt -s /bin/bash ctmagt
useradd -u 505 -g sfsw -c "Usuario Aplicacion STS" -d /sts -s /bin/ksh sts
useradd -u 507 -g sfsw -c "Usuario de Mesa de Ayuda" -d /home/mayuda -s /bin/ksh mayuda
useradd -u 510 -g vtareser -c "Venta x Reserva" -d /vtareserva/daemon -s /bin/ksh vprctrl 
useradd -u 700 -g oper -c "Osvaldo Pereiro, Leg.6920, Operador" -d /home/opereiro -s /bin/ksh opereiro
useradd -u 701 -g oper -c "Hugo Cerizola, Leg.6944, Operador" -d /home/cerizola -s /bin/ksh cerizola
useradd -u 702 -g oper -c "Juan Dal Zotto, Leg.78990, Operador" -d /home/dalzotto -s /bin/ksh dalzotto
useradd -u 704 -g oper -c "Alejandro Neer, Leg.89773, Operador" -d /home/aneer -s /bin/ksh aneer
useradd -u 705 -g oper -c "Hector Dubarry, Leg.90252, Operador" -d /home/hdubarry -s /bin/ksh hdubarry
useradd -u 706 -g oper -c "Diego Espindola,Leg. 69603,Operador" -d /home/ope1 -s /bin/ksh ope1
useradd -u 707 -g oper -c "Alejandro Geronimo, Leg. 37723, Operador" -d /home/ope2 -s /bin/ksh ope2
