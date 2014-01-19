#!/usr/bin/perl
my $DEBUG = 0;
use RRDs;
use JSON;
use CGI qw(:standard);

my $rrd = "rpi_stats.rrd";
my $q = new CGI;
#my $bat = getBattery();
#my $temp = getTemp();
my $cpu_stats = getCPUTemp();
my $ret = "[$cpu_stats]";

sub getCPUTemp{
	open(TEMP, "rrdtool lastupdate /home/pi/$rrd |")||die "failed to mtr\n\n\n";
	while(<TEMP>){
		if($_ =~ /:/){
			($time,$batt,$cpu_temp,$ram_total,$ram_used,$ram_free,$disk_total,$disk_free,$disk_perc) = split(' ',$_);
			$time =~ s/://g;
			print "DEBUG: $_" if $DEBUG;
		}
	}
	return "$batt,$cpu_temp,$ram_total,$ram_used,$ram_free,$disk_total,$disk_free,$disk_perc";
}

	
print header;
print $ret;
exit;

