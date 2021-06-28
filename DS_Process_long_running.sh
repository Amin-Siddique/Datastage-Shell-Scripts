#!/bin/sh
set -x



####################################################################################################################################################
#																		   #
# Script Name   :  ProcessRunningLong.sh 												   #       
# Created       :  AMin	
# Description   :  Script uses loop to check if a certain process crosses Threshold value and send mail accordingly                                            #                                                                                                     
# Usage         :  Script Usage: sh System_Status.sh #
#																		   #                                                                    
####################################################################################################################################################

d=$(echo $(TZ=GMT+5:00;date))
DATE3=`date +%I:%M`
DATE4=`date +%d-%b-%y`
DATE=`date`
DIR="$(dirname $0 ;pwd)"
Scriptname=$0
HostDSN=`uname -n`

EMAILID="Amin.Siddique@xxxx.com"
Threshold=3600 		#1hour


count=0

while true; do	
	
    until [ "$count" -ge 15 ]   ##15 times loop
    do





ps -ef | grep DSD > Process_list_${DATE3}.txt
chmod 777 Process_list_${DATE3}.txt
 


PIDs=$(cat Process_list_${DATE3}.txt |  awk '{print $2}')

AlertCount=0

#*************************************************
for i in $PIDs

do
PIDElapsedTime=$(ps -p $i -o etime | grep -v 'ELAPSED')
total_process=$(cat Process_list_${DATE3}.txt| wc -l)
PIDElapsed=$(ps -p $i -o etime | grep -v 'ELAPSED'  |  awk -F: '{ if (NF == 1) {print $NF} else if (NF == 2) {print $1 * 60 + $2} else if (NF==3) {print $1 * 3600 + $2 * 60 + $3} }')

	if [ $PIDElapsed -gt $Threshold ] && [ $PIDElapsed -ne 0 ]; then
		echo "Time now: $DATE3" > temp.txt
		echo "Total process running: $total_process"  >> temp.txt
		echo "---------------------------------------" >> temp.txt

		echo "$i is running more than 1 hour" >> temp.txt
		echo >> temp.txt
		echo "Total time taken by process $i is : $PIDElapsedTime" >> temp.txt
		echo >> temp.txt
		cat Process_list_${DATE3}.txt | grep -i "$i" >> temp.txt
		echo >> temp.txt
		echo "---------------------------------------" >> temp.txt
		cat Process_list_${DATE3}.txt >> temp.txt
		
		AlertCount=$((AlertCount+1))
		echo "Altert count is: $AlertCount" >> count_temp.txt #temp
		echo "---------------------------------------" >> count_temp.txt #temp



		
	#else #*****************************
	     #echo "---------------------------------------" >> count_temp.txt #temp

	      #echo "Time now: $DATE3" count_temp.txt #temp

	      #echo "$Threshold is greater than $TimeDifference" >> count_temp.txt
	     #echo "---------------------------------------" >> count_temp.txt #temp

		
	fi



done
#*************************************************

if [ $AlertCount -gt 0 ]; then
cat "temp.txt" | mailx -s "PRD_8.7 ! - Long Process Runnning"  ${EMAILID} 
rm -f temp.txt Process_list_${DATE3}.txt
fi


count=$((count+1)) 
#echo "loop count is : $count" >> count_temp.txt #temp





sleep $(((1 * 60 * 60)/2))   ##Break of 30 minutes


done && exit;

done


#*************************************************************************************************************************************#XX#
