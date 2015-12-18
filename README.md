# DNS-Server-Response-Time

URL:http://forums.cacti.net/about6332.html

<br>
## Requirement<br>
OS:CentOS6<br>
Package:cacti-0.8.8b-7.el6.noarch<br>
<br>
## Install<br>
-- copy dnsResponseTimeLoop.pl<br>
$ cp dnsResponseTimeLoop.pl /ush/share/cacti/scripts/<br>
$ chmod 755 /ush/share/cacti/scripts/dnsResponseTimeLoop.pl<br>
<br>
-- check example<br>
$ /usr/share/cacti/scripts/dnsResponseTimeLoop.pl -h www.example.org -s 127.0.0.1 -r -t 1 -i 2<br>
min:0 median:1 avg:6 max:675 iter:134<br>
$ /usr/share/cacti/scripts/dnsResponseTimeLoop.pl -h www.example.org -s 127.0.0.1 -p 53 -r -t 1 -i 2<br>
min:0 median:0.5 avg:0 max:15 iter:745<br>
$ /ush/share/cacti/scripts/dnsResponseTimeLoop.pl -h www.example.org -s 127.0.0.1 -p 5300 -r -t 1 -i 2<br>
min:0 median:0 avg:3 max:552 iter:322<br>
<br>
<br>
<br>
## Notes
 add -p option<br>
 <br>
 port 53固定だったものを任意指定できるようにオプション追加<br>
