Remote Control


Description:

The project involves two scripts that automate specific tasks on a remote machine.

Scripts Overview:

Script 1: Remotcontroller.sh

Function: Checks if the required software is installed on the machine and installs them if missing.

Required Software:

sshpass

Nipe

geoiplookup

Nmap

Whois

Process:

Checks if the machine is updated.

Installs missing software.

Tests for anonymous network connectivity using Nipe.

If anonymity is confirmed, it displays the current IP address and country.

If the connection is not anonymous, the system reboots and rechecks the connection.

Script 2: projectscann.sh

Function: Scans a remote machine for open ports.

Process:

The user is prompted to enter the remote machine’s IP address.

The script establishes an automatic SSH connection using sshpass.

The second script is transferred to the remote machine and executed.

It scans using tools like Nmap and Whois.

Generated files are transferred back to the personal machine.

The scripts and files on the remote machine are deleted to ensure no traces remain.
