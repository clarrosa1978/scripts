#!/bin/bash
#####################################################
# Name:        	drawSanPicture 
# Function:    	draw the virtual SAN configuration of Managed System  
# Version:      1.0 - draft
#
# Author:       Sandra Ulber
# Date:         23.10.2008
#
# Copy right for IBM Deutschland GmbH
# Change Log
# - changed hash bang to /bin/ksh for better portability
########################################################


################################################
# define functions
###############################################

drawVio ()
{
	declare -a VioHostname=( $(grep $1 $configFile | grep 'lpar_env=vioserver' |grep -v 'FC'| cut -f 2 -d ',' | sort -u | cut -f 2 -d '='))
        VioHostname_count=${#VioHostname[@]}
	vio_y=$starty
	((vhostLine_x2=startx+sizeViox+100))	
        a=0
        while [ $a -lt $VioHostname_count ]
        do
	        # draw VIO LPAR
       		declare -a vhostAdap=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'vhost=' | cut -f 3 -d ',' | cut -f 2 -d '='))
		vhostAdap_count=${#vhostAdap[@]}   
       		declare -a vfchosts=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'vfchost' | cut -f 4 -d ','))
		vfchost_count=${#vfchosts[@]}

		lparId=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep -v FC| grep 'adapter_type=server' | cut -f 3 -d ',' | cut -f 2 -d '=' | sort -u)   
       		declare -a vhostSlot=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'vhost=' | cut -f 4 -d ',' | cut -f 2 -d '=' | cut -f 3 -d '.' | cut -f 3 -d '-' | cut -c 2-3))
       		declare -a vfchostSlot=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'vfchost' | cut -f 5 -d ',' | cut -f 3 -d '-'))
		declare -a fcsAdap=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'WWPN=' | cut -f 3 -d ',' | cut -f 2 -d '='))
        	declare -a fcsAdapLocs=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'WWPN=' | cut -f 4 -d ',' | cut -f 2 -d '='))
        	declare -a fcsAdapWWPN=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'WWPN=' | cut -f 5 -d ',' | cut -f 2 -d '=' | cut -c 21-36))
        	fcsAdap_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep -c 'WWPN=')
		declare -a addPhys=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'io_adapter' | tr "=" "\n" | grep -v ${VioHostname[$a]} | grep -v Ethernet | grep -v 'PCI-to-PCI_bridge' | grep -v 'Fibre_Channel' | cut -f 1 -d ','))
		declare -a addPhysType $(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'io_adapter' | tr "=" "\n" | grep -v ${VioHostname[$a]} | grep -v Ethernet | grep -v 'PCI-to-PCI_bridge' | grep -v 'Fibre_Channel' | cut -f 2 -d ',' | cut -f 1 -d '_')
		addPhys_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'io_adapter' | tr "=" "\n" | grep -v ${VioHostname[$a]}| grep -v Ethernet | grep -v 'PCI-to-PCI_bridge' | grep -v 'Fibre_Channel' | wc | awk '{print $1}')
		
		((phys_count=fcsAdap_count+addPhys_count))
		((virt_count=vhostAdap_count+vfchost_count))

		if [ $phys_count -lt $virt_count ]
		then
	        	((sizeVioy=virt_count*50+40))
		else
			((sizeVioy=phys_count*50+40))
		fi

		id="lsnports_"${VioHostname[$a]}
		echo '<rect x="'$startx'" y="'$vio_y'" width="'$sizeViox'" height="'$sizeVioy'" fill="antiquewhite" style="stroke:red;stroke-width:1px" onclick="top.showMessage('$id')" onmouseover="evt.target.setAttribute('"'"'opacity'"'"', '"'"'0.5'"'"');" onmouseout="evt.target.setAttribute('"'"'opacity'"'"', '"'"'1'"'"');"/>' >> $pictureFile
                echo '${VioHostname[$a]}','$startx','$vio_y' >> $helpFile

                ((locText_x=startx+100))
                ((locText_y=vio_y+20))
                echo '<text x="'$locText_x'" y="'$locText_y'">'${VioHostname[$a]}'</text>' >> $pictureFile

# draw FC adapter
####################################################################
		((fcs_x1=startx-15))
		((fcs_y1=vio_y+50))
		b=0
		while [ $b -lt $fcsAdap_count ]
		do
			echo '<rect x="'$fcs_x1'" y="'$fcs_y1'" width="35" height="12" fill="powderblue" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
			((text_x1=fcs_x1+5))
			((text_y1=fcs_y1+11))
			echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'${fcsAdap[$b]}'</text>' >> $pictureFile

			((text_x2=fcs_x1-50))
                        ((text_y2=fcs_y1-2))
                        echo '<text x="'$text_x2'" y="'$text_y2'" style="font-size:10px">'${fcsAdapLoc[$b]}'</text>' >> $pictureFile
			((text_x3=fcs_x1-50))
                        ((text_y3=fcs_y1+25))
                        echo '<text x="'$text_x3'" y="'$text_y3'" style="font-size:10px">'${fcsAdapWWPN[$b]}'</text>' >> $pictureFile

                	echo ${VioHostname[$a]}','${fcsAdap[$b]}','$startx','$fcs_y1 >> $helpFile
			((fcs_y1=fcs_y1+50))	
			((b=b+1))
		done 			

# draw vhost adapter
#####################################################################
		((vhost_x1=startx+sizeViox-15))
		((vhost_y1=vio_y+50))
		type=$(grep 'ManagedSystem=' $configFile | grep $1 | cut -f 3 -d ',' | cut -f 1 -d '-')
		model=$(grep 'ManagedSystem=' $configFile | grep $1 | cut -f 3 -d ',' | cut -f 2 -d '-')
		((vhostLine_x1=vhost_x1+35))
		b=0
		while [ $b -lt $vhostAdap_count ]
		do
			echo '<rect x="'$vhost_x1'" y="'$vhost_y1'" width="35" height="12" fill="greenyellow" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
			echo ${VioHostname[$a]}',slotId='${vhostSlot[$b]}','$vhost_x1','$vhost_y1 >> $helpFile
			((text_x1=vhost_x1+5))
                        ((text_y1=vhost_y1+11))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'${vhostAdap[$b]}'</text>' >> $pictureFile
			((text_x2=vhost_x1-50))
                        ((text_y2=vhost_y1-2))
                	vhostLoc='U'$type'.'$model'.'$1'-V'$lparId'-C'${vhostSlot[$b]}'-T1'
		        echo '<text x="'$text_x2'" y="'$text_y2'" style="font-size:10px">'$vhostLoc'</text>' >> $pictureFile
			remoteLpar=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'slot_num='${vhostSlot[$b]} | grep 'adapter_type=server' | cut -f 9 -d ','| cut -f 2 -d '=')
			remoteLparId=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'slot_num='${vhostSlot[$b]} | grep 'adapter_type=server' | cut -f 10 -d ','| cut -f 2 -d '=')
			
			((vhostLine_y1=vhost_y1+5))
			((vhostLine_y2=starty))
			((vhostLine_y3=sizePicturey-50))
			echo '<line x1="'$vhostLine_x1'" y1="'$vhostLine_y1'" x2="'$vhostLine_x2'" y2="'$vhostLine_y1'" style="stroke:orange;stroke-width:2;" />' >> $pictureFile
                       	echo '<circle cx="'$vhostLine_x2'" cy="'$vhostLine_y1'" r="2.5" />' >> $pictureFile
			echo ${VioHostname[$a]}',mapping='$remoteLpar','$vhostLine_x2','$vhostLine_y1',remoteSlot='$remoteLparId >> $helpFile

                        remoteLparId=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'slot_num='${vhostSlot[$b]} | grep 'adapter_type=server' | cut -f 10 -d ','| cut -f 2 -d '=')
			((hdisk_x=vhost_x1-80))
			id="'"${VioHostname[$a]}"_vhost"$b"'"
			echo '<ellipse id="'${VioHostname[$a]}'_vhost'$b'" cx="'$hdisk_x'" cy="'$vhostLine_y1'" rx="35" ry="12" fill="lightyellow" style="stroke:red;stroke-width:1px" onclick="top.showMessage('$id')" onmouseover="evt.target.setAttribute('"'"'opacity'"'"', '"'"'0.5'"'"');" onmouseout="evt.target.setAttribute('"'"'opacity'"'"', '"'"'1'"'"');"/> ' >> $pictureFile 
			((hdiskLine_x=hdisk_x+35))
			echo '<line x1="'$hdiskLine_x'" y1="'$vhostLine_y1'" x2="'$vhost_x1'" y2="'$vhostLine_y1'" style="stroke:orange;stroke-width:2;" />' >> $pictureFile
			((text_x=hdisk_x-10))
			((text_y=vhostLine_y1+5))
			echo '<text x="'$text_x'" y="'$text_y'" style="font-size:10px" onclick="top.showMessage('$id')" onmouseover="evt.target.setAttribute('"'"'opacity'"'"', '"'"'0.5'"'"');" onmouseout="evt.target.setAttribute('"'"'opacity'"'"', '"'"'1'"'"');">hdisk</text>' >> $pictureFile
			((vhostLine_x2=vhostLine_x2+30))
			((vhost_y1=vhost_y1+50))
			((b=b+1))
		done
	
# draw vfchost adapter
#########################################################################
		 b=0
                while [ $b -lt $vfchost_count ]
                do
			id="'"${VioHostname[$a]}'_'${vfchosts[$b]}"'"
                        echo '<rect x="'$vhost_x1'" y="'$vhost_y1'" width="35" height="12" fill="greenyellow" style="stroke:black;stroke-width:1px" onclick="top.showMessage('$id')" onmouseover="evt.target.setAttribute('"'"'opacity'"'"', '"'"'0.5'"'"');" onmouseout="evt.target.setAttribute('opacity', '1');"/>' >> $pictureFile
                        echo ${VioHostname[$a]}',slotId='${vfchostSlot[$b]}','$vhost_x1','$vhost_y1 >> $helpFile
                        ((text_x1=vhost_x1+3))
                        ((text_y1=vhost_y1+11))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px" onclick="top.showMessage('$id')" onmouseover="evt.target.setAttribute('"'"'opacity'"'"', '"'"'0.5'"'"');" onmouseout="evt.target.setAttribute('"'"'opacity'"'"', '"'"'1'"'"');">'${vfchosts[$b]}'</text>'>> $pictureFile

			((text_x2=vhost_x1-50))
                        ((text_y2=vhost_y1-2))
                        vfchostLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vfchosts[$b]}',' | cut -f 5 -d ',')
                        echo '<text x="'$text_x2'" y="'$text_y2'" style="font-size:10px">'$vfchostLoc'</text>' >> $pictureFile
			slotID=$(echo ${vfchostSlot[$b]} | cut -c 2-4)
                        remoteLpar=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vfchosts[$b]}',' | cut -f 7 -d ',') 
                        #remoteLpar=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',slot_num='$slotID',' | cut -f 10 -d ',' | cut -f 2 -d '=' ) 
                        remoteLparId=$(grep $1 $configFile | grep ${VioHostname[$a]} |grep ${vfchosts[$b]}',' | cut -f 15 -d ',' | cut -f 3 -d '-' | cut -c 2-4) 
                        #remoteLparId=$(grep $1 $configFile | grep ${VioHostname[$a]} |grep ',slot_num='$slotID',' | cut -f 11 -d ',' | cut -f 2 -d '=') 

			((vhostLine_y1=vhost_y1+5))
                        ((vhostLine_y2=starty))
                        ((vhostLine_y3=sizePicturey-50))
                        echo '<line x1="'$vhostLine_x1'" y1="'$vhostLine_y1'" x2="'$vhostLine_x2'" y2="'$vhostLine_y1'" style="stroke:blue;stroke-width:1;" />' >> $pictureFile
                        echo '<circle cx="'$vhostLine_x2'" cy="'$vhostLine_y1'" r="2.5" />' >> $pictureFile
                        echo '${VioHostname[$a]}',mapping='$remoteLpar','$vhostLine_x2','$vhostLine_y1',remoteSlot='$remoteLparId' >> $helpFile
			backingFC=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vfchosts[$b]}',' | cut -f 9 -d ',' |cut -f 2 -d ':')
			vfchostLine_x1=$(grep ${VioHostname[$a]} $helpFile | grep $backingFC | cut -f 3 -d ',')
			vfchostLine_y1=$(grep ${VioHostname[$a]} $helpFile | grep $backingFC | cut -f 4 -d ',')
			((vfchostLine_x1=vfchostLine_x1+20))
			((vfchostLine_y1=vfchostLine_y1+6))
			((vfchostLine_y2=vhost_y1+6))
			echo '<line x1="'$vfchostLine_x1'" y1="'$vfchostLine_y1'" x2="'$vhost_x1'" y2="'$vfchostLine_y2'" style="stroke:blue;stroke-width:1;" />' >> $pictureFile

			((vhostLine_x2=vhostLine_x2+30))
                        ((vhost_y1=vhost_y1+50))
                        ((b=b+1))
                done


# draw SCSI adapter
#########################################################################
		((addPhys_y1=fcs_y1))
		((addPhys_x1=fcs_x1))
		b=0
		while [ $b -lt $addPhys_count ]
		do
			echo '<rect x="'$addPhys_x1'" y="'$addPhys_y1'" width="35" height="12" fill="powderblue" style="stroke:red;stroke-width:1px"/>' >> $pictureFile
			((text_x1=addPhys_x1+5))
                        ((text_y1=addPhys_y1+11))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'${addPhysType[$b]}'</text>' >> $pictureFile

			((text_x1=addPhys_x1-50))
                        ((text_y1=addPhys_y1-2))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'${addPhys[$b]}'</text>' >> $pictureFile
                	echo ${VioHostname[$a]}','${addPhys[$b]}','$startx','$vio_y >> $helpFile
			((addPhys_y1=addPhys_y1+50))
			((b=b+1))
		done	
	
		((vio_y=vio_y+sizeVioy+offsety))

	((a=a+1))
done
}

drawClient ()

{
	client_x3=0
	client_y3=0
	
	declare -a clientHostname=($(grep 02BE5FP server/200.200.20.5_SanConfig.out | grep 'lpar_env=aixlinux' | cut -f 2 -d ',' | cut -f 2 -d '='))
	clientHostname_count=$(grep $1 $configFile | grep 'lpar_env=aixlinux' | cut -f 2 -d ',' | sort -u | wc | awk '{print $1}')
	((client_x1=vhostLine_x2+100))
	((client_y1=starty))
	b=0
	while [ $b -lt $clientHostname_count ]
	do
		clientId=$(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_name='${clientHostname[$b]} | grep -v 'adapter_type=server' | cut -f 3 -d ',' |sort -u |  cut -f 2 -d '=')
		declare -a clientVhost=($(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_name='${clientHostname[$b]} | grep -v 'adapter_type=server'| grep -v FC | cut -f 4 -d ',' | sort -u | cut -f 2 -d '='))
		clientVhost_count=${#clientVhost[@]}
		
		declare -a clientVfchost=($(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_name='${clientHostname[$b]} | grep -v 'adapter_type=server'| grep FC | cut -f 5 -d ',' | sort -u | cut -f 2 -d '='))
		clientVfchost_count=${#clientVfchost[@]}

		declare -a addPhysClient=($(grep $1 $configFile | grep ${clientHostname[$b]} | grep 'io_adapter' | tr "=" "\n" | grep -v ${clientHostname[$b]} | grep -v Ethernet | grep -v 'PCI-to-PCI_bridge' | grep -v 'No_results' | cut -f 1 -d ','))
                declare -a addPhysClientType=($(grep $1 $configFile | grep ${clientHostname[$b]} | grep 'io_adapter' | tr "=" "\n" | grep -v ${clientHostname[$b]} | grep -v Ethernet | grep -v 'PCI-to-PCI_bridge' | cut -f 2 -d ',' | cut -f 1 -d ','))
                addPhysClient_count=$(grep $1 $configFile | grep ${clientHostname[$b]} | grep 'io_adapter' | tr "=" "\n" | grep -v ${clientHostname[$b]}| grep -v Ethernet | grep -v 'No_results' | wc | awk '{print $1}')
	
	
		((virt_Adapter=clientVhost_count+clientVfchost_count))	
		if [ $addPhysClient_count -lt $virt_Adapter ]
		then
			((sizeClient_y=virt_Adapter*40+40)) 
		else
			((sizeClient_y=addPhysClient_count*40+40))
		fi
		echo '<rect x="'$client_x1'" y="'$client_y1'" width="'$clientSize_x'" height="'$sizeClient_y'" fill="antiquewhite" style="stroke:black;stroke-width:1px"/>' >> $pictureFile
                echo ${clientHostname[$b]}','$client_x1','$client_y1 >> $helpFile
	
		((text_x1=client_x1+50))
		((text_y1=client_y1+20))
		 echo '<text x="'$text_x1'" y="'$text_y1'">'${clientHostname[$b]}'</text>' >> $pictureFile	
	
		((client_x2=client_x1-15))
		((client_y2=client_y1+40))
		c=0
		while [ $c -lt $clientVhost_count ]
		do 
			echo '<rect x="'$client_x2'" y="'$client_y2'" width="35" height="12" fill="greenyellow" style="stroke:yellow;stroke-width:1px"/>' >> $pictureFile
                        echo ${clientHostname[$b]}',slotId='${clientVhost[$c]}','$client_x2','$client_y2 >> $helpFile
                        ((text_x1=client_x2+5))
                        ((text_y1=client_y2+11))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">vhost'$c'</text>' >> $pictureFile		

			clientLoc='U'$type'.'$model'.'$1'-V'$clientId'-C'${clientVhost[$c]}'-T1'
			((text_x1=client_x2-50))
                        ((text_y1=client_y2-2))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'$clientLoc'</text>' >> $pictureFile


			client_x3=$(grep 'mapping='${clientHostname[$b]} $helpFile | grep 'remoteSlot='${clientVhost[$c]} | cut -f 3 -d ',') 	
			test=$(grep 'mapping='${clientHostname[$b]} $helpFile | grep -c 'remoteSlot='${clientVhost[$c]})
			client_y4=$(grep 'mapping='${clientHostname[$b]} $helpFile | grep 'remoteSlot='${clientVhost[$c]} | cut -f 4 -d ',')
			((client_y3=client_y2+5))
 			if [ $test == 0 ]
			then
				((client_x3=client_x2-50))
				((client_y4=client_y3))
			fi
			 echo '<line x1="'$client_x2'" y1="'$client_y3'" x2="'$client_x3'" y2="'$client_y3'" style="stroke:green;stroke-width:1;" />' >> $pictureFile
                      	echo '<circle cx="'$client_x3'" cy="'$client_y3'" r="2.5" />' >> $pictureFile
			 echo '<line x1="'$client_x3'" y1="'$client_y3'" x2="'$client_x3'" y2="'$client_y4'" style="stroke:green;stroke-width:1;" />' >> $pictureFile

			((client_y2=client_y2+40))
			((c=c+1))
		done 
		c=0
                while [ $c -lt $clientVfchost_count ]
                do
                        echo '<rect x="'$client_x2'" y="'$client_y2'" width="35" height="12" fill="greenyellow" style="stroke:red;stroke-width:1px"/>' >> $pictureFile
                        echo ${clientHostname[$b]}',slotId='${clientVfchost[$c]}','$client_x2','$client_y2 >> $helpFile
                        ((text_x1=client_x2+5))
                        ((text_y1=client_y2+11))
                        adapName=$(grep ${MaganedSystem[$x]} $configFile | grep FC | grep ','${clientHostname[$b]}',' | grep 'C'${clientVfchost[$c]}'-T1' | cut -f 14 -d ',' | cut -f 2 -d ':')
			echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'$adapName'</text>' >> $pictureFile


                        clientLoc=$(grep ${MaganedSystem[$x]} $configFile | grep ','${clientHostname[$b]}',' |grep 'C'${clientVfchost[$c]}'-T1' | cut -f 15 -d ',' | cut -f 2 -d ':')
                        ((text_x1=client_x2-50))
                        ((text_y1=client_y2-2))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'$clientLoc'</text>' >> $pictureFile

			clientWWPN=$(grep ${MaganedSystem[$x]} $configFile | grep 'lpar_name='${clientHostname[$b]} | grep FC | grep -v 'adapter_type=server' | grep 'slot_num='${clientVfchost[$c]}',' | cut -f 2 -d'"' | cut -f 2 -d '=')
			((text_y1=client_y2+25))
			 echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'$clientWWPN'</text>' >> $pictureFile

                        client_x3=$(grep 'mapping='${clientHostname[$b]} $helpFile | grep 'remoteSlot='${clientVfchost[$c]} | cut -f 3 -d ',')
                        test=$(grep 'mapping='${clientHostname[$b]} $helpFile | grep -c 'remoteSlot='${clientVfchost[$c]})
                        client_y4=$(grep 'mapping='${clientHostname[$b]} $helpFile | grep 'remoteSlot='${clientVfchost[$c]} | cut -f 4 -d ',') 
                        ((client_y3=client_y2+5))
                        if [ $test == 0 ]
                        then
                                ((client_x3=client_x2-50))
                                ((client_y4=client_y3))
                        fi
                         echo '<line x1="'$client_x2'" y1="'$client_y3'" x2="'$client_x3'" y2="'$client_y3'" style="stroke:green;stroke-width:1;" />' >> $pictureFile
                        echo '<circle cx="'$client_x3'" cy="'$client_y3'" r="2.5" />' >> $pictureFile
                         echo '<line x1="'$client_x3'" y1="'$client_y3'" x2="'$client_x3'" y2="'$client_y4'" style="stroke:green;stroke-width:1;" />' >> $pictureFile

                        ((client_y2=client_y2+40))
                        ((c=c+1))
                done

		((client_x3=client_x1+clientSize_x-15))
                ((client_y3=client_y1+40))
		c=0
		while [ $c -lt $addPhysClient_count ]
		do
			echo '<rect x="'$client_x3'" y="'$client_y3'" width="35" height="12" fill="powderblue" style="stroke:red;stroke-width:1px"/>' >> $pictureFile
                        ((text_x1=client_x3+5))
                        ((text_y1=client_y3+11))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'${addPhysClientType[$c]}'</text>' >> $pictureFile

                        ((text_x1=client_x3-50))
                        ((text_y1=client_y3-2))
                        echo '<text x="'$text_x1'" y="'$text_y1'" style="font-size:10px">'${addPhysClient[$c]}'</text>' >> $pictureFile
                       echo ${VioHostname[$a]}','${addPhysClient[$c]}','$client_x3','$client_y3 >> $helpFile
                        ((client_y3=client_y3+40))
		
			((c=c+1))
		done
		((client_y1=client_y1+sizeClient_y+50))
		((b=b+1))
	done
}

drawMessage ()
{
	declare -a VioHostname=($(grep $1 $configFile | grep 'adapter_type=server' |grep -v FC | cut -f 2 -d ',' | sort -u | cut -f 2 -d '='))
        VioHostname_count=${#VioHostname[@]}
	if [ $VioHostname_count == 0 ]
	then
		declare -a VioHostname=($(grep $1 $configFile | grep 'adapter_type=server' |grep FC | cut -f 3 -d ',' | sort -u | cut -f 2 -d '='))
        	VioHostname_count=${#VioHostname[@]}
	fi
        a=0
        while [ $a -lt $VioHostname_count ]
        do
		declare -a vhostAdap=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'vhost=' | cut -f 3 -d ',' | cut -f 2 -d '='))
                vhostAdap_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep -c 'vhost=')
		b=0
		while [ $b -lt $vhostAdap_count ]
		do
			
			declare -a vtd=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vhostAdap[$b]}',' | tr "," "\n" | grep VTD | cut -f 2 -d '='))
			vtd_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vhostAdap[$b]}',' | tr "," "\n" | grep -c VTD)
			declare -a backing=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vhostAdap[$b]}',' | tr "," "\n" | grep 'BackingDevice' | cut -f 2 -d '='))
			declare -a size=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep ${vhostAdap[$b]}',' | tr "VTD" "\n" | grep -v ',vhost='| cut -f 3 -d ',' | cut -f 2 -d '='))
			var=${VioHostname[$a]}'_'${vhostAdap[$b]}
 	               	string='var '$var' = "<h2>Plattenmappings for '${vhostAdap[$b]}'<\/h2><table border=1><tr><th>VTD</th><th>Hdisk</th><th>PvID</th><th>LunId</th><th>size in MB</th></tr>' 
			c=0
			while [ $c -lt $vtd_count ]
			do 
				pvid=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'hdiskName='${backing[$c]}',' | cut -f 4 -d ',' | cut -f 2 -d '=')			
				lunId=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'hdiskName='${backing[$c]}',' | cut -f 5 -d ',' | cut -f 2 -d '=')
				string=$string'<tr><td>'${vtd[$c]}'</td><td>'${backing[$c]}'</td><td>'$pvid'</td><td>'$lunId'</td><td>'${size[$c]}'</td></tr>'
				((c=c+1))
			done
			string=$string'</table>"'
			echo $string >> $htmlFile
			((b=b+1))
		done
		var="lsnports_"${VioHostname[$a]}
		lsnports_table='var '$var' = "<h2>lsnports for VIO '${VioHostname[$a]}'<\/h2><table border=1><tr><th>name</th><th>physloc</th><th>fabric</th><th>tports</th><th>aports</th><th>swwpns</th><th>awwpns</th></tr>"'
		declare -a lsnports=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep lsnports))
		lsnports_count=${#lsnports[@]}
		b=0
		while [ $b -lt $lsnports_count ]
		do
			string=$(echo ${lsnports[$b]} | cut -f 2 -d ';' | cut -f 2-8 -d ',' | sed 's/,/<\/td><td>/g')
			
		lsnports_table=$lsnports_table'<tr><td>'$string'</td></tr>'
			((b=b+1))
		done
		echo $lsnports_table'</table>' >> $htmlFile
	
		declare -a vfchostAdap=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep 'vfchost' | cut -f 4 -d ','))
		vfchost_count=${#vfchostAdap[@]}
		b=0
		while [ $b -lt $vfchost_count ]
		do
			var=${VioHostname[$a]}'_'${vfchostAdap[$b]}
			vfchostLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 5 -d ',')
			vfchostPhysPort=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 9 -d ',' | cut -f 2 -d ':')
			vfchostPhysLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 10 -d ',' | cut -f 2 -d ':')
			remoteLPAR=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 7 -d ',')
			remotePort=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 14 -d ',' | cut -f 2 -d ':')
			remotePortLoc=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 15 -d ',' | cut -f 2 -d ':')
			status=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 8 -d ',' | cut -f 2 -d ':')
			portsLoggedIn=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep ${vfchostAdap[$b]}',' | cut -f 11 -d ',' | cut -f 2 -d ':')
			remoteSlotID=$(echo $remotePortLoc | cut -f 3 -d '-' | cut -c 2-3)
			clientWWPN=$(grep $1 $configFile | grep ',lpar_name='$remoteLPAR | grep FC | grep -v 'adapter_type=server' | grep ',remote_lpar_name='${VioHostname[$a]}| grep ',slot_num='$remoteSlotID | cut -f 2 -d'"' | cut -f 2 -d '=')
 	               	
			string='var '$var' = "<h2>lsmap for '${vfchostAdap[$b]}'<\/h2><table border=1><tr><th>Name</th><td>'${vfchostAdap[$b]}'</td></tr><tr><th>Physloc</th><td>'$vfchostLoc'</tr><tr><th>FC name</th><td>'$vfchostPhysPort'</td></tr><tr><th>FC loc code</th><td>'$vfchostPhysLoc'</td></tr><tr><th>Client Name</th><td>'$remoteLPAR'</td></tr><tr><th>VFC client name</th><td>'$remotePort'</td></tr><tr><th>VFC client loc</th><td>'$remotePortLoc'</td></tr><tr><th>client WWPN</th><td>'$clientWWPN'</td></tr><tr><th>Status</th><td>'$status'</td></tr><tr><th>Ports logged in</th><td>'$portsLoggedIn'</td></tr></table>"'
			echo $string >> $htmlFile
                        ((b=b+1))
                done
 
		((a=a+1))
	done
	echo 'switch(id)' >> $htmlFile
        echo '{' >> $htmlFile
 	a=0
        while [ $a -lt $VioHostname_count ]
        do
		echo 'case "lsnports_'${VioHostname[$a]}'": mapping.document.open()' >> $htmlFile
		echo 'mapping.document.write(lsnports_'${VioHostname[$a]}')' >> $htmlFile
		echo 'mapping.document.close()' >> $htmlFile
                echo 'break' >> $htmlFile

		declare -a vhostAdap=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep 'vhost=' | cut -f 3 -d ',' | cut -f 2 -d '='))
                vhostAdap_count=$(grep $1 $configFile | grep ${VioHostname[$a]} | grep -c 'vhost=')
		b=0
		while [ $b -lt $vhostAdap_count ]
		do
			echo 'case "'${VioHostname[$a]}'_'${vhostAdap[$b]}'": mapping.document.open()' >> $htmlFile
			echo 'mapping.document.write('${VioHostname[$a]}'_'${vhostAdap[$b]}')' >> $htmlFile
			echo 'mapping.document.close()' >> $htmlFile
			echo 'break' >> $htmlFile
			((b=b+1))
		done
		declare -a vfchostAdap=($(grep $1 $configFile | grep ${VioHostname[$a]} | grep ',FC,' | grep 'vfchost' | cut -f 4 -d ','))
		vfchostAdap_count=${#vfchostAdap[@]}
		b=0
		while [ $b -lt $vfchostAdap_count ]
		do
			echo 'case "'${VioHostname[$a]}'_'${vfchostAdap[$b]}'": mapping.document.open()' >> $htmlFile
                        echo 'mapping.document.write('${VioHostname[$a]}'_'${vfchostAdap[$b]}')' >> $htmlFile
                        echo 'mapping.document.close()' >> $htmlFile
                        echo 'break' >> $htmlFile
                        ((b=b+1))
                done

		((a=a+1))
	done
	echo '}' >> $htmlFile
	echo '}' >> $htmlFile
}

#################################################################
# Main                                                          #
#################################################################

# set global variables
#################################################################
hostname=$1
dir=$2
configFile=$dir'/'$hostname'_SanConfig.out'

declare -a MaganedSystem=($(grep 'ManagedSystem=' $configFile | cut -f 2 -d ',' | sort -u))
ManagedSystem_count=$(grep 'ManagedSystem=' $configFile| cut -f 2 -d ',' | sort -u | wc | awk '{print $1}')

startx=200
starty=150
offsety=100
sizePic_x=0

# draw one picture for each Managed System managed by this HMC
################################################################
x=0
while [ $x -lt $ManagedSystem_count ]
do
# define files
################################################################
        helpFile=$dir'/'${MaganedSystem[$x]}'_help'
        pictureFile=$dir'/'${MaganedSystem[$x]}'_SAN_temp.svg'
        sanPicture=$dir'/'${MaganedSystem[$x]}'_SAN.svg'
	htmlFile=$dir'/'${MaganedSystem[$x]}'_SAN.php'
	embedFile=$dir'/'${MaganedSystem[$x]}'_SAN.html'
	> $sanPicture
        > $pictureFile
        > $helpFile
	> $htmlFile
	> $embedFile

# define spezific variables for this Managed System
######################################################################
        sizePicturex=1300
        #sizePicturey=$starty 
	sizePicturey=2000 
	sizeViox=250
        clientSize_x=200

	declare -a VioHostname=( $(grep ${MaganedSystem[$x]} $configFile | grep 'adapter_type=server' | cut -f 2 -d ',' | sort -u | cut -f 2 -d '='))
        VioHostname_count=$(grep ${MaganedSystem[$x]} $configFile | grep 'adapter_type=server' | cut -f 2 -d ',' | sort -u |  wc | awk '{print $1}')


        drawVio ${MaganedSystem[$x]}
	drawClient ${MaganedSystem[$x]}

# calculate hight of picture
#########################################################################

        allVioY=$vio_y
        pictureSize_y=0
        if [ $pictureSize_y -lt $allVioY ]
        then
        	pictureSize_y=$allVioY
        fi

        if [ $pictureSize_y -lt $client_y1 ]
        then
                pictureSize_y=$client_y1
        fi

        ((pictureSize_y=pictureSize_y+offsety))


# calculate page width
#########################################################################
        ((sizePic_x=client_x3+100))
        if [ $sizePicturex -lt $sizePic_x ]
        then
                sizePicturex=$sizePic_x
        fi
#######################################################
# write header information to SVG file
######################################################
        echo "<?xml version=\"1.0\" standalone=\"no\" ?>" >> $sanPicture
echo "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 20010904//EN\" \"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd\" >" >> $sanPicture
echo "<svg width=\""$sizePicturex"\" height=\""$pictureSize_y"\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">" >> $sanPicture

# write title to SVG file
##############################################################################
        type=$(grep ${MaganedSystem[$x]} $configFile | grep 'ManagedSystem=' | cut -f 3 -d ',' | cut -f 1 -d '-')
        model=$(grep ${MaganedSystem[$x]} $configFile | grep 'ManagedSystem=' | cut -f 3 -d ',' | cut -f 2 -d '-')
	creationYear=$(grep 'creationDate=' $configFile | awk '{print $6}' | sort -u)
        creationMonth=$(grep 'creationDate=' $configFile | awk '{print $2}' | sort -u)
        creationDay=$(grep 'creationDate=' $configFile | awk '{print $3}' | sort -u)

        ((title_y=starty-100))
        echo '<text x="'$startx'" y="'$title_y'" style="font-size:20px">SAN Configuration from Managed System</text>' >> $sanPicture
        ((title_x=startx+100))
        ((title_y=title_y+40))
        echo '<text x="'$title_x'" y="'$title_y'" style="font-size:25px">'$type' - '$model' - '${MaganedSystem[$x]}'</text>' >>$sanPicture
	 ((title_y=title_y+30))
        echo '<text x="'$title_x'" y="'$title_y'" style="font-size:15px">created: '$creationMonth' '$creationDay' '$creationYear'</text>' >> $sanPicture

# draw legend to SVG file
#############################################################################
        ((legend_x1=sizePicturex-150))
        ((legend_y1=starty-90))
        echo '<text x="'$legend_x1'" y="'$legend_y1'" style="font-size:10px">Physical Adapter</text>' >> $sanPicture
        ((legend_y2=legend_y1+20))
        echo '<text x="'$legend_x1'" y="'$legend_y2'" style="font-size:10px">Vhost/Vscsi Adapter</text>' >> $sanPicture
        ((legend_x2=legend_x1-20))
        ((legend_y4=legend_y1-10))
        echo '<rect x="'$legend_x2'" y="'$legend_y4'" width="10" height="10" fill="powderblue" style="stroke:red;stroke-width:1px"/>' >> $sanPicture
        ((legend_y5=legend_y2-10))
        echo '<rect x="'$legend_x2'" y="'$legend_y5'" width="10" height="10" fill="greenyellow" style="stroke:red;stroke-width:1px"/>' >> $sanPicture

        ((legend_x3=legend_x2-150))
        echo '<text x="'$legend_x3'" y="'$legend_y1'" style="font-size:10px">Logical Partition</text>' >> $sanPicture
        echo '<text x="'$legend_x3'" y="'$legend_y2'" style="font-size:10px">Disk Pool</text>' >> $sanPicture
        ((legend_x4=legend_x3-20))
        echo '<rect x="'$legend_x4'" y="'$legend_y4'" width="10" height="10" fill="antiquewhite" style="stroke:red;stroke-width:1px"/>' >> $sanPicture
        echo '<rect x="'$legend_x4'" y="'$legend_y5'" width="10" height="10" fill="lightyellow" style="stroke:red;stroke-width:1px"/>' >> $sanPicture

        ((legend_x7=legend_x4-10-150))
        ((legend_y7=legend_y4-10))
        echo '<rect x="'$legend_x7'" y="'$legend_y7'" width="470" height="70" fill="none" style="stroke:red;stroke-width:1px"/>' >> $sanPicture
        echo '<rect x="'$legend_x7'" y="'$legend_y7'" width="130" height="35" fill="none" style="stroke:red;stroke-width:1px"/>' >> $sanPicture
        ((legend_y=legend_y7+20))
	((legend_x=legend_x7+10))
        echo '<text x="'$legend_x'" y="'$legend_y'" style="font-size:15px">Legend</text>' >> $sanPicture

	((copy_y=legend_y7-30))
	echo '<text x="'$legend_x1'" y="'$copy_y'" style="font-family:Arial Unicode MS;font-size:10px">&#x00A9;</text>' >> $sanPicture
	((copy_x=sizePicturex-130))
	echo '<text x="'$copy_x'" y="'$copy_y'" style="font-size:10px">IBM Corporate 2008</text>' >> $sanPicture


	echo '<HTML><HEAD><TITLE>'$htmlOverview'</TITLE></HEAD><SCRIPT LANGUAGE="JavaScript"><!--' >> $htmlFile
	echo 'function tag(s)' >> $htmlFile
	echo '{' >> $htmlFile
	echo 'return "<"+s+">"' >> $htmlFile
	echo '}' >> $htmlFile
	echo 'function leer()' >> $htmlFile
	echo '{' >> $htmlFile
	echo 'html = tag("HTML")+tag("BODY")+tag("/BODY")+tag("/HTML")' >> $htmlFile
	echo 'return html' >> $htmlFile
	echo '}' >> $htmlFile
	echo 'function showMessage(id)' >> $htmlFile
	echo '{' >> $htmlFile
	
	drawMessage ${MaganedSystem[$x]}
	
	file=$(echo $sanPicture | cut -f 4 -d '/')
	echo '//--></SCRIPT><FRAMESET ROWS="70%,*">' >> $htmlFile
	echo '<FRAME NAME="picture" scrolling="yes" SRC="'${MaganedSystem[$x]}'_SAN.html">' >> $htmlFile
	echo '<FRAME NAME="mapping" SRC="javascript:top.leer()"></FRAMESET><NOFRAMES><BODY>' >> $htmlFile
	echo '</BODY></NOFRAMES></HTML>' >> $htmlFile


# write temp file to SVG
##############################################################################
        cat $pictureFile >> $sanPicture

        echo "</svg>">> $sanPicture

# make html file
#############################################################################
        echo '<HTML><HEAD><TITLE></TITLE></HEAD>' > $embedFile
        echo '<embed src="'${MaganedSystem[$x]}'_SAN.svg" width="'$sizePicturex'" height="'$pictureSize_y'" type="image/svg+xml">' >> $embedFile
        echo '<BODY></BODY></HTML>' >> $embedFile

rm $helpFile
rm $pictureFile

	((x=x+1))
done
