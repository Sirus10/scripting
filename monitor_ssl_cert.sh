#!/usr/bin/ksh
########################################################################################
#  This script aim to monoror SSL cert validity and alert in case v
#  validity will fail in few days.
#
# Site    : http://domotique.web2diz.net/
# Details : http://domotique.web2diz.net/?p=878
# Source  : https://github.com/Sirus10/scripting/blob/master/monitor_ssl_cert.sh
# License : CC BY-SA 4.0
#
#  Usage:
#  ./monitor_ssl_cert.sh
#
# Daily scheduling in crontab : 
# 30 7 * * *  /root/scripts/monitor_ssl_cert.sh >> /tmp/monitor_ssl_cert.log
#
#######################################################################################
server=domoticz  	# URL to monitor
port=443		# PORT SSL (default 443) 
RPI_NAME=`hostname`
# FREE SMS API SETUP / Only if you want to use SMS feature
# UNcomment the 3 lines below if you want to use this feature
#SMS_FREE_USER=<free api user>		# Put SMS user API KEY (see mobile.free.fr) 
#SMS_FREE_PASSWD=<free api password>	# Put SMS pass API KEY (see mobile.free.fr) 
#SMS_FREE_API="https://smsapi.free-mobile.fr/sendmsg?user=$SMS_FREE_USER&pass=$SMS_FREE_PASSWD&msg=$RPI_NAME ALERT : "

echo server:port :  https://$server:$port

startdate=`echo | openssl s_client -servername $server -connect $server:$port 2>/dev/null | openssl x509 -noout -dates | grep notBef | awk '{print $1,$2,$3,$4,$5}'|cut -d=  -f2`
expiredate=`echo | openssl s_client -servername $server -connect $server:$port 2>/dev/null | openssl x509 -noout -dates | grep notAfter | awk '{print $1,$2,$3,$4,$5}'|cut -d=  -f2`
today=`date`

echo $startdate  --- Start date
echo $expiredate  --- Expire date
echo `date '+%b %d %H:%m:%S %Y %Z'` --- Today




expiretimestamp=`date -d "$expiredate" +%s`
startimestamp=`date -d "$startdate" +%s`
curenttimestamp=`date +%s`
d1=expiretimestamp
d2=curenttimestamp

echo startimestamp= $startimestamp
echo expiretimestamp= $expiretimestamp
echo curenttimestamp= $curenttimestamp

# check diff between expiration date and today 
dayvalid=`echo $(( (((d1-d2) > 0 ? (d1-d2) : (d2-d1)) + 43200) / 86400 ))`
echo expiration in $dayvalid days

# Alert in case exiration is lower than 45 days
if [ $dayvalid -lt 45 ]

then
        echo "    Warning !!  "
		ALERT_MESS="SSL Cert expiration in $dayvalid days for $server:$port!"
		# SMS alert uncomment next line is you want to use SMS alerting
		#curl -k -f "$SMS_FREE_API$ALERT_MESS"
		# Mail alert 
		echo $ALERT_MESS | mail -s "SSL Cert expiration " <put your email adress here> 
		
		
else
        echo " CERT  OK "
fi
