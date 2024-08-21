#/usr/bin/ksh
set -x
################################################################################
#
# Borra los archivos del CAP correspondientes a la ultima transferencia que
# se haya realizado.
#
# Cesar Lopez  -  20/03/2002
#
################################################################################

DIRCAP=/tecnol/CAP

if [ -f $DIRCAP/CAP.zip ]
then
	rm -f $DIRCAP/CAP.zip
fi

if [ -f $DIRCAP/DETALLES.DAT ]
then
	rm -f $DIRCAP/DETALLES.DAT
fi

if [ -f $DIRCAP/PAGOS.DAT ]
then
	rm -f $DIRCAP/PAGOS.DAT
fi

if [ -f $DIRCAP/PROV.DAT ]
then
	rm -f $DIRCAP/PROV.DAT
fi

exit 0



