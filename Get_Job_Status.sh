#!/bin/sh
set -x

###############################################################
# This script will fetch job status across all datastage projects
# 
# Created By: Amin Siddique (June 21')
##############################################################

DIR=$(cd $(dirname $0); /bin/pwd)
Project=$DIR/Projects.txt
Jobs=$DIR/Joblist/JobList-
Status=$DIR/Stats/Status-
filename=$DIR/Sequences.txt
VarDSHome=/software_binaries/IBM/InformationServer/Server/DSEngine
DATE=`date +%Y-%m-%d`
DATEHM=`date +%Y%m%d%H%M`

touch $Status$i* $DIR/report.txt $DIR/temp.txt
rm -f $Status$i* $DIR/report.txt $DIR/temp.txt

#Initialize the environment parameters to use the Datastage commands.
cd  `cat /.dshome`
. ./dsenv > /dev/null 2>&1
cd $DSHOME/bin
 

#Get projects
dsjob -lprojects > $Project

#Divide projects with respective jobs
Get Jobs in the project
for i in `cat $Project`;
do	
dsjob -ljobs ${i}  >> $Jobs$i
done 


#Get Job report 
for i in `cat $filename`;
do
${VarDSHome}/bin/dsjob -report ${Project} ${i} >> $Status$i
done


##create a report
cd $DIR/Stats
for f in `ls -r`; 
do
JobName=$(basename $f | awk -F'-' '{print $2}')
Detail=$(cat $f | grep -e 'Job elapsed time' -e 'Job end time'  -e 'Job status' | perl -pi -e 's/\n/*/')
echo "$JobName * $Detail" >> $DIR/temp.txt
done


##Formating report
cat $DIR/temp.txt | awk -F'*' '{printf("%-60s %-10s %-10s %-10s\n", $1,$3,$2,$4)}' >> $DIR/DS_JOB_Report_${DATEHM}.txt
r_date=$(cat $DIR/DS_JOB_Report_${DATEHM}.txt | grep -v $DATE)
echo "##--------------------------------------------------XXXXXXXX----------------------------------------------" >> $DIR/DS_JOB_Report_${DATEHM}.txt
echo "##		                       Below jobs didn't RUN for date : $DATE            		                        " >> $DIR/DS_JOB_Report_${DATEHM}.txt
echo "##--------------------------------------------------XXXXXXXX----------------------------------------------" >> $DIR/DS_JOB_Report_${DATEHM}.txt
echo "$r_date" >> $DIR/DS_JOB_Report_${DATEHM}.txt
 


rm -f $DIR/temp.txt

exit 0
 
