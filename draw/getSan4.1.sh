#!/bin/ksh

#####################################################
# Name:         getSanConfig
# Function:     collect virtual LAN configuration of all Managed Systems
# Version:      1.0 - draft
#
# Author:       Sandra Ulber
# Date:         23.10.2008
#
# Copy right for IBM Deutschland GmbH
# Change Log
# - changed hash bang to /bin/ksh for better portability
#########################################################

#######################################################
# set Variables
######################################################
hostname=$1
dir=$2
configFile=$dir'/'$hostname'_SanConfig.out'

#####################################################
# delete old output file
####################################################
> $configFile

###################################################
# collect SAN information
###################################################

set -A ManagedSystem $(ssh hscroot@$1 lssyscfg -r sys | cut -f 1 -d ',' | cut -f 2 -d '=')
ManagedSystem_count=$(ssh hscroot@$1 lssyscfg -r sys | wc | awk '{print $1}')
set -A SerialNumber $(ssh hscroot@$1 lssyscfg -r sys | cut -f 3 -d ',' | cut -f 2 -d '=')
set -A typeModel $(ssh hscroot@$1 lssyscfg -r sys | cut -f 2 -d ',' | cut -f 2 -d '=') 

x=0
while [ $x -lt $ManagedSystem_count ]
do
	echo 'Get SAN configuration of '${ManagedSystem[$x]}
	
	set -A VioHostname $(ssh hscroot@$1 lssyscfg -r lpar -m ${ManagedSystem[$x]} | grep 'lpar_env=vioserver' | cut -f 1 -d ',' | cut -f 2 -d '=')
	VioHostname_count=${#VioHostname[*]}
 	set -A VioConfig $(ssh hscroot@$1 lssyscfg -r lpar -m ${ManagedSystem[$x]} | grep 'lpar_env=vioserver' | cut -f 1-3 -d ',')
	set -A ClientHostname $(ssh hscroot@$1 lssyscfg -r lpar -m ${ManagedSystem[$x]} | grep -v 'lpar_env=vioserver' | cut -f 1-3 -d ',')
        ClientHostname_count=$(ssh hscroot@$1 lssyscfg -r lpar -m ${ManagedSystem[$x]} | grep -v 'lpar_env=vioserver' |  wc | awk '{print $1}')

	set -A ConfHwresEth $(ssh hscroot@$1 lshwres -r virtualio --rsubtype scsi --level lpar -m ${ManagedSystem[$x]})
	ConfHwresEth_count=${#ConfHwresEth[*]}

	set -A ConfHwresFC $(ssh hscroot@$1 lshwres -r virtualio --rsubtype fc --level lpar -m ${ManagedSystem[$x]})
	ConfHwresFC_count=${#ConfHwresFC[*]}

	echo 'ManagedSystem='${ManagedSystem[$x]}','${SerialNumber[$x]}','${typeModel[$x]} >> $configFile	
	 date=$(date)
        echo 'creationDate='$date >> $configFile
	
	y=0
	while [ $y -lt $ConfHwresEth_count ]
	do
		string=${SerialNumber[$x]}','${ConfHwresEth[$y]}
		echo $string >> $configFile
		((y=y+1))
	done
	 y=0
        while [ $y -lt $ConfHwresFC_count ]
        do
                string=${SerialNumber[$x]}',FC,'${ConfHwresFC[$y]}
                echo $string >> $configFile
                ((y=y+1))
        done


	y=0
        while [ $y -lt $ClientHostname_count ]
        do
                string=${SerialNumber[$x]}','${ClientHostname[$y]}
                echo $string >> $configFile

                hostname=$(echo ${ClientHostname[$y]} | cut -f 1 -d ',' | cut -f 2 -d '=')
                lparId=$(echo ${ClientHostname[$y]} | cut -f 2 -d ',' | cut -f 2 -d '=')
                set -A adapAll $(ssh hscroot@$1 lshwres -r io --rsubtype slot -m ${ManagedSystem[$x]} --filter "lpar_ids=$lparId" -F drc_name,description | sed 's/ /_/g')
                adapAll_count=$(ssh hscroot@$1 lshwres -r io --rsubtype slot -m ${ManagedSystem[$x]} --filter "lpar_ids=$lparId" -F drc_name,description | wc | awk '{print $1}')
                string=${SerialNumber[$x]}','$hostname
                z=0
                while [ $z -lt $adapAll_count ]
                do
                        string=$string',io_adapter='${adapAll[$z]}
                        ((z=z+1))
                done
                echo $string >> $configFile
                ((y=y+1))
        done

	y=0	
	while [ $y -lt $VioHostname_count ]
	do
		#echo ${VioConfig[$y]}
		string=${SerialNumber[$x]}','${VioConfig[$y]}
                echo $string >> $configFile

		lparId=$(ssh hscroot@$1 lssyscfg -r lpar -m ${ManagedSystem[$x]} --filter ""lpar_names=${VioHostname[$y]}"" -F lpar_id)
                set -A adapAll $(ssh hscroot@$1 lshwres -r io --rsubtype slot -m ${ManagedSystem[$x]} --filter "lpar_ids=$lparId" -F drc_name,description | sed 's/ /_/g')
                adapAll_count=${#adapAll[*]}
		set -A vg $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsvg"' | grep -v rootvg)
		vg_count=${#vg[*]}
		set -A vhost $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev" | grep vhost' | awk '{print $1}')                
		vhost_count=${#vhost[*]}                
		set -A hdisk $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev" | grep hdisk' | awk '{print $1}')	
		hdisk_count=${#hdisk[*]}	
		
		string=${SerialNumber[$x]}','${VioHostname[$y]}
		z=0
		while [ $z -lt $vhost_count ]
		do
			set -A vtd $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsmap -vadapter '${vhost[$z]}' -field VTD"' | grep VTD | awk '{print $2}')
			vhostLoc=$(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsmap -vadapter '${vhost[$z]}' "' | grep 'vhost' | awk '{print $2}')
			vtd_count=${#vtd[*]}
			set -A backing $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsmap -vadapter '${vhost[$z]}' -field Backing"' | grep 'Backing device' | awk '{print $3}') 	
			string=$SerialNumber','${VioHostname[$y]}',vhost='${vhost[$z]}',vhostLoc='$vhostLoc	
			u=0
			while [ $u -lt $vtd_count ]
			do
				sizeHdisk=$(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lspv -size -fmt :"' | grep ${backing[$u]}':' | cut -f 3 -d ':')
				string=$string',VTD='${vtd[$u]}',BackingDevice='${backing[$u]}',size='$sizeHdisk	
				((u=u+1))
			done
		         echo $string >> $configFile
                        ((z=z+1))
                done
		set -A lsnports $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsnports -fmt ','"')
		lsnports_count=${#lsnports[*]}
		string=${SerialNumber[$x]}','${VioHostname[$y]}';lsnports'
		z=0
		while [ $z -lt $lsnports_count ]
		do
			string=$string','${lsnports[$z]}
			echo $string >> $configFile
			string=${SerialNumber[$x]}','${VioHostname[$y]}';lsnports'
			((z=z+1))
		done
		set -A vfchost $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev" | grep vfchost' | awk '{print $1}')
		vfchost_count=${#vfchost[*]}
		string=${SerialNumber[$x]}','${VioHostname[$y]}
		z=0
		while [ $z -lt $vfchost_count ]
		do
			set -A mapping $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsmap -vadapter '${vfchost[$z]}' -npiv"')			
			string=$string',FC,'${vfchost[$z]}','${mapping[11]}','${mapping[12]}','${mapping[13]}','${mapping[15]}','${mapping[17]}','${mapping[20]}','${mapping[23]}','${mapping[24]}','${mapping[27]}','${mapping[30]}
			
			echo $string >> $configFile
			
			string=${SerialNumber[$x]}','${VioHostname[$y]}
			((z=z+1))
		done	

		z=0
                while [ $z -lt $hdisk_count ]
                do
			pvid=$(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev -dev '${hdisk[$z]}' -attr"' | grep pvid | awk '{print $2}')
			uniqueId=$(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev -dev '${hdisk[$z]}' -attr"' | grep unique | awk '{print $2}')
			string=${SerialNumber[$x]}','${VioHostname[$y]}
			string=$string',hdiskName='${hdisk[$z]}',PvId='$pvid',LunId='$uniqueId
			echo $string >> $configFile
		  	((z=z+1))
                done

		string=${SerialNumber[$x]}','${VioHostname[$y]}
		z=0
                while [ $z -lt $adapAll_count ]
                do
                        string=$string',io_adapter='${adapAll[$z]}
                        ((z=z+1))
                done
                echo $string >> $configFile

		set -A VioFcsDev $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev -type adapter"' | grep fcs | awk '{print $1}')
		VioFcsDev_count=$(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev -type adapter"' | grep -c fcs)

		z=0
		while [ $z -lt $VioFcsDev_count ]
		do
			set -A DevAttrValue $(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev -dev '${VioFcsDev[$z]}' -vpd" | grep Network' | awk '{print $2}')
			DevLoc=$(ssh hscroot@$1 'viosvrcmd -m '${ManagedSystem[$x]}' -p '${VioHostname[$y]}' -c "lsdev -dev '${VioFcsDev[$z]}' -field physLoc" | grep U') 	
			string=${SerialNumber[$x]}','${VioHostname[$y]}',DeviceName='${VioFcsDev[$z]}',PhysLoc='$DevLoc',WWPN='$DevAttrValue
			echo $string >> $configFile	
			((z=z+1))
		done	
		((y=y+1)) 
	done		
	((x=x+1))
done
