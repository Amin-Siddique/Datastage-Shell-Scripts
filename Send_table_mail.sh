#!/bin/sh
set -x

temppath=`pwd`
recipientmailid="xxxx@yyyy.com"
rm -f $temppath/emailbody.txt

###############THIS IS VERY CRTICAL TO DEFINE AS MAIL IS SENT AS HTML######################

echo "From: xxx@yyy.com" >$temppath/emailbody.txt
echo "To: $recipientmailid">> $temppath/emailbody.txt
echo "MIME-Version: 1.0" >> $temppath/emailbody.txt
echo "Subject: Table tedt " >>$temppath/emailbody.txt
echo "Content-Type: text/html" >>$temppath/emailbody.txt

#########################################################################################


echo "<p>" " Hi All," >>$temppath/emailbody.txt


echo "<p>" "The statistics have been generated in the below tables " >>$temppath/emailbody.txt


awk -F',' 'BEGIN{print "<br> </br> <table border=1 style=width:80%>"}
 {print "<tr>";for(i=1;i<=NR;i++)print "<td>" $i"</td>";print "</tr>"} 
END{print "</table>"}'  $temppath/tempfile.txt >>$temppath/emailbody.txt



echo "<p>" >>$temppath/emailbody.txt
echo "&nbsp;</p>" >>$temppath/emailbody.txt

echo "<p><br><br>"  >>$temppath/emailbody.txt

echo "<p>" >>$temppath/emailbody.txt


#################### Generating Mail Body ##############################



echo "<p><p>" "Regards," >>$temppath/emailbody.txt
echo "<p>" "Github" >>$temppath/emailbody.txt

#################### Sending Mail ##############################

cat $temppath/emailbody.txt | sendmail $recipientmailid


#############Below is how the file "$temppath/tempfile.txt" looks like:
#x,y,z
#5,17,0
#7,17,.14
#9,17,-103.53
#10,17,17.64
#12,17,.1
#13,17,-24.09
#14,17,1.32
######################
