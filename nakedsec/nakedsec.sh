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
trap cleanup INT
versi="0.3"
copyright="By t193r"
#------------------------------AKSI DALAM TERMINAL------------------------------#
aksi() {
   error="free"
   if [ -z "$1" ] || [ -z "$2" ] ; then error="1" ; fi # Inisialisasi kode error
   if [ "$error" == "free" ] ; then
      xterm="xterm"
      command=$2
      if [ "$3" == "2" ] ; then echo "Command: $command" ; fi
      $xterm -geometry 100x15+0+0 -T "nakedsec.sh versi $versi - $1" -e "$command" # line+x+y
      return 0
   else
      echo -e "ERROR *_*"
      return 1
   fi
}

#------------------------------TAMPILAN PESAN------------------------------#
tampil() {
   error="free"
   if [ -z "$1" ] || [ -z "$2" ] ; then error="1" ; fi # Inisialisasi kode error
   if [ "$1" != "aksi" ] && [ "$1" != "info" ] && [ "$1" != "error" ] ; then error="5"; fi
   if [ "$error" == "free" ] ; then
      keluaran=""
      if [ "$1" == "aksi" ] ; then keluaran="\e[01;32m[>]\e[00m" ; fi
      if [ "$1" == "info" ] ; then keluaran="\e[01;33m[i]\e[00m" ; fi
      if [ "$1" == "error" ] ; then keluaran="\e[01;31m[!]\e[00m" ; fi
      keluaran="$keluaran $2"
      echo -e "$keluaran"
      if [ "$3" == "true" ] ; then
         if [ "$1" == "aksi" ] ; then keluaran="[>]" ; fi
         if [ "$1" == "info" ] ; then keluaran="[i]" ; fi
         if [ "$1" == "error" ] ; then keluaran="[-]" ; fi
      fi
      return 0
   else
      tampil error "Error *_*"
      return 1
   fi
}

#------------------------------CLEANUP------------------------------#
cleanup () {
   clear
   echo -e "#------------------------------CLEANUP------------------------------#"
   tampil aksi "Exiting ..."
   if [ -e "/tmp/iface.tmp" ] ; then
      tampil aksi "Menghapus temporary file ..."
      aksi "Clean up" " rm -fv /tmp/iface.tmp"
   fi
   if [ -e "/tmp/arp.tmp" ] ; then
      tampil aksi "Menghapus temporary file ..."
      aksi "Clean up" " rm -fv /tmp/arp.tmp"
   fi
   if [ -e "/tmp/netstat.tmp" ] ; then
      tampil aksi "Menghapus temporary file ..."
      aksi "Clean up" "rm -fv /tmp/netstat.tmp"
   fi
   exit 0
}

#------------------------------CREDITS------------------------------#
credits () {
   clear
   loopcr="true"
   echo -e "#------------------------------CREDITS------------------------------#"
   echo -e "$copyright --- IPTables by Toba Pramudia"
}
#------------------------------MEMASANG IPTABLES------------------------------#
pasang () {
   clear
   tampil info "Mengecek IPTABLES"
   cekiptables=( $(dpkg -l | awk '{print $2}' | grep iptables) )
   if [ $cekiptables != "iptables" ] ; then
      tampil error "IPTABLES belum terinstall"
      loopip="true"
      while [ $loopip != "false" ] ; do
         read -p "[?] Apakah kamu mau menginstall paket IPTables? [y/n] "
         if [ $REPLY == "y" ] ; then
            tampil aksi "apt-get update"
            aksi "UPDATING" "apt-get update" "true"
            tampil aksi "apt-get install iptables -y"
            aksi "Install IPTABLES" "apt-get install iptables -y" "true"
            tampil info "Done"
            loopip="false"
         elif [ $REPLY == "n" ] ; then
            tampil info "Pastikan kamu sudah menginstall paket IPTables sebelum memilih menu ini"
            loopip="false"
         else
            tampil error "Pilihan tidak valid [$REPLY]"
         fi
      done
   else
      echo -e "#------------------------------MEMASANG IPTABLES------------------------------#"
      iptables="iptables -A INPUT -p icmp -m icmp --icmp-type"
      tampil aksi "Memasang firewall ..."
      aksi "Memasang Firewall" "iptables --flush
iptables -A INPUT -p icmp -m icmp --icmp-type destination-unreachable -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type echo-reply -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type echo-request -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type parameter-problem -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type redirect -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type router-advertisement -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type router-solicitation -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type source-quench -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -p icmp -m icmp --icmp-type time-exceeded -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
sleep 2" "true"
      tampil info "Berhasil memasang firewall"
   fi
}

#------------------------------RESET IPTABLES (FLUSH)------------------------------#
reset () {
   clear
   tampil info "Mengecek IPTABLES"
   cekiptables=( $(dpkg -l | awk '{print $2}' | grep iptables) )
   if [ $cekiptables != "iptables" ] ; then
   tampil error "IPTABLES belum terinstall"
      loopip="true"
      while [ $loopip != "false" ] ; do
         read -p "[?] Apakah kamu mau menginstall paket IPTables? [y/n] "
         if [ $REPLY == "y" ] ; then
            tampil aksi "apt-get update"
            aksi "UPDATING" "apt-get update" "true"
            tampil aksi "apt-get install iptables -y"
            aksi "Install IPTABLES" "apt-get install iptables -y" "true"
            tampil info "Done"
            loopip="false"
         elif [ $REPLY == "n" ] ; then
            tampil info "Pastikan kamu sudah menginstall paket IPTables sebelum memilih menu ini"
            loopip="false"
         else
            tampil error "Pilihan tidak valid [$REPLY]"
         fi
      done
   else
      echo -e "#------------------------------RESET IPTABLES (FLUSH)------------------------------#"
      tampil aksi "Mereset firewall ..."
      aksi "Reset Firewall" "iptables --flush && sleep 2" "true"
      aksi "Reset ArpTables" "arptables --flush && sleep 2" "true"
      tampil info "Berhasil mereset firewall"
   fi
}

#------------------------------MEMBACA STATUS IPTABLES------------------------------#
status () {
   clear
   tampil info "Mengecek IPTABLES"
   cekiptables=( $(dpkg -l | awk '{print $2}' | grep iptables) )
   if [ $cekiptables != "iptables" ] ; then
      tampil error "IPTABLES belum terinstall"
      loopip="true"
      while [ $loopip != "false" ] ; do
         read -p "[?] Apakah kamu mau menginstall paket IPTables? [y/n] "
         if [ $REPLY == "y" ] ; then
            tampil aksi "apt-get update"
            aksi "UPDATING" "apt-get update" "true"
            tampil aksi "apt-get install iptables -y"
            aksi "Install IPTABLES" "apt-get install iptables -y" "true"
            tampil info "Done"
            loopip="false"
         elif [ $REPLY == "n" ] ; then
            tampil info "Pastikan kamu sudah menginstall paket IPTables sebelum memilih menu ini"
            loopip="false"
         else
            tampil error "Pilihan tidak valid [$REPLY]"
         fi
      done
   else
   echo -e "#------------------------------MEMBACA STATUS IPTABLES------------------------------#"
      tampil aksi "Listing status firewall"
      echo -e "#--------------------------------------------------------------------------------------------------------------------------#"
      iptables --list
      loopStatus="true"
      while [ $loopStatus != "false" ] ; do
         echo -e "#--------------------------------------------------------------------------------------------------------------------------#"
         read -p "[?] Tekan 'Enter' untuk melanjutkan "
         if [ "$REPLY" == "" ] ; then
            loopStatus="false"
         else
            tampil error "Pilihan tidak dikenali" 1>&2
            loopStatus="true"
         fi
      done
   fi
}

#------------------------------BLOCK IP------------------------------#
block () {
   clear
   tampil info "Mengecek IPTABLES dan ARPTables"
   cekarptables=( $(dpkg -l | awk '{print $2}' | grep arptables) )
   cekiptables=( $(dpkg -l | awk '{print $2}' | grep iptables) )
   if [ "$cekarptables" == "" ]; then
      tampil error "ARPTABLES belum terinstall"
      looparp="true"
      while [ $looparp != "false" ] ; do
         read -p "[?] Apakah kamu mau menginstall paket ARPTables? [y/n] "
         if [ $REPLY == "y" ] ; then
            tampil aksi "apt-get update"
            aksi "UPDATING" "apt-get update" "true"
            tampil aksi "apt-get install arptables -y"
            aksi "Install ARPTABLES" "apt-get install arptables -y" "true"
            tampil info "Done"
            looparp="false"
         elif [ $REPLY == "n" ] ; then
            tampil info "Pastikan kamu sudah menginstall paket ARPTables sebelum memilih menu ini"
            looparp="false"
         else
            tampil error "Pilihan tidak valid [$REPLY]"
         fi
      done
   elif [ $cekiptables != "iptables" ] ; then
      tampil error "IPTABLES belum terinstall"
      loopip="true"
      while [ $loopip != "false" ] ; do
         read -p "[?] Apakah kamu mau menginstall paket IPTables? [y/n] "
         if [ $REPLY == "y" ] ; then
            tampil aksi "apt-get update"
            aksi "UPDATING" "apt-get update" "true"
            tampil aksi "apt-get install iptables -y"
            aksi "Install IPTABLES" "apt-get install iptables -y" "true"
            tampil info "Done"
            loopip="false"
         elif [ $REPLY == "n" ] ; then
            tampil info "Pastikan kamu sudah menginstall paket IPTables sebelum memilih menu ini"
            loopip="false"
         else
            tampil error "Pilihan tidak valid [$REPLY]"
         fi
      done
#------------------------------Memilih interface------------------------------#
   else
      echo -e "#------------------------------BLOCK IP------------------------------#"
      tampil info "Berikut adalah daftar interface yang sedang aktif (up)"
      ifconfig | grep "Link encap" | awk '{print $1}' > /tmp/iface.tmp
      arrayInterface=( $(cat /tmp/iface.tmp) )
      namaInterface=""
      id=""
      index="0"
      loop=${#arrayInterface[@]}
      loopSub="false"
      for item in "${arrayInterface[@]}"; do
         if [ "$namaInterface" ] && [ "$namaInterface" == "$item" ] ; then id="$index" ; fi
         index=$(($index+1))
      done
      echo -e " No | Interface |\n-----|-----------|"
      for (( i=0;i<$loop;i++)); do
         printf ' %-3s | %-9s |\n' "$(($i+1))" "${arrayInterface[${i}]}"
         echo "$(($i+1))" "${arrayInterface[${i}]}" >> /tmp/interface
      done
      while [ "$loopSub" != "true" ] ; do
         read -p "[~] E[x]it atau pilih nomor tabel Interface: "
         if [ "$REPLY" == "x" ] ; then cleanup
            elif [ -z $(echo "$REPLY" | tr -dc '[:digit:]'l) ] ; then tampil error "Pilihan tidak valid, $REPLY" 1>&2
            elif [ "$REPLY" -lt 1 ] || [ "$REPLY" -gt $loop ] ; then tampil error "Nomor tidak valid, $REPLY" 1>&2
            else id="$(($REPLY-1))" ; loopSub="true" ; loopMain="true"
         fi
      done
      interface="${arrayInterface[$id]}"
      tampil info "Interface = $interface"
      #------------------------------Blocking------------------------------#
      IProute=$(ifconfig $interface | grep "inet addr" | awk '{print $2}' | sed 's/addr://')
      tampil info "IP address router kamu adalah: $IProute"
      tampil aksi "Scanning ARP packet ..."
      aksi "Scanning ARP" "arp -i $interface >> /tmp/arp.tmp" "true"
      tampil info "Berikut adalah hasil scanning: "
      cat /tmp/arp.tmp
      read -p "Ingin melanjutkan proses pemblokiran? [y/n] "
      loopBlock="true" # Karena variable di pasang sebagai true, maka proses loop akan terus terjadi
      while [ "$loopBlock" =! "false" ] ; do
         if [ "$REPLY" == "y" ] ; then
            echo -en "[?] Masukkan IP yang ingin kamu blok: "
            read ip
            tampil aksi "Memblokir IP $ip ..."
            aksi "Memblokir IP attacker" "iptables -A INPUT -s $ip -j DROP
iptables -A OUTPUT -p tcp -d $ip -j DROP
sleep 1" "true"
            tampil info "Berhasil memblokir IP address attacker [$ip]"
            echo -en "[?] Masukkan mac address yang ingin kamu blok: "
            read mac
            tampil aksi "Memblokir mac address $mac ..."
            aksi "Memblokir mac address attacker" "arptables -A INPUT --source-mac $mac -j DROP
arptables -A OUTPUT -p tcp --destination-mac $mac -j DROP
sleep 1" "true"
            tampil info "Berhasil memblokir mac address attacker [$mac]"
            tampil aksi "Refreshing interface $interface"
            aksi "Refreshing interface" "ifconfig $interface down && ifconfig $interface down && sleep 1" "true"
            tampil info "Berhasil refresh, silahkan koneksikan ulang network kamu"
            loopBlock="false" # Menghentikan proses looping
         elif [ "$REPLY" == "n" ] ; then
            loopBlock="false" # Menghentikan proses looping
         else
            tampil error "Pilihan tidak valid [$REPLY] (y/n)"
            loopBlock="true"  # Proses looping masih berlanjut
         fi
      done
   fi
}

tutupPort () {
   echo -e "#------------------------------Tutup PORT------------------------------#"
   id=""
   index="0"
   loopMain="true"
   while [ $loopMain != "false" ] ; do
      netstat -lpn | grep tcp > /tmp/netstat.tmp
      arrayProto=( $(cat /tmp/netstat.tmp | awk '{print $1}') )
      arrayPort=( $(cat /tmp/netstat.tmp | awk '{print $4}' | sed "s/0.0.0.0://" | sed "s/127.0.0.1://" | sed "s/::1://" | sed "s/::://") )
      arrayState=( $(cat /tmp/netstat.tmp | awk '{print $6}') )
      arrayNamaProses=( $(cat /tmp/netstat.tmp | awk '{print $7}' | sed "s/.*\///") )
      arrayPID=( $(cat /tmp/netstat.tmp | awk '{print $7}' | sed "s/\/.*//") )
      cekcek=( $(netstat -lpn | grep tcp) )
      if [ "$cekcek" == "" ] ; then
         tampil info "Tidak ada port yang terbuka..." 1>&2
         loopMain="false"
      else
         for item in "${arrayNamaProses[@]}"; do
            if [ "$namaproses" ] && [ "$namaproses" == "$item" ] ; then id="$index" ; fi
            index=$(($index+1))
         done
         tampil info "Berikut adalah daftar port yang terbuka"
         echo -e " No. | Proto | Port | Status |    Nama Proses    | PID \n-----|-------|------|--------|-------------------|------"
         loop=${#arrayNamaProses[@]}
         for (( i=0;i<$loop;i++)); do
            printf ' %-3s | %-5s | %-4s | %-6s | %-17s | %-2s\n' "$(($i+1))" "${arrayProto[${i}]}" "${arrayPort[${i}]}" "${arrayState[${i}]}" "${arrayNamaProses[${i}]}" "${arrayPID[${i}]}"
         done
         loopSub="true"
         while [ $loopSub != "false" ] ; do
            echo -e "--------------------------------------------------------"
            read -p "E[x]it, [r]efresh, kem[b]ali ke menu utama, atau pilih nomor yang akan ditutup: "
            if [ $REPLY == "x" ] || [ $REPLY == "X" ] ; then
               cleanup
            elif [ $REPLY == "r" ] || [ $REPLY == "R" ] ; then
               tutupPort
            elif [ $REPLY == "b" ] || [ $REPLY == "B" ] ; then
               loopMain="false"
               loopSub="false"
            elif [ -z $(echo "$REPLY" | tr -dc '[:digit:]'l) ] ; then
               tampil error "Pilihan tidak valid [$REPLY]" 1>&2
            elif [ "$REPLY" -lt 1 ] || [ "$REPLY" -gt $loop ] ; then
               tampil error "Nomor tidak valid [$REPLY]" 1>&2
            else
               id="$(($REPLY-1))"
               loopSub="false"
               loopMain="false"
               proto="${arrayProto[id]}"
               port="${arrayPort[$id]}"
               state="${arrayState[id]}"
               proses="${arrayNamaProses[id]}"
               PID="${arrayPID[id]}"
               tampil info "Warning!!!"
               echo -e "--------------------------------------------------
Spesifikasi
$proses yang berjalan di port $port, memiliki PID $PID
PROTOCOL = $proto
STATE = $state
akan DITUTUP!!!
--------------------------------------------------"
               loopSure="true"
               while [ $loopSure != "false" ] ; do
                  echo -en "[?] Anda yakin ingin melanjutkan? [y/n] "
                  read sure
                  if [ $sure == "y" ] ; then
                     tampil aksi "Menutup port"
                     aksi "Menutup port $port" "killall $proses -9 && sleep 1" true
                     tampil info "Done (="
                     loopSure="false"
                  elif [ $sure == "n" ] ; then
                     tampil aksi "Mengembalikan ke menu utama ..."
                     loopSure="false"
                  else
                     tampil error "Pilihan tidak valid $sure"
                  fi
               done
            fi
         done
      fi
   done
}

# Cek mekanisme keamanan kernel
cekKernel() {
   printf "  Konfigurasi kernel: "
   if [ -f /proc/config.gz ] ; then
      kconfig="zcat /proc/config.gz"
      printf "\033[32m/proc/config.gz\033[m\n\n"
   elif [ -f /boot/config-`uname -r` ] ; then
      kconfig="cat /boot/config-`uname -r`"
      printf "\033[33m/boot/config-`uname -r`\033[m\n\n"
      printf "  PERINGATAN! Kami menggunakan konfigurasi yang sepertinya mungkin tidak diaplikasikan di kernel yang sedang berjalan\n\n";
   else
      printf "\033[31mKONFIGURASI KERNEL TIDAK DITEMUKAN\033[m\n\n"
      exit 0
   fi
   # GCC STACK PROTECTOR
   printf "  GCC stack protector:            "
   if $kconfig | grep -qi 'CONFIG_CC_STACKPROTECTOR=y'; then
      printf "\033[32mAKTIF\033[m\n"
   else
      printf "\033[31mTIDAK AKTIF\033[m\n"
   fi
   # USER MONGKOPI HALAMAN KERNEL
   printf "  User mengkopi halaman kernel:   "
   if $kconfig | grep -qi 'CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y'; then
      printf "\033[32mAKTIF\033[m\n"
   else
      printf "\033[31mTIDAK AKTIF\033[m\n"
   fi
   # READ ONLY DATA DI DALAM KERNEL
   printf "  Read-only data dalam kernel:    "
   if $kconfig | grep -qi 'CONFIG_DEBUG_RODATA=y'; then
      printf "\033[32mAKTIF\033[m\n"
   else
      printf "\033[31mTIDAK AKTIF\033[m\n"
   fi
   # MEMPROTEKSI DAN MEMBATASI AKSES /dev/mem
   printf "  Proteksi akses /dev/mem:        "
   if $kconfig | grep -qi 'CONFIG_STRICT_DEVMEM=y'; then
      printf "\033[32mAKTIF\033[m\n"
   else
      printf "\033[31mTIDAK AKTIF\033[m\n"
   fi
   # MEMPROTEKSI DAN MEMBATASI AKSES /dev/kmem
   printf "  Proteksi akses /dev/kmem:       "
   if $kconfig | grep -qi 'CONFIG_DEVKMEM=y'; then
      printf "\033[31mTIDAK AKTIF\033[m\n"
   else
      printf "\033[32mAKTIF\033[m\n"
   fi
   # PAX PATCHES
   printf "\n"
   printf "* grsecurity / PaX: "
   if $kconfig | grep -qi 'CONFIG_GRKERNSEC=y'; then
      # CEK LEVEL
      if $kconfig | grep -qi 'CONFIG_GRKERNSEC_HIGH=y'; then
         printf "\033[32mHigh GRKERNSEC\033[m\n\n"
      elif $kconfig | grep -qi 'CONFIG_GRKERNSEC_MEDIUM=y'; then
         printf "\033[33mMedium GRKERNSEC\033[m\n\n"
      elif $kconfig | grep -qi 'CONFIG_GRKERNSEC_LOW=y'; then
         printf "\033[31mLow GRKERNSEC\033[m\n\n"
      else
         printf "\033[33mCustom GRKERNSEC\033[m\n\n"
      fi
      # HALAMAN KERNEL TIDAK BISA DIEKSEKUSI
      printf "  Non-executable halaman kernel:          "
      if $kconfig | grep -qi 'CONFIG_PAX_KERNEXEC=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # MEMBATASI AKSES POINTER UNTUK DIGUNAKAN USERSPACE
      printf "  Mencegah userspace menggunakan pointer: "
      if $kconfig | grep -qi 'CONFIG_PAX_MEMORY_UDEREF=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # MENCEGAH OVERFLOW PADA kobject
      printf "  Mencegah overflow kobject:              "
      if $kconfig | grep -qi 'CONFIG_PAX_REFCOUNT=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # HEAP KETIKA MENGKOPI MEMORI DALAM FRAGMEN-FRAGMEN
      printf "  Heap ketika mengkopi fragmen memori:    "
      if $kconfig | grep -qi 'CONFIG_PAX_USERCOPY=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # MEMBATASI AKSES WRITE PADA kmem/mem/port
      printf "  Mencegah penulisan pada kmem/mem/port:  "
      if $kconfig | grep -qi 'CONFIG_GRKERNSEC_KMEM=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # AKSES INPUT/OUTPUT DIBATASI SEKALIPUN USER ADALAH SUPERUSER
      printf "  Mencegah akses superuser I/O:           "
      if $kconfig | grep -qi 'CONFIG_GRKERNSEC_IO=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # MODUL AUTO-LOAD DIPERKUAT, SEHINGGA TIDAK MUDAH MENGALAMI BUFFER
      printf "  Memperkuat modul auto-loading:          "
      if $kconfig | grep -qi 'CONFIG_GRKERNSEC_MODHARDEN=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
      # SIMBOL KERNEL DISEMBUNYIKAN UNTUK MENGURANGI CELAH INFORMASI
      printf "  Menyembunyikan simbol kernel :          "
      if $kconfig | grep -qi 'CONFIG_GRKERNSEC_HIDESYM=y'; then
         printf "\033[32mAKTIF\033[m\n"
      else
         printf "\033[31mTIDAK AKTIF\033[m\n"
      fi
   else
      # PATCH TIDAK TERSEDIA
      printf "\033[31mTidak ada patch GRKERNSEC\033[m\n\n"
      printf "  Patch grsecurity / PaX tersedia di sini:\n"
      printf "    http://grsecurity.net/\n"
   fi
   # KERNEL HEAP
   printf "\n"
   printf "* Memperkuat Kernel Heap: "
   if $kconfig | grep -qi 'CONFIG_KERNHEAP=y'; then
      # LEVEL PATCH KERNEL-HEAP
      if $kconfig | grep -qi 'CONFIG_KERNHEAP_FULLPOISON=y'; then
         printf "\033[32mKERNHEAP Penuh\033[m\n\n"
      else
         printf "\033[33mKERNHEAP Sebagian\033[m\n\n"
      fi
   else
      # PATCH TIDAK ADA
      printf "\033[31mTidak ada patch KERNHEAP\033[m\n\n"
      printf "  Patch KERNHEAP hardening tersedia di sini:\n"
      printf "    https://www.subreption.com/kernheap/\n\n"
   fi
   loopStatus="true"
   while [ $loopStatus != "false" ] ; do
      echo -e "#----------------------------------------------------------------------------#"
      read -p "[?] Tekan 'Enter' untuk melanjutkan "
      if [ "$REPLY" == "" ] ; then
         loopStatus="false"
      else
         tampil error "Pilihan tidak dikenali" 1>&2
         loopStatus="true"
      fi
   done
}

#------------------------------PROGRAM BERJALAN------------------------------#
#------------------------------Cek ROOT access------------------------------#
if [ $(whoami) != "root" ] ; then
   tampil error "Pastikan kamu menjalankan script ini sebagai root!"
   cleanup
fi
#------------------------------LOOPING------------------------------#
while : ; do
clear
cat << !
#--------------------------------NakedSec.sh--------------------------------#
                             nakedsec Versi $versi
                                  $copyright
(1) Memasang firewall            --- Mengkonfigurasikan IPTables
(2) Me-reset settingan firewall  --- Menghapus setting-an IPTables
(3) Mengecek status firewall     --- Melakukan pengecekkan status IPTables
(4) Blocking IP Attacker         --- Escape from hacker
(5) Cek dan tutup port           --- Are there backdoors?
(6) Credits                      --- Behind the scene
(7) Kernel                       --- Cek konfigurasi kernel
(8) Exit                         --- Keluar dari program ini
#----------------------------------------------------------------------------#
!
   echo -en "[?] What do you want today? "
   read choice
   case $choice in
      1) pasang ;;
      2) reset ;;
      3) status ;;
      4) block ;;
      5) tutupPort ;;
      6) credits ;;
      7) cekKernel ;;
      8) cleanup ;;
      *) echo "Pilihan tidak valid [$choice]" && sleep 1 ;;
   esac
done
