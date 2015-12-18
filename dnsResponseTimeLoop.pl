#!/usr/bin/perl -w
use strict;
use Net::DNS;
use Getopt::Long;
use Pod::Usage;
use Time::HiRes qw( usleep ualarm gettimeofday tv_interval );

=head1 NAME

dnsResponseTimeLoop.pl - DNS-Query and Statistics

=head1 SYNOPSIS

        dnsResponseTime.pl -h host -s server -r -v -i interval -d delay -t timeout -p port]

        ./dnsResponseTime.pl -h www.icrc.org  -s 129.132.98.12 -p 53 -v  -r  -t 5  -i 300

        host:           host to be resolved
        server:         DNS servers to ask
        port:           DNS servers Port (default 53)
        recursive:      recursive query (default 0 iterative , e.g. all or nothing)
        verbose:        debug output
        interval:       time interval during which to query repeatedly (default 60)
        delay:          delay between quweries in seconds (default 0s)
        timeout:        timeout in seconds (default 10s)

=head1 DESCRIPTION

This scripts repeatedly queries a server to resolve a host resp. a domain name
during a given interall.
It returns the min, median, average and maximum resolution times in milliseconds,
if the resolution was successfull, as well as the number of resolutions performed
during the intervall. Otherwise, it returns -1000 if a timeout
occurred, -2000 if query return with errors, or -3000 if the queries did not
resolve into an A record.


=head1 PROBLEMS


=head1 AUTHOR

12. Jan 2005 / Rolf Sommerhalder rolf.sommerhalder at alumni.ethz.ch
 - modified for Cacti v0.8.6

Copyright (c) 2003 Hannes Schulz <mail@hannes-schulz.de>
 - originally written for Nagios

=cut


# $average = mean(\@array) computes the mean of an array of numbers.
sub mean {
 my ($arrayref) = shift;
 my $result;
 foreach (@$arrayref) { $result += $_ }
 return $result / @$arrayref;
}


my ($host,$server,$recursive,$verbose,$interval,$delay,$timeout,$port);

GetOptions(
        "h=s" => \$host,
        "s=s" => \$server,
        "r!"  => \$recursive,
        "v!"  => \$verbose,
        "i=i" => \$interval,
        "d=i" => \$delay,
        "t=i" => \$timeout,
        "p=i" => \$port,
);


if(!$server || !$host) {
 pod2usage("$0: Not enough arguments.\n");
 exit 3;  # Nagios: unknown
}

if (!$recursive) {$recursive= 0;}
if (!$verbose) {$verbose= 0;}
if (!$interval) {$interval= 60};
if (!$delay) {$delay= 0};
if (!$timeout) {$timeout= 10};
if (!$port) {$port= 53};

my $res= Net::DNS::Resolver->new(
 nameservers    => [$server],
 recurse        => $recursive,
 debug          => $verbose,
 port           => $port,       # default= 53
 retrans        => $timeout,    # default= 5
 retry          => 1,           # default= 4
 #udp_timeout   => $timeout,    # default= undef, e.g. retrans and retry are used
 persistent_udp => 0,           # If set to true, Net::DNS will keep a single UDP socket open for all queries
 igntc          => 1,           # If true truncated packets will be ignored. If false truncated packets will cause the query to be retried using TCP
 dnssec         => 0,           # disable EDNS0 (extended) queries and disables checking flag (cdflag)
 udppacketsize  => 512,         # default= 512, if larger than Net::DNS::PACKETSZ() an EDNS extension will be added
);

my @elapsed;
my $wasok;
my ($t0, $t1, $startTime);

my $i= 0;
$startTime= [gettimeofday];
while ((tv_interval($startTime, [gettimeofday]) +$timeout) < $interval) {
 $t0= [gettimeofday];
 #my $query= $res->send($host);
 my $query= $res->send($host, 'A');
 $t1= [gettimeofday];
 $elapsed[$i]= int (tv_interval($t0, $t1) *1000);
 if ($query) {
  if (! ($query->header->rcode eq "NOERROR") ) {
   #print "$query->header->rcode   ";
   $elapsed[$i]= -2000;                 # query returned error
  }
  elsif ($query->header->ancount ==0) {
   $elapsed[$i]= -3000;                 # did not resolve into an A record
  }
 }
 else {
  $elapsed[$i]= -1000;                  # timeout occurred
 }
 #print "$elapsed[$i]\n";
 select(undef, undef, undef, $delay);
 $i++;
}


my @sorted= sort {$a <=> $b} @elapsed;
my $min= $sorted[0];
my $max= $sorted[$#sorted];

my $median;
my $mid= scalar(@elapsed) >> 1;
if ($mid & 1) {
 $median= $elapsed[$mid];
}
else {
 # If there is an even number of values in @values, then you need to add them
 # and divide by two to get the median.
 $median= ($elapsed[$mid-.5] + $elapsed[$mid+.5]) / 2;
}

my $average= int mean(\@elapsed);

print "min:$min median:$median avg:$average max:$max iter:$i\n";
