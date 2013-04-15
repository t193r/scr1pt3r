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

trap keluar INT

#------------------------------Tampil Pesan------------------------------#
tampil () {
   keluaran=""
   if [ "$1" == "aksi" ] ; then keluaran="\e[01;32m[>]\e[00m" ; fi
   if [ "$1" == "inform" ] ; then keluaran="\e[01;33m[i]\e[00m" ; fi
   if [ "$1" == "error" ] ; then keluaran="\e[01;31m[!]\e[00m" ; fi
   if [ "$1" == "peringatan" ] ; then keluaran="\e[01;34m[W]\e[00m" ; fi
   keluaran="$keluaran $2"
   echo -e "$keluaran"
   return 0
}

#------------------------------Keluar------------------------------#
keluar () {
   index=( $(pwd) )
   tampil aksi "Membersihkan testping..."
   rm -f /tmp/testping > /dev/null
   tampil aksi "Membersihkan index.html..."
   rm -f $index/index.html* > /dev/null
   rm -f index.html* > /dev/null
   tampil inform "Are you blusp10it?"
   exit
}

#------------------------------Cek------------------------------#
cek () {
#------------------------------Cek Koneksi------------------------------#
   if [ "$1" == "koneksi" ] ; then
      internet=""
      index=( $(pwd) )
      tampil aksi "Cek koneksi..."
      if [ -e $pwd/index.html ] ; then rm -f $pwd/index.html* > /dev/null ; fi
      wget -nv "http://www.google.com" -o /tmp/testping
      command=( $(cat /tmp/testping | grep -w 'index.html') )
      if [ "$command" == "" ] ; then
         internet="false"
         tampil peringatan "Kamu tidak terkoneksi dengan internet"
      else
         internet="true"
         tampil inform "Kamu memiliki koneksi internet!"
      fi
#------------------------------Cek Metasploit------------------------------#
   elif [ "$1" == "metasploit" ] ; then
      tampil aksi "Mengecek Metasploit Framework"
      if [ -d "/opt/framework/" ] ; then
         missMsf="false"
      elif [ -d "/opt/metasploit/" ] ; then
         missMsf="false"
      else
         missMsf="true"
      fi
#------------------------------Cek W3af------------------------------#
   elif [ "$1" == "w3af" ] ; then
      missW3af=""
      w3afDir="/pentest/web/w3af/"
      tampil aksi "Mengecek W3af"
      if [ -d "$w3afDir" ] ; then
         missW3af="false"
         tampil inform "Direktori W3af = '$w3afDir'"
      else
         missW3af="true"
      fi
#------------------------------Cek ExploitDB------------------------------#
   elif [ "$1" == "exploitdb" ] ; then
      missExdb=""
      tampil aksi "Mengecek Exploit DB"
      exdbDir="/pentest/exploits/exploitdb/"
      if [ -d "$exdbDir" ] ; then
         missExdb="false"
         tampil inform "Direktori Exploit DB = '$exdbDir'"
      else
         missExdb="true"
      fi
#------------------------------Cek SET------------------------------#
   elif [ "$1" == "SET" ] ; then
      missSet=""
      dirSet=""
      setdir="/pentest/exploits/set/"
      SETdir="/pentest/exploits/SET/"
      tampil aksi "Mengecek SET"
      if [ -d "$setdir" ] ; then
         missSet="false"
         dirSet="$setdir"
         tampil inform "Direktori SET = '$dirSet'"
      elif [ -d "$SETdir" ] ; then
         missSet="false"
         dirSet="$SETdir"
         tampil inform "Direktori SET = '$dirSet'"
      else
         missSet="true"
      fi
#------------------------------Cek WPScan------------------------------#
   elif [ "$1" == "wpscan" ] ; then
      tampil aksi "Mengecek WPScan"
      tampil inform "Direktori WPScan = /pentest/web/wpscan"
#------------------------------Cek SQLMap------------------------------#
   elif [ "$1" == "sqlmap" ] ; then
      missSqlmap=""
      dirSqlmap=""
      sqlmapDir="/pentest/database/sqlmap/"
      tampil aksi "Mengecek SQLMap"
      if [ -d "$sqlmapDir" ] ; then
         missSqlmap="false"
         dirSqlmap="$sqlmapDir"
         tampil inform "Direktori SQLMap = '$dirSqlmap'"
      else
         missSqlmap="true"
      fi
   fi
}

#------------------------------Install------------------------------#
grab () {
#------------------------------Install Metasploit------------------------------#
   if [ "$1" == "metasploit" ] ; then
      loop="true"
      while [ "$loop" != "false" ] ; do
         echo -en "[?] Apakah kamu mau menginstall Metasploit? [y/n] "
         read keputusan
         if [ "$keputusan" == "y" ] || [ "$keputusan" == "Y" ] ; then
            tampil aksi "Menginstall Metasploit Framework..."
            apt-get install framework --yes
            tampil inform "Done"
            loop="false"
            l00p="true"
            while [ "$l00p" != "true" ] ; do
               echo -en "[?] Apakah kamu mau melakukan update? [y/n] "
               read choice
               if [ "$choice" == "y" ] || [ "$choice" == "Y" ] ; then
                  update metasploit
                  l00p="false"
               elif [ "$choice" == "n" ] || [ "$choice" == "N" ] ; then
                  l00p="false"
               else
                  tampil error "Bad input"
               fi
               done
         elif [ "$keputusan" == "n" ] || [ "$keputusan" == "N" ] ; then
            loop="false"
         else
            tampil error "Pilihan tidak valid [$keputusan]"
            loop="true"
         fi
      done
#------------------------------Install W3af------------------------------#
   elif [ "$1" == "w3af" ] ; then
      loop="true"
      while [ "$loop" != "false" ] ; do
         echo -en "[?] Apakah kamu mau menginstall w3af? [y/n] "
         read keputusan
         if [ "$keputusan" == "y" ] || [ "$keputusan" == "Y" ] ; then
            tampil aksi "Menginstall W3af..."
            apt-get install w3af --yes
            tampil inform "Done"
            loop="false"
            l00p="true"
            while [ "$l00p" != "true" ] ; do
               echo -en "[?] Apakah kamu mau melakukan update? [y/n] "
               read choice
               if [ "$choice" == "y" ] || [ "$choice" == "Y" ] ; then
                  update w3af
                  l00p="false"
               elif [ "$choice" == "n" ] || [ "$choice" == "N" ] ; then
                  l00p="false"
               else
                  tampil error "Bad input"
               fi
            done
         elif [ "$keputusan" == "n" ] || [ "$keputusan" == "N" ] ; then
            loop="false"
         else
            tampil error "Pilihan tidak valid [$keputusan]"
            loop="true"
         fi
      done
#------------------------------Install ExploitDB------------------------------#
   elif [ "$1" == "exploitdb" ] ; then
      loop="true"
      while [ "$loop" != "false" ] ; do
         echo -en "[?] Apakah kamu mau menginstall ExploitDB? [y/n] "
         read keputusan
         if [ "$keputusan" == "y" ] || [ "$keputusan" == "Y" ] ; then
            tampil aksi "Menginstall ExploitDB..."
            apt-get install exploitdb --yes
            tampil inform "Done"
            loop="false"
            l00p="true"
            while [ "$l00p" != "true" ] ; do
               echo -en "[?] Apakah kamu mau melakukan update? [y/n] "
               read choice
               if [ "$choice" == "y" ] || [ "$choice" == "Y" ] ; then
                  update exploitdb
                  l00p="false"
               elif [ "$choice" == "n" ] || [ "$choice" == "N" ] ; then
                  l00p="false"
               else
                  tampil error "Bad input"
               fi
            done
         elif [ "$keputusan" == "n" ] || [ "$keputusan" == "N" ] ; then
            loop="false"
         else
            tampil error "Pilihan tidak valid [$keputusan]"
            loop="true"
         fi
      done
#------------------------------Install SET------------------------------#
   elif [ "$1" == "SET" ] ; then
      loop="true"
      while [ "$loop" != "false" ] ; do
         echo -en "[?] Apakah kamu mau menginstall SET? [y/n] "
         read keputusan
         if [ "$keputusan" == "y" ] || [ "$keputusan" == "Y" ] ; then
            tampil aksi "Menginstall SET..."
            apt-get install set -y
            tampil inform "Done"
            loop="false"
            l00p="true"
            while [ "$l00p" != "true" ] ; do
               echo -en "[?] Apakah kamu mau melakukan update? [y/n] "
               read choice
               if [ "$choice" == "y" ] || [ "$choice" == "Y" ] ; then
                  update SET
                  l00p="false"
               elif [ "$choice" == "n" ] || [ "$choice" == "N" ] ; then
                  sleep 2
                  l00p="false"
               else
                  tampil error "Bad input"
               fi
            done
         elif [ "$keputusan" == "n" ] || [ "$keputusan" == "N" ] ; then
            sleep 1
            loop="false"
         else
            tampil error "Pilihan tidak valid [$keputusan]"
            loop="true"
         fi
      done
#------------------------------Install WPScan------------------------------#
   elif [ "$1" == "wpscan" ] ; then
      loop="true"
      while [ "$loop" != "false" ] ; do
         echo -en "[?] Apakah kamu mau menginstall WPScan? [y/n] "
         read keputusan
         if [ "$keputusan" == "y" ] || [ "$keputusan" == "Y" ] ; then
            tampil aksi "Menginstall WPScan..."
            apt-get install wpscan -y
            tampil inform "Done"
            loop="false"
            l00p="true"
            while [ "$l00p" != "true" ] ; do
               echo -en "[?] Apakah kamu mau melakukan update? [y/n] "
               read choice
               if [ "$choice" == "y" ] || [ "$choice" == "Y" ] ; then
                  update wpscan
                  l00p="false"
               elif [ "$choice" == "n" ] || [ "$choice" == "N" ] ; then
                  sleep 2
                  l00p="false"
               else
                  tampil error "Bad input"
               fi
            done
         elif [ "$keputusan" == "n" ] || [ "$keputusan" == "N" ] ; then
            sleep 1
            loop="false"
         else
            tampil error "Pilihan tidak valid [$keputusan]"
            loop="true"
         fi
      done
#------------------------------Install SQLMap------------------------------#
   elif [ "$1" == "sqlmap" ] ; then
      loop="true"
      while [ "$loop" != "false" ] ; do
         echo -en "[?] Apakah kamu mau menginstall SQLMap? [y/n] "
         read keputusan
         if [ "$keputusan" == "y" ] || [ "$keputusan" == "Y" ] ; then
            tampil aksi "Menginstall SQLMap..."
            apt-get install sqlmap -y
            tampil inform "Done"
            loop="false"
            l00p="true"
            while [ "$l00p" != "true" ] ; do
               echo -en "[?] Apakah kamu mau melakukan update? [y/n] "
               read choice
                  if [ "$choice" == "y" ] || [ "$choice" == "Y" ] ; then
                     update sqlmap
                     l00p="false"
                  elif [ "$choice" == "n" ] || [ "$choice" == "N" ] ; then
                     l00p="false"
                  else
                     tampil error "Bad input"
                  fi
            done
         elif [ "$keputusan" == "n" ] || [ "$keputusan" == "N" ] ; then
            loop="false"
         else
            tampil error "Pilihan tidak valid [$keputusan]"
            loop="true"
         fi
      done
   fi
}

#------------------------------Update------------------------------#
update () {
#------------------------------Update Metasploit------------------------------#
   if [ "$1" == "metasploit" ] ; then
      cek metasploit
      cek koneksi
      if [ "$missMsf" == "true" ] ; then
         tampil error "Metasploit tidak terinstall!"
         grab metasploit
      elif [ "$missMsf" == "false" ] ; then
         if [ "$internet" == "true" ] ; then
            tampil aksi "Melakukan update..."
            msfupdate
            tampil inform "Selesai (="
            rm -f index.html* > /dev/null
            sleep 3
         elif [ "$internet" == "false" ] ; then
            tampil error "Kamu tidak memiliki akses internet!"
         fi
      fi
#------------------------------Update W3af------------------------------#
   elif [ "$1" == "w3af" ] ; then
      cek w3af
      cek koneksi
      if [ "$missW3af" == "false" ] ; then
         if [ "$internet" == "true" ] ; then
            tampil aksi "Memindahkan direktori yang aktif..."
            cd "$w3afDir"
            tampil aksi "Melakukan update..."
            svn update
            tampil inform "Selesai (="
            tampil aksi "Memindahkan ke direktori awal..."
            cd -
            rm -f index.html* > /dev/null
            sleep 3
         elif [ "$internet" == "false" ] ; then
            tampil error "Kamu tidak memiliki akses internet!"
         fi
      elif [ "$missW3af" == "true" ] ; then
         tampil error "W3af tidak terinstall!"
         grab w3af
      fi
#------------------------------Update ExploitDB------------------------------#
   elif [ "$1" == "exploitdb" ] ; then
      cek exploitdb
      cek koneksi
      if [ "$missExdb" == "false" ] ; then
         if [ "$internet" == "true" ] ; then
            tampil aksi "Memindahkan direktori yang aktif..."
            cd "$exdbDir"
            tampil aksi "Melakukan update..."
            svn update
            tampil inform "Selesai (="
            tampil aksi "Memindahkan ke direktori awal..."
            cd -
            rm -f index.html* > /dev/null
            sleep 3
         elif [ "$internet" == "false" ] ; then
            tampil error "Kamu tidak memiliki akses internet!"
         fi
      elif [ "$missExdb" == "true" ] ; then
         tampil error "Exploit DB tidak terinstall!"
         grab exploitdb
      fi
#------------------------------Update SET------------------------------#
   elif [ "$1" == "SET" ] ; then
      cek SET
      cek koneksi
      if [ "$missSet" == "false" ] ; then
         if [ "$internet" == "true" ] ; then
            tampil aksi "Memindahkan direktori yang aktif..."
            cd "$dirSet"
            tampil aksi "Melakukan update..."
            svn update
            tampil inform "Selesai"
            tampil aksi "Memindahkan ke direktori awal..."
            cd -
            rm -f index.html* > /dev/null
            sleep 3
         elif [ "$internet" == "false" ] ; then
            tampil error "Kamu tidak memiliki akses internet!"
         fi
      elif [ "$missSet" == "true" ] ; then
         tampil error "SET tidak terinstall!"
         grab SET
      fi
#------------------------------Update WPScan------------------------------#
   elif [ "$1" == "wpscan" ] ; then
      cek wpscan
      cek koneksi
        if [ "$internet" == "true" ] ; then
            tampil aksi "Memindahkan direktori yang aktif..."
            cd "$dirwpscan"
            tampil aksi "Melakukan update..."
            svn update
            tampil inform "Selesai"
            tampil aksi "Memindahkan ke direktori awal..."
            cd -
            rm -f index.html* > /dev/null
            sleep 3
         elif [ "$internet" == "false" ] ; then
            tampil error "Kamu tidak memiliki akses internet!"
         fi
#------------------------------Update SQLMap------------------------------#
   elif [ "$1" == "sqlmap" ] ; then
      cek sqlmap
      cek koneksi
      if [ "$missSqlmap" == "false" ] ; then
         if [ "$internet" == "true" ] ; then
            tampil aksi "Memindahkan direktori yang aktif..."
            cd "$sqlmapDir" && cd ../
            tampil aksi "Melakukan update..."
            svn checkout https://svn.sqlmap.org/sqlmap/trunk/sqlmap sqlmap/
            tampil inform "Selesai"
            tampil aksi "Memindahkan ke direktori awal..."
            cd -
            rm -f index.html* > /dev/null
            sleep 3
         elif [ "$internet" == "false" ] ; then
            tampil error "Kamu tidak memiliki akses internet!"
         fi
      elif [ "$missSqlmap" == "true" ] ; then
         tampil error "SQLMap tidak terinstall!"
         grab sqlmap
      fi
   fi
}

#------------------------------Program Berjalan ------------------------------#
while : ; do
reset
     cat << BANNER
------------------------------------------------------------------
                      t193r triger.sh
------------------------------------------------------------------
Script ini dapat mengupdate software-software berikut:
[M]etasploit  --- Metasploit Framework
[W]3af        --- Web Application Attack and Audit Framework
[E]xploitDB   --- Vulnerability DB by Offensive Security
[S]ET         --- Social Engineering Toolkit (ReL1K)
W[P]Scan      --- Automatic Word Press CMS Vulnerabilirty Scanner
S[Q]LMap      --- Automatic Database Takeover Control
[A]ll         --- Update all
------------------------------------------------------------------
BANNER
     read -p "[M/W/E/S/P/Q] atau [K]eluar : "
     case "$REPLY" in
          A|a) update metasploit; update w3af; update exploitdb; update SET; update wpscan; update sqlmap ;;
          M|m) update metasploit ;;
          W|w) update w3af ;;
          E|e) update exploitdb ;;
          S|s) update SET ;;
          P|p) update wpscan ;;
          Q|q) update sqlmap ;;
      K|k|X|x) keluar ;;
          *) tampil error "Pilihan tidak valid $REPLY" && sleep 1 ;;
     esac
done
