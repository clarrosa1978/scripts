#!/usr/bin/expect 

if $argc<7 {
  send_user "$argv0: faltan parametros\n"
  send_user "\n"
  send_user " Usuario            : Nombre del usuario.\n"
  send_user " Password           : Password del usuario.\n"
  send_user " IP/Host            : Direccion IP o nombre del host.\n"
  send_user " Directorio_Origen  : Directorio origen del archivo.\n"
  send_user " Directorio_Destino : Directorio destino donde se guardara el archivo.\n"
  send_user " Archivo            : Nombre del archivo que se tiene que bajar.\n"
  send_user " Fecha              : Fecha del dia para bajar el archivo.\n\n"
  exit
}

#
# Obtengo los datos que pasan.
#
set USUARIO            [lindex $argv 0]
set PASSWORD           [lindex $argv 1]
set IP                 [lindex $argv 2]
set DIRECTORIO_ORIGEN  [lindex $argv 3]
set DIRECTORIO_DESTINO [lindex $argv 4]
set ARCHIVO            [lindex $argv 5]
set FECHA              [lindex $argv 6]

#
# 

spawn -noecho sftp ${USUARIO}@${IP}
#set timeout 10

#expect {
# timeout {puts "El tiempo de conexion ha expirado verifique si la ip es correcta.\n";exit 1}
#} 

expect "${USUARIO}@${IP}'s password:"
send "${PASSWORD}\r"
expect  {
   "ssh: connect to host ${IP} port 22: Connection timed out" {puts "El tiempo de conexion ha expirado\n";exit}
   "Connection closed" {puts "El tiempo de conexion ha expirado\n";exit}
   "Permission denied, please try again." {puts ("Usuario incorrecto no tiene permiso.\n";exit}
   "Connection to ${IP} closed by remote host." {puts "Password incorrecta.\n";exit}
}

expect  "sftp>"
send "cd ${DIRECTORIO_ORIGEN}\r"
expect  {
  "Couldn't canonicalise: No such file or directory" {puts "No existe el directorio : ${DIRECTORIO_ORIGEN}\n";exit 1}
}

expect "sftp>"
send "ls ${ARCHIVO}\r"
expect {
  "Couldn't stat remote file: No such file or directory" {puts "No existe el archivo indicado : ${ARCHIVO}\n";exit 1}
}

expect "sftp>"
send "get ${ARCHIVO} ${DIRECTORIO_DESTINO}\r"

expect "sftp>"
send "lls ${DIRECTORIO_DESTINO}/${ARCHIVO}\r"
expect {
  "Couldn't stat remote file: No such file or directory" {puts "No existe el archivo indicado : ${ARCHIVO}\n";exit 1}
}

expect "sftp>"
send "exit\r"

expect eof
