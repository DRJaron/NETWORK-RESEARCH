#!/bin/bash
#STUDANT NAME: SHAGALOV YARON CODE:S12
#CLASS CODE: 7736/20
#LECTURER: SEGEV EREL

HOME=$(pwd)

#This start function checking if there exist a directory, and if not its creating a new one.
function START()
{

if [ -d "$HOME/scann" ]

	then 
		APPS
		
	else 
		$(mkdir $HOME/scann)
		START
fi

	
}

#The apps function checking if geoip and sshpass installed on the system, if not it will install the apps.
function APPS()
{

	REQUIRED_APPS=("sshpass" "nmap" "whois" "geoip-bin")

	for app in "${REQUIRED_APPS[@]}"; do
		if ! command -v "$app" > /dev/null 2>&1; then
			echo "Installing $app..."
			sudo apt-get install -y "$app" > /dev/null 2>&1
		else
			echo "[#]$app is already installed."
		fi
	done
	CHECK
}

#This function checking if nipe installed, if not it will install nipe.
function CHECK()
{
	
if [ -d "$HOME/scann/nipe" ]

	then 
	
		echo "[#]nipe is installed, continuing..."
		NIPE
		
	else
	
		echo "nipe is not installed"
		sleep 0.5
		echo "installing nipe..."
		cd $HOME/scann || exit 1
		sudo git clone https://github.com/htrgouvea/nipe  > /dev/null 2>&1
		cd nipe || exit 1
		sudo cpan install Try::Tiny Config::Simple JSON > /dev/null 2>&1
		sudo perl nipe.pl install > /dev/null 2>&1
		
		CHECK
fi
}

#This function starting the nipe service and checking if we are anonymous it showing the ip and the country location, if not it restarting nipe until there are a secure conection.
function NIPE()
{
		cd $HOME/scann/nipe 
	
		
NIP=$( sudo perl nipe.pl start | sudo perl nipe.pl status | curl -s icanhazip.com )
LOCATION=$(geoiplookup $NIP | awk '{ print $4 , $5 }' )
		 
		if [ "$LOCATION" == "IL, Israel" ]
			then
			echo "you are not anonymous! restarting nipe"
			cd $HOME/scann/nipe
			sudo perl nipe.pl restart
		
			NIPE
			
			else 
	
			echo "you are anonymous!"
			echo "your spoofed country is: $LOCATION"
			echo "your ip is:$NIP"
		
			NMAP
		
fi
}	

#This function is scanning the remote machine and check for open ports.
function NMAP()
{	
echo "Please input targets IP to start scanning:" 
read -r NMAPIP
	
	if [ -d "$HOME/scann/$NMAPIP" ]
		then
			echo "directory exist...."
			cd $HOME/scann/$NMAPIP
			nmap -vvv -sT -sV $NMAPIP >> $NMAPIP.nmap
			echo "scanning... pleas wait "
			sleep 0.5
			echo "scanning complited!" $NMAPIP.nmap "created"
		else 
			echo "directory does not exist... creating directory.."
			mkdir $HOME/scann/$NMAPIP && cd $HOME/scann/$NMAPIP
			echo "directory $NMAPIP created"
			nmap -vvv -sT -sV $NMAPIP >> $NMAPIP.nmap
			echo "scanning... pleas wait "
			sleep 0.5
			echo "scanning complited!" $NMAPIP.nmap "created"
	fi
	SSHPASS
}

#This function using the SSHPASS to connect the remote machine when its done it's copy the second script that update and install all the needed apps and making the machine anonymous, then its scann the target, copying the created files back to the local machine and deleting all the evidences.

function SSHPASS()
{
	echo "enter your remote IP:"
	read -r remoteip
	
	echo "enter  username:" 
	read -r username
	
	echo "enter password:"
	read -s password
	
	echo "enter your target IP:" 
	read -r IPT

			
sshpass -p "$password" scp "/home/kali/Desktop/scripts/projectscann.sh" "$username@$remoteip:/home/kali/Desktop/projectscann.sh"   
sshpass -p "$password" ssh "$username@$remoteip" "echo '$password' |sudo -S bash /home/kali/Desktop/projectscann.sh"
sshpass -p "$password" ssh "$username@$remoteip" "echo '$IPT' >> /home/kali/Desktop/targetsip.txt"
sshpass -p "$password" ssh "$username@$remoteip" "sudo -S nmap -vvv -sT -sV $IPT >> /home/kali/Desktop/target.nmap"
sshpass -p "$password" ssh "$username@$remoteip" "whois $IPT >> /home/kali/Desktop/whois.txt"
sshpass -p "$password" scp "$username@$remoteip:/home/kali/Desktop/targetsip.txt" "/home/kali/Desktop/"
sshpass -p "$password" scp "$username@$remoteip:/home/kali/Desktop/target.nmap" "/home/kali/Desktop/"
sshpass -p "$password" scp "$username@$remoteip:/home/kali/Desktop/whois.txt" "/home/kali/Desktop/"
sshpass -p "$password" ssh "$username@$remoteip" "echo '$password' |sudo -S rm /home/kali/Desktop/targetsip.txt; rm /home/kali/Desktop/target.nmap ; rm /home/kali/Desktop/whois.txt "
sshpass -p "$password" ssh "$username@$remoteip" "echo '$password' | sudo -S rm -Rvf /home/kali/Desktop/projectscann.sh"

		cd $HOME/scann/nipe
		sudo perl nipe.pl stop
		
		echo "[#] nmap data on the target $IPT has been collected and saved to /home/kali/Desktop/target.nmap"
		echo "[#] whois data on the target $IPT has been collected and saved to /home/kali/Desktop/whois.txt"
		
		
}

figlet "REMOTE CONTROLLER"
START
