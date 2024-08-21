#!/bin/ksh

#####################################################
# Name: 	getLanConfig
# Function:	collect virtual LAN configuration of all Managed Systems
# Version:	1.0 - draft
#
# Author:	Sandra Ulber
# Date:		23.10.2008
#
# Copy right for IBM Deutschland GmbH
# Change History
# - changed hash bang to /bin/ksh for better portability
#########################################################

#######################################################
# set Variables
######################################################
hostname=$1 
dir=$2
configFile=$dir'/'$hostname'_LanConfig.out'
system=$dir'/'$hostname'_lssyscfg.out'
lpar=$dir'/'$hostname'_lpar.out'
virtualIO=$dir'/'$hostname'_virtualIO.out'
io=$dir'/'$hostname'_io.out'
adapter=$dir'/'$hostname'_adapter.out'
testDlpar=$dir'/'$hostname'_testDlpar.out'
entAdap=$dir'/'$hostname'_entAdapt.out'
tcpip=$dir'/'$hostname'_tcpip.out'

#####################################################
# delete old output file
####################################################
> $configFile 

###################################################
# collect LAN information
###################################################
ssh hscroot@$1 lssyscfg -r sys > $system
set -A ManagedSystem $(cut -f 1 -d ',' $system | cut -f 2 -d '=')
ManagedSystem_count=$(wc $system | awk '{print $1}')
set -A SerialNumber $(cut -f 3 -d ',' $system | cut -f 2 -d '=') 
set -A typeModel $(cut -f 2 -d ',' $system | cut -f 2 -d '=')

test=0

x=0
while [ $x -lt $ManagedSystem_count ]
do
	echo 'Get LAN configuration of '${ManagedSystem[$x]}
	ssh hscroot@$1 lssyscfg -r lpar -m ${ManagedSystem[$x]} > $lpar

	set -A VioHostname $(grep 'lpar_env=vioserver' $lpar | cut -f 1 -d ',' | cut -f 2 -d '=')
	VioHostname_count=$(grep 'lpar_env=vioserver' $lpar | wc | awk '{print $1}')
	set -A VioConfig $(grep 'lpar_env=vioserver' $lpar | cut -f 1-3 -d ',')
	set -A ClientHostname $(grep -v 'lpar_env=vioserver' $lpar | cut -f 1-3 -d ',')
	ClientHostname_count=$(grep -v 'lpar_env=vioserver' $lpar |  wc | awk '{print $1}')

	ssh hscroot@$1 lshwres -r virtualio --rsubtype eth --level lpar -m ${ManagedSystem[$x]} > $virtualIO
	set -A ConfHwresEth $(cat $virtualIO)
	ConfHwresEth_count=$(cat $virtualIO | wc | awk '{print $1}')

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
	while [ $y -lt $ClientHostname_count ]
        do
                string=${SerialNumber[$x]}','${ClientHostname[$y]}
                echo $string >> $configFile

		hostname=$(echo ${ClientHostname[$y]} | cut -f 1 -d ',' | cut -f 2 -d '=')
		lparId=$(echo ${ClientHostname[$y]} | cut -f 2 -d ',' | cut -f 2 -d '=')
		
		ssh hscroot@$1 lshwres -r io --rsubtype slot -m ${ManagedSystem[$x]} > $io	
		set -A adapAll $(cat $io | grep "lpar_id="$lparId | cut -f 19 -d ',' | cut -f 2 -d '=')
		adapAll_count=$(cat $io  | grep "lpar_id="$lparId | wc | awk '{print$1}')
		string=${SerialNumber[$x]}','$hostname
		z=0
		while [ $z -lt $adapAll_count ]
		do
			desc=$(cat $io | grep "lpar_id="$lparId | cut -f 4 -d ',' | cut -f 2 -d '=' | sed 's/ /_/g')
			string=$string',io_adapter='${adapAll[$z]}','$desc
			((z=z+1))
		done	
		echo $string >> $configFile
		((y=y+1))
        done
	y=0
	while [ $y -lt $VioHostname_count ]
	do
		string=${SerialNumber[$x]}','${VioConfig[$y]}
		echo $string >> $configFile	
	
		lparId=$(grep ${VioHostname[$y]} $lpar | cut -f 2 -d ',' | cut -f 2 -d '=')
		set -A adapAll $(cat $io | grep "lpar_id="$lparId | cut -f 19 -d ',' | cut -f 2 -d '=')
		adapAll_count=$(cat $io  | grep "lpar_id="$lparId | wc | awk '{print$1}')	
                
		string=${SerialNumber[$x]}','${VioHostname[$y]}
                z=0
                while [ $z -lt $adapAll_count ]
                do
 			desc=$(cat $io | grep "lpar_id="$lparId | cut -f 4 -d ',' | cut -f 2 -d '=' | sed 's/ /_/g')
                       string=$string',io_adapter='${adapAll[$z]}','$desc
                        ((z=z+1))
                done
                echo $string >> $configFile
		test=0
		test=$(ls -la $dir'/' | grep -c $1'_testDlpar.out')
		if [ $test == 1 ]
		then
			isDlpar=$(grep ${VioHostname[$y]} $testDlpar | cut -f 4 -d ';')
		else
			isDlpar="no"
		fi
		
			
			ssh hscroot@$1 viosvrcmd -m ${ManagedSystem[$x]} -p ${VioHostname[$y]} -c '"lsdev -type adapter -field name physLoc description -fmt ':'"' > $adapter
			set -A VioEntDev $(cat $adapter | grep ent | cut -f 1 -d ':')
			VioEntDev_count=$(cat $adapter | grep -c ent)
			
			ssh hscroot@$1 viosvrcmd -m ${ManagedSystem[$x]} -p ${VioHostname[$y]} -c '"lstcpip -interfaces"' > $tcpip		
			z=0
			while [ $z -lt $VioEntDev_count ]
			do
				echo "echo \"\"" >> hmc2.log 
				echo "echo \"Device=${VioEntDev[$z]};\"" >> hmc2.log
				echo "viosvrcmd -m ${ManagedSystem[$x]} -p ${VioHostname[$y]} -c \"lsdev -dev ${VioEntDev[$z]} -attr\" | grep -v attribute | sed '/^$/d'" >> hmc2.log

				((z=z+1))
			done
			ssh hscroot@$1 < hmc2.log >> $entAdap
			z=0
			while [ $z -lt $VioEntDev_count ]
			do
				set -A DevAttrName $(grep -p "Device="${VioEntDev[$z]}";" $entAdap | grep -v "Device="${VioEntDev[$z]}";" | awk '{print $1}')
				set -A DevAttrValue $(grep -p "Device="${VioEntDev[$z]}";" $entAdap | grep -v "Device="${VioEntDev[$z]}";" | awk '{print $2}')
				DevAttrCount=$(grep -p "Device="${VioEntDev[$z]}";" $entAdap | grep -v "Device="${VioEntDev[$z]}";" | wc | awk '{print $1}')
 
				DevType=$(cat $adapter | grep ${VioEntDev[$z]}':' | cut -f 3 -d ':')
				DevLoc=$(cat $adapter | grep ${VioEntDev[$z]}':' | cut -f 2 -d ':') 
				
				DevEnName='en'$(echo ${VioEntDev[$z]} | cut -c 4-6)
				DevIP=$(cat $tcpip | grep $DevEnName' ' | awk '{print $2}')
				DevMac=$(cat $tcpip | grep $DevEnName' ' | awk '{print $5}')
			
				u=0
				string=${SerialNumber[$x]}','${VioHostname[$y]}',DeviceName='${VioEntDev[$z]}',DeviceType='$DevType',PhysLoc='$DevLoc',IpAddress='$DevIP',MacAddess='$DevMac
				while [ $u -lt $DevAttrCount ]
				do
					string=$string','${DevAttrName[$u]}'='${DevAttrValue[$u]}
					((u=u+1))
				done
				echo $string >> $configFile	
				((z=z+1))
			done	
			
			rm $adapter
			rm $entAdap
			rm $tcpip
			rm hmc2.log

		
		((y=y+1)) 
		done		

	((x=x+1))
done

rm $system
rm $lpar
rm $virtualIO
rm $io

