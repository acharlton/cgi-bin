#!/usr/bin/perl
my $DEBUG = 1;
use RRDs;
use JSON;
use CGI qw(:standard);
my $q = new CGI;
my $ds = param('ds');
my $cpu_stats = getCPUTemp();
my $ret = "[$cpu_stats]";

sub getCPUTemp{
	open(TEMP, "rrdtool lastupdate /home/pi/cpu_temp.rrd |")||die "failed to mtr\n\n\n";
	while(<TEMP>){
		if($_ =~ /:/){
			($time,$cpu_temp,$ram_total,$ram_used,$ram_free,$disk_total,$disk_free,$disk_perc) = split(' ',$_);
			print "DEBUG: $_" if $DEBUG;
		}
	}
	return "$cpu_temp";
}

	
print header;
print $ret;
exit;

