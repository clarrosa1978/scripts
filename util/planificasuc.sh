for NEW in $LISTALNX
do
echo "$suc$NEW"

        if [ $NEW -lt 100 ]
        then
                export SUCNEW=0$NEW
        fi
echo "SUC$SUCNEW"

ssh suc$SUCNEW "su - ctmsrv -c \"ctmorder 'STS-$SUCNEW' PTES0321 20170411\""
echo "-----------------------------------------------------------------------"
done
