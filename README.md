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
##Usage
            dnsResponseTime.pl -h host -s server -r -v -i interval -d delay -t timeout -p port]<br>
<br>
            ./dnsResponseTime.pl -h www.icrc.org  -s 129.132.98.12 -p 53 -v  -r  -t 5  -i 300<br>
<br>
            host:           host to be resolved<br>
            server:         DNS servers to ask<br>
            recursive:      recursive query (default 0 iterative , e.g. all or nothing)<br>
            verbose:        debug output<br>
            interval:       time interval during which to query repeatedly (default 60)<br>
            delay:          delay between quweries in seconds (default 0s)<br>
            timeout:        timeout in seconds (default 10s)<br>
            port:           DNS Server Port (default 53)<br>
<br>
<br>
## Notes
 add -p option<br>
 <br>
 port 53固定だったものを任意指定できるようにオプション追加<br>
