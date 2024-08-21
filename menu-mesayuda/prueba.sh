SERVIDOR=sap1

COLA=s46pe1

OUTPUT="$(ssh ${SERVIDOR} "host ${COLA}")"
echo "${OUTPUT}"
