set -x
export STRING="${1}"
export DCFROM="${2}"
export DCTO="${3}"
for i in $LISTASUC
do
	export STRING="${1}"
	echo "sqlplus emuser/password@EM62 ${STRING} ${DCFROM} ${DCTO}"
done
