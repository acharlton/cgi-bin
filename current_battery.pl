#!/usr/bin/perl
my $DEBUG = 1;
use RRDs;
use JSON;
use CGI qw(:standard);
my $q = new CGI;
my $bat = getBattery();
#my $temp = getTemp();
my $cpu_stats = getCPUTemp();
my $ret = "[$bat,0,$cpu_stats]";
sub getBattery{
	open(MTR, "rrdtool lastupdate /home/pi/battery.rrd |")||die "failed to mtr\n\n\n";
	while(<MTR>){
		if($_ =~ /:/){
			($time,$volts) = split(' ',$_);
			$time =~ s/://g;
			print "DEBUG: $_" if $DEBUG;
		}
	}
	return $volts;
}
#sub getTemp{
#	open(TEMP, "rrdtool lastupdate /home/pi/ambient_temp.rrd |")||die "failed to mtr\n\n\n";
#	while(<TEMP>){
#		print "DEBUG: $_" if $DEBUG;
#		if($_ =~ /:/){
#			($time,$data) = split(' ',$_);;
#			$time =~ s/://g;
#		}
#	}
#	return $data;
#}
sub getCPUTemp{
	open(TEMP, "rrdtool lastupdate /home/pi/cpu_temp.rrd |")||die "failed to mtr\n\n\n";
	while(<TEMP>){
		if($_ =~ /:/){
			($time,$cpu_temp,$ram_total,$ram_used,$ram_free,$disk_total,$disk_free,$disk_perc) = split(' ',$_);
			$time =~ s/://g;
			print "DEBUG: $_" if $DEBUG;
		}
	}
	return "$cpu_temp,$ram_total,$ram_used,$ram_free,$disk_total,$disk_free,$disk_perc";
}

	
print header;
print $ret;
exit;

