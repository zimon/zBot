package Weather;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8; 

use LWP::UserAgent;
use HTML::Entities;
use lib "../modules";
use Plugins;


sub removeWhiteSpaces {
	my $string = shift;
	$string =~ s/^\s*//mg; # remove whitespaces at beginning of line
	$string =~ s/\s*\n/\n/mg; # remove whitespaces at end of line
	$string =~ s/&nbsp;\n//mg; # remove &nbsp; lines

	return $string;
}
sub removeUnwantedChars {
	my $string = shift;
	$string =~ s/&#160;/\n/g;
	$string =~ s/&.*?;//g; # remove all other special chars

	return $string;
}

sub getWeather {
	my $bot = shift;
	my $user = shift;

	my $input = join(" ",@_);
	my $ua = LWP::UserAgent->new("agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14");
	$ua->timeout(10);
	$ua->env_proxy;

	return "Bitte einen Ort oder eine Postleitzahl angeben." if($input eq "");

	my $notfound = "Kein Ergebnis zu \"$input\" gefunden";
	my $url = "http://wetter.com/suche/?search=$input&search_type_weather=checked";
	my $response = $ua->get($url);
	return $notfound unless ($response->is_success);
	my $content = $response->content;
	my $baseurl = $response->base;
	return $notfound if($content =~ /Treffer/);


	$content =~ /<b style="font-size:12px;">(.*?)<\/div>/s;
	$content =~ $1;
	$content = removeWhiteSpaces($content);
	$content = removeUnwantedChars($content);
	$content =~ s/<script.*?<\/script>//sg;
	$content =~ s/<br \/>/\n/sg;
	$content =~ s/<.*?>//g;

	$content = encode_entities($content);
	$content = decode_entities($content);
	utf8::decode($content);
    chomp $content;
    return $content;

}

Plugins::registerPlugin("wetter",\&getWeather,"Wetter für die eingegebene PLZ in Deutschland (oder Ort weltweit. Funktioniert jedoch nicht immer)\n\nBeispiel: wetter 40223\n\nHinweis: PLZ Suche funktioniert Teilweise auch für andere Europäische Länder. Am besten ausprobieren. Bei Suche nach Orten am besten Sonderzeichen (z.B. ö durch oe) ersetzen.","Wettervorhersage");
