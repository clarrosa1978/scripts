#!/bin/ksh
. ${MENU_CTM}/funciones/dynamic_menu.var
. ${MENU_CTM}/funciones/funciones.lib
. ${MENU_CTM}/funciones/funciones_ecs.lib
stop_local_admin_agent
stop_local_ecs
stop_local_conf_server
stop_local_corba
