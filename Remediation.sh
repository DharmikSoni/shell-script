#!/bin/bash

#CIS security Audit script
#Author: Dharmik Soni

echo -e "\t\t\t\t\t\t\t**************************************************"
echo -e "\t\t\t\t\t\t\t*\t\tCIS Security Remediation script\t *"			
echo -e "\t\t\t\t\t\t\t*\t\t    Debian 9 Stretch\t\t *"  

echo -e "\t\t\t\t\t\t\t**************************************************"

#cis_compliance file
com="/home/osboxes/Desktop/cis_compliance.txt"

#Output Files
exec > >(tee "/home/osboxes/Desktop/remedy_report.txt") 2>&1
remedy="/home/osboxes/Desktop/remedy_sf.txt"


#Compliance file
#input="/home/osboxes/Desktop/cis_compliance.txt"

#Remediation code

echo "Enter fileName: "
read fileName

clear

while :
do 	
	echo "1. Patching and Software Updates"
	echo "2. FileSystem Configuration"
	echo "3. Secure Boot Setting"
	echo "4. Additional Process Hardening"
	echo "5. Os Services"
	echo "6. Special Purpose Services"
	echo "7. Network Configuration and Firewalls"
	echo "8. Logging and Auditing"
	echo "9. System Access, Authentication and Authorization"
	echo "10. User Accounts and Environment"
	echo "11. Warning Banners"
	echo "12. Verify System File Permissions"
	echo "13. Review User and Group Settings"
	
	echo -e "\tEnter Root Choice: "
	read root
	case $root in	
		1) 
		echo -e "\t1.1 Install Updates, Patches, Additional Security Software"
		sudo apt-get update
		;;
		2)
		echo -e "\t2.1 Create Separate Partition for /tmp"
		echo -e "\t2.5 Create Separate Partition for /var"
		echo -e "\t2.7 Create Separate Partition for /var/log"
		echo -e "\t2.9 Create Separate Partition for /home"
		echo -e "\t2.18 Disable Mounting of cramfs FileSystems"	
		echo -e "\tEnter choice in 2"
		read sub2
		fline=`cat cis_compliance.txt | grep " $sub2 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub2 in
			2.1)
			if [ $fline == "No" ]
			then
				echo "$count"
				sudo systemctl enable tmp.mount
			else
				echo "$count"
				echo "Remedy already applied"
			fi
			;;
			
		#	2.5)
			
		#	;;
		#	2.7)
			
		#	;;
		#	2.9)
			
		#	;;
		#	2.18)
		esac
		;;
		
		3)
		echo -e "\t3.1 Set User/Group Owner on bootloader config"
		echo -e "\t3.2 Set Permission on bootloader config"
		echo -e "\t3.4 Require Authentication for Single-User-Mode"
		echo -e "\tEnter choice in 3"
		read sub3
		fline=`cat cis_compliance.txt | grep " $sub3 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub3 in
			3.1)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo chown root:root /boot/grub/grub.cfg
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			3.2)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo chmod og-rwx /boot/grub/grub.cfg
				elif [ $fline == "Yes"]
				then 
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			3.4)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo passwd root
				elif [ $fline == "Yes" ]
				then 
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi			
			;;
		esac
		;;	
		4)
		echo -e "\t4.1 Restrict Core Dumps"
		echo -e "\t4.4 Disable Prelink"
		echo -e "\tEnter choice in 4"
		read sub4
		fline=`cat cis_compliance.txt | grep " $sub4 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub4 in
			4.1)
			if [ $fline ]
			then
				add_in_limit="*\t\thard\t core\t\t 0"
				add_in_sysctl="fs.suid_dumpable = 0"
				if [ $fline == "No" ]
				then
					sudo echo -e "$add_in_limit" >> /etc/security/limits.conf
					sudo echo -e "$add_in_sysctl" >> /etc/sysctl.conf
				elif [ $fline == "Yes" ]
				then 
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			4.4)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo /usr/sbin/prelink -ua
					sudo apt-get purge prelink
				elif [ $fline == "Yes" ]
				then 
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi			
			;;
		esac
		;;
		5)
		echo -e "\t5.1 Ensure Legacy Service are Not Enabled"
		echo -e "\t5.4 Ensure echo is not enabled"
		echo -e "\t5.6 Ensure time is not enabled"
		echo -e "\tEnter choice in 5:"
		read sub5
		fline=`cat cis_compliance.txt | grep " $sub5 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub5 in
			5.1)
			echo -e "\t\t5.1.1 Ensure NIS is not Installed"
			echo -e "\t\t5.1.5 Ensure talk client is not installed"
			echo -e "\t\t5.1.6 Ensure telnet server is not enabled"
			echo -e "\t\t5.1.7 Ensure tftp-server is not enabled"
			echo -e "\tEnter choice in sub of 5:"
			read sub_sub_5
			fline=`cat cis_compliance.txt | grep "$sub_sub_5" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_5 in
				5.1.1)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo apt-get purge nis
					elif [ $fline == "Yes" ]
					then 
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi						
				;;
				5.1.5)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo apt-get purge talk
					elif [ $fline == "Yes" ]
					then 
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi											
				;;
				5.1.6)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo sed -e '/^telnet/s/^/#/g' -i /etc/inetd.conf					
					elif [ $fline == "Yes" ]
					then 
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi											
				;;
				5.1.7)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo sed -e '/^tftp/s/^/#/g' -i /etc/inetd.conf					
					elif [ $fline == "Yes" ]
					then 
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi											
				;;
			esac		
			;;
			5.4)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo sed -e '/^echo/s/^/#/g' -i /etc/inetd.conf					
				elif [ $fline == "Yes" ]
				then 
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi											
			;;
			5.6)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo sed -e '/^time/s/^/#/g' -i /etc/inetd.conf					
				elif [ $fline == "Yes" ]
				then 
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi														
			;;
		esac 
		;;
		6)
		echo -e "\t6.1 Ensure the X windows system is not installed"
		echo -e "\t6.3 Ensure print server is not enabled"
		echo -e "\t6.4 Ensure DHCP sever is not enabled"
		echo -e "\t6.5 Configure Network Time Protocol"
		echo -e "\t6.6 Ensure LDAP is not enabled"
		echo -e "\t6.9 Ensure FTP server is not enabled"
		echo -e "\t6.11 Ensure IMAP and POP server is not enabled"
		echo -e "\t6.15 Configure Mail Transfer Agent for Local-Only-Mode"
		echo -e "\tEnter choice in 6"
		read sub6	
		fline=`cat cis_compliance.txt | grep " $sub6 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub6 in
			6.1)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo apt-get purge xserver-xorg-core*
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			6.3)
			;;
			6.4)
			;;
			6.5)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo apt-get install ntp
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			6.6)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					echo "Remedy Applied"
				elif [ $fline == "Yes" ]
				then
					sudo apt-get purge slapd
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			6.9)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo systemctl disable vsftpd
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			6.11)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo systemctl disable dovecot
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			6.15)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					if grep -E "dc_local_interfaces='127.0.0.1 ; ::1" /etc/exim4/update-exim4.conf.conf
					then
						echo "Line Exists"						
					else	
						sudo echo -e "dc_local_interfaces='127.0.0.1 ; ::1" >> /etc/exim4/update-exim4.conf.conf
						sudo update-exim4.conf
						sudo service exim4 reload
					fi
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;	
		esac		
		;;
		7)
		echo -e "\t7.1 Modify Network Parameter(Host Only)"
		echo -e "\t7.2 Modify Network Parameter(Host and Router)"
		echo -e "\t7.3 Configure IPv6"
		echo -e "\t7.4 Install TCP Wrappers"
		echo -e "\t7.5 Uncommon Network Protocols"
		echo -e "\t7.6 Deactivate Wireless Interfaces"
		echo -e "\t7.7 Ensure Firewall is active"
		echo -e "\tEnter choice in 7"
		read sub7
		fline=`cat cis_compliance.txt | grep " $sub7 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub7 in
			7.1)
			echo -e "\tEnter choice in sub_sub_7.1"
			read sub_sub_7_1
			fline=`cat cis_compliance.txt | grep "$sub_sub_7_1" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_7_1 in
				7.1.1)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv4.ip_forward=0" >> /etc/sysctl.conf
						#modify active kernel parameter
						sudo /sbin/sysctl -w net.ipv4.ip_forward=0
						sudo /sbin/sysctl -w net.ipv4.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi		
				;;
				7.1.2)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
						sudo echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf
						#modify active kernel parameter
						sudo /sbin/sysctl -w net.ipv4.conf.all.send_redirects=0
						sudo /sbin/sysctl -w net.ipv4.conf.default.send_redirects=0
						sudo /sbin/sysctl -w net.ipv4.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi		
				;;
			esac
			;;
			7.2)
			echo -e "\tEnter choice in sub_sub_7.2"
			read sub_sub_7_2
			fline=`cat cis_compliance.txt | grep "$sub_sub_7_2" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_7_2 in
				7.2.2)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.conf
						sudo echo "net.ipv4.conf.default.send_redirects=0" >> /etc/sysctl.conf

						#modify kernel parameter
						sudo /sbin/sysctl -w net.ipv4.conf.all.accept_redirects=0
						sudo /sbin/sysctl -w net.ipv4.conf.default.accept_redirects=0
						sudo /sbin/sysctl -w net.ipv4.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi		
				;;	
				7.2.4)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv4.conf.all.log_martians=1" >> /etc/sysctl.conf
						sudo echo "net.ipv4.conf.default.log_martians=1" >> /etc/sysctl.conf

						#modify kernel parameter
						sudo /sbin/sysctl -w net.ipv4.conf.all.log_martians=1
						sudo /sbin/sysctl -w net.ipv4.conf.default.log_martians=1
						sudo /sbin/sysctl -w net.ipv4.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.2.5)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf

						#modify kernel parameter
						sudo /sbin/sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
						sudo /sbin/sysctl -w net.ipv4.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.2.6)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv4.icmp_ignore_bogus_error_responses=1" >> /etc/sysctl.conf

						#modify kernel parameter
						sudo /sbin/sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
						sudo /sbin/sysctl -w net.ipv4.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
			esac
			;;
			7.3)
			echo -e "\tEnter choice in sub_sub_7.3"
			read sub_sub_7_3
			fline=`cat cis_compliance.txt | grep "$sub_sub_7_3" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_7_3 in
				7.3.1)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv6.conf.all.accept_ra=0" >> /etc/sysctl.conf
						sudo echo "net.ipv6.conf.default.accept_ra=0" >> /etc/sysctl.conf

						#modify kernel parameter
						sudo /sbin/sysctl -w net.ipv6.conf.all.accept_ra=0
						sudo /sbin/sysctl -w net.ipv6.conf.default.accept_ra=0
						sudo /sbin/sysctl -w net.ipv6.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.3.2)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv6.conf.all.accept_redirects=0" >> /etc/sysctl.conf
						sudo echo "net.ipv6.conf.default.accept_redirects=0" >> /etc/sysctl.conf

						#modify kernel parameter
						sudo /sbin/sysctl -w net.ipv6.conf.all.accept_redirects=0
						sudo /sbin/sysctl -w net.ipv6.conf.default.accept_redirects=0
						sudo /sbin/sysctl -w net.ipv6.route.flush=1
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.3.3)	
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
						sudo echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
						sudo echo "net.ipv6.conf.lo.disable_ipv6=1" >> /etc/sysctl.conf
		
						#apply changes
						sudo sysctl -p

					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
			esac
			;;
			7.4)
			echo -e "\tEnter choice in sub_sub_7.4"
			read sub_sub_7_4
			fline=`cat cis_compliance.txt | grep "$sub_sub_7_4" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_7_4 in
				7.4.1)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo apt-get install tcpd
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.4.2)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "ALL:192.168.43.0/255.255.255.0, 192.168.0.108/255.255.255.0" >> /etc/hosts.allow
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.4.3)	
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo /bin/chmod 644 /etc/hosts.allow
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				7.4.4)
				if [ $fline ]
				then
					if [ $fline == "No" ]
					then
						sudo echo "ALL: ALL" >> /etc/hosts.deny
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
			esac
			;;
			7.5)
			echo -e "\tEnter choice in sub_sub_7.5"
			read sub_sub_7_5
			fline=`cat cis_compliance.txt | grep "$sub_sub_7_5" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_7_5 in
				7.5.1)
				;;
				7.5.3)
				;;
			esac
			;;
			7.6)
			;;
			7.7)
			if [ $fline ]
			then
				if [ $fline == "No" ]
				then
					sudo  apt-get install iptables iptables-persistent
					sudo update-rc.d netfilter-persistent enable
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;						
		esac
		;;
		8)
		echo -e "\t8.1 Configure System Accounting(audited)"
		echo -e "\t8.2 Configure Syslog"
		echo -e "\tEnter choice in 8"
		read sub8
		fline=`cat cis_compliance.txt | grep "$sub8" | cut -f4 -d " "| cut -d ":" -f2`
		case $sub8 in
			8.1)
			echo -e "\tEnter choice in 8.1"
			read sub_sub_8
			fline=`cat cis_compliance.txt | grep "$sub_sub_8" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_8 in
				8.1.1)
				echo -e "\tEnter choice in 8.1.1"
				read sub_sub_8_1_1
				fline=`cat cis_compliance.txt | grep "$sub_sub_8_1_1" | cut -f4 -d " "| cut -d ":" -f2`
				case $sub_sub_8_1_1 in
					8.1.1.1)
						
					;;
					8.1.1.2)
					;;
				esac		
				;;
				8.1.2)
				;;
				8.1.4)
				;;
				8.1.5)
				;;
				8.1.6)
				;;
				8.1.8)
				;;
				8.1.9)
				;;
				8.1.15)
				;;
				8.1.16)
				;;
			esac
			;;
			8.2)
			echo -e "\tEnter choice in 8.1"
			read sub_sub_8
			fline=`cat cis_compliance.txt | grep "$sub_sub_8" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_8 in
				8.2.1)
				;;
				8.2.2)
				;;
				8.2.3)
				;;
			esac
			;;
		esac
		;;
		9)
		echo -e "\t9.1 Configure Cron"
		echo -e "\t9.2 Configure PAM"		
		echo -e "\t9.3 Configure SSH"
		echo -e "\t9.4 Restrict root Login to System Console"
		echo -e "\t9.5 Restrict Access to the su command"
		;;
		10)
		echo -e "\t10.1 Set Shadow Password Suite Parameters(/etc/login.defs)"
		echo -e "\t10.3 Set Default Group for root Account"
		echo -e "\t10.4 Set Default umask for Users"
		echo -e "\t10.5 Lock Inactive User Account"	
		echo -e "\tEnter choice in 10"
		read sub10
		fline=`cat cis_compliance.txt | grep " $sub10 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub10 in
			10.1)
			echo -e "\tEnter choice in sub_sub_10"
			read sub_sub_10
			fline=`cat cis_compliance.txt | grep "$sub_sub_10" | cut -f4 -d " "| cut -d ":" -f2`
			case $sub_sub_10 in
				10.1.1)	
				if [ $fline ]			
				then
					if [ $fline == "No" ]
					then
						sudo awk '/PASS_MAX_DAYS/{$2=90}1;' file>/etc/login.defs
						sudo chage --maxdays 90 osboxes
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				10.1.2)
				if [ $fline ]			
				then
					if [ $fline == "No" ]
					then
						sudo awk '/PASS_MIN_DAYS/{$2=7}1;' file>/etc/login.defs
						sudo chage --mindays 7 osboxes
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
				10.1.3)
				if [ $fline ]			
				then
					if [ $fline == "No" ]
					then
						sudo awk '/PASS_WARN_AGE/{$2=7}1;' file>/etc/login.defs
						sudo chage --warndays 7 osboxes
					elif [ $fline == "Yes" ]
					then
						echo "Remedy Applied"
					fi
				else
					echo "Details in File Not Found!"
				fi
				;;
		esac	
		;;	
			10.3)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo usermod -g 0 root
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			10.4)
			;;
			10.5)
			if [ $fline ]			
			then
				VAR=`sudo useradd -D | grep INACTIVE | cut -d "=" -f 2`
				if [ $fline == "No" ]
				then
					sudo useradd -D -f $VAR
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
		esac
		;;
		11)
		echo -e "\t11.1 Set Warning Banner for Standard Login Services"
		echo -e "\t11.3 Set Graphical Warning Banner"
		echo -e "\tEnter choice in 11"
		read sub11
		fline=`cat cis_compliance.txt | grep " $sub11 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub11 in
			11.1)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /home/osboxes/Desktop/11.1.sh
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			11.3)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					echo > "banner-message-enable=true" /etc/gdm3/greeter.dconf-defaults
					echo > "banner-message-text='<banner-text>'" /etc/gdm3/greeter.dconf-defaults
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;			
		esac	
		;;
		12)
		echo -e "\t12.1 Verify Permission on /etc/passwd"
		echo -e "\t12.2 Verify Permission on /etc/shadow"
		echo -e "\t12.3 Verify Permission on /etc/group"
		echo -e "\t12.4 Verify User/Group Ownership on /etc/passwd"
		echo -e "\t12.5 Verify User/Group Ownership on /etc/shadow"
		echo -e "\t12.6 Verify User/Group Ownership on /etc/group"
		echo -e "\tEnter choice in 12"
		read sub12
		fline=`cat cis_compliance.txt | grep " $sub12 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub12 in
			12.1)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /bin/chmod 644 /etc/passwd
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			12.2)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /bin/chmod 640 /etc/shadow
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			12.3)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /bin/chmod 644 /etc/group
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			12.4)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /bin/chown root:root /etc/passwd
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			12.5)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /bin/chown root:shadow /etc/shadow
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			12.6)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /bin/chown root:root /etc/group
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
		esac
		;;	
		13)
		echo -e "\t13.1 Ensure Password	Fields are Not Empty"
		echo -e "\t13.2 Verify No Legacy "+" Entries Exist in /etc/passwd File"
		echo -e "\t13.3 Verify No Legacy "+" Entries Exist in /etc/shadow File"
		echo -e "\t13.4 Verify No Legacy "+" Entries Exist in /etc/group File"
		echo -e "\t13.5 Verify No UID 0 Accounts Exist Other Than root"
		echo -e "\tEnter choice in 13"
		read sub13
		fline=`cat cis_compliance.txt | grep " $sub13 " | cut -f4 -d " "| cut -d ":" -f2`
		case $sub13 in
			13.1)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo /usr/bin/passwd -l $USER
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi
			;;
			13.2)
			if [ $fline ]			
			then
				if [ $fline == "No" ]
				then
					sudo 
				elif [ $fline == "Yes" ]
				then
					echo "Remedy Applied"
				fi
			else
				echo "Details in File Not Found!"
			fi			
			;;
			13.3)
			;;
			13.4)
			;;
			13.5)
			;;
		esac
		;;
		*)
		echo -e "\t***Please Enter a Appropriate Choice***"
		;;
	esac	
done
