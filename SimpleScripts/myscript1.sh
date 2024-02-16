
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d'"' -f 2,4 | sort -u | sed "s#.*/##" | sort -n > out.txt

grep "200" cdlinux.www.log | cut -d " " -f 1,7 | sort -u | sed "s#.*/##" | cut -d" " -f 2 | sort -n >> out.txt

sort -n out.txt | uniq -c | sort -n | grep "\.iso$"
 
