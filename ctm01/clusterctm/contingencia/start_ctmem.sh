#!/bin/ksh
. ${MENU_CTM}/funciones/dynamic_menu.var
. ${MENU_CTM}/funciones/funciones.lib
. ${MENU_CTM}/funciones/funciones_ecs.lib
start_local_corba
start_local_conf_server
start_local_admin_agent
sleep 10
start_local_ecs
