#!/bin/sh
set -x


####################################################################################################################################################
#																		   #
#  												   #       
# Created       :  AMIN SIDDIQUE	
# Description   :  Script uses loop to check if CPU crosses Threshold value and send mail accordingly                                            #                                                                                                     
#  #
#																		   #                                                                    
####################################################################################################################################################


DATE3=`date +%I:%M`
DIR=`pwd`

EMAILID="xxxxx"
Threshold=85     #set threshold here to send alert!
#CPU=$(mpstat | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ { print 100 - $field }')

count=0



while true; do	
	
    until [ "$count" -ge 43200 ]   ##xX times loop
    do		#return 1 if true ; O if not
	#count=0
	CPU=$(top -bn1 | sed -n '/Cpu/p' | awk '{print $2+$4}')
	Condition=$(echo "${CPU} > ${Threshold}" | bc -q)
	if [ ${Condition} = 1 ]; then

##BLOCK
#*******************************************************************************************************************************
 Tpr=$(ps -ef|wc -l)
 echo "Time right now:  `date +%I:%M`" >>  $DIR/process_list_$count.txt
 echo "CPU usage :  $CPU " >>  $DIR/process_list_$count.txt
 echo "--------------------------TOP COMMAND-------------------------------" >>  $DIR/process_list_$count.txt
    top -b -n 1 | grep -v c0022658 >> 	$DIR/process_list_$count.txt
 echo "--------------------------XXXXXXXXXXXX-------------------------------" >>  $DIR/process_list_$count.txt

 echo "--------------------------xxxxxxxxxxxxxxxxx-------------------------------" >>  $DIR/process_list_$count.txt
   
   echo "Total process running : $Tpr" >> $DIR/process_list_$count.txt
 echo "--------------------------xxxxxxxxxxxxxxxxx-------------------------------" >>  $DIR/process_list_$count.txt

    ps -ef >> $DIR/process_list_$count.txt



#echo "--------------------------AUX COMMAND-------------------------------" >>  $DIR/process_list_$count.txt
#    ps aux >> 	$DIR/process_list_$count.txt


echo "--------------------------MEMORY COMMAND-------------------------------" >>  $DIR/process_list_$count.txt

	 free -m >> $DIR/process_list_$count.txt

	 
   #cat $DIR/process_list_$count.txt |  mail -a $DIR/process_list_$count.txt -s "Plapds101e: Process List - $count"  $EMAILID
   #rm -f $DIR/process_list_$count.txt
   count=$((count+1))
##BLOCK
#*******************************************************************************************************************************
   
		else
		count=$((count+1))
		echo "Time right now:  `date +%I:%M`" >>  $DIR/noissue.txt
 		echo "CPU usage :  $CPU " >>  $DIR/noissue.txt
 		echo "-------------------------XXX" >>  $DIR/noissue.txt
		fi 
    sleep $(((1 * 60 * 60)/1800))   ##Break of 2 minutes
done && exit;

done

