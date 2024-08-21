#!/usr/bin/ksh
columns=7
source_file="${1}"
export REV=`tput smso`
export END=`tput sgr0`
file2process[$columns]={}
ind=1
while [ $ind -lt $columns+1 ]
do

    file2process[${ind}]="./.file$ind.tmp"
    let ind="$ind+1"

done
rows=`wc -l $source_file | awk '{ print $1 }'`
rows_per_col=`expr $rows / $columns`
if [ `expr $rows % $columns` -gt 0 ]
then

    let rows_per_col="$rows_per_col+1"

fi
last_row[$columns]={0}
let last_row[1]="$rows_per_col"
ind=2
while [ $ind -lt $columns+1 ]
do

    let last_row[$ind]="${last_row[$ind-1]}+$rows_per_col"
    let ind="$ind+1"

done

indrow=1
indcol=1

export current_row=0

cat $source_file | while read LINE
do
    
    let current_row="$current_row+1"

    ind=1

    while [ $ind -lt $columns+1 ]
    do

        if [ $current_row -lt ${last_row[$ind]}+1 ]
        then
            printf '%-15s\n' "$LINE" |  awk ' { print sprintf("%02d) %s", '$current_row', $1) } ' >> "${file2process[$ind]}"
            break

        fi 

        let ind="$ind+1"

    done

done

files2print=""

ind=1

while [ $ind -lt $columns+1 ]
do
    if [ -s ${file2process[$ind]} ]
    then
        files2print=$files2print" "${file2process[$ind]}
    fi
    let ind="$ind+1"

done

paste $files2print |  sed s/\)/${REV}\)${END}/g 

rm $files2print 2>/dev/null
