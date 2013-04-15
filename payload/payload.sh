#!/usr/bin/env bash
############################################################################
#                       COPYRIGHT t193r (2012)                             #
############################################################################
# This program is free software: you can redistribute it and/or modify     #
# it under the terms of the GNU General Public License as published by     #
# the Free Software Foundation, either version 3 of the License, or        #
# (at your option) any later version.                                      #
#                                                                          #
# This program is distributed in the hope that it will be useful,          #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# GNU General Public License for more details.                             #
#                                                                          #
# You should have received a copy of the GNU General Public License        #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.    #
############################################################################

### Variable ###
ver="0.1"
### End of Variable ###

### Functions ###

check_dependencies(){
	echo "Checking metasploit"
	if [ `dpkg -l | grep framework3 | awk {'print $1'}` == "ii" ]; then
		echo "Good.. You have metasploit installed.. :)"
	else
		echo "Damn... No metasploit found on your system :("
		echo "Install metasploit first, then execute this script again.."
		exit 0
	fi
}

check_privilege(){
	if [ `id | awk -F "=" {'print $2'} | awk -F "(" {'print $1'}` == "0" ]; then
		echo "Good.. You have root permission.."
	else
		echo "Damn.. Give me root permission!!"
		exit 0
	fi
}

to_do(){
	echo "What we do now? Choose a NUMBER!"
	echo "1. Build a payload"
	echo "2. Create metasploit listener"
	echo "3. Quit"
	echo ""
	read number_to_do
	if [[ $number_to_do == "1" ]]; then
		echo "Will build a payload..."
	elif [[ $number_to_do == "2" ]]; then
		echo "Will create metasploit listener..."
	elif [[ $number_to_do == "3" ]]; then
		echo "Exiting..."
		exit 0
	else
		echo "Please choose a valid NUMBER!!!"
	fi
}

configure(){
	echo "Let's take a few minutes to configure this script, so you won't get any error..."
	echo "Configure metasploit path..."
	echo "Where is your metasploit path?"
	echo "1. I don't know?"
	echo "2. /opt/metasploit/app"
	echo "3. /opt/metasploit/msf3"
	read number_metasploit_path
	if [[ $number_metasploit_path == "1" ]]; then
		echo "WTF man? Okay, no problem. I can do it for you..."
		echo "First.. Let's find msfconsole"
		sleep 1
		echo "There! Your msfconsole is found in `which msfconsole`"
		echo "Let's see this path..."
		sleep 1
		file `which msfconsole`
		echo "There! Your metasploit path is found in`ls -l $(which msfconsole) | awk -F "->" {'print $2'}`"
		sleep 1
		echo "Ok, I'll set this path to our Variable..."
		metasploit_path=`ls -l $(which msfconsole) | awk -F "->" {'print $2'}`
		echo "Done..."
	elif [[ $number_metasploit_path == "2" ]]; then
		echo "I will set metasploit path to /opt/metasploit/app"
		metasploit_path=/opt/metasploit/app
		sleep 1
		echo "Done..."
	elif [[ $number_metasploit_path == "3" ]]; then
		echo "I will set metasploit path to /opt/metasploit/msf3"
		metasploit_path=/opt/metasploit/msf3
		echo "Done..."
	else
		echo "Please choose a correct number!"
	fi
}

### End of Functions ###

echo "Payload builder $ver"
echo "Checking dependencies... This may take several minutes..."
sleep 1
check_dependencies
echo "Checking privileges..."
sleep 1
check_privilege
to_do
