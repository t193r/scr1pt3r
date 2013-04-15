#!/bin/bash
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

case $1 in
    --weefee|-w) wifi;;
  --wordlist|-l) wordlist;;
    --update|-u) update;;
       --sec|-s) nakedsec;;
   --payload|-p) payload;;
     --rules|-r) rules;;
        --up|-u) echo "Updating ..."; git pull; exit 0;;
esac

trap quit INT

wifi() {
  clear
  bash weefee/weefee.sh
}

payload() {
  clear
  bash payload/payload.sh
}

update() {
  clear
  bash trigger/trigger.sh
}

wordlist() {
  clear
  bash deectee/deectee.sh
}

nakedsec() {
  clear
  bash nakedsec/nakedsec.sh
}

payload() {
  clear
  bash payload/payload.sh
}

rules() {
  clear
  bash icewall/icewall.sh
}

quit() {
  if [ -e "index.html" ]; then
    rm -f index.html
  fi
  echo -e "Bye bye (="
  exit 0
}

while : ; do
   clear
   cat << BANNER
========================================
-- [C]rack or DoS an Access Point
-- [U]pdate persenjataan hacking
-- Membuat atau memodifikasi [W]ordlist
-- Check [S]ecurity
-- [P]ayload builder
-- iptables [R]ules
-- [./t193r.sh --up] update script ini
========================================
BANNER
   echo -n "       [Untuk keluar, pilih \"X\"]
========================================
What do you want today? "
   read choice
   case $choice in
      C|c) wifi ;;
      U|u) update ;;
      W|w) wordlist ;;
      S|s) nakedsec ;;
      P|p) payload ;;
      R|r) rules ;;
      X|x) quit ;;
      *) echo "Input error -> $choice! Coba lagi! Pilihan yang memungkinkan adalah C-U-W-S-X-R.
Skrip ini tidak case-sensitive"; sleep 2 ;;
   esac
done
