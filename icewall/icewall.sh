#!/usr/bin/env bash
############################################################################
#                       COPYRIGHT t193r (2013)                             #
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


# Global variable
ver="1.4.18"
defaultDir=$(pwd)
distribution=$(lsb_release -i | awk '{print $3}')
workingDir=$(pwd | awk -F/ '{print $NF}')
url="http://www.netfilter.org/projects/iptables/files/iptables-1.4.18.tar.bz2"
controlDir="/etc/iptables"

if [[ "$distribution" == "Debian" ]]; then
	iptRepo=$(apt-cache show iptables | grep Version | awk '{print $2}' | sed 's/-.*$//g')
elif [[ "$distribution" == "arch" ]]; then
	iptRepo=$(pacman -Ss iptables | grep core | awk '{print $2}' | sed 's/-.*$//g')
else
	iptRepo="NaN"
fi

cin() {
	if [ "$1" == "action" ] ; then output="\e[01;32m[>]\e[00m" ; fi
	if [ "$1" == "info" ] ; then output="\e[01;33m[i]\e[00m" ; fi
	if [ "$1" == "error" ] ; then output="\e[01;31m[!]\e[00m" ; fi
	output="$output $2"
	echo -en "$output"
}

cout() {
	if [ "$1" == "action" ] ; then output="\e[01;32m[>]\e[00m" ; fi
	if [ "$1" == "info" ] ; then output="\e[01;33m[i]\e[00m" ; fi
	if [ "$1" == "error" ] ; then output="\e[01;31m[!]\e[00m" ; fi
	output="$output $2"
	echo -e "$output"
}

getSource() {
	cout action "Creating 'app' directory on home directory"
	mkdir ~/app
	cout action "Changing directory"
	cd ~/app
	cout action "Getting source from $url"
	wget $url -O iptables.tar.bz2
	cout action "Extracting source"
	tar jxpf iptables.tar.bz2
	cout action "Changing directory to source directory"
	cd iptables*
	cout action "Configuring..."
	./configure
	cout action "Building iptables..."
	make
	cout action "Installing"
	make install
	cout action "Getting back to default directory"
	cd $defaultDir
}

promptInstall() {
	loop="true"
	while [[ "$loop" == "true" ]]; do
		cin error "Cannot find your spesific distribution. Do you want to install iptables from source? [Y/n]"
		read choice
		if [[ "$choice" == "" ]] || [[ "$choice" == *[Yy]* ]]; then
			getSource
		elif [[ "$choice" == *[Nn]* ]]; then
			cout error "Not installing iptables. Aborting..."
			exit 0
		fi
	done
}

getPackage() {
	checkConnection
	if [[ $iptRepo == "$ver" ]]; then
		if [[ "$distribution" == "Debian" ]]; then
			apt-get install iptables --yes
		elif [[ "$distribution" == "arch" ]]; then
			pacman --sync iptables --noconfirm
		else
			promptInstall
		fi
	else
		promptInstall
	fi
}

checkConnection() {
	/usr/bin/env wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null
	if [ ! -s /tmp/index.google ];then
		cout info "There's connection. It's OK for now."
		rm /tmp/index.google
	else
		cout error "There's no connection. Aborting..."
		exit 2
	fi
}

# Program running
if command -v iptables > /dev/null 2>&1 ; then
	cout info "iptables installed"
else
	cout error "iptables not installed"
	getPackage
fi

if [ ! -d "$controlDir" ]; then
	cout info "Contol directory is not exist. Creating control directory."
  	mkdir $controlDir
fi

if [[ "$workingDir" == "icewall" ]]; then
	cout action "Copying configuration"
	cp ../tools/*.rules $controlDir
elif [[ "$workingDir" == "t193r" ]]; then
	cout action "Copying configuration"
	cp tools/*.rules $controlDir
else
	cout error "Error. Did you run this script stand alone? Then you must be moron!"
	cout info "Please run from scr1pt3r.sh script or 'cd /path/to/icewall/icewall && bash icewall.sh'"
	exit 2
fi

cout action "Flushing rules before restoring our rules..."
iptables-restore < $controlDir/empty.rules
iptables --flush
cout info "Done"
sleep 1
cout action "Restoring iptables..."
iptables-restore < $controlDir/iptables.rules
cout info "Done"
cout action "Checking iptables"
iptables -L | head -n 10
echo "[... snip ...]"
cin info "Please ENTER to continue..."
read ret
cout info "The script end gracefully, now you're safe"
cout info "Script by blusp10it, rules by blusp10it, made by love and respect for t193r team"
cout info "If you have a problem or bugs, please send a bugs report on github"
cout info "PM or comment on facebook group will not be accepted"
cout info "Regards: t193r team"
cout info "Are..."
sleep 1
cout info " you..."
sleep 1
cout info "   blusp10it???"
exit 0
