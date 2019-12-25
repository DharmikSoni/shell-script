<<c
echo "4.1 Restrict core Dumps" 								
set -x					
	
fileName="/etc/security/limits.conf"
fileName1="/etc/sysctl.conf"								
echo "grep "hard core" /etc/security/limits.conf"
echo "sysctl fs.suid_dumpable"

VARIABLE=($grep "hard core" /etc/security/limits.conf)
echo "variable: "$VARIABLE
VARIABLE1=`sysctl fs.suid_dumpable`

fileName_match="* hardcore 0"
fileName1_match="fs.suid_dumpable = 0"

if [[ -f "$fileName" && -f "$fileName1" ]]
then
	if [[ "$VARIABLE" == "$fileName_match" && "$VARIABLE" == "$fileName1_match" ]]
	then
		echo "$(date +%r) Compliance status:Yes" "4.1 " $fileName 
	else
		echo "$(date +%r) Compliance status:No" "4.1" $fileName 
	fi
fi
c

<<c
echo "6.1 Ensure the X windows system is not installed"
set -x
VARIABLE=$(dpkg -l xserver-xorg-core*)
#dpkg -l xserver-xorg-core*
#echo "$VARIABLE"
if [ "$VARIABLE" -eq "\0" ]
then
	echo "$(date +%r) Compliance status:yes" "6.1 X windows">>$file1
else
	echo "$(date +%r) Compliance status:no" "6.1 X windows">>$file1
fi
c

<<c
#!/bin/sh

echo "6.1 Ensure the X windows system is not installed"


dpkg-query -s xserver-xorg-core* > /dev/null 2>&1
case $? in
0)
    echo $1 is installed 
    echo "$(date +%r) Compliance status:Yes" "6.1 xserver-xorg-core*" 
    ;;
1)
    echo $1 is not installed
    echo "$(date +%r) Compliance status:No"  "6.1 xserver-xorg-core*"  
    ;;
2)
    echo An error occurred
    echo "$(date +%r) Compliance status:No"  "6.1 xserver-xorg-core*"  
    ;;
esac
c

<<c
#!/bin/sh
#
# Script to check if enabled rc scripts are running, if not start them
#
# Uses ``<rc.d script> status'' to check if service is running.
# Some rc scripts do not run a simple daemon, we also might not want
# to check them, add the rc script name to IGNORE_LIST.
#
# Jake Smith, <jake at xz.cx>
# http://mebsd.com

# Ignore list, services we don't want to start, e.g. bgfsck, newsyslog.
# Note space at ends of string and in test var, this ensures exact matches.
IGNORE_LIST=" bgfsck newsyslog ntpdate "

# Get list of enabled rc scripts
/usr/sbin/service -e | while read SERVICE
do
    # is rc script in ignore list?
    test "${IGNORE_LIST#* $(basename ${SERVICE}) }" != "${IGNORE_LIST}" && continue

    # check rc script supports status
    ${SERVICE} 2>&1 | /usr/bin/grep '|status|poll' >/dev/null
    if [ $? -eq 0 ]
    then
        # check status
        STATUS=$(${SERVICE} status)
        if [ $? -gt 0 ]
        then
            # service not running try to start
            echo ${STATUS}
            ${SERVICE} start
            ${SERVICE} status
        fi
    fi
done
c


<<c
echo "5.1.6 Ensure telnet server is not enabled"
echo "grep ^telnet /etc/inetd.conf"

if [ -e "/etc/inetd.conf" ]
then
	count=`grep ^telnet /etc/inetd.conf | wc -l`
	if [ $count -ne 0 ]
	then
		VARIABLE=`grep ^telnet /etc/inetd.conf`
		if [[ $VARIABLE == ^telnet ]]
		echo "come"		
		then		
			echo "$(date +%r) Compliance status:No" "5.1.6 telnet server"
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.1.6 telnet server"
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.1.6 telnet server"	
fi
c

<<c
if [ -f "/etc/inetd.conf" ]
then
	
	count=`grep ^echo /etc/inetd.conf | wc -l`
	if [ "$count" -ne 0 ]	
	then
		VARIABLE=`grep ^echo /etc/inetd.conf`		
		if [ $VARIABLE == ^echo ]
		#echo "come"	
		then	
			echo "$(date +%r) Compliance status:No" "5.1.6 telnet server"
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.1.6 telnet server"
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.1.6 telnet server"	
fi
c
<<c
echo "5.4 Ensure echo is not enabled"
if [  -e " /etc/inetd.conf" ]
then
	echo "5.4 file doesn't exists."
	echo "$(date +%r) Compliance status:Yes" "5.4 echo service">>$file1
grep ^echo /etc/inetd.conf
OUT=$?
elif [ $OUT -ne 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "5.4 echo service">>$file1
else
	echo "$(date +%r) Compliance status:No" "5.4 echo service">>$file1
fi
c







<<c
echo "5.6 Ensure time is not enabled"
if [ -f "/etc/inetd.conf" ]
then
	
	count=`grep ^time /etc/inetd.conf | wc -l`
	if [ "$count" -ne 0 ]	
	then
		VARIABLE=`grep ^time /etc/inetd.conf`		
		if [ $VARIABLE == ^echo ]
		#echo "come"	
		then	
			echo "$(date +%r) Compliance status:No" "5.1.6 telnet server"
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.1.6 telnet server"
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.1.6 telnet server"	
fi
c

<<c
#ntp
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ntp | grep "install ok installed")

if [ $? eq 0 ]
then
	#echo "redirect the status"
	echo "check parameters"
	
	
else
	echo "ntp not installed"
	echo "return the status no"

c




#->query-disable/not installed
#check exit status
#check installation status-dpkg-query

#auditd


#dpkg-query - status
#exit status
#enabled or not
<<c
echo "8.1.2 Install and Enabled auditd service"

dpkg -s auditd												
if [ $? -eq 0 ]
then
	VARIABLE=$(systemctl is-enabled auditd)
	if [ "$VARIABLE" == "enabled" ]
	then
		echo "$(date +%r) Compliance status:Yes " "8.1.2 auditd service "
	else
		echo "$(date +%r) Compliance status:No " "8.1.2 auditd service " 	
	fi
else
	echo "$(date +%r) Compliance status:No " "8.1.2 auditd service " 
fi
c
<<c
if [ "$(grep -cim1 "time-change" /etc/audit/audit.rules)" == 1 ]	#will match lines if found then 1 or 0, use -ge to match number of lines
then
	echo "found"
else
	echo "not found"
fi
c

<<c
echo "8.2.3 Configure /etc/rsyslog.conf"

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' iptables | grep "install ok installed")
if [[ $PKG_OK == "install ok installed" ]]
then
	echo "$(date +%r) Compliance status:Yes " "8.2.3 rsyslog" 
else
	echo "$(date +%r) Compliance status:Yes " "8.2.3 rsyslog" 
fi
c


echo "9.3.3 Set Permissions on /etc/ssh/sshd_config"

perm=`/bin/ls -l /etc/ssh/sshd_config | wc -l`

if [ $perm != 0 ]
then
	default=$(/bin/ls -l /etc/ssh/sshd_config)
	expected=$(ls -l /etc/ssh/sshd_config | grep "^.rw.......")

	if [[ $default == $expected ]]
	then
		echo "$(date +%r) Compliance status:Yes " "9.1.4 /etc/cron.daily"
	else
		echo "$(date +%r) Compliance status:No " "9.1.4 /etc/cron.daily"
	fi
else
	echo "$(date +%r) Compliance status:No " "9.1.4 /etc/cron.daily"		
fi
