#!/bin/bash

#CIS security Audit script
#Author: Dharmik Soni

echo -e "\t\t\t\t\t\t\t**************************************************"
echo -e "\t\t\t\t\t\t\t*\t\tCIS Security Audit script\t *"			
echo -e "\t\t\t\t\t\t\t*\t\t    Debian 9 Stretch\t\t *"  

echo -e "\t\t\t\t\t\t\t**************************************************"

#Output Files
exec > >(tee "/home/osboxes/Desktop/cis_report_output.txt") 2>&1
file1="/home/osboxes/Desktop/cis_compliance.txt"

echo -e "*******************System Details********************************" 
#Basic System Details
echo "CIS security Audit report"
echo "*DATE*"
date

echo "*OS*"
cat /etc/debian_version
echo "*KERNEL*"
uname -a

echo "*HOST*"
hostname

echo -e "\n"
echo "****************************Code***********************************"
echo -e "\n"


#Audit Code
echo "****************************************************************************"

echo "1.1 Install updates, patches, additional security softwares"
echo "$ apt-get update"
echo "$(date +%r)"
#apt-get update

echo "****************************************************************************"

echo "2.1 Create separate partition for /tmp"		
echo " mount |grep /tmp"
#mount | grep /tmp
if grep -q /tmp /proc/mounts
then
	echo "$(date +%r) Compliance status:Yes" $fileName "2.1 /tmp partition" >>$file1
else
	echo "$(date +%r) Compliance status:No" $fileName "2.1 /tmp partition" >>$file1
fi

echo "****************************************************************************"

echo "2.5 Create separate partition for /var"	
echo "# grep " /var " /etc/fstab"
grep " /var " /etc/fstab

if grep -q /var /etc/fstab
then
	echo "$(date +%r) Compliance status:Yes" $fileName "2.5 /var partition" >>$file1
else
	echo "$(date +%r) Compliance status:No" $fileName "2.5 /var partition" >>$file1
fi

echo "****************************************************************************"

echo "2.7 Create separate partition for /var/log"	
echo "# grep " /var/log " /etc/fstab"
grep " /var/log " /etc/fstab


if grep -q /var/log /etc/fstab
then
	echo "$(date +%r) Compliance status:Yes" $fileName "2.7 /var/log partition" >>$file1
else
	echo "$(date +%r) Compliance status:No" $fileName "2.7 /var/log partition" >>$file1
fi

echo "****************************************************************************"

echo "2.9 Create separate partition for /home"	
echo "# grep " /home " /etc/fstab"
grep " /home " /etc/fstab

if grep -q /home /etc/fstab
then
	echo "$(date +%r) Compliance status:Yes" $fileName "2.9 /home partition" >>$file1
else
	echo "$(date +%r) Compliance status:No" $fileName "2.9 /home partition" >>$file1
fi

echo "****************************************************************************"

echo "2.18 Disable mounting of cramfs filesystem"					#fail
echo "#/sbin/modprobe -n -v cramfs"


echo "****************************************************************************"

echo "3.1 Set user/group owner on bootloader config"					
echo "stat -c "%u %g" /boot/grub/grub.cfg | egrep "^0 0""
fileName="/boot/grub/grub.cfg"

VARIABLE=`stat -c "%u %g" /boot/grub/grub.cfg | egrep "^0 0"`

if [ -e "$fileName" ]
then
	count=`stat -c "%u %g" /boot/grub/grub.cfg | egrep "^0 0" | wc -l`
	if [ $count -ne 0 ]
	then
		match="0 0"
		if [ "$VARIABLE" == "$match" ]
		then
			echo "$(date +%r) Compliance status:Yes" "3.1" $fileName >>$file1
		else
			echo "$(date +%r) Compliance status:No" "3.1 " $fileName >>$file1
		fi  
	else
		echo "No Rows found"	
		echo "$(date +%r) Compliance status:No" "3.1 " $fileName >>$file1	
	fi
fi

echo "****************************************************************************"

fileName="/boot/grub/grub.cfg"
echo "3.2 Set permission on bootloader config"						
echo "stat -L -c "%a" /boot/grub/grub.cfg | egrep ".00"
"

VARIABLE=`stat -L -c "%a" /boot/grub/grub.cfg | egrep ".00"`

if [ -e "$fileName" ]
then
	count=`stat -L -c "%a" /boot/grub/grub.cfg | egrep ".00" | wc -l`
	if [ $count -ne 0 ]
	then
		match=".00"
		if [ "$VARIABLE" == "$match" ]
		then
			echo "$(date +%r) Compliance status:Yes" "3.2" $fileName >>$file1
		else
			echo "$(date +%r) Compliance status:No"  "3.2" $fileName >>$file1
		fi  
	else
		echo "No Rows found"		
		echo "$(date +%r) Compliance status:No" "3.2 " $fileName >>$file1
	fi
fi


echo "****************************************************************************"

fileName="etc/shadow"
echo "3.4 Require Authentication for siingle user mode"
echo "grep ^root:[*\!]: /etc/shadow"

if [ "-f $fileName" ]
then
	if [ -n `grep ^root:[*\!]: /etc/shadow` ]
	then
		echo "$(date +%r) Compliance status:Yes" "3.4 " $fileName >>$file1
	else
		echo "$(date +%r) Compliance status:No" "3.4" $fileName >>$file1
	fi
fi

echo "****************************************************************************"		

echo "4.1 Restrict core Dumps" 								#one file returns  output,others not
											#partial compliant	
fileName="etc/security/limits.conf"
fileName1="etc/sysctl.conf"								
echo "grep "hard core" /etc/security/limits.conf"
echo "sysctl fs.suid_dumpable"

VARIABLE=`grep "hard core" /etc/security/limits.conf`
VARIABLE1=`sysctl fs.suid_dumpable`

fileName_match="* hardcore 0"
fileName1_match="fs.suid_dumpable = 0"

if [ -f "$fileName" && -f "$fileName1" ]
then
	if [[ "$VARIABLE" == "$fileName_match" && "$VARIABLE" == "$fileName1_match" ]]
	then
		echo "$(date +%r) Compliance status:Yes" "4.1 " $fileName >>$file1
	else
		echo "$(date +%r) Compliance status:No" "4.1" $fileName >>$file1
	fi
fi

echo "****************************************************************************"
			
echo "4.4 Disable prelink"

dpkg-query -s prelink > /dev/null 2>&1
case $? in
0)
    echo $1 is installed 
    echo "$(date +%r) Compliance status:Yes" "4.4 prelink"  >>$file1
    ;;
1)
    echo $1 is not installed
    echo "$(date +%r) Compliance status:No"  "4.4 prelink"  >>$file1
    ;;
2)
    echo An error occurred
    ;;
esac

echo "****************************************************************************"
#Legacy services
echo "5.1.1 Ensure NIS is not installed"

dpkg-query -s nis > /dev/null 2>&1
case $? in
0)
    echo $1 is installed 
    echo "$(date +%r) Compliance status:Yes" "5.1.1 nis"  >>$file1
    ;;
1)
    echo $1 is not installed
    echo "$(date +%r) Compliance status:No"  "5.1.1 nis"  >>$file1
    ;;
2)
    echo An error occurred
    ;;
esac

echo "****************************************************************************"

echo "5.1.5 Ensure talk client is not installed"

dpkg-query -s talk > /dev/null 2>&1
case $? in
0)
    echo $1 is installed 
    echo "$(date +%r) Compliance status:Yes" "5.1.5 talk"  >>$file1
    ;;
1)
    echo $1 is not installed
    echo "$(date +%r) Compliance status:No"  "5.1.5 talk"  >>$file1
    ;;
2)
    echo An error occurred
    ;;
esac


echo "****************************************************************************"

echo "5.1.6 Ensure telnet server is not enabled"
echo "grep ^telnet /etc/inetd.conf"

if [ -e "/etc/inetd.conf" ]
then
	count=`grep ^telnet /etc/inetd.conf | wc -l`
	if [ $count -ne 0 ]
	then
		VARIABLE=`grep ^telnet /etc/inetd.conf`
		if [[ $VARIABLE == ^telnet ]]
		then		
			echo "$(date +%r) Compliance status:No" "5.1.6 telnet server">>$file1
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.1.6 telnet server">>$file1
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.1.6 telnet server">>$file1	
fi

<<c
OUT=$?
elif [ $OUT -ne 0 ]	
then
	echo "$(date +%r) Compliance status:Yes" "5.1.6 telnet server">>$file1
else
	echo "$(date +%r) Compliance status:No" "5.1.6 telnet server" >>$file1
fi	
c

echo "****************************************************************************"

echo "5.1.7 Ensure tftp-server is not enabled"
echo "grep ^tftp /etc/inetd.conf"

if [ -e "/etc/inetd.conf" ]
then
	count=`grep ^tftp /etc/inetd.conf | wc -l`
	if [ $count -ne 0 ]
	then
		VARIABLE=`grep ^tftp /etc/inetd.conf`
		if [[ $VARIABLE == ^tftp ]]
		then		
			echo "$(date +%r) Compliance status:No" "5.1.7 tftp server" >>$file1
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.1.7 tftp server" >>$file1
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.1.7 tftp server" >>$file1
fi


echo "****************************************************************************"

echo "5.4 Ensure echo is not enabled"
if [ -f "/etc/inetd.conf" ]
then
	
	count=`grep ^echo /etc/inetd.conf | wc -l`
	if [ "$count" -ne 0 ]	
	then
		VARIABLE=`grep ^echo /etc/inetd.conf`		
		if [ $VARIABLE == ^echo ]
		#echo "come"	
		then	
			echo "$(date +%r) Compliance status:No" "5.4 echo service" >>$file1
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.4 echo service" >>$file1
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.4 echo service" >>$file1
fi

echo "****************************************************************************"

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
			echo "$(date +%r) Compliance status:No" "5.6 time service" >>$file1
		fi
	else
		echo "$(date +%r) Compliance status:Yes" "5.6 time service" >>$file1
	fi
else
	echo "File doesn't exists."
	echo "$(date +%r) Compliance status:No" "5.6 time service" >>$file1
fi

echo "****************************************************************************"

echo "6.1 Ensure the X windows system is not installed"


dpkg-query -s xserver-xorg-core* > /dev/null 2>&1
case $? in
0)
    echo $1 is installed 
    echo "$(date +%r) Compliance status:Yes" "6.1 xserver-xorg-core*"  >>$file1
    ;;
1)
    echo $1 is not installed
    echo "$(date +%r) Compliance status:No"  "6.1 xserver-xorg-core*"  >>$file1
    ;;
2)
    echo An error occurred
    echo "$(date +%r) Compliance status:No"  "6.1 xserver-xorg-core*"  >>$file1
    ;;
esac

echo "****************************************************************************"

echo "6.3 Ensure print server is not enabled"
VARIABLE=$(systemctl is-enabled cups)
systemctl is-enabled cups
if [ "$VARIABLE" == "disabled" ]
then
	echo "$(date +%r) Compliance status:Yes" "6.3 print server">>$file1
else
	echo "$(date +%r) Compliance status:No" "6.3 print server">>$file1
fi

echo "****************************************************************************"

echo "6.4 Ensure DHCP server is not enabled"
																			
ls /etc/rc*.d | grep isc-dhcp-server > t.lis
											$fail
if [[ -s t.lis ]] ; then
	echo "$(date +%r) Compliance status:Yes" "6.4 DHCP server">>$file1
else
	echo "$(date +%r) Compliance status:No" "6.4 DHCP server">>$file1
fi


echo "****************************************************************************"

echo "6.5 Configure Network time protocol"
dpkg -s ntp
OUT=$?
if [ $OUT -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "6.5 NTP"  >>$file1
else
	echo "$(date +%r) Compliance status:No" " 6.5 NTP" >>$file1	
fi

echo "****************************************************************************"
								
echo "6.6 Ensure LDAP is not enabled"							
#VARIABLE=$(dpkg-query -l | grep slapd | wc -l)
dpkg -s slapd

if [ $? == 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "6.6 LDAP"  >>$file1
else
	echo "$(date +%r) Compliance status:No" " 6.6 LDAP" >>$file1	
fi

echo "****************************************************************************"

echo "6.9 Ensure FTP server is not enabled"							
systemctl is-enabled vsftpd
VARIABLE=$(systemctl is-enabled vsftpd)

if [ "$VARIABLE" == "disabled" ]
then
	echo "$(date +%r) Compliance status:Yes" "6.9 vsftpd " >>$file1
else
	echo "$(date +%r) Compliance status:No" "6.9 vsftpd " >>$file1
fi

echo "****************************************************************************"


echo "6.11 Ensure IMAP and POP server is not enabled"
VARIABLE=$(systemctl is-enabled dovecot)
systemctl is-enabled dovecot
if [ "$VARIABLE" == "disabled" ]
then
	echo "$(date +%r) Compliance status:Yes" "6.11 dovecot " >>$file1
else
	echo "$(date +%r) Compliance status:No" "6.11 dovecot " >>$file1
fi

echo "****************************************************************************"

echo "6.15 Configure Mail Transfer Agent for Local-Only Mode"					

VARIABLE=`netstat -an | grep LIST | grep ":25[[:space:]]"`

if [ $? == 0 ]
then
	if [[ $VARIABLE == *127.0.0.1* ]] 
	then
		echo "$(date +%r) Compliance status:Yes" "6.15 MTA " >>$file1
	else
		echo "$(date +%r) Compliance status:Yes" "6.15 MTA"  >>$file1
	fi
else
	echo "An error occured"
fi

echo "----------------------------------------------------------------------------"
echo -e "\t\t\tNetwork Configuration and Firewalls"
echo "----------------------------------------------------------------------------"		

echo "7.1.1 Disable IP Forwarding"
#VARIABLE=$(/sbin/sysctl net.ipv4.ip_forward | grep -o '0$')
VARIABLE=$(/sbin/sysctl net.ipv4.ip_forward | cut -d "=" -f 2 | tr -d ' ')
/sbin/sysctl net.ipv4.ip_forward 
if [ "$VARIABLE" == 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "7.1.1 ip_forward " >>$file1
else
	echo "$(date +%r) Compliance status:No" "7.1.1 ip_forward " >>$file1
fi

echo "****************************************************************************"

echo "7.1.2 Disable send packet Redirects"
VARIABLE=$(/sbin/sysctl net.ipv4.conf.all.send_redirects && /sbin/sysctl net.ipv4.conf.default.send_redirects | cut -d "=" -f 2 | tr -d ' ')

/sbin/sysctl net.ipv4.conf.all.send_redirects
/sbin/sysctl net.ipv4.conf.default.send_redirects
if [ "$VARIABLE" == 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.1.2 send packets " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.1.2 send packets " >>$file1
fi

echo "****************************************************************************"

echo "7.2.2 Disable source Routed packet Acceptance"
VARIABLE=$(/sbin/sysctl net.ipv4.conf.all.accept_source_route && /sbin/sysctl net.ipv4.conf.default.accept_source_route | cut -d "=" -f 2 | tr -d ' ')

/sbin/sysctl net.ipv4.conf.all.accept_source_route
/sbin/sysctl net.ipv4.conf.default.accept_source_route

if [ "$VARIABLE" == 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.2.2 source Packet acceptance " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.2.2 source Packet acceptance " >>$file1
fi

echo "****************************************************************************"

echo "7.2.4 Log Suspicious packets"
VARIABLE=$(/sbin/sysctl net.ipv4.conf.all.log_martians && /sbin/sysctl net.ipv4.conf.default.log_martians | cut -d "=" -f 2 | tr -d ' ')

/sbin/sysctl net.ipv4.conf.all.log_martians
/sbin/sysctl net.ipv4.conf.default.log_martians

if [ "$VARIABLE" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.2.4 Log packets " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.2.4 Log packets " >>$file1
fi

echo "****************************************************************************"

echo "7.2.5 Enable Ignore Broadcast Request"
VARIABLE=$(/sbin/sysctl net.ipv4.icmp_echo_ignore_broadcasts | cut -d "=" -f 2 | tr -d ' ')
q
/sbin/sysctl net.ipv4.icmp_echo_ignore_broadcasts

if [ "$VARIABLE" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.2.5 Broadcast Req " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.2.5 Broadcast Req " >>$file1
fi

echo "****************************************************************************"

echo "7.2.6 Enable Bad Error Message Protection"
VARIABLE=$(/sbin/sysctl net.ipv4.icmp_ignore_bogus_error_responses | cut -d "=" -f 2 | tr -d ' ')

/sbin/sysctl net.ipv4.icmp_ignore_bogus_error_responses

if [ "$VARIABLE" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.2.6 Bad Error Message " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.2.6 Bad Error Message " >>$file1
fi

echo "****************************************************************************"

echo "7.3.1 Disable ipv6 router Advertisements"
VARIABLE=$(/sbin/sysctl net.ipv6.conf.all.accept_ra && /sbin/sysctl net.ipv6.conf.default.accept_ra | cut -d "=" -f 2 | tr -d ' ')

/sbin/sysctl net.ipv6.conf.all.accept_ra
/sbin/sysctl net.ipv6.conf.default.accept_ra

if [ "$VARIABLE" == 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.3.1 Disable ipv6 RA " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.3.1 Disable ipv6 RA " >>$file1
fi

echo "****************************************************************************"

echo "7.3.2 Disable IPv6 Redirect Acceptance"

VARIABLE=$(/sbin/sysctl net.ipv6.conf.all.accept_redirects && /sbin/sysctl net.ipv6.conf.default.accept_redirects | cut -d "=" -f 2 | tr -d ' ')

/sbin/sysctl net.ipv6.conf.all.accept_redirects
/sbin/sysctl net.ipv6.conf.default.accept_redirects

if [ "$VARIABLE" == 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.3.2 Disable ipv6 Redirect Acpt " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.3.2 Disable ipv6 Redirect Acpt " >>$file1
fi
echo "****************************************************************************"

echo "7.3.3 Disable IPv6"
VARIABLE=$(ip addr | grep inet6)
if [ "$VARIABLE" -eq '\0' ]
then
	echo "$(date +%r) Compliance status:Yes " "7.3.3 Disable ipv6 " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.3.3 Disable ipv6 " >>$file1
fi

echo "****************************************************************************"

echo "7.4.1 Install TCP Wrappers"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' tcpd|grep "install ok installed")
dpkg -s tcpd
if [ ""="$PKG_OK" ]
then
	echo "$(date +%r) Compliance status:Yes " "7.4.1 TCP Wrapper " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.4.1 TCP Wrapper " >>$file1	
fi
echo "****************************************************************************"

echo "7.4.2 Create /etc/hosts.allow"
cat /etc/hosts.allow
<<comm
if [ -n "-f /etc/hosts.allow" ]
then
	echo "$(date +%r) Compliance status:Yes " "7.4.2 /etc/hosts.allow " >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.4.2 /etc/hosts.allow " >>$file1	
fi
comm

fileName="/etc/hosts.allow"
function valid_ip()
{	
	local ip=$1
	local stat=1

	if [[ $fileName =~  ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1-3}\.[0-9]{1-3}$ ]]
	then
		OIFS=$IFS
		IFS='.'
		ip=($fileName)
		IFS=$OIFS

		[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
	fi
	return $stat
}

if [ "-e $fileName" ]
then
	if [ $valid_ip ]
	then	
	 	echo "$(date +%r) Compliance status:Yes " "7.4.2 /etc/hosts.allow " >>$file1	
	else
		echo "$(date +%r) Compliance status:No " "7.4.2 /etc/hosts.allow " >>$file1
	fi
fi 

echo "****************************************************************************"

echo "7.4.3 Verify Permission on /etc/hosts.allow"
ls -l /etc/hosts.allow
if [ $(stat -c %a /etc/hosts.allow) == 644 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.4.3 /etc/hosts.allow Perm " >>$file1	
else
	echo "$(date +%r) Compliance status:No " "7.4.3 /etc/hosts.allow Perm " >>$file1
fi 
echo "****************************************************************************"

echo "7.4.4 Create /etc/hosts.deny"
cat /etc/hosts.deny
fileName="/etc/hosts.deny"
str="ALL:ALL"
if [[ $(> $fileName) == "$str" ]]
then
	echo "$(date +%r) Compliance status:Yes " "7.4.4 /etc/hosts.deny " >>$file1	
else
	echo "$(date +%r) Compliance status:No " "7.4.4 /etc/hosts.deny " >>$file1
fi

echo "****************************************************************************"

echo "7.5.1"
grep "install dccp /bin/true" /etc/modprobe.d/CIS.conf

if [ $? -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.5.1 DCCP" >>$file1
else
	echo "$(date +%r) Compliance status:No "  "7.5.1 DCCP" >>$file1
fi 

echo "****************************************************************************"
echo "7.5.3 Disable RDS"

grep "install rds /bin/true" /etc/modprobe.d/CIS.conf

if [ $? -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.5.3 RDS" >>$file1
else
	echo "$(date +%r) Compliance status:No " "7.5.3 RDS" >>$file1
fi 

echo "****************************************************************************"

echo "7.6 Deactivate Wireless Interfaces"

echo "****************************************************************************"

echo "7.7 Ensure Firewall is active"

#PKG_OK=$(dpkg-query -W --showformat='${Status}\n' iptables | grep "install ok installed")
#PKG_OK1=$(dpkg-query -W --showformat='${Status}\n' iptables-persistent | grep "install ok installed")

#dpkg -s iptables
#dpkg -s iptables-persistent

#dpkg-query -W --showformat='${Status}\n' iptables | grep "install ok installed" && dpkg-query -W --showformat='${Status}\n' iptables-persistent | #grep "install ok installed"

VARIABLE=$(dpkg-query -l | grep iptables-persistent | wc -l && dpkg-query -l | grep iptables | wc -l)

if [ $? -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "7.7 iptables" >>$file1 
else
	echo "$(date +%r) Compliance status:No " "7.7 iptables"	>>$file1
fi

echo "****************************************************************************"

echo -e "\t\t\t\t\tLogging and Auditing"
echo "****************************************************************************"

echo "8.1.1.1 Configure Audit Log Storage Size"

grep max_log_file /etc/audit/auditd.conf

str="max_log_file" | cut -d "=" -f 2 | tr -d ' '
#if [[ $(< /etc/audit/auditd.conf) != "$str"  ]]
if [ "-e /etc/audit/auditd.conf" ]
then
	if [ "$str" > 5 ]
	then
		echo "$(date +%r) Compliance status:Yes " "8.1.1.1 Audit Log storage " >>$file1
	else
		echo "$(date +%r) Compliance status:No " "8.1.1.1 Audit Log storage " >>$file1	
	fi
fi

echo "****************************************************************************"

echo "8.1.1.2 Disable System on Audit Log Full"
grep space_left_action /etc/audit/auditd.conf
grep action_mail_acct /etc/audit/auditd.conf
grep admin_space_left_action /etc/audit/auditd.conf

str1="space_left_action" | cut -d "=" -f 2 | tr -d ' ' 
str2="action_mail_acct" | cut -d "=" -f 2 | tr -d ' '
str3="admin_space_left_action" | cut -d "=" -f 2 | tr -d ' '
 

if [ "-e /etc/audit/auditd.conf" ]
then
	if [[ "$str1" == "email" && "$str2" == "root" && "$str3" == "halt" ]]
	then
		echo "$(date +%r) Compliance status:Yes " "8.1.1.2 Audit Log full " >>$file1
	else
		echo "$(date +%r) Compliance status:No " "8.1.1.2 Audit Log full " >>$file1	
	fi
fi
echo "****************************************************************************"

echo "8.1.2 Install and Enabled auditd service"

dpkg -s								#i have installed it. auditd																			
if [ $? -eq 0 ]
then
	VARIABLE=$(systemctl is-enabled auditd)			#not enabled apply it in remediation
	if [ "$VARIABLE" == "enabled" ]
	then
		echo "$(date +%r) Compliance status:Yes " "8.1.2 auditd service " >>$file1
	else
		echo "$(date +%r) Compliance status:No " "8.1.2 auditd service " >>$file1	
	fi
else
	echo "$(date +%r) Compliance status:No " "8.1.2 auditd service " >>$file1 
fi

echo "****************************************************************************"

echo "8.1.4 Record Events That Modify Date and Time Information"

if [ "$(grep -cim1 "time-change" /etc/audit/audit.rules)" == 1 ]	#will match lines if found then 1 or 0, use -ge to match number of lines
then
	echo "$(date +%r) Compliance status:Yes " "8.1.4 Events, Date and time" >>$file1
else
	echo "$(date +%r) Compliance status:No " "8.1.4 Events, Date and time"  >>$file1
fi

echo "****************************************************************************"

echo "8.1.5 Record Events That Modify User/Group Information"

if [ "$(grep -cim1 "identity" /etc/audit/audit.rules)" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "8.1.5 Events, User/group" >>$file1
else
	echo "$(date +%r) Compliance status:No " "8.1.4 Events, User/group"  >>$file1
fi

echo "****************************************************************************"

echo "8.1.6 Record Events That Modify the System's Network Environment"

if [ "$(grep -cim1 "system-locale" /etc/audit/audit.rules)" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "8.1.6 Events, System Network Environment" >>$file1
else
	echo "$(date +%r) Compliance status:No " "8.1.6 Events, System Network Environment"  >>$file1
fi

echo "****************************************************************************"

echo "8.1.8 Collect Login and Logout Events"

if [ "$(grep -cim1 "logins" /etc/audit/audit.rules)" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "8.1.8 Events, Login and Logout" >>$file1
else
	echo "$(date +%r) Compliance status:No " "8.1.8 Events, Login and Logout"  >>$file1
fi

echo "****************************************************************************"

echo "8.1.9 Collect Session Initiation Information"

if [ "$(grep -cim1 "session" /etc/audit/audit.rules)" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "8.1.9 Session Init Info" >>$file1
else
	echo "$(date +%r) Compliance status:No "  "8.1.9 Session Init Info" >>$file1
fi

echo "****************************************************************************"

echo "8.1.15 Collect Changes to System Administration Scope (sudoers)"

if [ "$(grep -cim1 "scope" /etc/audit/audit.rules)" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "8.1.15 changes to sysadmin scope" >>$file1
else
	echo "$(date +%r) Compliance status:No "  "8.1.15 changes to sysadmin scope" >>$file1
fi

echo "****************************************************************************"

echo "8.1.16 Collect System Administrator Actions (sudolog)"

if [ "$(grep -cim1 "actions" /etc/audit/audit.rules)" == 1 ]
then
	echo "$(date +%r) Compliance status:Yes " "8.1.16 sysadmin actions" >>$file1
else
	echo "$(date +%r) Compliance status:No "  "8.1.15 sysadmin actions" >>$file1
fi

echo "****************************************************************************"

echo "8.2.1 Install the rsyslog package"

VARIABLE=$(dpkg-query -l | grep rsyslog | wc -l)
#if [ $? -eq 0 ]

if [ $VARIABLE -eq "1" ]
then
	echo "$(date +%r) Compliance status:Yes " "8.2.1 rsyslog package " >>$file1
else
	echo "$(date +%r) Compliance status:No " "8.2.1 rsyslog package " >>$file1	
fi

echo "****************************************************************************"

echo "8.2.2 Ensure the rsyslog Service is activated"
VARIABLE=$(systemctl is-enabled rsyslog)
systemctl is-enabled rsyslog
if [ "$VARIABLE" == "enabled" ]
then
	echo "$(date +%r) Compliance status:Yes " "8.2.2 rsyslog service " >>$file1
else
	echo "$(date +%r) Compliance status:No " "8.2.2 rsyslog service " >>$file1	
fi


echo "****************************************************************************"

echo "8.2.3 Configure /etc/rsyslog.conf"

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' iptables | grep "install ok installed")
if [[ $PKG_OK == "install ok installed" ]]
then
	echo "$(date +%r) Compliance status:Yes " "8.2.3 rsyslog" >>$file1
else
	echo "$(date +%r) Compliance status:Yes " "8.2.3 rsyslog" >>$file1
fi

echo "****************************************************************************"

echo "9.1.1 Enable cron Daemon"
VARIABLE1=$(systemctl is-enabled cron)
VARIABLE2=$(systemctl is-enabled anacron)

if [ "$VARIABLE1" == "$VARIABLE2" ]
then	
	echo "$(date +%r) Compliance status:Yes " "9.1.1 cron Daemon " >>$file1
else
	echo "$(date +%r) Compliance status:No " "9.1.1 cron Daemon " >>$file1	
fi
	
echo "****************************************************************************"

echo "9.1.2 Set User/Group Owner and Permission on /etc/crontab"

perm=`stat -c "%a %u %g" /etc/crontab | egrep ".00 0 0" | wc -l`

if [ $perm != 0 ]
then
	default=$(ls -l /etc/crontab)
	expected=$(ls -l /etc/crontab | grep "^.rw.......")
	if [[ $perm == $expected ]]
	then
		echo "$(date +%r) Compliance status:Yes " "9.1.2 /etc/crontab user/group" >>$file1
	else
		echo "$(date +%r) Compliance status:No " "9.1.2 /etc/crontab user/group" >>$file1
	fi
else
	echo "$(date +%r) Compliance status:No " "9.1.2 /etc/crontab user/group" >>$file1		
fi


echo "****************************************************************************"

echo "9.1.3 Set User/Group Owner and Permission on /etc/cron.hourly"

perm=`stat -c "%a %u %g" /etc/cron.hourly | egrep ".00 0 0" | wc -l`

if [ $perm != 0 ]
then
	default=$(ls -l /etc/cron.hourly)
	expected=$(ls -l /etc/cron.hourly | grep "^.rw.......")
	if [[ $perm == $expected ]]
	then
		echo "$(date +%r) Compliance status:Yes " "9.1.3 /etc/cron.hourly" >>$file1
	else
		echo "$(date +%r) Compliance status:No " "9.1.3 /etc/cron.hourly" >>$file1
	fi
else
	echo "$(date +%r) Compliance status:No " "9.1.3 /etc/cron.hourly" >>$file1		
fi

echo "****************************************************************************"

echo "9.1.4 Set User/Group Owner and Permission on /etc/cron.daily"

perm=`stat -c "%a %u %g" /etc/cron.daily | egrep ".00 0 0" | wc -l`

if [ $perm != 0 ]
then
	default=$(ls -l /etc/cron.daily)
	expected=$(ls -l /etc/cron.daily | grep "^.rw.......")
	if [[ $perm == $expected ]]
	then
		echo "$(date +%r) Compliance status:Yes " "9.1.4 /etc/cron.daily" >>$file1
	else
		echo "$(date +%r) Compliance status:No " "9.1.4 /etc/cron.daily" >>$file1
	fi
else
	echo "$(date +%r) Compliance status:No " "9.1.4 /etc/cron.daily" >>$file1		
fi

echo "****************************************************************************"

echo "9.2.1 Set Password Creation Requirement Parameters Using pam_cracklib"

<<c
checking if package is installed then perform further commands.
0=not installed
1=installed
c

VARIABLE=$(dpkg-query -l | grep libpam-cracklib | wc -l)
			

if [ $VARIABLE -ne "0" ]
then
	echo "$(date +%r) Compliance status:Yes " "9.2.1 libpam-cracklib " >>$file1
else
	echo "$(date +%r) Compliance status:No " "9.2.1 libpam-cracklib " >>$file1	
fi

echo "****************************************************************************"

echo "9.2.3 Limit Password Reuse"

count=`grep "remember" /etc/pam.d/common-password | wc -l`

if [ "$count" != 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "9.2.3 pam.d/common-pass " >>$file1
else
	echo "$(date +%r) Compliance status:No " "9.2.3 pam.d/common-pass "  >>$file1
fi

echo "****************************************************************************"

echo "9.3.1 Set SSH Protocol to 2"
grep "^Protocol" /etc/ssh/sshd_config
count=`grep "^Protocol" /etc/ssh/sshd_config | wc -l`

if [ "$count" != 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "9.3.1 /ssh/sshd_config " >>$file1
else
	echo "$(date +%r) Compliance status:No "  "9.3.1 /ssh/sshd_config "  >>$file1
fi
echo "****************************************************************************"

echo "9.3.2 Set LogLevel to INFO "
grep "^LogLevel" /etc/ssh/sshd_config
count=`grep "^LogLevel" /etc/ssh/sshd_config | wc -l`

if [ "$count" != 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "9.3.2 /ssh/sshd_config " >>$file1
else
	echo "$(date +%r) Compliance status:No "  "9.3.2 /ssh/sshd_config "  >>$file1
fi

echo "****************************************************************************"

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

echo "****************************************************************************"

echo "9.3.4 Disable SSH X11 Forwarding"
grep "^X11Forwarding" /etc/ssh/sshd_config 
default="X11Forwarding no"
output=`grep "^X11Forwarding" /etc/ssh/sshd_config`

#VARIBALE=`grep "^X11Forwarding" /etc/ssh/sshd_config | cut -d ' ' -f 2`

if [ "$default" == "$output" ]
then
	echo "$(date +%r) Compliance status:Yes " "9.3.4 /ssh/sshd_config-X11Forwarding " >>$file1
else
	echo "$(date +%r) Compliance status:No " "9.3.4 /ssh/sshd_config-X11Forwarding " >>$file1
fi

echo "****************************************************************************"

echo "9.3.8 Disable SSH Root Login"
grep "^PermitRootLogin" /etc/ssh/sshd_config
default="PermitRootLogin no"
output=`grep "^PermitRootLogin" /etc/ssh/sshd_config`

if [ "$default" == "$output" ]
then
	echo "$(date +%r) Compliance status:Yes " "9.3.8 /ssh/sshd_config-X11Forwarding(Root Login) " >>$file1
else
	echo "$(date +%r) Compliance status:No " "9.3.8 /ssh/sshd_config-X11Forwarding(Root Login) " >>$file1
fi

echo "****************************************************************************"

echo "9.3.9 Set SSH PermitEmptyPasswords to No"
grep "^PermitEmptyPasswords" /etc/ssh/sshd_config
default="PermitEmptyPasswords no"
output=`grep "^PermitEmptyPasswords" /etc/ssh/sshd_config`

if [ "$default" == "$output" ]
then
	echo "$(date +%r) Compliance status:Yes " "9.3.9 /ssh/sshd_config-X11Forwarding(Empty Pass) " >>$file1
else
	echo "$(date +%r) Compliance status:No " "9.3.9 /ssh/sshd_config-X11Forwarding(Empty Pass) " >>$file1
fi

echo "****************************************************************************"

echo "9.3.10 Do Not Allow Users to Set Environment Options"
count=`grep PermitUserEnvironment /etc/ssh/sshd_config | wc -l` 

if [ "$count" != 0 ]
then
	default="PermitUserEnvironment no"
	output=`grep PermitUserEnvironment /etc/ssh/sshd_config`
	if [ "$default" == "$output" ]
	then
		echo "$(date +%r) Compliance status:Yes " "9.3.10 /ssh/sshd_config-X11Forwarding(Envi option) " >>$file1
	else
		echo "$(date +%r) Compliance status:Yes " "9.3.10 /ssh/sshd_config-X11Forwarding(Envi option) " >>$file1
	fi
else
	echo "No Row is returned"
fi

echo "****************************************************************************"

echo "9.4 Restrict root Login to System Console"

echo "****************************************************************************"
echo "9.5 Restrict Access to the su Command"

echo "****************************************************************************"
echo "10.1.1 Set Password Expiration Days"
count=`grep "^PASS_MAX_DAYS" /etc/login.defs | wc -l`

if [ "$count" != 0 ]
then
	
	default="PASS_MAX_DAYS 90" #`grep "^PASS_MAX_DAYS" /etc/login.defs |  cut -f 2`
	output=`grep PASS_MAX_DAYS /etc/login.defs | tail -n +2`  #Two lines of output, omitting first line

	if [ "$default" == "$output" ]
	then
		echo "$(date +%r) Compliance status:Yes " "10.1.1 Password Expire Days " >>$file1
	else
		echo "$(date +%r) Compliance status:No " "10.1.1 Password Expire Days "  >>$file1
	fi
else
	echo "No Row is returned"
fi

echo "****************************************************************************"

echo "10.1.2 Set Password Change Minimum Number of Days"

count=`grep "^PASS_MIN_DAYS" /etc/login.defs | wc -l`

if [ "$count" != 0 ]
then
	default="PASS_MIN_DAYS 7"
	output=`grep PASS_MIN_DAYS /etc/login.defs | tail -n +2`

	if [ "$default" == "$output" ]
	then
		echo "$(date +%r) Compliance status:Yes " "10.1.2 Password Change Days " >>$file1
	else
		echo "$(date +%r) Compliance status:No " "10.1.2 Password Change Days "  >>$file1
	fi
else
	echo "No Row is returned"
fi

echo "****************************************************************************"

echo "10.1.3 Set Password Expiring Warning Days"

count=`grep "^PASS_WARN_DAYS" /etc/login.defs | wc -l`

if [ "$count" != 0 ]
then
	default="PASS_WARN_DAYS 7"
	output=`grep PASS_MIN_DAYS /etc/login.defs | tail -n +2`

	if [ "$default" == "$output" ]
	then
		echo "$(date +%r) Compliance status:Yes " "10.1.2 Password Expire Warning " >>$file1
	else
		echo "$(date +%r) Compliance status:No " "10.1.2 Password Expire Warning "  >>$file1
	fi
else
	echo "No Row is returned"
fi

echo "****************************************************************************"

echo "10.3 Set Default Group for root Account"

grep "^root:" /etc/passwd | cut -f4 -d:

VARIABLE=`grep "^root:" /etc/passwd | cut -f4 -d:`
if [ "$VARIABLE" -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "10.1.2 Grp for Root " >>$file1
else
	echo "$(date +%r) Compliance status:Yes " "10.1.2 Grp for Root " >>$file1
fi

echo "****************************************************************************"

echo "10.4 Set Default umask for Users"

echo "****************************************************************************"

echo "10.5 Lock Inactive User Accounts"

useradd -D | grep INACTIVE

VARIABLE=`useradd -D | grep INACTIVE | cut -d "=" -f 2`

if [ "$VARIABLE" -le 0 ]
then
	echo "$(date +%r) Compliance status:Yes " "10.5 Inactive Users" >>$file1
else
	echo "$(date +%r) Compliance status:No " "10.5 Inactive Users"  >>$file1
fi

echo "****************************************************************************"

echo "11.1 Set Warning Banner for Standard Login Services"

fileX=/etc/issue
fileY=/etc/motd
fileZ=/etc/issue.net

if [[ -e "$fileX" && -e "$fileY" && -e "$fileZ" ]]
then
	echo "$(date +%r) Compliance status:Yes " "11.1 Banner /etc/issue" >>$file1
else
	echo "$(date +%r) Compliance status:No " "11.1 Banner /etc/issue"  >>$file1
fi
 
echo "****************************************************************************"

echo "11.3 Set Graphical Warning Banner"

grep banner-message /etc/gdm3/greeter.dconf-defaults

#count=`grep banner-message /etc/gdm3/greeter.dconf-defaults | wc -l`
VARIABLE=$(grep banner-message /etc/gdm3/greeter.dconf-defaults)

if [[ $VARIABLE != ^# ]]
then
	echo "$(date +%r) Compliance status:Yes " "11.3 Banner Warning Graphical" >>$file1
else
	echo "$(date +%r) Compliance status:No " "11.3 Banner Warning Graphical"  >>$file1
fi 

echo "****************************************************************************"

echo "12.1 Verify Permissions on /etc/passwd"
#set -x
#/bin/ls -l /etc/passwd

default=$(ls -l /etc/passwd)
VARIABLE=$(ls -l /etc/passwd | grep "^.rw.r..r..")


if [ "$VARIABLE" == "$default" ]
then
	echo "$(date +%r) Compliance status:Yes" "12.1 /etc/passwd permission" >>$file1
else
	echo "$(date +%r) Compliance status:No" "12.1 /etc/passwd permission"  >>$file1
fi

echo "****************************************************************************"

echo "12.2 Verify Permissions on /etc/shadow"
#set -x
#/bin/ls -l /etc/shadow

default=$(ls -l /etc/shadow)
VARIABLE=$(ls -l /etc/shadow | grep "^.rw.r.....")


if [ "$VARIABLE" == "$default" ]
then
	echo "$(date +%r) Compliance status:Yes" "12.1 /etc/shadow permission" >>$file1
else
	echo "$(date +%r) Compliance status:No" "12.1 /etc/shadow permission"  >>$file1
fi

echo "****************************************************************************"

echo "12.3 Verify Permissions on /etc/group"
#set -x
#/bin/ls -l /etc/group

default=$(ls -l /etc/group)
VARIABLE=$(ls -l /etc/group | grep "^.rw.r..r..")


if [ "$VARIABLE" == "$default" ]
then
	echo "$(date +%r) Compliance status:Yes" "12.3 /etc/group permission" >>$file1
else
	echo "$(date +%r) Compliance status:No" "12.3 /etc/group permission"  >>$file1
fi

echo "****************************************************************************"


echo "12.4 Verify User/Group Ownership on /etc/passwd"

default_user="root"
default_group="root"
user=$(/bin/ls -l /etc/passwd | cut -d ' ' -f3)
group=$(/bin/ls -l /etc/passwd | cut -d ' ' -f4)
#echo "user:"$user
#echo "group:"$group

if [[ "$default_user" == "$user" && "$default_group" == "$group" ]]
then
	echo "$(date +%r) Compliance status:Yes" "12.4 verify /etc/passwd user+group" >>$file1
else
	echo "$(date +%r) Compliance status:No" "12.4 verify /etc/passwd user+group"  >>$file1
fi

echo "****************************************************************************"

echo "12.5 Verify User/Group Ownership on /etc/shadow"

default_user="root"
default_group="shadow"
user=$(/bin/ls -l /etc/shadow | cut -d ' ' -f3)
group=$(/bin/ls -l /etc/shadow | cut -d ' ' -f4)
#echo "user:"$user
#echo "group:"$group

if [[ "$default_user" == "$user" && "$default_group" == "$group" ]]
then
	echo "$(date +%r) Compliance status:Yes" "12.5 verify /etc/shadow user+group" >>$file1
else
	echo "$(date +%r) Compliance status:No" "12.5 verify /etc/shadow user+group"  >>$file1
fi

echo "****************************************************************************"

echo "12.6 Verify User/Group Ownership on /etc/group"

default_user="root"
default_group="root"
user=$(/bin/ls -l /etc/group | cut -d ' ' -f3)
group=$(/bin/ls -l /etc/group | cut -d ' ' -f4)
#echo "user:"$user
#echo "group:"$group

if [[ "$default_user" == "$user" && "$default_group" == "$group" ]]
then
	echo "$(date +%r) Compliance status:Yes" "12.6 verify /etc/group user+group" >>$file1
else
	echo "$(date +%r) Compliance status:No" "12.5 verify /etc/group user+group"  >>$file1
fi

echo "****************************************************************************"

echo "13.1 Ensure Password Fields are Not Empty"

echo "****************************************************************************"

echo "13.2 Verify No Legacy "+" Entries Exist in /etc/passwd File"
/bin/grep '^+:' /etc/passwd

count=`/bin/grep '^+:' /etc/passwd | wc -l`

if [ $count -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "13.2 No Legacy Entry /etc/passwd" >>$file1
else
	echo "$(date +%r) Compliance status:No" "13.2 No Legacy Entry /etc/passwd" >>$file1
fi

echo "****************************************************************************"

echo "13.3 Verify No Legacy "+" Entries Exist in /etc/shadow File"

/bin/grep '^+:' /etc/shadow
count=`/bin/grep '^+:' /etc/shadow | wc -l`
if [ $count -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "13.3 No Legacy Entry /etc/shadow" >>$file1
else
	echo "$(date +%r) Compliance status:No" "13.3 No Legacy Entry /etc/shadow" >>$file1	
fi

echo "****************************************************************************"

echo "13.4 Verify No Legacy "+" Entries Exist in /etc/group File"

/bin/grep '^+:' /etc/group
count=`/bin/grep '^+:' /etc/group | wc -l`

if [ $count -eq 0 ]
then
	echo "$(date +%r) Compliance status:Yes" "13.4 No Legacy Entry /etc/group" >>$file1
else
	echo "$(date +%r) Compliance status:No" "13.4 No Legacy Entry /etc/group" >>$file1
fi

echo "****************************************************************************"

echo "Verify No UID 0 Accounts Exist Other Than root"

/bin/cat /etc/passwd | /usr/bin/awk -F: '($3 == 0) { print $1 }'
VARIABLE=$(/bin/cat /etc/passwd | /usr/bin/awk -F: '($3 == 0) { print $1 }')

if [ "$VARIABLE" == "root" ]
then
	echo "$(date +%r) Compliance status:Yes" "13.5 UID 0 only" >>$file1	
else
	echo "$(date +%r) Compliance status:No" "13.5 UID 0 only"  >>$file1
fi

echo "****************************************************************************"
	
