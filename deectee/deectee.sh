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

# Mengurutkan berdasarkan alfabet
urutan_abjad () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read fsortin
   while [ ! -f $fsortin ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read fsortin
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read fsortout
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      /bin/cat $fsortin | sort > $fsortout
   fi
   cat $fsortout | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$fsortout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Mengurutkan berdasarkan kebalikan alfabet
kebalikan_urutan_abjad () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read rsortin
   while [ ! -f $rsortin ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst):  "
      read rsortin
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read rsortout
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      /bin/cat $rsortin |sort -r > $rsortout
   fi
   cat $rsortout | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$rsortout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Menghapus kata-kata yang sama
menghapus_duplikat () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read indups
   while [ ! -f $indups ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "\nMasukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst):  "
      read indups
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read outdups
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P' $indups > $outdups
   fi
   cat $outdups | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$outdups terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# l33ting
leet () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst)"
   read leetin
   while [ ! -f $leetin ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read leetin
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read leetout
   echo -e "Proses ini akan membuat wordlist berukuran sangat besar."
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      sed -e 's/A/4/g' -e 's/a/@/g' -e 's/B/8/g' -e 's/b/8/g' -e 's/E/3/g' -e 's/e/3/g' -e 's/G/9/g' -e 's/g/9/g' -e 's/I/1/g' -e 's/i/1/g' -e 's/L/1/g' -e 's/l/1/g' -e 's/O/0/g' -e 's/o/0/g'  -e 's/S/5/g' -e 's/s/5/g' -e 's/T/7/g' -e 's/t/7/g' -e 's/Z/2/g' -e 's/z/2/g' < $leetin > $leetout
   fi
   cat $leetout | while read line; do
        count=$[ $count + 1 ]
   done
   echo -e "$leetout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# John rules Section
jtr_rules () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read manglefile
   while [ ! -f $manglefile ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read manglefile
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read mangleout
   echo -e "Proses ini akan membuat wordlist berukuran sangat besar."
   echo -e "Setiap kata akan di-mangle sebanyak 50 kali"
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   cd /pentest/passwords/john/
   if [ "$return" == "" ]; then
      ./john --rules -w:$manglefile -stdout:63  > $mangleout
   fi
   cat $mangleout | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$mangleout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
   cd -
}

# Menghapus awalan spasi
menghapus_awalan_spasi () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read inbeginwhite
   while [ ! -f $inbeginwhite ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read inbeginwhite
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read outbeginwhite
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      echo
      sed -e 's/^[ \t]*//' $inbeginwhite > $outbeginwhite
   fi
   cat $outbeginwhite | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$outbeginwhite terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Menghapus karakter non-ASCII
menghapus_karakter_nonascii () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read innonascii
   while [ ! -f $incontrolm ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read innonascii
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read outnonascii
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      /usr/bin/tr -cd '\11\12\40-\176' < $innonascii > $outnonascii
   fi
   cat $outnonascii | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$outnonascii terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Menghapus kata dalam wordlist yang mengandung kata tertentu
menghapus_string_tertentu () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read inpattern
   while [ ! -f $inpattern ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read inpattern
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read outpattern
   echo -en "Masukkan kata yang akan dihapus: "
   read pattern
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      /bin/sed "/$pattern/d" $inpattern > $outpattern
   fi
   cat $outpattern | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$outpattern terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Crunch nomor telepon
nomor_telepon () {
   echo -e "======Setting======"
   echo -en "Masukkan kode area: "
   read areacode
   echo -en "Masukkan nama wordlist yang baru: "
   read phonefile
   echo -e "1. 2125551234
2. (212)5551234
3. 212-555-1234
4. (212)555-1234"
   echo -en "Pilih format area kode [1-4]: "
   read phone
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      echo -e "Harap tunggu ..."
      if [ "$phone" = "1" ]; then
         /pentest/passwords/crunch/crunch 10 10 1234567890 -t $areacode@@@@@@@ -o $phonefile
      elif [ "$phone" = "2" ]; then
         /pentest/passwords/crunch/crunch 12 12 1234567890 -t "($areacode)@@@@@@@" -o $phonefile
      elif [ "$phone" = "3" ]; then
         /pentest/passwords/crunch/crunch 12 12 1234567890 -t $areacode-@@@-@@@@ -o $phonefile
      elif [ "$phone" = "4" ]; then
         /pentest/passwords/crunch/crunch 13 13 1234567890 -t "($areacode)@@@-@@@@" -o $phonefile
      fi
      cat "$phonefile" | while read line; do
         count=$[ $count + 1 ]
      done
      echo -e "Selesai memproses $phonefile"
   fi
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Menghapus comment
menghapus_komentar () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read incomments
   while [ ! -f $incomments ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read incomments
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read outcomments
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      echo
      /bin/sed '1p; /^[[:blank:]]*#/d; s/[[:blank:]][[:blank:]]*#.*//' $incomments > $outcomments
   fi
   cat $outcomments | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$outcomments terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Menspesifikasikan jumlah karakter minimal dan maksimal di dalam wordlist
minimal_maksimal () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read minmaxin
   while [ ! -f $minmaxin ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read minmaxin
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read minmaxout
   echo -en "Masukkan jumlah karakter minimal yang ada dalam wordlist: "
   read minlen
   echo -en "Masukkan jumlah karakter maksimal yang ada dalam wordlist: "
   read maxlen
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      pw-inspector -i $minmaxin -o $minmaxout -m $minlen -M $maxlen
   fi
   cat $minmaxout | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$minmaxout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Full optimize
optimasi () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read passfile
   while [ ! -f $passfile ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read passfile
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read passout
   echo -en "Masukkan jumlah karakter minimal yang ada dalam wordlist: "
   read min
   echo -en "Masukkan jumlah karakter maksimal yang ada dalam wordlist: "
   read max
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      echo "Menghapus kata yang sama dalam wordlist ..."
      cat $passfile | uniq > working.txt
      echo "Mengurutkan wordlist berdasarkan alfabet ..."
      cat working.txt | sort > working2.txt
      echo "Menghapus kata yang tidak cocok dengan jumlah minimum karakter yang ditentukan ..."
      pw-inspector -i working2.txt -o working3.txt -m $min -M $max
      echo "Menghapus karakter non-ASCII ..."
      /usr/bin/tr -cd '\11\12\40-\176' < working3.txt > working4.txt
      echo "Menghapus komentar ..."
      /bin/sed '1p; /^[[:blank:]]*#/d; s/[[:blank:]][[:blank:]]*#.*//' working4.txt > working5.txt
      echo "Menghapus kata yang di depannya mengandung spasi atau tab ..."
      sed -e 's/^[ \t]*//' working5.txt > working6.txt
      echo "Mengurutkan dan menghapus kata yang sama ..."
      cat working6.txt | sort | uniq > working7.txt
      mv working7.txt $passout
      echo "Menghapus file temporer ..."
      rm -rf working*.txt
   fi
   cat $passout | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$passout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}


# Who's your daddy
whos_your_daddy () {
   if [ ! -d /pentest/passwords/wyd ]; then
      echo "Tidak dapat menemukan wyd.pl"
   else
      echo -e "Masukkan nama domain yang akan dijadikan base passwords (Misalkan www.unpam.ac.id): "
      read domain
      echo -en "Masukkan nama wordlist yang baru: "
      read wydfile
      echo -en "Tekan ENTER untuk melanjutkan: "
      read return
      if [ "$return" == "" ]; then
         mkdir /tmp/TARGET
         cd /tmp/TARGET
         wget -r http://$domain
         cd /pentest/passwords/wyd
         perl wyd.pl -n -o ~/$wydfile /tmp/TARGET
      fi
      echo -e "$wydfile tersimpan di folder $HOME."
      echo "Kembali ke menu utama ..."
      sleep 2
   fi
}

# Crunch
crunch () {
   if [ ! -d /pentest/passwords/crunch/ ]; then
      echo "Tidak dapat menemukan crunch.pl"
   else
      echo -e "=======Setting======="
      echo -en "Masukkan jumlah karakter minimal password: "
      read min
      echo -en "Masukkan jumlah karakter maksimal password: "
      read max
      echo -en "Masukkan karakter yang akan dijadikan password: "
      read charset
      echo -en "Masukkan nama wordlist baru: "
      read output
      echo -en "Tekan ENTER untuk melanjutkan: "
      read return
      if [ "$return" = "" ]; then
         echo -e "Harap tunggu: "
         /pentest/passwords/crunch/crunch "$min" "$max" "$charset" > "$output"
         cat $output | while read line; do
            count=$[ $count + 1 ]
         done
         echo -e "Selesai memproses $output."
      fi
      echo "Kembali ke menu utama ..."
      sleep 2
   fi
}

# CUPP
cupp () {
   if [ ! -d /pentest/passwords/cupp ]; then
      echo "Tidak dapat menemukan cupp.py!"
   else
      echo -en "Tekan ENTER untuk menjalankan CUPP"
      read return
      if [ "$return" = "" ]; then
         cd /pentest/passwords/cupp; python cupp.py -i
      fi
      echo "Wordlist tersimpan di direktori /pentest/passwords/cupp."
      echo "Kembali ke menu utama ..."
      sleep 2
   fi
}

# Menggabungkan beberapa wordlist menjadi satu
gabungan () {
   echo -en "Masukkan path lengkap dari direktori tempat wordlist wordlist yang akan digabungkan: "
   read path
   while [ ! -d $path ]; do
      echo "Direktori tidak ditemukan!"
      echo
      echo -en "Masukkan path lengkap dari direktori tempat wordlist wordlist yang akan digabungkan: "
      read path
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read dictout
   echo
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      cat $path/*.* > $dictout
   fi
   cat $dictout | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$dictout terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}


# Memisahkan wordlist yang besar ke potongan-potongan kecil
pisahkan () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read insplit
   while [ ! -f $insplit ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read insplit
   done
   echo -en "Masukkan jumlah baris yang akan dipotong: "
   read lines
   echo -en "Masukkan nama direktori tujuan wordlist potongan disimpan: "
   read outdir
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      mkdir $outdir
      echo "Membuat $outdir..."
      split -l $lines $insplit $outdir/part
   fi
   cat $outdir/part* | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "Potongan wordlist terletak di $outdir"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Tiap kalimat di kapitalisasi di huruf terdepannya saja
kapitalisasi () {
   echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
   read incapital
   while [ ! -f $incapital ]; do
      echo "Wordlist tidak ditemukan!"
      echo -en "Masukkan path lengkap dari wordlist yang akan diproses. Misalkan (/home/loser/wordlist.lst): "
      read incapital
   done
   echo -en "Masukkan nama wordlist yang baru: "
   read outcapital
   echo -en "Tekan ENTER untuk melanjutkan: "
   read return
   if [ "$return" == "" ]; then
      sed -r 's/\b(.)/\U\1/g' $incapital > $outcapital
   fi
   cat $outcapital | while read line; do
      count=$[ $count + 1 ]
   done
   echo -e "$outcapital terletak di `pwd`"
   echo "Kembali ke menu utama ..."
   sleep 2
}

# Memulai interface
while : ; do
   clear
   cat << !
=============================================================================
                      t193r presents deectee.sh
=============================================================================
 1. Optimasi wordlist secara keseluruhan
 2. Mengurutkan berdasarkan alfabet dalam wordlist
 3. Mengurutkan berdasarkan kebalikan alfabet dalam wordlist
 4. Menghapus kata-kata yang sama dalam wordlist
 5. Menghapus spasi di depan password
 6. Menghapus karakter non ASCII
 7. Remove komentar yang ada dalam wordlist (Kecuali di baris pertama)
 8. Menspesifikasikan jumlah karakter minimal dan maksimal di dalam wordlist
 9. Memanipulasi wordlist dengan --rules John The Ripper
10. L33t wordlist
11. Menghapus baris yang mengandung kata tertentu
12. Membuat wordlist berdasarkan crunch
13. Membuat wordlist berdasarkan wyd.pl
14. Membuat wordlist berdasarkan CUPP
15. Membuat wordlist dengan nomor telepon
16. Menggabungkan wordlist yang ada dalam satu direktori
17. Memisahkan wordlist manjadi bagian-bagian kecil
18. Mengkapitalisasi tiap awalan password di dalam wordlist
19. Keluar
=============================================================================
!
   echo -n "Pilih nomor menu yang ada: "
   read choice
   case $choice in
       1) optimasi ;;
       2) urutan_abjad ;;
       3) kebalikan_urutan_abjad ;;
       4) menghapus_duplikat ;;
       5) menghapus_awalan_spasi ;;
       6) menghapus_karakter_nonascii ;;
       7) menghapus_komentar ;;
       8) minimal_maksimal ;;
       9) jtr_rules ;;
      10) leet ;;
      11) menghapus_string_tertentu ;;
      12) crunch ;;
      13) whos_your_daddy ;;
      14) cupp ;;
      15) nomor_telepon ;;
      16) gabungan ;;
      17) pisahkan ;;
      18) kapitalisasi ;;
      19) exit ;;
      *) echo "\"$choice\" tidak valid "; sleep 2 ;;
   esac
done