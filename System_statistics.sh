#!/bin/sh
#set -x

#This script is to provide system statistics for Datatstage 8.x release 
#Created By: Amin Siddique


export DATE=`date +%Y%m%d`
export DATEMINUTE=`date +%Y%m%d%H%M`
WALL="#***********************************"
export SYSTEM=`hostname`
PS=$(cd $(dirname $0); /bin/pwd)


if [ -d ${PS}/${DATE} ]
   then echo "Directory exists"
     else
        mkdir ${PS}/${DATE}
fi


# Keep track of all processes
ps -ef >> ${PS}/${DATE}/${DATEMINUTE}_system_ps


# Update Statistics on system
echo ${WALL}${WALL} >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo `date` >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats



echo "Top Ten Processes Running" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
ps -e -o pcpu,pid,user,tty,args |sort -n -k 1 |head >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats



echo ${WALL}${WALL} >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "Vmstats results" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
vmstat 5 10 >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats


echo ${WALL}${WALL} >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "CPU Utilization Percentage:" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo $[100-$(vmstat 1 2|tail -1|awk '{print $15}')]
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats


echo ${WALL}${WALL} >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "Total Processes Running " `date`   `ps -ef |wc -l` >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats


echo ${WALL}${WALL} >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "Checking tmp folder usage" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
cd /tmp
du -s * |  sort -nr | head -20  >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats



echo ${WALL}${WALL} >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "DataStage Processes Running" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
ps -ef | grep DSD|egrep -v "grep"  >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
echo "" >> ${PS}/${DATE}/${DATEMINUTE}_sys_stats
