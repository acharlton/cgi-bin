#!/usr/bin/perl
my $DEBUG = 0;
use RRDs;
use JSON;
use CGI qw(:standard);
my $q = new CGI;
open(MTR, "rrdtool lastupdate /home/pi/battery.rrd |")||die "failed to mtr\n\n\n";
while(<MTR>){
	print "$_" if $DEBUG;
	if($_ =~ /:/){
		my ($time,$volts) = split(' ',$_);;
		$time =~ s/://g;
		print header;
		print "[$time,$volts]";
	}
}
exit;

