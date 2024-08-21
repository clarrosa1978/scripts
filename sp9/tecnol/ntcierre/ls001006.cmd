#########################################################################
#                                                                       #
#       SCRIPT:         /sfctrl/bin/lista2                              #
#       USUARIO:        sfctrl                                          #
#       EQUIPO:         sucursales                                      #
#       AUTOR :         Francisco Corvalan
#       FECHA :         16 - 3 - 99                                     #
#	MODIFICADO:	
#       DESCRIPCION:    PARAMETROS DE LISTADO                           #
#                       ESTADO = ACTIVO,INACTIVO (Activa o Desactiva la
#                           emision del Listado)
#                       NOMBRE = Nombre del Listado
#                       IMPRESORA =  Cola de Impresion
#                       COPIAS = Cantidad de Copias
#                       TIPOLETRA = CHICA, GRANDE (Activa Tipografia Condensada)
#########################################################################
%%ESTADO=ACTIVO
%%LISTADO=LS001006
%%IMPRESORA=s50co1
%%COPIAS=1
%%TIPOLETRA=CHICA
#########################################################################
#
# NO MODIFICAR DE AQUI EN ADELANTE 
#
# UTILIZADA POR PLANIFICADOR
#
%%PARM1=%%ESTADO
%%PARM2=%%LISTADO
%%PARM3=%%IMPRESORA
%%PARM4=%%COPIAS
%%PARM5=%%TIPOLETRA
