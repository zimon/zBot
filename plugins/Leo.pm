package Leo;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use LWP::UserAgent;
use utf8;
use lib "../modules";
use Plugins;

sub removeUnwantedChars {
	my $string = shift;
	$string =~ s/<.*?>//g;
	$string =~ s/&#160;/\n/g;
	$string =~ s/&#174;/®/g;
	$string =~ s/&.*?;//g; # remove all other special chars
	$string =~ s///g; # remove strange character in some translations (for example in instalments)
	$string =~ s/^\s*//mg; # remove whitespaces at beginning of line
	$string =~ s/\s*\n/\n/mg; # remove whitespaces at end of line
	$string =~ s/\s{3,}/ - /mg; # replace whitespaces with -

	return $string;
}

sub getLeo {
# initialise LWP (libwww-perl)
	my $ua = LWP::UserAgent->new("agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14");
	$ua->timeout(10);
	$ua->env_proxy;
	my $t = shift;
	#$t =~ s/ /_/g;

	my $notfound = "Kein Ergebnis zu \"$t\" gefunden";
	my $url = "http://pda.leo.org/ende?lp=ende&search=$t";
	my $response = $ua->get($url);
	return $notfound unless ($response->is_success);
	my $content = $response->content;
	my $baseurl = $response->base;
	return $notfound if($content =~ /Die Suche lieferte keine Treffer/);
	$content =~ /<th colspan=2>DEUTSCH<\/th>(.*)Link zu Merriam Webster/;
	$content = $1;
	$content =~ s/<\/tr>/\n/g;
	my @matches = split("<tr>",$content);
	$content = "";
	foreach my $match (@matches) {
		$content .= " ".$match if(not($match =~ /^[^\w]*$/));
		$content = join('',split('&nbsp;',$content));
	}
	$content = removeUnwantedChars($content);
	$content =~ s/(.*{,10000}).*/$1/m;  #trunc to max 10000 chars
	utf8::decode($content);

	return $content;
}

sub getLeoTrans {
	my $bot = shift;
	my $user = shift;
	my @searchlist = @_;
	my $searchword = join(" ",@searchlist);
	my $answer = getLeo($searchword);
	return $answer;
}


Plugins::registerPlugin("leo",\&getLeoTrans,"Schlägt ein Wort im Englisch<->Deutsch Wörterbuch von Leo nach\nUsage: \nleo <word>\n\nBeispiel:\nleo wörterbuch","Deutsch <-> Englisch Wörterbuch");
