#!/bin/sh
set -x

#############################################################################################################################################
# This script is user dependent & utilizes authorization_keys under ~/.ssh folder in targert server to connect to target host.
# Please configure & ssh through terminal once before running this script
# Script doesn't prompt for password & will fail if user has no authorizated_keys to connect to target server from source server.
# Created BY: AMIN SIDDIQUE
############################################################################################################################################


user=`whoami`  	#########################user to be ssh'd from source
Thost="xxxxxxx"  
Shost=`uname -n`


################################## User defined Variables - Change values to send different files#####################
DIR2Transfer=/home/xxxxxxxxx
Targetdir=/home/yyyyyyyyyyy
Keyword="Directory Transfer" 

EMAILID="xxxxxxxxxxxx"

ArchiveDir=/home/xxxxxxxxxxxxxxx
LogDir=/home/zzzzzzzzzzzzz/DIR_transfer_log.txt





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
if  [ -d $DIR2Transfer ]; then


##PasswordAuthentication is set to no to avoid password prompt & utilise authorization_key to connect to target server
scp -v -o PasswordAuthentication=No -r $DIR2Transfer/$FileName $user@$Thost:$Targetdir   >> $LogDir




zReturn_Code=$?
echo "Return Code = $zReturn_Code" >> $LogDir

	if [[ $zReturn_Code -ne 0 ]]; then
		echo "Permission denied. An error was encountered in transfering the files" >> $LogDir
		cat $LogDir |  mail  -s "Failed: $Keyword  - Permission denied"  $EMAILID 
		rm -f $LogDir && exit; ##removing temp logfile
	fi


echo "Below files are present are transfered from $Shost to Target host $Thost : $Targetdir" >> $LogDir
ssh $user@$Thost ls -l  $Targetdir   >> $LogDir


##########################################################
##Archive from source destination on successfull transfer   (Disabled)
##########################################################
#rm -r $DIR2Transfer


cat $LogDir |  mail  -s "Success: $Keyword Tranfer Completed"  $EMAILID 
else

echo "No Such Directory $DIR2Transfer present in $Shost. Please Check" >> $LogDir
cat $LogDir |  mail -s "Failed: No such Directory are present in $Shost"  $EMAILID 
	
fi
	
rm -f $LogDir  ##removing temp logfile
##############################################################################################################################################################	
