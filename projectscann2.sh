#!/bin/bash

HOME=$(pwd)





	echo "please enter your remoteip: "
	read $rip
	
	sshpass -p 'kali' ssh -t  kali@$rip bash projectscann.sh
	sshpass -p 'kali' ssh -t  kali@$rip "echo" remote server details :"geoiplookup ; curl -s ifconfig.me | awk '{print $4}'| sed 's/,//'; curl -s ifconfig.me ; echo ; uptime | awk '{print \$1, \$2, \$3}' | sed 's/,/ /g'"
	sshpass -p 'kali' ssh -t  kali@$rip ifconfig


