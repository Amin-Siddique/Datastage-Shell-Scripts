#!/bin/sh
#set -x

#Output every sec 
#Created by: Amin Siddique

export DATE=`date +%Y%m%d`
export DATEMINUTE=`date +%Y%m%d%H%M`
WALL="#***********************************"
export SYSTEM=`hostname`
PS=$(cd $(dirname $0); /bin/pwd)
tmp=$PS/tmp_usage


cd /tmp
#df -g | grep tmp | awk '{ print $4-1 }'

count=0

while true; do	
	
    until [ "$count" -ge 5000 ]   ##12 times loop
    do		
	echo "Time right now:  `date +%I:%M`" >> ${tmp}/${DATEMINUTE}_tmp_usage 
	df -g /tmp >> ${tmp}/${DATEMINUTE}_tmp_usage
	#du -s * |  sort -nr   >> ${tmp}/${DATEMINUTE}_tmp_usage_${count}
	echo "$WALL$WALL" >> ${tmp}/${DATEMINUTE}_tmp_usage
    	sleep $(((1 * 60 * 60)/3600))   ##Break of 2 minutes
	count=$((count+1))
done && exit;
done
