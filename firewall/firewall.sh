#!/bin/bash
#
# Autor: Pablo Morales pmorales@redcoto.com.ar 2012'
# COTO C.I.C.S.A
# Departamento de Sisemas - Administracion UNIX  
#
#################################################################
# Control de Programa.
#################################################################
#
# Firewall Sucursal 74
#
set -e

CheckPrograma() {
   # Programas usados
   IFCONFIG='/sbin/ifconfig'
   #IPTABLES='/usr/sbin/iptables'
   IPTABLES="/sbin/iptables"
   echo -en  'Control de Ejecutables                       '
   if ! [ -x $IPTABLES ] ; then
        clear
        echo
        echo 'ERROR : IPTABLES no existe o no tiene permisos para ejecutarlo!'
        exit 1
   fi
   echo '[Done]'
   echo ''
}

#################################################################
#
# Seteos a Nivel del Kernel.
# 
#
KernelSettings() {

  echo '- Kernel Parameters ' 

  echo 1 > /proc/sys/net/ipv4/tcp_syncookies
  echo '       TCPSync (Floods) [Disabled]'

  echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
  echo '       BradCast Responce [Disable] ' 

  echo 1 > /proc/sys/net/ipv4/ip_forward
  echo '       IP Forwarding [Enabled]'

  # Requerido  para IPSec
  echo 0 > /proc/sys/net/ipv4/conf/eth0/secure_redirects
  echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects
  echo 0 > /proc/sys/net/ipv4/conf/eth0/accept_redirects
  echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects
  echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
  echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects
  echo 0 > /proc/sys/net/ipv4/conf/lo/send_redirects
  echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
  echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects
  echo 0 > /proc/sys/net/ipv4/conf/lo/accept_redirects
  echo 0 > /proc/sys/net/ipv4/conf/eth0/accept_redirects
  echo '       IPSEC Settings [Enabled]'

 echo '[Done]'
 echo ''
}

################################################################
#
#
VariablesSistema() {
  echo  '- Varibales del Sistema '

# Interfaz por la cual se generaran las virtuales.
  LOOPBACK='lo'
  LOOP='127.0.0.1'
  ETH_PRIMARIA='eth0'
  ETH_EXTERNA='eth1'

  # Direcciones IP del Firewall.
  # Esta es mi IP
  D_INTERNA='129.74.255.253'
  # Red Interna, mi red
  MISUBRED='129.74.0.0/255.255.0.0'
  MISUBRED1='129.74.255.0/255.255.255.0'
  MISUBRED2='128.2.0.0/16'
  
  # Mesa de Ayuda
  MAYUDA='172.16.57.0/255.255.255.0'
  
  D_EXTERNA='1.1.1.1'
  NTPSERVER='128.2.254.180'
  RELAYINTERNO='172.16.3.61'
  CTM01='172.16.7.10'

  #Otras redes
  RED_INTERNA2='172.16.0.0/255.255.0.0'
  RED_INTERNA3='128.2.0.0/255.255.0.0'
  RED_INTERNA4="129.0.0.0/255.0.0.0"

  #Otros Equipos.
  ANY_EQUIPO='0/0'

  ADM01='172.16.7.39'
  
  # Subred IP Fijas
  REDCAJAS1='129.74.102.0/24'
  
  # Subred IP's Dinamicas
  REDCAJAS2=''

  # Solicitado por Ing Alejandro M. Roberto
  MMONTERO='128.2.109.11'
  AROBERTO='128.2.107.62'
  LAURA='172.16.57.250'
  ALANDUN='172.16.51.15'
  TERESAPAZ='172.16.57.71'
  JORGEHEBER='129.107.103.109'
  LUCASARGUELLO='172.30.205.126'
  CIROMARTIN='172.16.51.128'
  CLAUDIOSORIA='172.16.51.26'
  JORGESANDOLVAL='128.2.108.105'
  ATILOCASADEI='172.16.51.61'
  JORGEGONZALEZ='128.2.107.121'
  CARLOSGIUNTOLI='172.16.51.174'
  FFALLARDI='128.2.107.123'
 
  # Coto Digital.
  NTSXXX=''
 
 
  # Las sucursales reciben informacion desde SF000, 
  # actualizaciones de clientes,precios, etc.
  SF000='172.16.7.32' 
 
  OSIRIS='172.16.8.10' 
  PSP1='128.2.254.91'
 
  # Lo pidio auditoria para que se conecte al 1521
  DWH='172.16.7.20'

  #Backup de sucursales
  SP9='172.16.7.40'  

  GDM='172.16.7.13'
  PUCARA='130.93.254.1' 
  NTSANDES='172.16.3.54' 
  NTSSQL11='172.16.3.130'
  NTSWEB8='172.16.3.85'
  NTSWEB7='128.2.101.146'
  NTSNORTE='172.16.3.55'
  NTSPAMPA='172.16.3.102'


  # En principio esta solo hablitado en la suc02
  NTSINTRANET='192.168.2.20'

  # Servicio de Maquinas Zona E!
  NTSZE=''

  # FTP de camaras
  NTSALFRED3='128.2.101.72'
  REDFTP='129.74.22.0/24'
  
  #Servidores de DNS /etc/resolv.conf 
  DNSSERVER1='128.2.254.180'
  DNSSERVER2='172.16.3.50'
  DNSSERVER3='130.93.253.240'
  
  SLNXAPP3='172.16.8.16'
  
  # Es el online1 
  TARJETAS='10.10.10.100'

  # IP's de los DBA
  NTSDBA='172.16.3.30' 
  DBAS='128.2.108.103 128.2.107.111 128.2.105.121 128.2.108.213'
  GRIDDBA='172.16.8.21'
  
  # Seguridad de la informacion solicito acceso a la base de SF
  # para poder crear los usuarios
  SEGINFORMACION='128.2.107.0/24'

  # Jose Chariano pidio este rango de IP
  MULTISTORE='129.199.0.0/24'


 ######################

  # Servicios
  DNS="53"
  RSYSLOG='514'
  RSYNC='873'
  IPSEC_IKE='500'
  IPSEC_NAT='4500' 
  FTP='20:21'
  HTTP='80'
  HTTPS='443'
  HTTP1='8080'
  SSH='22'
  TELNET='23'
  POP='110'
  SMTP='25'
  LDAP='389'
  SQUID="3128"
  PRINTER='515'
 
  ANY_PORT='1:65535'
  UNPRIV='1024:65535'
  LISTENER='1521'
  NFS_TCP='111 2049'
  # 969 972'
  NFS_UDP='111 2049'
  # 969 972'
  
  # Nagios Monitoring
  SNMP='161'
  
  NTP='123'
  CONTROLM='9005:9007 1524 2370:2371'
  # 3872'
  XORG='6001'
  VNC='5900:5901'
  DHCP='67:68'
  MYSQL='3601'
  
  # Samba se hablita por defecto, en las sucursales existe un directorio
  # llamado transfer desde el cual se copian archivos.
  SAMBATCP='445 139'
  SAMBAUDP='137:138'
  
  # Puertos que usan las cajas
 #STOREFLOWTCP='3580 4580 5200 5510 5520 6580 6550 6560 6580 6750 7373 7904 8580 9985 24500:24501 24600:24601 50000 65240:65251'
 #STOREFLOWUDP='6600:6699 6550 6560 6570 6750 65001 65003 65011 65013'

 #STOREFLOWTCP='5200 5510 5520 6580 6550 6560 6580 6750 7373 24500:24501 24600:24601 50000 65240:65251'
 #STOREFLOWUDP='6600:6699 6570'


  STOREFLOWTCP='6580 7373'
  STOREFLOWUDP='6600:6699'
 

  # Ticket Status, esta en todas las suc para consultar el estado de un tk
  TKSTATUS='10101'

  # Detalles de precios en los verificadores de precios.
  PRECIOS='9001' 



# ---  Estos son los servicios comunes que usamos en Activar_Principal 

  SERVICIOS_TCP="$SAMBATCP $PRINTER $VNC"
  SERVICIOS_UDP="$DNS $SNMP $NTP $SAMBAUDP $RSYNC $DHCP"

echo ''
echo ''

  echo '==========================================='
  echo  "Servidor de Camaras $NTSALFRED3"
  echo  "Servidor de NTP $NTPSERVER"
  echo  "Relay Interno $RELAYINTERNO"
  echo  "Mi Direccion IP $D_INTERNA"
  echo  '=========================================='
  echo ''

echo ''

}

######################################################################
#
#
# Reglas de Negacion por defecto.
#
ActivarNegacion(){
  echo  '- Activando Negacion'
  # Borrar Reglas anteriores y Contadores
  $IPTABLES -F
  $IPTABLES -Z
  $IPTABLES -X


 # Negamos todo menos la salida
 $IPTABLES -P INPUT  DROP
 $IPTABLES -P OUTPUT  ACCEPT
 $IPTABLES -P FORWARD DROP

 $IPTABLES -A INPUT -m state --state INVALID -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
 $IPTABLES -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP


}


######################################################################
#
#
#
#
ActivarInterfases() {

  echo  '- Activando LoopBack '
  
  # Control de FTP, no se usa, pero trata de conectase
  # constantemente y loguea constantemente. 
  $IPTABLES -A INPUT -s 128.2.101.76 -d $D_INTERNA -j DROP

  # Por ejemplo, el envio de mail conecta al localhost.
  $IPTABLES -A INPUT -i $LOOPBACK -s $LOOP -d $LOOP -j ACCEPT
  
  # Hay servicios locales que conectan a la IP en vez del LOOPBACK
  $IPTABLES -A INPUT  --source $D_INTERNA \
  	 --destination $D_INTERNA \
  -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT


  # Esta regla permite el trafico que pertenezca a conexiones en condicion
  # de ESTABLISHED, no tiene nada que ver con permitir todo de cualquier lado
  # recordemos que la INPUT policy es DROP
  $IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  
  # Permitimos conexiones salientes.
  $IPTABLES -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

}

######################### PRINCIPAL ###################################
#
#
# Funcion principal que habilita servicios comunes que presta
# el servidor, otros servicios requieren un tratamiento especial
#
#
Activar_Principal(){
echo '- Activando Principal '

for puerto in $SERVICIOS_TCP  
   do
     $IPTABLES -A INPUT -p tcp -s $ANY_EQUIPO -d $D_INTERNA \
	--dport $puerto -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT 

   done

for puerto in $SERVICIOS_UDP   
   do
     $IPTABLES -A INPUT -p udp -s $ANY_EQUIPO -d $D_INTERNA \
	--dport $puerto -m state --state NEW,ESTABLISHED -j ACCEPT 

   done


}

#######################################################################
#
#
# Comunicacion entre servidores de mi red interna permito todo el
# trafico
#

ServidoresRedInterna(){

echo  '- Activando Servidores Red Interna '

for servidor in $TARJETAS $SF000
   do
        $IPTABLES -A INPUT -s $servidor \
	 -m state --state NEW,RELATED,ESTABLISHED \
	 -d $D_INTERNA -j ACCEPT
   done

}

#######################################################################
#
#
# Comunicacion entre servidor y cajas
# 
#
Activar_Cajas(){
echo '- Activando Cajas '

  for server in $REDCAJAS1 
    do
      #for puerto in $STOREFLOWUDP
      #   do
            $IPTABLES -A INPUT -s $server -d $D_INTERNA \
             -m state --state NEW,ESTABLISHED -j ACCEPT
      #    done
   done


}


######################################################################
#
# Configurando opciones de Logeo.
#
#
ActivarLogeo(){

  echo '- Activando Logs '

# Para no llenar /var/log/messages en rsyslog.conf o syslog.conf agregar
# kern.crit  /var/log/iptables.log
# --log-level 2 corresponde a crit, ver man syslog.

       #define KERN_EMERG    "<0>"  /* system is unusable               */
       #define KERN_ALERT    "<1>"  /* action must be taken immediately */
       #define KERN_CRIT     "<2>"  /* critical conditions              */
       #define KERN_ERR      "<3>"  /* error conditions                 */
       #define KERN_WARNING  "<4>"  /* warning conditions               */
       #define KERN_NOTICE   "<5>"  /* normal but significant condition */
       #define KERN_INFO     "<6>"  /* informational                    */
       #define KERN_DEBUG    "<7>"  /* debug-level messages             */

$IPTABLES -N AUDITA-TRAFICO
$IPTABLES -A INPUT -j AUDITA-TRAFICO


         $IPTABLES -A AUDITA-TRAFICO -d $D_INTERNA \
         -m limit --limit 10/s -j LOG \
         --log-prefix "DENEGADO " --log-level 2 
	 
         $IPTABLES -A AUDITA-TRAFICO -j DROP

}


######################################################################
#
#
#
#
ActivarPing() {

  echo '- Activando Ping Interno  '
  
 # Ping permitido desde la intranet.
  $IPTABLES -A INPUT -p icmp --icmp-type 8 -s $ANY_EQUIPO \
	 -d $D_INTERNA -m state --state NEW,ESTABLISHED,RELATED \
	-j ACCEPT 
  
  $IPTABLES -A INPUT -p icmp --icmp-type 0 -s $ANY_EQUIPO -d $D_INTERNA \
         -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

}


#####################################################################
#
#
#
#
Activar_ControlM(){
echo '- Politica [ Habilito Control-M ]'

for servidor in $CTM01 
   do

   for i in $CONTROLM 
    do

      $IPTABLES -A INPUT -p tcp -s $servidor -d $D_INTERNA \
      --dport $i -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
    done


   done

}

######################################################################
#
#
#
#
Activar_SSH(){
echo '- Politica [ Habilito SSH ]'

for servidor in $SLNXAPP3 $ADM01 $SP9 $GDM $SF000 $PSP1 
    do

       for puerto in $SSH
        do
           $IPTABLES -A INPUT -p tcp -s $servidor -d $D_INTERNA \
	    --dport $puerto -m state --state NEW,ESTABLISHED -j ACCEPT
        done
    done

}

######################################################################
#
#
#
#
Activar_Oracle(){

echo '- Politica [ Habilito Oracle ]'

   for server in $DBAS $NTSDBA $MAYUDA $NTSWEB8 $NTSINTRANET \
		 $PUCARA $GRIDDBA $NTSANDES $NTSSQL11 \
		 $GDM $AROBERTO $MMONTERO $OSIRIS $LAURA \
		 $ALANDUN $NTSNORTE $NTSWEB7 $FFALLARDI \
                 $JORGEHEBER $LUCASARGUELLO $CIROMARTIN \
    		 $CLAUDIOSORIA $JORGESANDOLVAL $ATILOCASADEI \
  	         $JORGEGONZALEZ $CARLOSGIUNTOLI $DWH \
		 $SEGINFORMACION $MULTISTORE $NTSPAMPA
    do
	for i in $LISTENER
   	 do
            $IPTABLES -A INPUT -p tcp -s $server -d $D_INTERNA \
            --dport $i -m state --state NEW,ESTABLISHED -j ACCEPT 
         done
   done


}

#####################################################################
#
#
#
#
Activar_RelayInterno(){
echo '- Politica [ Habilito Relay Interno - MAIL ]'

        $IPTABLES -A INPUT -p tcp -s $RELAYINTERNO \
	 --sport $SMTP -d $D_INTERNA --dport $UNPRIV \
	 -m state --state ESTABLISHED -j ACCEPT

}

####################################################################

Activar_StoreFlow(){
echo -en '- Politica [ Habilito StoreFlow - Servicio de Cajas ]'

# Por alguna otra consulta, preguntar a Soporte Storeflow
# El proceso SF_VCC que corre en el DBT01 esta escuchando
# peticiones desde las sucursales (proceso tpv2vcc) y para
# el cobro de Tarjetas Propias, Envios a Domicilio y
# Fidelizacion Clarin / Nacion

# Todo tiene relacion, no es solo los puertos entre las cajas
# y el servidor, sino tambien hay conexiones a otros servidores
# DBT01, SF000

# Con este error que me dio, acusaron error al procesar una
# de las cajas y nada que ver, es entre dbt01 y suc250

# Esto es, del dbt01 con source port 5200 se conecto a la
# suc250

# Aug 22 15:43:38 suc250 kernel: IPTables Packet Dropped -> : 
# IN=eth0 OUT= MAC=00:01:02:c1:1b:f7:00:04:0d:1a:f0:fa:08:00 
# SRC=172.16.7.23 DST=192.168.250.253 LEN=60 TOS=0x00 PREC=0x00 
# TTL=59 ID=21696 PROTO=TCP SPT=5200 DPT=50543 
# WINDOW=65535 RES=0x00 ACK SYN URGP=0 

# El arhivo de log es /sfctrl/tmp/vcc2tpv.17.log

# Puerto en el que se escucha a las sucursales (TPV2VCC)
# PuertoAtencionDeSucursales:5200
# Puerto en el que se responden las peticiones (VCC2TPV)
# PuertoEscribeVCC:5510

# * 8580 y 7373 para produccion Central.
# * 6580 y 7373 para produccion Sucursales.

# En produccion hay que deshabilitar estos:
# * 4580 y 7373 para produccion Testing.
# * 3580 y 7373 para produccion Desarrollo


# Esta funcion no se hablito y se opto por habilitar todo el trafico
# entre las cajas y el servidor, nunca se pudo determinar todos los
# puertos relacionados, en los logs del firewall se veian intentos
# a puertos altos los cuales nunca se pudieron identificar.


###--- Comienzo


   for caja in $REDCAJAS1 $REDCAJAS2 $SF000 
    do

       for puerto in $STOREFLOWTCP
        do
               $IPTABLES -A INPUT -p tcp -s $caja -d $D_INTERNA --dport $puerto\
               -m state --state NEW,ESTABLISHED -j ACCEPT

        done
    done


   for caja in $REDCAJAS1 $REDCAJAS2 $SF000   
      do

        for puerto in $STOREFLOWUDP
         do
                $IPTABLES -A INPUT -p udp -s $caja -d $D_INTERNA --dport $puerto\
                -m state --state NEW,ESTABLISHED -j ACCEPT

        done
     done
echo '[Done]'

}

########################################################################
#
#
# Recordar cargar el modulo ip_conntrack_ftp, leer la documentacion
# que esta en la Wiki, Revision 4 al final del documento.
# esta IP 128.2.101.76 es de control y no se usa, pero como la bloqueamos
# el log lo reporta, asi que en el AUDIT la exclui.
#

Activar_FTP(){
echo '- Politica [ Habilito FTP ]'

   for server in $REDFTP $NTSALFRED3 
    do
        for i in $FTP
         do
            $IPTABLES -A INPUT -p tcp -s $server -d $D_INTERNA \
            --dport $i -m state --state NEW -j ACCEPT
         done
   done


}

#########################################################################
#
#
#
Activar_NTPClient(){

echo '- Politica [ Habilito Cliente NTP ]'

        $IPTABLES -A INPUT -i $ETH_PRIMARIA -p udp -s $NTPSERVER \
        -d $D_INTERNA --dport $NTP -j ACCEPT 


}

#########################################################################
#
#
#
Activar_DNS(){
echo '- Politica [ Habilito Consultas DNS ]'

for server in $DNSSERVER1 $DNSSERVER2 $DNSSERVER3
    do
        for i in $DNS
        do
                $IPTABLES -A INPUT -p udp -s $server \
		 --sport $DNS -d $D_INTERNA \
		 --dport $UNPRIV -i $ETH_PRIMARIA  -j ACCEPT 
        done
   done


}

########################################################################
#
#
#
#
Activar_HTTP(){
echo '- Politica [ Habilito HTTP ]'

for server in $MISUBRED $MAYUDA $MISUBRED2
    do
           for i in $HTTP
           do   

             $IPTABLES -A INPUT -p tcp -s $server -d $D_INTERNA \
              --dport $i -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT

           done 
   done

}


#######################################################################
#
#
#
#
Activar_TKStatus(){
echo '- Politica [ Habilito Ticket Status ]'

for server in $MAYUDA $MISUBRED1
    do
        for i in $TKSTATUS
         do
            $IPTABLES -A INPUT -p tcp -s $server -d $D_INTERNA --dport $i \
            -m state --state NEW,ESTABLISHED,RELATED  -j ACCEPT
        
        done
   done


}


#######################################################################
#
#
#
#
Activar_Precios(){
echo '- Politica [ Habilito Verificador de Precios ]'

   for i in $PRECIOS
   do

      $IPTABLES -A INPUT -p tcp -s $MISUBRED1 -d $D_INTERNA \
      --dport $i -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
   
   done


}


#######################################################################
#
#
# Encriptacion de datos entre las cajas y el servidor de la sucursal.
#
#
Activar_IPsec(){

echo '- Politica [ Habilito IPSec ]'
       
for server in $REDCAJAS1 
    do
        for i in $IPSEC_IKE
         do
            $IPTABLES -A INPUT -p udp -s $server -d $D_INTERNA --dport $i \
	    -m state --state NEW,ESTABLISHED,RELATED  -j ACCEPT
            
            # AH and ESP son protocolos de transporte y no tienen
            # un puerto asociado,en teoria usan el 50y 51.
 	    $IPTABLES -A INPUT -p esp -s $server -d $D_INTERNA \
	    -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT 
        
	    $IPTABLES -A INPUT -p ah -s $server -d $D_INTERNA \
	    -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
 
	done
   done


}

########################################################################
#
#
# Mesa de ayuda consulta Multistore
#
#
Activar_Mayuda(){

echo '- Politica [ Habilito Mesa de Ayuda ]'

        for i in $STOREFLOWTCP
         do
            $IPTABLES -A INPUT -p tcp -s $MAYUDA -d $D_INTERNA \
            --dport $i -m state --state NEW,ESTABLISHED -j ACCEPT
         done

}


########################################################################
#
#
#
#
Activar_Multistore(){

echo '- Politica [ Habilito Multistore ]'


for server in $MULTISTORE
    do

       for puerto in $STOREFLOWTCP
        do
           $IPTABLES -A INPUT -p tcp -s $server -d $D_INTERNA --dport $puerto\
           -m state --state NEW,ESTABLISHED -j ACCEPT
        done
    done

}




######################################################################
#
#                              PRINCIPAL
#
#
######################################################################

sleep 2

  CheckPrograma
  KernelSettings
  VariablesSistema
  ActivarNegacion
  ActivarInterfases
  ActivarPing
  
  #Esta es la funcion principal
  Activar_Principal
  ServidoresRedInterna
  
  Activar_ControlM
  Activar_Cajas
  #Activar_StoreFlow
  Activar_Oracle
  Activar_SSH
  Activar_RelayInterno
  Activar_DNS
  Activar_NTPClient
  Activar_HTTP
  Activar_FTP
  Activar_TKStatus
  
  # Esta en la misma subred que las cajas, asi que no lo habilito
  # ya que las cajas tienen permitido todo el trafico.
  # Activar_Precios

  Activar_Mayuda
  Activar_Multistore

  # Como desde las cajas permitimos todo el trafico
  # no utilizamos esta funcion.
  #Activar_IPsec 
  
  # Esta regla debe ser siempre la ultima en activarse
  ActivarLogeo

echo ''
echo '[Reglas Activadas]'
