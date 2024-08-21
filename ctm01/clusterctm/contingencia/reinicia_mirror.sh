#!/bin/ksh
. ${MENU_CTM}/funciones/dynamic_menu.var
. ${MENU_CTM}/funciones/funciones.lib
. ${MENU_CTM}/funciones/funciones_ctm.lib
stop_local_ctm_ca
stop_local_ctm 
copy_to_mirror
start_local_ctm
start_local_ctm_ca
