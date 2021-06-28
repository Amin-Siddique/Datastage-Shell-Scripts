#!/bin/sh
#set -x

#############################################################################################################################################
# This script is user dependent & utilizes authorization_keys under ~/.ssh folder in targert server to connect to target host.
# Please configure & ssh through terminal once before running this script
# Script doesn't prompt for password & will fail if user has no authorizated_keys to connect to target server from source server.
# Created By: Amin Siddique
############################################################################################################################################


user="dsadm"  	#########################user to be ssh'd from source
Thost="xxxxxxx"  
Shost=`uname -n`


################################## User defined Variables - Change values to send different files#####################
FileName="xxxxxxxxxxx*.txt" 
Keyword="xxxxxxxxxxxx" 	         #########################Used in Mail Subject
EMAILID="xxxxxxxxxxxxx"

Sourcedir=/work_area/xxxxxxxxx
Targetdir=/work_area/yyyyyyyyy
ArchiveDir=/work_area/xxxxxxxxxxx
LogDir=/work_area/xxxxxxxxxxxxxxxxxx


###########################################################################################################################################


#############
touch $LogDir
rm -f $LogDir
#############



############################################################################################################################################
#Check1: If file not present then exit script & notify
#Check2: list out all files in target after transfer is made
#Check3: If sftp error then notify
############################################################################################################################################

FileCount=$(ls $Sourcedir/$FileName | wc -l)

if  [ $FileCount -gt 0 ]; then


##PasswordAuthentication is set to 'No' to avoid password prompt & utilise authorization_key to connect to target server
scp -v -o PasswordAuthentication=No $Sourcedir/$FileName $user@$Thost:$Targetdir   >> $LogDir


zReturn_Code=$?
echo "Return Code = $zReturn_Code" >> $LogDir

	if [[ $zReturn_Code -ne 0 ]]; then
		echo "Permission denied. An error was encountered in transfering the files" >> $LogDir
		cat $LogDir |  mail  -s "Failed: $Keyword File Tranfer - Permission denied"  $EMAILID 
		rm -f $LogDir && exit; ##removing temp logfile
	fi


echo "Below files are present are transfered from $Shost to Target host $Thost : $Targetdir" >> $LogDir
ssh $user@$Thost ls -l  $Targetdir   >> $LogDir


##########################################################
##Archive from source destination on successfull transfer (please change to remove command if file needs to be deleted)
##########################################################
mv  $Sourcedir/$FileName $ArchiveDir 


cat $LogDir |  mail  -s "Success: $Keyword File Tranfer Completed"  $EMAILID 
else

echo "No $Keyword Files are present in $Shost : $Sourcedir. Please Check" >> $LogDir
cat $LogDir |  mail -s "Failed: No $Keyword files are present in Source : $Shost"  $EMAILID 
	
fi
	
rm -f $LogDir  ##removing temp logfile
##############################################################################################################################################################	
