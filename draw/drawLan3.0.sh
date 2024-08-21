#!/bin/ksh
#########################################################################
# Name:         drawLanPicture						#
# Description:	Draw the LAN configuration of Virtual I/O server from a #
#		Managed System 						#
# Version:      1.0 - beta 						#
#									#
# Author:       Sandra Ulber						#
# Date:         23.10.2008						#
# Last Update:								#
# Changes:								#
#									#
# Copyright for IBM Deutschland GmbH					#
# Change Log
# - changed hash bang to /bin/ksh for better portability
#########################################################################	


#########################################################################
# define functions							#
#########################################################################

#########################################################################
# Function to draw all Ethernet Adapter of VIO servers 			#
#########################################################################
drawVio ()
{
# set start variables
#########################################################################
	set -A VioHostname $(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_env=vioserver' | cut -f 2 -d ',' | sort -u | cut -f 2 -d '=')
        VioHostname_count=$(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_env=vioserver' | cut -f 2 -d ',' | sort -u |  wc | awk '{print $1}')
	vio_y=$starty
        pvVlan_count=0
	ctlVlan_count=0
	a=0
        while [ $a -lt $VioHostname_count ]
        do
# set variables of SEA
#########################################################################
		set -A seaName $(grep $1 $configFile | grep ${VioHostname[$a]} | grep Shared | cut -f 3 -d ',' | cut -f 2 -d '=')
                seaName_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep -c Shared)
		((sea_x=startx+140))
		((sea_y=vio_y+50))
		((pvVlan_x1=startx+sizeViox+20))
		((pvVlan_x2=pvVlan_x1+100+seaName_count*30))
		((ctlVlan_x1=startx+sizeViox+20))
		((ctlVlan_x2=ctlVlan_x1+70))

		b=0
                while [ $b -lt $seaName_count ]
		do
			grep $1 $configFile | grep ${VioHostname[$a]} | grep Shared | grep 'DeviceName='${seaName[$b]}',' | tr "=" "\n" > $seaHelp

# draw SEA adapter
###########################################################################
			echo '<rect x="'$sea_x'" y="'$sea_y'" width="35" height="12" fill="yellow" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
			((seaText_x=sea_x+5))
                        ((seaText_y=sea_y+11))
                        echo '<text x="'$seaText_x'" y="'$seaText_y'" style="font-size:10px">'${seaName[$b]}'</text>' >> $pictureFile
	echo ${VioHostname[$a]}','${seaName[$b]}','$sea_x','$sea_y >> $helpFile

# find name and type of SEA base adapter
###########################################################################
			seaBase=$(grep ',thread' $seaHelp | cut -f 1 -d ',')
			((base_y=sea_y))
			baseType=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$seaBase',' | cut -f 4 -d ',' | cut -f 2 -d '=' | cut -f 1 -d ' ')
# draw EtherChannel adapter as base of SEA
###########################################################################
			if [ $baseType = "EtherChannel" ]
			then
				((base_x=sea_x-65))
				echo '<rect x="'$base_x'" y="'$base_y'" width="35" height="12" fill="lavender" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
				((baseLine_y=base_y+5))
				((baseLine_x=base_x+35))
                                echo '<line x1="'$baseLine_x'" y1="'$baseLine_y'" x2="'$sea_x'" y2="'$baseLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
				((baseText_x=base_x+5))
                                ((baseText_y=base_y+11))
                                echo '<text x="'$baseText_x'" y="'$baseText_y'" style="font-size:10px">'$seaBase'</text>' >> $pictureFile
                                echo ${VioHostname[$a]}','$seaBase','$base_x','$base_y >> $helpFile
					
# draw physical adapter of EtherChannel
###########################################################################
				grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceType=EtherChannel' | grep 'DeviceName='$seaBase | tr "=" "\n" > $ethHelp
				ethBaseAll=$(grep ',alt_addr' $ethHelp)
				ethBase_count=$(echo $ethBaseAll | tr "," "\n" | wc | awk '{print $1}')
				((ethBase_y=base_y))
				d=1
				countChan=0
				while [ $d -lt $ethBase_count ]
				do
					ethBase=$(echo $ethBaseAll | cut -f $d -d ',')
					((ethBase_x=startx-15))
					echo '<rect x="'$ethBase_x'" y="'$ethBase_y'" width="35" height="12" fill="powderblue" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
					((ethBaseText_x=ethBase_x+5))
					((ethBaseText_y=ethBase_y+11))
					echo '<text x="'$ethBaseText_x'" y="'$ethBaseText_y'" style="font-size:10px">'$ethBase'</text>' >> $pictureFile
 		                      	echo ${VioHostname[$a]}','$ethBase','$ethBase_x','$ethBase_y >> $helpFile
	
					devLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$ethBase',' | cut -f 5 -d ',' | cut -f 2 -d '=')
					((locText_x=ethBase_x-85))
          			       	((locText_y=ethBase_y-2))
                        		echo '<text x="'$locText_x'" y="'$locText_y'" style="font-size:10px">'$devLoc'</text>' >> $pictureFile
	
					((ethBaseLine_x1=ethBase_x+35))
					((ethBaseLine_y1=ethBase_y+5))
					((ethBaseLine_x2=ethBaseLine_x1+20))
					echo '<line x1="'$ethBaseLine_x1'" y1="'$ethBaseLine_y1'" x2="'$ethBaseLine_x2'" y2="'$ethBaseLine_y1'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
					echo '<circle cx="'$ethBaseLine_x2'" cy="'$ethBaseLine_y1'" r="2" />' >> $pictureFile
						
					((ethBase_y=ethBase_y+40))
					((base_y=base_y+40))
					((d=d+1))
				done 
					echo '<line x1="'$ethBaseLine_x2'" y1="'$baseLine_y'" x2="'$ethBaseLine_x2'" y2="'$ethBaseLine_y1'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
					echo '<line x1="'$ethBaseLine_x2'" y1="'$baseLine_y'" x2="'$base_x'" y2="'$baseLine_y'" style="stroke:black;stroke-width:1;"/>' >> $pictureFile
					
					((countChan=countChan+1))

# draw physical Ethernet adapter as base of SEA
####################################################################
			else
				((base_x=startx-15))
				echo '<rect x="'$base_x'" y="'$base_y'" width="35" height="12" fill="powderblue" style="stroke:black;stroke-width:1px"/>' >> $pictureFile				
				((ethBaseLine_y1=base_y+5))
				((baseLine_x=base_x+35))
				echo '<line x1="'$baseLine_x'" y1="'$ethBaseLine_y1'" x2="'$sea_x'" y2="'$ethBaseLine_y1'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
				((baseText_x=base_x+5))
                       		((baseText_y=base_y+11))
                       		echo '<text x="'$baseText_x'" y="'$baseText_y'" style="font-size:10px">'$seaBase'</text>' >> $pictureFile
               			echo ${VioHostname[$a]}','$seaBase','$base_x','$base_y >> $helpFile

				devLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$seaBase',' | cut -f 5 -d ',' | cut -f 2 -d '=')
                                ((locText_x=base_x-85))
                                ((locText_y=base_y-2))
                                 echo '<text x="'$locText_x'" y="'$locText_y'" style="font-size:10px">'$devLoc'</text>' >> $pictureFile
			fi
# draw PV adapter of SEA
######################################################################
			pvName=$(grep ',qos_mode' $seaHelp | cut -f 1 -d ',')
			if [ -z "$pvName" ]
			then
				pvName=$(grep ',real_adapter' $seaHelp | cut -f 1 -d ',')
			fi
			pvLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$pvName',' | cut -f 5 -d ',' | cut -f 2 -d '=')
			pvId=$(grep ',pvid_adapter' $seaHelp | cut -f 1 -d ',')
			pvSlot=$(echo $pvLoc | tr '-' '\n' | awk 'NR==3 {print}') 
			word=$(echo $pvSlot | wc | awk '{print $3}')
			pvSlot=$(echo $pvSlot | cut -c 2-$word)
			pvPrio=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'slot_num='$pvSlot',' | cut -f 8 -d ',')
	((pvName_x=startx+sizeViox-15))
			((pvName_y=sea_y))
			echo '<rect x="'$pvName_x'" y="'$pvName_y'" width="35" height="12" fill="greenyellow" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
			echo ${VioHostname[$a]}','$pvName','$pvName_x','$pvName_y',pv='$pvId',' >> $helpFile		
	
			((pvText_x=pvName_x+5))
                        ((pvText_y=pvName_y+11))
                        echo '<text x="'$pvText_x'" y="'$pvText_y'" style="font-size:10px">'$pvName'</text>' >> $pictureFile

			((pvLine_y=pvName_y+5))
			((pvLine_x1=pvName_x-20))
			echo '<line x1="'$pvLine_x1'" y1="'$pvLine_y'" x2="'$pvName_x'" y2="'$pvLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
			echo '<circle cx="'$pvLine_x1'" cy="'$pvLine_y'" r="2" />' >> $pictureFile

			((pvLoc_x=pvName_x-30))
			((pvLoc_y=pvName_y-2))
			echo '<text x="'$pvLoc_x'" y="'$pvLoc_y'" style="font-size:10px">'$pvLoc'</text>' >> $pictureFile

			((prio_x=sea_x-20))
			((prio_y=sea_y-2))
			echo '<text x="'$prio_x'" y="'$prio_y'" style="font-size:10px">'$pvPrio'</text>' >> $pictureFile
		
			((pvVlan_count=pvVlan_count+1))

			((pvVlan_y=pvName_y+10))
			test=$(grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$pvSlot',' | grep -c '"')	
			if [ $test != 0 ]
			then
				grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$pvSlot',' | tr '"' '\n' > $vlanHelp
                        else
				grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$pvSlot',' | tr "," "\n" > $vlanHelp
			fi
			line_count=$(wc $vlanHelp | awk '{print $1}')
			addVlan=$(grep 'addl_vlan' $vlanHelp | cut -f 2 -d '=')
                        test=$(echo $addVlan | wc | awk '{print $2}')
			if [ $test != 0 ]
			then
				addVlan_count=$(echo $addVlan | tr "," "\n" | wc | awk '{print $1}')
			
                        	if [ $addVlan_count -gt 0 ]
                       		 then
                                	((addVlan_count=addVlan_count+1))

                               		c=1
                                	while [ $c -lt $addVlan_count ]
                                	do
                                        	vlan=$(echo $addVlan | cut -f $c -d ',')
                                        	echo ${VioHostname[$a]}',vlan='$vlan','$pvVlan_y',pvid='$pvId >> $helpFile
                                        	((c=c+1))
                                	done
                        	fi
			fi
# draw ControlChannel adapter of SEA
####################################################################
			ctlName=$(grep ',gvrp' $seaHelp | cut -f 1 -d ',')
			if [ $ctlName != 'Control' ]                
			then	
				ctlLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$ctlName',' | cut -f 5 -d ',' | cut -f 2 -d '=') 
				ctlSlot=$(echo $ctlLoc | cut -f 3 -d '-' | cut -c 2-3)
				ctlId=$(grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$ctlSlot',' | cut -f 9 -d ',' | cut -f 2 -d '=') 
                        	((ctlName_x=startx+sizeViox-15))
                        	((ctlName_y=pvName_y+40))
                        	echo '<rect x="'$ctlName_x'" y="'$ctlName_y'" width="35" height="12" fill="lightgrey" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
                        	echo ${VioHostname[$a]}','$ctlName','$ctlName_x','$ctlName_y',ctl='$ctlId >> $helpFile

 	                       ((ctlText_x=ctlName_x+5))
        	               ((ctlText_y=ctlName_y+11))
				echo '<text x="'$ctlText_x'" y="'$ctlText_y'" style="font-size:10px">'$ctlName'</text>' >> $pictureFile

                        	((ctlLine_y=ctlName_y+5))
                        	((ctlLine_x1=ctlName_x-20))
                        	echo '<line x1="'$ctlLine_x1'" y1="'$ctlLine_y'" x2="'$ctlName_x'" y2="'$ctlLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
                        	echo '<circle cx="'$ctlLine_x1'" cy="'$ctlLine_y'" r="2" />' >> $pictureFile

				((ctlLoc_x=ctlName_x-30))
                        	((ctlLoc_y=ctlName_y-2))
                        	echo '<text x="'$ctlLoc_x'" y="'$ctlLoc_y'" style="font-size:10px">'$ctlLoc'</text>' >> $pictureFile
			
 	                       ((ctlVlan_count=ctlVlan_count+1))

			else
				((ctlName_y=pvName_y))
				((ctlLine_y=pvName_y+5))
			fi
# draw additional virtual adapters of SEA 
#######################################################################
			addAdapAll=$(awk 'c&&c--;/virt_adapters/{c=1}' $seaHelp)
			addAdap_count=$(echo $addAdapAll | tr "," "\n" | wc | awk '{print $1}')
			((addAdap_count=addAdap_count-2))
			((addAdap_y=ctlName_y+40))
			((addAdap_x=startx+sizeViox-15))
			((addAdap_count=addAdap_count+1))
			c=0
			while [ $c -lt $addAdap_count ]
			do
				((m=c+1))
				addAdap=$(echo $addAdapAll | cut -f $m -d ',')
				testString=$pvName','	
				if [ $addAdap != $pvName ]
				then
					addAdapLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$addAdap | cut -f 5 -d ',' | cut -f 2 -d '=')
                        		addAdapSlot=$(echo $addAdapLoc | cut -f 3 -d '-' | cut -c 2-4)
                        		addAdapId=$(grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addAdapSlot',' | cut -f 10 -d ',' | cut -f 2 -d '=')
			      		echo '<rect x="'$addAdap_x'" y="'$addAdap_y'" width="35" height="12" fill="greenyellow" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
                        		echo ${VioHostname[$a]}','$addAdap','$addAdap_x','$addAdap_y',pv='$addAdapId',' >> $helpFile

                        		((addAdapText_y=addAdap_y+11))
       					((addAdapText_x=addAdap_x+5))
	                 		echo '<text x="'$addAdapText_x'" y="'$addAdapText_y'" style="font-size:10px">'$addAdap'</text>' >> $pictureFile

                        		((addAdapLine_y=addAdap_y+5))
                        		((addAdapLine_x1=addAdap_x-20))
                        		echo '<line x1="'$addAdapLine_x1'" y1="'$addAdapLine_y'" x2="'$addAdap_x'" y2="'$addAdapLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
                       			echo '<circle cx="'$addAdapLine_x1'" cy="'$addAdapLine_y'" r="2" />' >> $pictureFile

                        		((addAdapLoc_x=addAdap_x-30))
                        		((addAdapLoc_y=addAdap_y-2))
                        		echo '<text x="'$addAdapLoc_x'" y="'$addAdapLoc_y'" style="font-size:10px">'$addAdapLoc'</text>' >> $pictureFile
					pvVlan_x3=$(grep 'addvlan='$addAdapId',' $helpFile | cut -f 2 -d ','| sort -u)
					if [ -z "$pvVlan_x3" ]
					then
 		                               	((pvVlan_x2=pvVlan_x2+30))

 		                       	else
                	                	((pvVlan_x2=pvVlan_x3))
                        		fi
                        		((pvVlan_y=addAdap_y+10))
#                        		echo '<line x1="'$pvVlan_x1'" y1="'$pvVlan_y'" x2="'$pvVlan_x2'" y2="'$pvVlan_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
#                        		echo '<circle cx="'$pvVlan_x2'" cy="'$pvVlan_y'" r="2.5" />' >> $pictureFile
                        		echo ${VioHostname[$a]}',pvVlan='$addAdapId','$pvVlan_x2','$pvVlan_y >> $helpFile

 		                       ((pvVlan_count=pvVlan_count+1))
			
					test=$(grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addAdapSlot',' | grep -c '"')
        	                	if [ $test != 0 ]
                	        	then
                        	        	grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addAdapSlot',' | tr '"' '\n' > $vlanHelp
                        		else
                                		grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addAdapSlot',' | tr "," "\n" > $vlanHelp
                        		fi
	
                        		addVlan=$(grep 'addl_vlan' $vlanHelp | cut -f 2 -d '=')
                        		addVlan_count=$(echo $addVlan | tr "," "\n" | wc | awk '{print $1}')

 		                       	if [ $addVlan_count != 0 ]
                        		then
                                		((addVlan_count=addVlan_count+2))
                                		d=1
                                		while [ $d -lt $addVlan_count ]
                                		do
                                        		vlan=$(echo $addVlan | cut -f $d -d ',')
							# vlan_test=$(grep $addVlan $helpFile | cut -f 3 -d ',')
                                        		echo ${VioHostname[$a]}',vlan='$vlan','$pvVlan_y',pvid='$addAdapId >> $helpFile

                                        		((d=d+1))
                                		done
                        		fi
			
				
					((addAdap_y=addAdap_y+40))
				else
					((addAdapLine_x1=pvLine_x1))
					((addAdapLine_y=ctlLine_y))
				fi
				((c=c+1))
			done
	
			((seaLine_x=sea_x+35))
			((seaLine_y=sea_y+5))
			echo '<line x1="'$addAdapLine_x1'" y1="'$seaLine_y'" x2="'$seaLine_x'" y2="'$seaLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
			echo '<line x1="'$addAdapLine_x1'" y1="'$addAdapLine_y'" x2="'$addAdapLine_x1'" y2="'$seaLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
# draw VLAN adapter of SEA
#########################################################################
		set -A vlanAdapAll $(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep 'DeviceType=VLAN' | grep 'base_adapter='${seaName[$b]}',' | cut -f 3 -d ',' | cut -f 2 -d '=') 		
		set -A vlanAdapId $(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep 'DeviceType=VLAN' | grep 'base_adapter='${seaName[$b]}',' | cut -f 11 -d ',' | cut -f 2 -d '=') 		
			vlanAdap_count=$(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep 'DeviceType=VLAN' | grep -c 'base_adapter='${seaName[$b]}',')
			vlanAdapLine_y=0
			c=0
			((vlanAdap_y=sea_y+25))
			while [ $c -lt $vlanAdap_count ]
			do
				((vlanAdap_x=sea_x+10))
				echo '<rect x="'$vlanAdap_x'" y="'$vlanAdap_y'" width="35" height="12" fill="peachpuff" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
				((vlanAdapText_y=vlanAdap_y+11))
				((vlanAdapText_x=vlanAdap_x+5))
				echo '<text x="'$vlanAdapText_x'" y="'$vlanAdapText_y'" style="font-size:10px">'${vlanAdapAll[$c]}'</text>' >> $pictureFile
				((vlanAdapLine_y=vlanAdap_y+5))
			 	echo '<line x1="'$sea_x'" y1="'$vlanAdapLine_y'" x2="'$vlanAdap_x'" y2="'$vlanAdapLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
                                echo '<circle cx="'$sea_x'" cy="'$vlanAdapLine_y'" r="2" />' >> $pictureFile	
				echo ${VioHostname[$a]}','${vlanAdapAll[$c]}','$vlanAdap_x','$vlanAdap_y >> $helpFile
			
				((idText_x=vlanAdap_x-35))
				echo '<text x="'$idText_x'" y="'$vlanAdapText_y'" style="font-size:10px">'${vlanAdapId[$c]}'</text>' >> $pictureFile
				((vlanAdap_y=vlanAdap_y+25))

				((vlanAdapLine_y1=sea_y+12))
				echo '<line x1="'$sea_x'" y1="'$vlanAdapLine_y1'" x2="'$sea_x'" y2="'$vlanAdapLine_y'" style="stroke:black;stroke-width:1;" />' >> $pictureFile
				((c=c+1))
			done
# set Y - value for next SEA
#########################################################################
			((vlanAdap_y=vlanAdap_y+15))
	
			if [ $base_y -lt $addAdap_y ]
                        then
                                ((sea_y=addAdap_y))
                        else
				((sea_y=base_y))
			fi
			if [ $sea_y -lt $vlanAdap_y ] 
                        then
			        ((sea_y=vlanAdap_y))
                        fi

			((b=b+1))
		done

		endVio_y=$sea_y
# draw additional physical adapter
############################################################################
		set -A addPhysAdapAll $(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep -v Shared | grep -v Virtual | grep -v VLAN | grep -v EtherChannel | grep 'DeviceName=ent' | cut -f 3 -d ',' | cut -f 2 -d '=')
		addPhysAdap_count=$(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep -v Shared | grep -v Virtual | grep -v VLAN | grep -v EtherChannel | grep -c 'DeviceName=ent')
		b=0
		while [ $b -lt $addPhysAdap_count ]	
		do
			test=$(grep ${VioHostname[$a]} $helpFile | grep -c ','${addPhysAdapAll[$b]}',')
			if [ $test = 0 ]
			then
				((addPhysAdap_x=startx-15))
				((addPhysAdap_y=sea_y))
        			echo '<rect x="'$addPhysAdap_x'" y="'$addPhysAdap_y'" width="35" height="12" fill="powderblue" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
                                ((addPhysAdapText_x=addPhysAdap_x+5))
                                ((addPhysAdapText_y=addPhysAdap_y+11))
                                echo '<text x="'$addPhysAdapText_x'" y="'$addPhysAdapText_y'" style="font-size:10px">'${addPhysAdapAll[$b]}'</text>' >> $pictureFile
                                echo ${VioHostname[$a]}','${addPhysAdapAll[$b]}','$addPhysAdap_x','$addPhysAdap_y >> $helpFile

                                addPhysAdapLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='${addPhysAdapAll[$b]}',' | cut -f 5 -d ',' | cut -f 2 -d '=')
				((addPhysAdapText_x=addPhysAdap_x-85))
                               	((addPhysAdapText_y=addPhysAdap_y-2))
                               	echo '<text x="'$addPhysAdapText_x'" y="'$addPhysAdapText_y'" style="font-size:10px">'$addPhysAdapLoc'</text>' >> $pictureFile
			
				((sea_y=sea_y+40))		 			
			fi
			((b=b+1))
		done
	
		endVio_y=$sea_y
# draw additional virtual adapter
#############################################################################
		set -A addVirtAdapAll $(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep Virtual | grep 'DeviceName=ent' | cut -f 3 -d ',' | cut -f 2 -d '=') 
		addVirtAdap_count=$(grep ${MaganedSystem[$x]} $configFile | grep ${VioHostname[$a]} | grep Virtual | grep -c 'DeviceName=ent')
	 	b=0
                while [ $b -lt $addVirtAdap_count ]
                do
                        test=$(grep ${VioHostname[$a]}',' $helpFile | grep ','${addVirtAdapAll[$b]}',')
                        if [ -z "$test" ]
                        then
				
				((addVirtAdap_x=startx+sizeViox-15))
                                ((addVirtAdap_y=sea_y))
                                echo '<rect x="'$addVirtAdap_x'" y="'$addVirtAdap_y'" width="35" height="12" fill="greenyellow" style="stroke:black;stroke-width:1px"/>' >>$pictureFile
                                ((addVirtAdapText_x=addVirtAdap_x+5))
                                ((addVirtAdapText_y=addVirtAdap_y+11))
                                echo '<text x="'$addVirtAdapText_x'" y="'$addVirtAdapText_y'" style="font-size:10px">'${addVirtAdapAll[$b]}'</text>' >> $pictureFile
                                echo ${VioHostname[$a]}','${addVirtAdapAll[$b]}','$addVirtAdap_x','$addVirtAdap_y >> $helpFile

                                addVirtAdapLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='${addVirtAdapAll[$b]}',' | cut -f 5 -d ',' | cut -f 2 -d '=')
                                ((addVirtAdapText_x=addVirtAdap_x-85))
                                ((addVirtAdapText_y=addVirtAdap_y-2))
                                echo '<text x="'$addVirtAdapText_x'" y="'$addVirtAdapText_y'" style="font-size:10px">'$addVirtAdapLoc'</text>' >> $pictureFile
				addVirtAdapSlot=$(echo $addVirtAdapLoc | cut -f 3 -d '-' | cut -c 2-3)
                                addVirtAdapId=$(grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addVirtAdapSlot',' | cut -f 9 -d ',' | cut -f 2 -d '=')
                               ((pvVlan_y=addVirtAdap_y+10))
                               echo ${VioHostname[$a]}',vlan='$addVirtAdapId','$pvVlan_y >> $helpFile

                               ((pvVlan_count=pvVlan_count+1))
 			 	test=$(grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addVirtAdapSlot',' | grep -c '"')
    				if [ $test != 0 ]
                        	then
                                	grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addVirtAdapSlot',' | tr '"' '\n' > $vlanHelp
                        	else
                                	grep $1 $configFile | grep 'lpar_name='${VioHostname[$a]} | grep 'slot_num='$addVirtAdapSlot',' | tr "," "\n" > $vlanHelp
                               	fi
				addVlan=$(grep 'addl_vlan' $vlanHelp | cut -f 2 -d '=')
 	                       	test=$(echo $addVlan | wc | awk '{print $2}')

                               if [ $test != 0 ]
                               then
                               		addVlan_count=$(echo $addVlan | tr "," "\n" | wc | awk '{print $1}')
                                	if [ $addVlan_count -gt 0 ]
                                 	then

					((addVlan_count=addVlan_count+1))
                                        c=1
                                        while [ $c -lt $addVlan_count ]
                                        do
                                                 vlan=$(echo $addVlan | cut -f $c -d ',')
                                                 # vlan_test=$(grep $addVlan $helpFile | cut -f 3 -d ',')
                                                 echo ${VioHostname[$a]}',vlan='$vlan','$pvVlan_y',pvid='$addVirtAdapId >> $helpFile

                                                 ((c=c+1))
                                        done
					fi
                               fi
                                ((sea_y=sea_y+40))
                        fi
                        ((b=b+1))
                done
		endVio_y=$sea_y	
# draw Ip address on adapter
##############################################################################
		set -A ipAddr $(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName=ent' | grep -v 'IpAddress=-' | grep -v 'IpAddress=,' | cut -f 6 -d ',' | cut -f 2 -d '=')
		set -A ipMac $(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName=ent' | grep -v 'IpAddress=-' | grep -v 'IpAddress=,' | cut -f 7 -d ',' | cut -f 2 -d '=')
		ipAddr_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName=ent' | grep -v 'IpAddress=-' | grep -v 'IpAddress=,' | wc | awk '{print $1}')
		b=0
		while [ $b -lt $ipAddr_count ]
		do
			ipAddrBase=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'IpAddress='${ipAddr[$b]}',' | cut -f 3 -d ',' | cut -f 2 -d '=')
			ipAddrBaseType=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'DeviceName='$ipAddrBase',' | cut -f4 -d ',' | cut -f 2 -d '=')
			adap_x=$(grep ${VioHostname[$a]} $helpFile | grep ','$ipAddrBase',' | cut -f 3 -d ',')
                        adap_y=$(grep ${VioHostname[$a]} $helpFile | grep ','$ipAddrBase',' | cut -f 4 -d ',')
                        ((ip_x=adap_x-90))
                        ((ip_y=adap_y+23))
                        echo '<text x="'$ip_x'" y="'$ip_y'" style="font-size:10px">'${ipAddr[$b]}'</text>' >> $pictureFile
			((mac_x=ip_x+80))
			((mac_y=ip_y))	
                        echo '<text x="'$mac_x'" y="'$mac_y'" style="font-size:10px">'${ipMac[$b]}'</text>' >> $pictureFile
			((b=b+1))
		done

		echo $1','${VioHostname[$a]}','$endVio_y >> $vioHelp
		((vio_y=endVio_y+offsety))

		((a=a+1))
	done

}
#################################################################################
# Function to draw virtual LANs							#
#################################################################################
drawVlan ()
{
# set start variables for VLANs
#################################################################################        
	set -A ctlLan $(grep ',ctl=' $helpFile | cut -f 5 -d ',' | sort -u | cut -f 2 -d '=')
        ctlLan_count=$(grep ',ctl=' $helpFile |cut -f 5 -d ',' | sort -u | wc | awk '{print $1}')
        set -A vlan $(grep ',vlan=' $helpFile | cut -f 2 -d ',' | sort -u | cut -f 2 -d '=')
        vlan_count=$(grep ',vlan=' $helpFile | cut -f 2 -d ',' | sort -u | wc | awk '{print $1}')
        b=0
        ctl_y1=$starty
	((ctl_x1=startx+sizeViox+20))
	((ctl_x2=ctl_x1+80))
	((vlan_y2=pictureSize_y-50))
	((text_y1=starty-15))
 	ctlx_min=5000
       
# draw Control Channel VLANs 
###################################################################################

	while [ $b -lt $ctlLan_count ]
        do
		set -A ctl_y $(grep 'ctl='${ctlLan[$b]} $helpFile | cut -f 4 -d ',')
                ctl_y_count=$(grep 'ctl='${ctlLan[$b]} $helpFile | cut -f 4 -d ',' | wc | awk '{print $1}')
                c=0
		while [ $c -lt $ctl_y_count ]
		do
			((ctl_y2=ctl_y[$c]+5))
                        echo '<line x1="'$ctl_x1'" y1="'$ctl_y2'" x2="'$ctl_x2'" y2="'$ctl_y2'" style="stroke:black;stroke-width:1;stroke-dasharray:2px, 2px" />' >> $pictureFile
                        echo '<circle cx="'$ctl_x2'" cy="'$ctl_y2'" r="2.5" />' >> $pictureFile

			((c=c+1))
		done
		echo '<line x1="'$ctl_x2'" y1="'$starty'" x2="'$ctl_x2'" y2="'$vlan_y2'" style="stroke:black;stroke-width:1;stroke-dasharray:2px, 2px" />' >> $pictureFile 
                echo '<rect x="'$ctl_x2'" y="'$starty'" width="25" height="12" fill="white" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
                ((text_y=starty+11))
                echo '<text x="'$ctl_x2'" y="'$text_y'" style="font-size:10px">'${ctlLan[$b]}'</text>' >> $pictureFile
		
		if [ $ctl_x2 -lt $ctlx_min ]
		then
			ctlx_min=$ctl_x2 
		fi 
        	((ctl_x2=ctl_x2+30))
	       ((b=b+1))
        done
	
	echo '<text x="'$ctlx_min'" y="'$text_y1'" style="font-size:10px">'Control Channel'</text>' >> $pictureFile

# draw PV VLANs
####################################################################################
	set -A pvLan $(grep ',pv=' $helpFile | cut -f 5 -d ',' | sort -u | cut -f 2 -d '=')
        pvLan_count=$(grep ',pv=' $helpFile |cut -f 5 -d ',' | sort -u | wc | awk '{print $1}')
        b=0
	((pv_x1=startx+sizeViox+20))
	((pv_x2=ctl_x2+50))
	pvVlanx_min=5000
	pvVlanx_max=0
        while [ $b -lt $pvLan_count ]
        do
		set -A pv_y $(grep ',pv='${pvLan[$b]}',' $helpFile | cut -f 4 -d ',')
		pv_y_count=$(grep ',pv='${pvLan[$b]}',' $helpFile | wc | awk '{print $1}')
		c=0
		while [ $c -lt $pv_y_count ]
		do
			((pv_y2=pv_y[$c]+10)) 
			echo '<line x1="'$pv_x1'" y1="'$pv_y2'" x2="'$pv_x2'" y2="'$pv_y2'" style="stroke:black;stroke-width:1" />' >> $pictureFile
			echo '<circle cx="'$pv_x2'" cy="'$pv_y2'" r="2.5" />' >> $pictureFile		
			((c=c+1))
		done	
		echo '<line x1="'$pv_x2'" y1="'$starty'" x2="'$pv_x2'" y2="'$vlan_y2'" style="stroke:black;stroke-width:1" />' >> $pictureFile
                echo '<rect x="'$pv_x2'" y="'$starty'" width="25" height="12" fill="white" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
                ((text_y=starty+11))
                echo '<text x="'$pv_x2'" y="'$text_y'" style="font-size:10px">'${pvLan[$b]}'</text>' >> $pictureFile
 		if [ $pv_x2 -lt $pvVlanx_min ]
		then
			pvVlanx_min=$pv_x2
		fi
		if [ $pvVlanx_max -lt $pv_x2 ]
		then
			pvVlanx_max=$pv_x2
		fi
		echo 'addvlan='${pvLan[$b]}','$pv_x2 >> $helpFile
		((pv_x2=pv_x2+30))
               ((b=b+1))
	done
	echo '<text x="'$pvVlanx_min'" y="'$text_y1'" style="font-size:10px">'Port VLAN IDs'</text>' >> $pictureFile
# draw additional VLANs
#######################################################################################	
	set -A vlan $(grep ',vlan=' $helpFile | cut -f 2 -d ',' | sort -u |cut -f 2 -d '=')
        vlan_count=$(grep ',vlan=' $helpFile | cut -f 2 -d ',' | sort -u | wc | awk '{print $1}')
        b=0
        ((vlan_x1=startx+sizeViox+20))
        ((vlan_x2=pvVlanx_max+50))
        ((text_y1=starty-15))
        if [ $vlan_count != 0 ]
        then
		test=$(grep -c 'addvlan='${vlan[0]}',' $helpFile)
		if [ $test = 0 ]
                then
			echo '<text x="'$vlan_x2'" y="'$text_y1'" style="font-size:10px">'Additional VLAN IDs'</text>' >> $pictureFile
                fi
		while [ $b -lt $vlan_count ]
                do
			test_x=$(grep 'addvlan='${vlan[$b]}',' $helpFile | cut -f 2 -d ',')
			test=$(grep -c 'addvlan='${vlan[$b]}',' $helpFile)
			set -A vlan_pv $(grep ',vlan='${vlan[$b]}',' $helpFile | cut -f 3 -d ',')
                        vlany_count=$(grep -c ',vlan='${vlan[$b]}',' $helpFile)
                        c=0
                        while [ $c -lt $vlany_count ]
                        do
                                ((vlan_y1=vlan_pv[$c]-7))
                        	if [ $test = 0 ]
				then  
			      		echo '<line x1="'$vlan_x1'" y1="'$vlan_y1'" x2="'$vlan_x2'" y2="'$vlan_y1'" style="stroke:black;stroke-width:1" />' >> $pictureFile
                                	echo '<circle cx="'$vlan_x2'" cy="'$vlan_y1'" r="2.5" />' >> $pictureFile
                                	echo 'addvlan='${vlan[$b]}','$vlan_x2','$vlan_y1 >> $helpFile
                                else
					echo '<line x1="'$vlan_x1'" y1="'$vlan_y1'" x2="'$test_x'" y2="'$vlan_y1'" style="stroke:black;stroke-width:1" />' >> $pictureFile
					echo '<circle cx="'$test_x'" cy="'$vlan_y1'" r="2.5" />' >> $pictureFile
				fi
				((c=c+1))
                        done
                        if [ $test = 0 ]
                        then

				echo '<line x1="'$vlan_x2'" y1="'$starty'" x2="'$vlan_x2'" y2="'$vlan_y2'" style="stroke:black;stroke-width:1" />' >> $pictureFile
                        	echo '<rect x="'$vlan_x2'" y="'$starty'" width="25" height="12" fill="white" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
 	                       ((text_y=starty+11))
        	                echo '<text x="'$vlan_x2'" y="'$text_y'" style="font-size:10px">'${vlan[$b]}'</text>' >> $pictureFile
                	        ((vlan_x2=vlan_x2+30))
			fi

                       	((b=b+1))
                done
       fi
# draw VLANs not provided via VIO
################################################################
	set -A vlan $(echo $addVlanString | tr ',' '\n')
	vlan_count=$(echo $addVlanString | tr ',' '\n' | wc | awk '{print $1}')
	((vlan_count=vlan_count-1))
	b=0
	while [ $b -lt $vlan_count ]
	do
		echo '<line x1="'$vlan_x2'" y1="'$starty'" x2="'$vlan_x2'" y2="'$vlan_y2'" style="stroke:black;stroke-width:1" />' >> $pictureFile
                echo '<rect x="'$vlan_x2'" y="'$starty'" width="25" height="12" fill="white" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
                ((text_y=starty+11))
                echo '<text x="'$vlan_x2'" y="'$text_y'" style="font-size:10px">'${vlan[$b]}'</text>' >>$pictureFile
        	echo 'addvlan='${vlan[$b]}','$vlan_x2','$vlan_y1 >> $helpFile
	        ((vlan_x2=vlan_x2+30))
		
		((b=b+1))
	done

}

#########################################################################
# Function to draw Client LPARs						#
#########################################################################

drawClient ()
{
# set start variables
#########################################################################
	set -A ClientHostname $(grep $1 $configFile | grep 'lpar_env=aixlinux' | cut -f 2 -d ',' | cut -f 2 -d '=')
        ClientHostname_count=$(grep $1 $configFile | grep 'lpar_env=aixlinux' | wc | awk '{print $1}')
        ((client_x=vlan_x2+80))
        client_y=$starty
	b=0
        while [ $b -lt $ClientHostname_count ]
        do
		set -A clientPhys $(grep $1 $configFile | grep ${ClientHostname[$b]} | grep 'io_adapter' | sed 's/=/\n/g' | grep Ethernet | cut -f 1 -d ',') 	
		
		clientPhys_count=$(grep $1 $configFile | grep ${ClientHostname[$b]} | grep 'io_adapter' | sed 's/=/\n/g' | grep -c Ethernet) 	
	      	clientDev_count=$(grep $1 $configFile | grep -v 'lpar_env=aixlinux' | grep -c 'name='${ClientHostname[$b]})
                set -A clientId $(grep $1 $configFile | grep -v 'lpar_env=aixlinux' | grep 'name='${ClientHostname[$b]} | cut -f 3 -d ',' | cut -f 2 -d '=')
                set -A clientDevSlot $(grep $1 $configFile | grep -v 'lpar_env=aixlinux' | grep 'name='${ClientHostname[$b]} | cut -f 4 -d ',' | cut -f 2 -d '=')
                set -A clientDevVlan $(grep $1 $configFile | grep -v 'lpar_env=aixlinux' | grep 'name='${ClientHostname[$b]} | cut -f 9 -d ',' | cut -f 2 -d '=')
                set -A clientDevMac $(grep $1 $configFile | grep -v 'lpar_env=aixlinux' | grep 'name='${ClientHostname[$b]} | cut -f 12 -d ',' | cut -f 2 -d '=')
	        ((clientSize_y=clientDev_count*40+40))
		((clientSizePhys_y=clientPhys_count*40+40))
		if [ $clientSize_y -lt $clientSizePhys_y ]
		then
			clientSize_y=$clientSizePhys_y
		fi
          	if [ $client_x -lt $startx ]
		then
			client_x=800
		fi 
	      	echo '<rect x="'$client_x'" y="'$client_y'" width="'$clientSize_x'" height="'$clientSize_y'" fill="antiquewhite" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
                ((text_x=client_x+50))
                ((text_y=client_y+20))
                echo '<text x="'$text_x'" y="'$text_y'">'${ClientHostname[$b]}'</text>' >> $pictureFile
                ((clientPhys_y=client_y+40))
                ((clientPhys_x=client_x+clientSize_x-15))
		c=0
		while [ $c -lt $clientPhys_count ]
		do
			echo '<rect x="'$clientPhys_x'" y="'$clientPhys_y'" width="35" height="12" fill="powderblue" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
			((devText_x=clientPhys_x-40))
                        ((devText_y=clientPhys_y-2))
	#		echo '<text x="'$devText_x'" y="'$devText_y'" style="font-size:10px">'${clientPhys[$c]}'</text>' >> $pictureFile
			((clientPhys_y=clientPhys_y+40))
			((c=c+1))
		done
		((clientDev_y=client_y+40))
                ((clientDev_x=client_x-15))
                c=0
		while [ $c -lt $clientDev_count ]
                do
                        echo '<rect x="'$clientDev_x'" y="'$clientDev_y'" width="35" height="12" fill="greenyellow" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
                        ((devText_x=clientDev_x+5))
                        ((devText_y=clientDev_y+11))
                        clientDevLoc=$(echo $pvLoc | cut -f 1 -d '-')
			clientDevLoc=$clientDevLoc'-V'${clientId[0]}'-C'${clientDevSlot[$c]}'-T1'
                        ((textLoc_x=clientDev_x-60))
                        ((textLoc_y=clientDev_y-2))
                        echo '<text x="'$textLoc_x'" y="'$textLoc_y'" style="font-size:10px">'$clientDevLoc'</text>' >> $pictureFile
                        ((textMac_x=textLoc_x+40))
			((textMac_y=textLoc_y+25))
                        echo '<text x="'$textMac_x'" y="'$textMac_y'" style="font-size:10px">'${clientDevMac[$c]}'</text>' >> $pictureFile
			
			clientVlan_x1=$(grep 'addvlan='${clientDevVlan[$c]}',' $helpFile | cut -f 2 -d ',' | sort -u)
		        if [ -z $clientVlan_x1 ]
			then 
				clientVlan_x1=$(grep 'lan='${clientDevVlan[$c]}',' $helpFile | cut -f 3 -d ',' | sort -u)
			fi 
			((clientVlan_y=clientDev_y+5))
                        echo '<line x1="'$clientVlan_x1'" y1="'$clientVlan_y'" x2="'$clientDev_x'" y2="'$clientVlan_y'" style="stroke:black;stroke-width:1" />' >> $pictureFile
                        echo '<circle cx="'$clientVlan_x1'" cy="'$clientVlan_y'" r="2.5" />' >> $pictureFile
                        ((clientDev_y=clientDev_y+40))
                        ((c=c+1))
                done
                ((client_y=client_y+clientSize_y+40))
                ((b=b+1))
        done
}

#################################################################
# Main 								#
#################################################################

# set global variables
#################################################################
hostname=$1
dir=$2
configFile=$dir'/'$hostname'_LanConfig.out'

set -A MaganedSystem $(grep 'ManagedSystem=' $configFile | cut -f 2 -d ',' | sort -u)
ManagedSystem_count=$(grep 'ManagedSystem=' $configFile | cut -f 2 -d ',' | sort -u | wc | awk '{print $1}')

startx=200
starty=150
offsety=100

# draw one picture for each Managed System managed by this HMC
################################################################
x=0
while [ $x -lt $ManagedSystem_count ]

do

# define files
################################################################
        helpFile=$dir'/'${MaganedSystem[$x]}'_help'
        pictureFile=$dir'/'${MaganedSystem[$x]}'_LAN_temp.svg'
	htmlFile=$dir'/'${MaganedSystem[$x]}'_LAN.php'
	lanPicture=$dir'/'${MaganedSystem[$x]}'_LAN.svg'
	ethHelp=$dir'/ethHelp'
	seaHelp=$dir'/seaHelp'
	vlanHelp=$dir'/'${MaganedSystem[$x]}'_vlanHelp'
	vioHelp=$dir'/vioHelp'
	> $vioHelp
	> $lanPicture
        > $pictureFile
        > $helpFile
	> $htmlFile

# define spezific variables for this Managed System 
######################################################################
        sizePicturex=1300
        sizePicturey=$starty
        sizeViox=250
	clientSize_x=200

        vlan_count=0

        set -A VioHostname $(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_env=vioserver' | cut -f 2 -d ',' | sort -u | cut -f 2 -d '=')
        VioHostname_count=$(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_env=vioserver' | cut -f 2 -d ',' | sort -u |  wc | awk '{print $1}')

	set -A ClientHostname $(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_env=aixlinux' | cut -f 2 -d ',' | cut -f 2 -d '=')
        ClientHostname_count=$(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_env=aixlinux' | wc | awk '{print $1}')
        
# calculate hight of all Clients 
#########################################################################
	y=0
        clientSize_y=$starty
        while [ $y -lt $ClientHostname_count ]
        do
                clientDev_count=$(grep ${MaganedSystem[$x]} $configFile | grep -v 'lpar_env=aixlinux' | grep -c ',lpar_name='${ClientHostname[$y]})
		clientPhys_count=$(grep ${MaganedSystem[$x]} $configFile | grep ${ClientHostname[$y]} | grep 'io_adapter' | sed 's/=/\n/g' | grep -c Ethernet) 	
                ((size_y1=clientDev_count*40+40))
		((size_y2=clientPhys_count*40+40))
		if [ $size_y1 -lt $size_y2 ]
		then
                	((clientSize_y=clientSize_y+size_y2+40))
		else
			((clientSize_y=clientSize_y+size_y1+40))
		fi
                ((y=y+1))
        done
# call function to draw Virtual I/O server
##########################################################################
	drawVio ${MaganedSystem[$x]}

# calculate hight of picture
#########################################################################	
	set -A allVioY $(grep ${MaganedSystem[$x]} $vioHelp | cut -f 3 -d ',')
	allVioY_count=$(grep -c ${MaganedSystem[$x]} $vioHelp)
	pictureSize_y=0
	y=0
	while [ $y -lt $allVioY_count ]
	do
		if [ $pictureSize_y -lt ${allVioY[$y]} ]
		then
			pictureSize_y=${allVioY[$y]}
		fi
		((y=y+1))
	done
	if [ $pictureSize_y -lt $clientSize_y ]
        then
                pictureSize_y=$clientSize_y
        fi
	((pictureSize_y=pictureSize_y+offsety))	

# check additional VLANs, not supported via VIO
#########################################################################
	addVlanString=''
	set -A vlan1 $(grep ${MaganedSystem[$x]} $configFile | grep port_vlan_id= | cut -f 9 -d ',' | grep -v ieee_virtual_eth | sort -u | cut -f 2 -d '=') 
	vlan1_count=$(grep ${MaganedSystem[$x]} $configFile | grep port_vlan_id= | cut -f 9 -d ',' | grep -v ieee_virtual_eth | sort -u | wc | awk '{print $1}')
	y=0
	while [ $y -lt $vlan1_count ]
	do
		addVlanIdTest=$(grep '='${vlan1[$y]} $helpFile)
		if [ -z "$addVlanIdTest" ]
		then
			addVlanString=$addVlanString','${vlan1[$y]}
		fi
		((y=y+1))
	done
	set -A vlan2 $(grep ${MaganedSystem[$x]} $configFile | grep port_vlan_id= | cut -f 10 -d ',' | grep -v vswitch= | sort -u | cut -f 2 -d '=')
	vlan2_count=$(grep ${MaganedSystem[$x]} $configFile | grep port_vlan_id= | cut -f 10 -d ',' | grep -v vswitch= | sort -u |  wc | awk '{print $1}')
	y=0
        while [ $y -lt $vlan2_count ]
        do
                addVlanIdTest=$(grep '='${vlan2[$y]} $helpFile)
                if [ -z "$addVlanIdTest" ]
                then
                        addVlanString=$addVlanString','${vlan2[$y]}
                fi
                ((y=y+1))
        done

	set -A vlan3 $(grep ${MaganedSystem[$x]} $configFile | grep port_vlan_id= | grep -v addl_vlan_ids=,mac)
	vlan3_count=$(grep ${MaganedSystem[$x]} $configFile | grep port_vlan_id= | grep -v addl_vlan_ids=,mac | wc | awk '{print $1}')	
	y=0
	while [ $y -lt $vlan3_count ]
	do
		test=$(echo ${vlan3[$y]} | grep -c '"')
		 if [ $test != 0 ]
                 then
			echo ${vlan3[$y]} | tr '"' '\n' > $vlanHelp
		else 
			 echo ${vlan3[$y]} | tr "," "\n" > $vlanHelp
		fi
		line_count=$(wc $vlanHelp | awk '{print $1}')
                addVlan=$(grep 'addl_vlan' $vlanHelp | cut -f 2 -d '=')
                test=$(echo $addVlan | wc | awk '{print $2}')
                if [ $test != 0 ]
               then
	                addVlan_count=$(echo $addVlan | tr "," "\n" | wc | awk '{print $1}')
			if [ $addVlan_count -gt 0 ]
                        then
                                c=1
                                while [ $c -lt $addVlan_count ]
                                do
	                                vlan=$(echo $addVlan | cut -f $c -d ',')
					addVlanIdTest=$(grep '='$vlan $helpFile)
                			if [ -z "$addVlanIdTest" ]
                			then
                        			addVlanString=$addVlanString','$vlan
                			fi

					((c=c+1))
                                done
                        fi
		fi
		((y=y+1))
	done

# call functions to draw virtual LANs and Clients
##########################################################################
	drawVlan
        drawClient ${MaganedSystem[$x]}

# calculate page width
#########################################################################
	((sizePic_x=client_x+startx+100))       	
	if [ $sizePicturex -lt $sizePic_x ]
	then
		sizePicturex=$sizePic_x
	fi

# write header to SVG file
#########################################################################
	echo "<?xml version=\"1.0\" standalone=\"no\" ?>" >> $lanPicture
	echo "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 20010904//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\" >" >> $lanPicture
	echo "<svg width=\""$sizePicturex"\" height=\""$pictureSize_y"\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" >" >> $lanPicture

# write title to SVG file
##############################################################################	
#	type=$(grep 'ManagedSystem=' $configFile | grep ${MaganedSystem[$x]} | cut -f 2 -d '=' | cut -f 2 -d '-')
#	model=$(grep 'ManagedSystem=' $configFile | grep ${MaganedSystem[$x]} | cut -f 2 -d '=' | cut -f 3 -d '-')
	name=$(grep 'ManagedSystem=' $configFile | grep ${MaganedSystem[$x]} | cut -f 1 -d ',' | cut -f 2 -d '=')
	creationYear=$(grep 'creationDate=' $configFile | awk '{print $6}' | sort -u)
	creationMonth=$(grep 'creationDate=' $configFile | awk '{print $2}' | sort -u)
	creationDay=$(grep 'creationDate=' $configFile | awk '{print $3}' | sort -u) 
	 
	((title_y=starty-100))
        echo '<text x="'$startx'" y="'$title_y'" style="font-size:20px">VLAN Configuration from Managed System</text>' >> $lanPicture
	((title_x=startx+100))
	((title_y=title_y+40))
#	echo '<text x="'$title_x'" y="'$title_y'" style="font-size:25px">'$type' - '$model' - '${MaganedSystem[$x]}'</text>' >> $lanPicture
	echo '<text x="'$title_x'" y="'$title_y'" style="font-size:25px">'$name'</text>' >> $lanPicture
	((title_y=title_y+30))
	echo '<text x="'$title_x'" y="'$title_y'" style="font-size:15px">created: '$creationMonth' '$creationDay' '$creationYear'</text>' >> $lanPicture
	

# draw legend to SVG file
############################################################################# 
	((legend_x1=sizePicturex-150))
	((legend_y1=starty-90))
	echo '<text x="'$legend_x1'" y="'$legend_y1'" style="font-size:10px">VLAN Adapter</text>' >> $lanPicture
	((legend_y2=legend_y1+20))
	echo '<text x="'$legend_x1'" y="'$legend_y2'" style="font-size:10px">Virtual Adapter</text>' >> $lanPicture
	((legend_y3=legend_y2+20))
        echo '<text x="'$legend_x1'" y="'$legend_y3'" style="font-size:10px">Control Channel Adapter</text>' >> $lanPicture
	((legend_x2=legend_x1-20))
	((legend_y4=legend_y1-10))
	echo '<rect x="'$legend_x2'" y="'$legend_y4'" width="10" height="10" fill="peachpuff" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	((legend_y5=legend_y2-10))
	echo '<rect x="'$legend_x2'" y="'$legend_y5'" width="10" height="10" fill="greenyellow" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	((legend_y6=legend_y3-10))
	echo '<rect x="'$legend_x2'" y="'$legend_y6'" width="10" height="10" fill="lightgrey" style="stroke:black;stroke-width:1px"/>' >> $lanPicture

	((legend_x3=legend_x2-150))	
	echo '<text x="'$legend_x3'" y="'$legend_y1'" style="font-size:10px">Shared Ethernet Adapter</text>' >> $lanPicture
	echo '<text x="'$legend_x3'" y="'$legend_y2'" style="font-size:10px">Ether Channel Adapter</text>' >> $lanPicture
	echo '<text x="'$legend_x3'" y="'$legend_y3'" style="font-size:10px">Physical Adapter</text>' >> $lanPicture
	((legend_x4=legend_x3-20))
	echo '<rect x="'$legend_x4'" y="'$legend_y4'" width="10" height="10" fill="yellow" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	echo '<rect x="'$legend_x4'" y="'$legend_y5'" width="10" height="10" fill="lavender" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	echo '<rect x="'$legend_x4'" y="'$legend_y6'" width="10" height="10" fill="powderblue" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	
	((legend_x5=legend_x3-150))
        echo '<text x="'$legend_x5'" y="'$legend_y3'" style="font-size:10px">Logical Partition</text>' >> $lanPicture
	((legend_x6=legend_x5-20))
	echo '<rect x="'$legend_x6'" y="'$legend_y6'" width="10" height="10" fill="antiquewhite" style="stroke:black;stroke-width:1px"/>' >> $lanPicture

	((legend_x7=legend_x6-10))
	((legend_y7=legend_y4-10))
	echo '<rect x="'$legend_x7'" y="'$legend_y7'" width="470" height="70" fill="none" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	echo '<rect x="'$legend_x7'" y="'$legend_y7'" width="130" height="35" fill="none" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
	((legend_y=legend_y7+20))
	echo '<text x="'$legend_x5'" y="'$legend_y'" style="font-size:15px">Legend</text>' >> $lanPicture	


	((copy_y=legend_y7-30))
        echo '<text x="'$legend_x1'" y="'$copy_y'" style="font-family:Arial Unicode MS;font-size:10px">&#x00A9;</text>' >> $lanPicture
        ((copy_x=sizePicturex-130))
        echo '<text x="'$copy_x'" y="'$copy_y'" style="font-size:10px">IBM Corporate 2008</text>' >> $lanPicture
	
# draw VIO LPAR to SVG file
############################################################################
	vio_y=$starty
	y=0
	while [ $y -lt $VioHostname_count ]
	do
		sizeVioy=$(grep ${VioHostname[$y]}',' $vioHelp | cut -f 3 -d ',')
		((hightVio=sizeVioy-vio_y))
		echo '<rect x="'$startx'" y="'$vio_y'" width="'$sizeViox'" height="'$hightVio'" fill="antiquewhite" style="stroke:black;stroke-width:1px"/>' >> $lanPicture
		
		((locText_x=startx+100))
                ((locText_y=vio_y+20))
                echo '<text x="'$locText_x'" y="'$locText_y'">'${VioHostname[$y]}'</text>' >> $lanPicture

		((vio_y=vio_y+hightVio+offsety))
		((y=y+1))
	done

# write temp file to SVG
##############################################################################
	cat $pictureFile >> $lanPicture
	
	echo "</svg>" >> $lanPicture

# make html file
#############################################################################
	echo '<HTML><HEAD><TITLE></TITLE></HEAD>' > $htmlFile
	echo '<embed src="'${MaganedSystem[$x]}'_LAN.svg" width="'$sizePicturex'" height="'$pictureSize_y'" type="image/svg+xml">' >> $htmlFile
	echo '<BODY></BODY></HTML>' >> $htmlFile

# delete help files
#############################################################################
	rm $vioHelp >> /dev/null 2>&1
	rm $vlanHelp >> /dev/null 2>&1
	rm $seaHelp >> /dev/null 2>&1
	rm $ethHelp >> /dev/null 2>&1
	rm $pictureFile >> /dev/null 2>&1
	rm $helpFile >> /dev/null 2>&1

	
        ((x=x+1))
done
