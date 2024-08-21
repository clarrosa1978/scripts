#!/bin/ksh 
# 
#  ACT Tool Extraction Script for IBM AIX 7.x and below
#
#  
#  REVISION HISTORY:
# ------------------------------------------------------------------------------------
#  Version	 Date			Author			  Activity			
# ------------------------------------------------------------------------------------
#  1.0		05/18/2012	  Mallela, Gopinadh		Script Created 				
#  1.1          07/20/2012        Prabhala, Suchitra            Script modified
#  2.0          05/20/2013        Prabhala, Suchitra            Script modified
#  3.0          01/06/2016        Prabhala, Suchitra            Script modified
#				04/22/2016		  Ramakrishna, Shashank			Script Modified- Added 'Extract Application Version'
#  3.1			05/25/2016		  Ramakrishna, Shashank			Script Modified- Added 'etc/pam.conf'
#				05/25/2016		  Ramakrishna, Shashank			Script Modified- Modified Code to append Servername in the final zip file created
#				05/25/2016		  Ramakrishna, Shashank			Script Modified- Modified Code to identify if the script is running on the correct OS
#				05/25/2016		  Ramakrishna, Shashank			Script Modified- Modified Code to identify if the script is running with root privilege
#				05/25/2016		  Ramakrishna, Shashank			Script Modified- Modified Code for bug fix related to auto deletion of files
#  4.0		    02/06/2017		  Antony, Godwin				Script Modified- Modified Code for extracting file permissions for /var/adm and /etc/default directories for file_perms.txt
#  				02/06/2017        Antony, Godwin 				Added new file ACTT_SYSTEM_UNIX_AIX.actt as per Req ID: 1533
#  4.1 	  	    05/06/2017        Antony, Godwin 				Script Modified- updated code for extraction of files software_history.txt  				
#				08/10/2017		  Ramakrishna, Shashank			Script Modified - Code updated to make the extracted output accessible only to the owner
#               08/14/2017		  Antony, Godwin				Script Modified - Added Disclaimer to delete the files once it is shared with engagement team.
#  15.0			10/11/2017		  Antony,Godwin					Commented Extraction of /etc/services,/etc/protocols,/etc/ftpusers,/etc/ftpd/ftpusers and netstat -n as per Req ID: 1677				
#				11/22/2017		  Antony,Godwin					Script Modified - Script updated to remove that empty temporary folder if the script is terminated manually.ID:1727
#				01/26/2017        Antony,Godwin					Scrit Modified- Script updated to extract /etc/netsvc.conf file. Req ID:1592
#				02/06/2017		  Ramakrishna, Shashank         Script Modified -  Script updated to address "ROOT" user when the password is encrypted with SHA1 Algorithm.Req ID: 1801
#  16.0			10/24/2018		  Antony, Godwin				Script Modified - Change the attribute name from "Extraction Script Version" to "Extract Script Version". ID : 1999
#				10/25/2018    	  Antony, Godwin	 			Script Modified - Added code to check the execution of uname -n , commented "rm" related codes and set 700 premission to $FOLDER. ID: 1998
#				11/21/2018		  Antony,Godwin					Script Modified - Added code for the extraction of sudoers.d Req ID: 1920
#				03/01/2019		  Antony, Godwin				Scrit Modified- Added code for extraction of evidence for telnet. Req ID: 2066
#  17.0			10/01/2019        Antony,Godwin					Script Modified - Modified code for the extraction of sudoersd.d
#               04/01/2020	      Antony,Godwin 			    Script Modified - Added code to capture Hostname under ACTT_CONFIG_SETTINGS.actt file.Req ID 2223
#  				04/15/2020	      Antony,Godwin					Script Modified - Added code for the extraction of /etc/ssh2/sshd2_config. Req ID: 2226
# Notice:
# ------------------------------------------------------------------------------------
#	The purpose of this .read only. script is to download data that can be analyzed as part of our audit.  
#	We expect that you will follow your company.s regular change management policies and procedures prior to running the script.
#	To the extent permitted by law, regulation and our professional standards, this script is provided .as is,. 
#	without any warranty, and the Deloitte Network and its contractors will not be liable for any damages relating to this script or its use.  
#	As used herein, .we. and .our. refers to the Deloitte Network entity that provided the script to you, and the .Deloitte Network. refers to 
#	Deloitte Touche Tohmatsu Limited (.DTTL.), the member firms of DTTL, and each of their affiliates and related entities.
#
#	© 2016.  For more information, contact Deloitte Touche Tohmatsu Limited.  All rights reserved.
#
# ------------------------------------------------------------------------------------



###### Declaration of variables
uname -n > /dev/null 2>> /dev/null
if [ $? -eq 0 ];
then
ERRFILE="`uname -n`_errors.txt"	
SCRIPTFLOW="`uname -n`_scriptflow.txt"
FOLDER="`uname -n`_`uname`_data.tar"
TARFILE="`uname -n`_ACTT_Output_AIX.tar"
echo "Folder $FOLDER created successfully"

else
ERRFILE="ACTT_AIX_errors.txt"
SCRIPTFLOW="ACTT_AIX_scriptflow.txt"
FOLDER="ACTT_AIX_data.tar"
TARFILE="ACTT_Output_AIX.tar"
echo "Folder $FOLDER created successfully"

fi

mkdir ./$FOLDER
if [ $? -ne 0 ]; then 
    echo "Unable to create directory $FOLDER. Exiting script."
    exit
fi

chmod 700 $FOLDER


cd ./$FOLDER
if [ $? -ne 0 ]; then 
    echo "Unable to change the directory to $FOLDER. Exiting script."
    exit
fi


echo "|^|" >ACTT_CONFIG_FIELDTERMINATOR.actt

##### Function to remove the temporary files created by this script
CLEARALL()

{
	#tput smso;tput blink;
	echo " \n Script Terminated. Exiting the script on a signal. \n";
	#tput rmso;
	
			
echo " \nExtraction incomplete. Kindly delete the temporary folder " $FOLDER." \n";

	cd ..
#	rm -rf $FOLDER
    
sleep 5
}

opt='y'
while test $opt = 'y';do

#### Code to trap the signals
trap 'CLEARALL; exit 1' 1 2 3 15 24

##### Extraction of System Information
echo "Extraction of system information\n\n" | tee $SCRIPTFLOW
echo "SettingName nvarchar(max)|^|SettingValue nvarchar(max)"  > ACTT_CONFIG_SETTINGS.actt
echo "Extract Script Version|^|17.0" >> ACTT_CONFIG_SETTINGS.actt
echo  "Hostname|^|`uname -n`" >> ACTT_CONFIG_SETTINGS.actt
echo "Extract Application Version|^|ACTT AIX" >> ACTT_CONFIG_SETTINGS.actt
echo "Operating System|^|`uname`" >> ACTT_CONFIG_SETTINGS.actt
ver=`uname -rv|awk '{print $2"."$1}'`
ver2=`uname`
ver3="AIX"
echo "Operating System Version|^|$ver" >> ACTT_CONFIG_SETTINGS.actt
echo "Extraction Script Start Time|^|`date +\"%D %I:%M:%S %p\"`" >> ACTT_CONFIG_SETTINGS.actt
echo "SettingName nvarchar(max)|^|SettingValue nvarchar(max)"  > ACTT_SYSTEM_UNIX_AIX.actt
echo "Extraction completed. Output file is \"ACTT_CONFIG_SETTINGS.actt\"\n" | tee -a $SCRIPTFLOW


##### Compare OS
if [[ "$ver2" == *"$ver3"* ]]; then
echo "Script Starting on AIX." >> $SCRIPTFLOW
clear
echo "Script Starting on AIX. Please hit enter to continue"
read STRN
else
clear
echo "This Script is for AIX system and this OS is not AIX." >> $SCRIPTFLOW
echo "This Script is for AIX system and this OS is not AIX. If you hit enter the extraction will continue"
read STRN
fi

##### Check for root privilege
if [ `id -u` == 0 ]; then
echo "This script is being run as root" >> $SCRIPTFLOW
else
echo "Script not run as root" >> $SCRIPTFLOW
clear
echo "ABORT Initiated due to insufficient privilege...\nPlease run this script with root privilege."
echo "\nScript Execution Failed.Please hit Enter to exit."
read STRN
exit 1
fi



##### Extraction of /etc/passwd file
echo "Extraction of /etc/passwd file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/passwd ]; then
cat /etc/passwd > etc_passwd.txt 2> $ERRFILE
else
echo "/etc/passwd does not exist in the system" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_passwd.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/group file
echo "Extraction of /etc/group file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/group ]; then
cat /etc/group > etc_group.txt 2>> $ERRFILE
else
echo "/etc/group does not exist in the system" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_group.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/security/user file
echo "Extraction of /etc/security/user file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/security/user ];then
cat /etc/security/user > etc_security_user.txt 2>> $ERRFILE
else
echo "/etc/security/user file does not exist in the system" >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_security_user.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/security/passwd file
echo "Extraction of /etc/security/passwd file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/security/passwd ]; then
awk '{
if ($0 ~ /password =/) 
{split($0,arr,"=");printf("%s %s %s\n",arr[1],"=",length(arr[2])-1)}
else print $0
}' /etc/security/passwd > etc_security_passwd.txt 2>> $ERRFILE
else
echo "/etc/security/passwd does not exist"  >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_security_passwd.txt\"\n" | tee -a $SCRIPTFLOW

#### Extraction of /etc/sudoers file
echo "Extraction of /etc/sudoers file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/sudoers ]; then
cat /etc/sudoers > etc_sudoers.txt 2>> $ERRFILE
else
echo "/etc/sudoers file does not exist in the system"  >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_sudoers.txt\"\n" | tee -a $SCRIPTFLOW

#########Extraction of sudo files configured under sudoers.d directory#####
echo "Extraction of files under sudoers.d directory \n " | tee -a $SCRIPTFLOW
if [ -f /etc/sudoers ]; then
grep "^#includedir" /etc/sudoers | while read line
do
	sudodir="/${line#*/}"
	if [ -d $sudodir ]; then
		ls $sudodir | while read file
		do
			fullpath="$sudodir/$file"
			echo "$fullpath:"
			cat $fullpath
			echo "---------------------------------------------------"
			done >> etc_sudoersd_files.txt
	else
		echo "$sudodir directory does not exist in the system " >> $ERRFILE
	fi
done
echo "Extraction completed. Output file is \"etc_sudoersd_files.txt\"\n" | tee -a $SCRIPTFLOW
else
echo "/etc/sudoers file does not exist in the system"  >> $ERRFILE 
fi



##### Extraction of /var/adm/sulog file
echo "Extraction of sulog file\n"
if [ -f /var/adm/sulog ]; then
cat /var/adm/sulog > var_adm_sulog.txt 2>> $ERRFILE
else
echo "/var/adm/sulog file does not exist"  >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_adm_sulog.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/inetd.conf file
echo "Extraction of inetd.conf file\n"
if [ -f /etc/inetd.conf ]; then
cat /etc/inetd.conf > etc_inetd_conf.txt 2>> $ERRFILE
else
echo "/etc/inetd.conf file does not exist" >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_inetd_conf.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/services file
#echo "Extraction of /etc/services file\n"
#if [ -f /etc/services ]; then
#cat /etc/services > etc_services.txt 2>> $ERRFILE
#else
#echo "/etc/services file does not exist"  >> $ERRFILE 
#fi
#echo "Extraction completed. Output file is \"etc_services.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/protocols file
#echo "Extraction of /etc/protocols file\n"
#if [ -f /etc/protocols ]; then
#cat /etc/protocols > etc_protocols.txt 2>> $ERRFILE
#else
#echo "/etc/protocols file does not exist"  >> $ERRFILE 
#fi
#echo "Extraction completed. Output file is \"etc_protocols.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/hosts.equiv file
echo "Extraction of /etc/hosts.equiv file\n"
if [ -f /etc/hosts.equiv ]; then
cat /etc/hosts.equiv > etc_hosts_equiv.txt 2>> $ERRFILE
else
echo "/etc/hosts.equiv file does not exist"  >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_hosts_equiv.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of .rhosts files from users' home directories
echo "Extraction of .rhosts files\n" | tee -a $SCRIPTFLOW
while read line
do
homes=`echo $line|cut -d: -f6 2>> $ERRFILE`
users=`echo $line|cut -d: -f1 2>> $ERRFILE`
	if [ -f $homes/.rhosts ];then
	echo "\n\n.rhosts file found in user \"$users\" home directory - $homes:"
	cat $homes/.rhosts 2>> $ERRFILE
	else
	echo "\n.rhosts file does not exist in user \"$users\" home directory - $homes" >> $ERRFILE 
	fi
done </etc/passwd > rhosts.txt
echo "Extraction completed. Output file is \"rhosts.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of at.allow file
echo "Extraction of at.allow file\n"
if [ -f /var/adm/cron/at.allow ]; then
	cat /var/adm/cron/at.allow > var_adm_cron_at_allow.txt 2>> $ERRFILE
else
	echo "/var/adm/cron/at.allow file does not exist\n" >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"var_adm_cron_at_allow.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of at.deny file
echo "Extraction of at.deny file\n"
if [ -f /var/adm/cron/at.deny ]; then
	cat /var/adm/cron/at.deny > var_adm_cron_at_deny.txt 2>> $ERRFILE
else
	echo "/var/adm/cron/at.deny file does not exist\n" >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"var_adm_cron_at_deny.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of cron.deny file
echo "Extraction of cron.deny file\n"
if [ -f /var/adm/cron/cron.deny ]; then
	cat /var/adm/cron/cron.deny > var_adm_cron_cron_deny.txt 2>> $ERRFILE
else
	echo "/var/adm/cron/cron.deny file does not exist\n" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_group.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of cron.allow file
echo "Extraction of cron.allow file\n"
if [ -f /var/adm/cron/cron.allow ]; then
	cat /var/adm/cron/cron.allow > var_adm_cron_cron_allow.txt 2>> $ERRFILE
else
	echo "/var/adm/cron/cron.allow file does not exist\n" >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"var_adm_cron_cron_allow.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of cron job files
echo "Extraction of cron job files\n" | tee -a $SCRIPTFLOW
ls -l /var/spool/cron/crontabs | grep -v "total" > var_spool_cron_crontabs.txt 2>> $ERRFILE 

##### Extraction of at job files
echo "Extraction of at job files\n" | tee -a $SCRIPTFLOW
ls -l /var/spool/cron/atjobs | grep -v "total" > var_spool_cron_atjobs.txt 2>> $ERRFILE 

##### Extraction of users' information through logins command
echo "Gathering user information\n" | tee -a $SCRIPTFLOW
logins -axo > logins_axo.txt 2>> $ERRFILE


##### Extraction of access permissions of critical files
echo "Extracting permissions of critical files\n" | tee -a $SCRIPTFLOW
for dir in "/ /bin /sbin /usr/bin /usr /etc /var /dev /etc/security /var/adm /etc/ssh"
do ls -laL $dir 2>> $ERRFILE; done > file_perms.txt
echo "Extraction completed. Output file is \"file_perms.txt\"\n" | tee -a $SCRIPTFLOW


##### Extraction of installed softwares history
echo "Installed softwares history\n" | tee -a $SCRIPTFLOW
lslpp -a -h > softwares_history.txt 2>> $ERRFILE

##### Extraction of /etc/syslog.conf file
echo "Extraction of syslog.conf file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/syslog.conf ]; then
cat /etc/syslog.conf > etc_syslog_conf.txt 2>> $ERRFILE
else
echo "/etc/syslog.conf file does not exist in the system" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_syslog_conf.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of failed login users information
echo "Extraction of failedlogin file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/security/failedlogin ]; then
who -a /etc/security/failedlogin > etc_security_failedlogin.txt 2>> $ERRFILE
else
echo "/etc/security/failedlogin file does not exist" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_security_failedlogin.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of last login details of users
echo "Extraction of lastlog file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/security/lastlog ]; then
cat /etc/security/lastlog > etc_security_lastlog.txt 2>> $ERRFILE
else
echo "/etc/security/lastlog file does not exist" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_security_lastlog.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/hosts.allow file
echo "Extraction of /etc/hosts.allow file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/hosts.allow ]; then
cat /etc/hosts.allow > etc_hosts_allow.txt 2>> $ERRFILE
else
echo "/etc/hosts.allow does not exist in the system" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_hosts_allow.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/hosts.deny file
echo "Extraction of /etc/hosts.deny file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/hosts.deny ]; then
cat /etc/hosts.deny > etc_hosts_deny.txt 2>> $ERRFILE
else
echo "/etc/hosts.deny does not exist in the system" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_hosts_deny.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/ftpusers file
#echo "Extraction of /etc/ftpusers file\n" | tee -a $SCRIPTFLOW
#if [ -f /etc/ftpusers ]; then
#cat /etc/ftpusers > etc_ftpusers.txt 2>> $ERRFILE
#else
#echo "/etc/ftpusers does not exist in the system" >> $ERRFILE	
#fi
#echo "Extraction completed. Output file is \"etc_ftpusers.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/ftpd/ftpusers file
#echo "Extraction of /etc/ftpd/ftpusers file\n" | tee -a $SCRIPTFLOW
#if [ -f /etc/ftpd/ftpusers ]; then
#cat /etc/ftpd/ftpusers > etc_ftpd_ftpusers.txt 2>> $ERRFILE
#else
#echo "/etc/ftpd/ftpusers does not exist in the system" >> $ERRFILE
#fi
#echo "Extraction completed. Output file is \"etc_ftpd_ftpusers.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /var/adm/messages file
echo "Extraction of /var/adm/messages file\n" | tee -a $SCRIPTFLOW
if [ -f /var/adm/messages ]; then
cat /var/adm/messages > var_adm_messages.txt 2>> $ERRFILE
else
echo "/var/adm/messages does not exist in the system" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"var_adm_messages.txt\"\n" | tee -a $SCRIPTFLOW

##### Extraction of /etc/ssh/sshd_config
echo "Extraction of /etc/ssh/sshd_config file\n"
if [ -f /etc/ssh/sshd_config ]; then
cat /etc/ssh/sshd_config > etc_ssh_sshd_config.txt 2>> $ERRFILE
else
echo "/etc/ssh/sshd_config does not exist in the system\n" >> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_ssh_sshd_config.txt\"\n" | tee -a $SCRIPTFLOW

########## Script to extract the umask values from all '.profile' files of the users ##########

echo "\n\n Extraction of umask values from user's home directories"
while read line; do
home=`echo $line|cut -d ":" -f6`
if [ -f $home/.profile ]; then
	name=`echo $line|cut -d ":" -f1`
	u_value=`cat $home/.profile |awk '/umask/ {print $2}'`
	if [ x"$u_value" != 'x' ]; then echo "$name $u_value";fi
fi
done < /etc/passwd > user_mask.txt 2>> $ERRFILE
echo "\n Extraction completed. Output file is \"user_mask.txt\"\n" | tee -a $SCRIPTFLOW

#### Extraction of /etc/pam.conf file -added by Shashank
echo "Extraction of /etc/pam.conf file\n" | tee -a $SCRIPTFLOW
if [ -f /etc/pam.conf ]; then
cat /etc/pam.conf > etc_pam_conf.txt 2>> $ERRFILE
else
echo "/etc/pam.conf file does not exist in the system"  >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_pam_conf.txt\"\n" | tee -a $SCRIPTFLOW


########## Script to extract access permissions of the files located in /var/adm/cron & /var/spool/cron/crontabs directories ##########

echo "\n\nFile permissions of /var/adm/cron, /var/spool/cron/crontabs & /var/spool/cron/atjobs directories" | tee -a  $SCRIPTFLOW
ls -la /var/spool/cron/crontabs/* /var/spool/cron/atjobs/* > cron_perms.txt 2>> $ERRFILE
ls -la /var/adm/cron/* >> cron_perms.txt 2>> $ERRFILE
echo "\n\nExtraction Completed. Output file is \"cron_perms.txt\"\n" | tee -a  $SCRIPTFLOW

##### Extraction of listening_ports.txt file
#echo "Extraction of listening_ports.txt file\n" | tee -a $SCRIPTFLOW

#netstat -n >> listening_ports.txt 2>> $ERRFILE 

#######Extraction on /etc/nsswitch.conf file#####
echo "Extracting netsvc.conf file content \n" | tee -a $SCRIPTFLOW
if [ -f /etc/netsvc.conf ]; then
cat /etc/netsvc.conf > etc_netsvc_conf.txt 2>> $ERRFILE
else
echo "/etc/netsvc.conf file does not exists in the system" 2>> $ERRFILE
fi
echo "Extraction completed. Output file is \"etc_netsvc_conf.txt\"\n" | tee -a $SCRIPTFLOW

##### 36. Verification for Telnet service#######
echo "Extraction for  Telnet service"
telnet localhost < ACTT_CONFIG_FIELDTERMINATOR.actt 2>&1 > telnet_status.txt | tee -a $SCRIPTFLOW
grep -q "Connected" telnet_status.txt
if [ $? == 0 ]; then
echo "Telnet is Enabled" >>  telnet_status.txt | tee -a $SCRIPTFLOW
else
echo "Telnet is Not Enabled" >> telnet_status.txt | tee -a $SCRIPTFLOW
fi


#######37.Extraction of /etc/ssh2/sshd2_config#####
echo "Extracting /etc/ssh2/sshd2_config file \n " | tee -a $SCRIPTFLOW
if [ -f /etc/ssh2/sshd2_config ]; then
cat /etc/ssh2/sshd2_config > etc_ssh2_sshd2_config.txt 2>> $ERRFILE
else
echo "/etc/ssh2/sshd2_config  file does not exists in the system" >> $ERRFILE 
fi
echo "Extraction completed. Output file is \"etc_ssh2_sshd2_config.txt\"\n" | tee -a $SCRIPTFLOW



##### Listing of .txt files and their number of lines 
echo "FileName Nvarchar(max)|^|RecordCount NUMERIC"  > ACTT_CONFIG_RECORDCOUNT.actt
for i in `ls *.txt`
do
LINES=`awk 'END{print NR}' $i`
echo "$i|^|$LINES" >> ACTT_CONFIG_RECORDCOUNT.actt 
done
echo "Extraction Script End Time|^|`date +\"%D %I:%M:%S %p\"`" >> ACTT_CONFIG_SETTINGS.actt

##### Code to move  all the generated files to a folder and then to archive

tar -cf $TARFILE *
compress $TARFILE

if [ -f "$TARFILE.Z" ]
then
mv $TARFILE.Z ./..
else
echo " Zip file not created hence terminating the execution \n"
CLEARALL; exit 1
fi
#cp $TARFILE.Z ./..
cd ..
chmod 700 $TARFILE.Z


##### Cleaning up the temp files and/or directories created within the script
#rm -r ./$FOLDER
opt='n'
done

### Disclaimer to remove the extracted zip file after transferring ###

echo " \n\t\t\t\t********** IMPORTANT: The file has successfully generated as $TARFILE.Z. **********\n\t\t******* Please make sure to delete the generated file "$TARFILE" and directory "$FOLDER" from the server after you have provided the file to Deloitte Engagement Team ******* "
echo "\n\n"

