#set -x

>/tmp/DiaAnt.log
export LOG_CIERRE=/tmp/DiaAnt.log

export ENT_NRO="06 00 02 03 01 05"

################################### SACO EL DIA ANTERIOR ################################################

#DIA="$1"
#MES="$2"
#ANO="$3"

DIA=`date +%d`
MES=`date +%m`
ANO=`date +%Y`

if  [ ${MES} -eq "01" ]
then
        if  [ ${DIA} -eq "01" ]
        then
             MES_ANT=12
             DIA_ANT=31
             ANO_ANT=`expr ${ANO} - 1`
        else
             DIA_ANT=`expr ${DIA} - 1`
                if [ ${DIA_ANT} -lt 10 ]
                then
                        DIA_ANT1="0$DIA_ANT"
                        DIA_ANT="$DIA_ANT1"
                        MES_ANT="$MES"
                        ANO_ANT="$ANO"
                else
                        DIA_ANT=`expr ${DIA} - 1`
                        MES_ANT="$MES"
                        ANO_ANT="$ANO"
                fi

        fi
else

        if  [ ${DIA} -eq "01" ]
        then

                case $MES in
                        05|07|10|12)    DIA_ANT=30
                        ;;
                        02|04|06|08|09|11)      DIA_ANT=31
                        ;;
                        03)     ANO_BIS=`expr ${ANO} % 4`
                                if [ ${ANO_BIS} != 0 ]
                                then
                                        DIA_ANT=28
                                else
                                        DIA_ANT=29
                                fi
                        ;;
                esac
        MES_ANT=`expr ${MES} - 1`
        else
        MES_ANT="${MES}"
        DIA_ANT=`expr ${DIA} - 1`
        ANO_ANT="$ANO"
fi
case `echo $DIA_ANT |awk '{ print length }'` in
                1)      export DIA_ANT1="0${DIA_ANT}"
                        ;;
                2)      export DIA_ANT1="${DIA_ANT}"
                        ;;
esac
case `echo $MES_ANT |awk '{ print length }'` in
                1)      export MES_ANT1="0${MES_ANT}"
                        ;;
                2)      export MES_ANT1="${MES_ANT}"
                        ;;
esac

DIA_ANT="$DIA_ANT1"
MES_ANT="$MES_ANT1"
ANO_ANT="${ANO}"
echo "$DIA_ANT$MES_ANT" >$LOG_CIERRE
fi
