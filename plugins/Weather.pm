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

	my $location = $content;
	$location =~ /<title>wetter\.com Wetter (.*?) Wetter auf einen Blick/;
	$location = $1;

	$content =~ /END SOI DE rectangle1 Tag(.*?)\.backward_button/s;
	$content = $1;
	$content =~ s/<script.*?<\/script>//sg;
	$content =~ s/<.*?>//g;
	$content = removeWhiteSpaces($content);
	$content = decode_entities($content);
	$content = removeUnwantedChars($content);

	$content =~ s/.*?\n(.*)/$1/s; # remove first line

	my $answer = "";
	my $x = 0;
	my @days = split("Details",$content);
	foreach my $day (@days) {
		my @lines = split("\n",$day);
			if ($x == 1){
				shift @lines;
			}
			last if($x == 2);
			$answer .= $lines[0]."\n".$lines[1]."\n".$lines[5]."\n".$lines[9]." - ".$lines[13]."\nRegen: ".$lines[17]." mit ".$lines[21]."\n\n";
			$answer .= $lines[2]."\n".$lines[6]."\n".$lines[10]." - ".$lines[14]."\nRegen: ".$lines[18]." mit ".$lines[22]."\n\n";
			$answer .= $lines[3]."\n".$lines[7]."\n".$lines[11]." - ".$lines[15]."\nRegen: ".$lines[19]." mit ".$lines[23]."\n\n";
			$answer .= $lines[4]."\n".$lines[8]."\n".$lines[12]." - ".$lines[16]."\nRegen: ".$lines[20]." mit ".$lines[24]."\n\n\n";
		$x++;
	}

	utf8::decode($answer);
	return "Wettervorhersage für $location:\n$answer";

}

Plugins::registerPlugin("wetter",\&getWeather,"Wetter für die eingegebene PLZ in Deutschland (oder Ort weltweit. Funktioniert jedoch nicht immer)\n\nBeispiel: wetter 40223\n\nHinweis: PLZ Suche funktioniert Teilweise auch für andere Europäische Länder. Am besten ausprobieren. Bei Suche nach Orten am besten Sonderzeichen (z.B. ö durch oe) ersetzen.","Wettervorhersage");
