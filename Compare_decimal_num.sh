#!/bin/sh
set -x


result1=1.4 
result2=5.1

##result=$(echo "${result1}<${result2}" | bc) 

if [[ `echo "$result1 $result2" | awk '{print ($1 > $2)}'` == 1 ]]; then
     echo "$result1 is greater than $result2"
else
	echo "$result2 is greater than $result1"

fi
