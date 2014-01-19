#!/usr/bin/perl 
# this graph used hard coded colors and elements, and no database interaction at all
# returns a one data set with times

use JSON;
use RRDs;
use CGI::Pretty qw(:standard);
use CGI::Carp 'fatalsToBrowser';
my $dst = param('data');
my $interval = param('interval');
my $resolution = param('resolution');
my $graphDir = "/home/pi/";
my $device = "Statistical data for Raspberry";
my $v;
my $p;
my $category;
my @test = fetchCurrent();
my $xml = '[' . $v . ']';
print header(-type => "xml/text", -expires =>'now');
my $json = new JSON;
print $json->encode($json->allow_blessed->convert_blessed->allow_nonref->utf8->relaxed->decode($xml));
exit;

sub fetchCurrent{
	my $rrd = "$graphDir"."battery.rrd";
    	my $cf = "AVERAGE";
    	$o = 0;
	my ($start,$step,$dsnames,$data) = RRDs::fetch ("$rrd", "$cf", "-r $resolution", "-s $interval", "-e now");
    	$start = $start;# + 3600;
	$ERR=RRDs::error;
    	die "ERROR while fetching $rrd: $ERR\n" if $ERR;
    	my @dsnames = @$dsnames;
	my $cnt = 0;
	foreach my $par(@dsnames){
		if($par =~ /$dst/){$p = $cnt;}
		$cnt++;
	}
    	my @commval;
    	my $counter = 0;
    	foreach my $row (@$data) {  # for each line - each lien comes like x.x y.y (ch_curr pv_curr) etc
		if($counter > 0){$v .= ',';}
        	$start += $resolution;
		# highcharts needs unix time times 1000
		my $hightime = ($start * 1000);
		#$hightime += 3600;
		if ($counter < $#$data){
			$v .= "[$hightime," .  sprintf "%2.2f",(@$row[$p]);
			$v .= "]";
		}
		$counter++;
    	}
	chomp($v);
	push @commval, ("current: ".sprintf "%2.1f",($values{'ch_curr'}));
    	return @commval;
}
