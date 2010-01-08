package Wikipedia;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use LWP::UserAgent;
use HTML::Entities;
use HTML::TreeBuilder;
use utf8;
use lib "../modules";
use Plugins;

# TODO: Encoding Probleme lösen


sub getWiki {
	# initialise LWP (libwww-perl)
	my $ua = LWP::UserAgent->new("agent" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14");
	$ua->timeout(10);
	$ua->env_proxy;
	# Suchphrase holen und Leerzeichen durch Unterstriche ersetzen
	my $t = shift;

	return "Bitte einen Begriff eingeben." if($t eq "");

	# Bla bla, falls kein Artikel gefunden wird
	my @answers = ("Google weis das bestimmt: http://google.de/search?q=$t", "Vielleicht hilft Dir Google weiter: http://google.de/search?q=$t", "Schau mal bei http://google.de/search?q=$t");
	my $i = int(rand(@answers +1) -1);

	my $answer = $answers[$i]; # die Antwort wird mit einer zufälligen Phrase initialisiert, die zur Googlesuche verlinkt. (Falls kein Artikel gefunden wird)

	# Artikel laden
	my $url = "http://de.wikipedia.org/wiki/$t";
	my $response = $ua->get($url);
	return $answer unless ($response->is_success);
	my $content = $response->content;
	my $baseurl = $response->base;
	return $answer if($content =~ /Artikel verschwunden/ || $content =~ /Diese Seite wurde gel.{1,2}scht/);

	# Artikel parsen
	my $html = new HTML::TreeBuilder;
	$html->parse($content);
	my @res = ();
    
	my $dodecode = 1;
	# Unterscheidung ob Begriffsklärung oder nicht
	if($content =~ /Diese Seite ist eine/s){
		$answer = $html->as_HTML;
		$answer =~ s/.*?<p>(.*)<div id="Vorlage_Begriffsklaerung">.*/$1/s; 
	} else {
		my @pars   = $html->find("p");
		my $phtml = "";
		foreach my $p (@pars) {
			my $phtml .= $p->as_HTML;
			next if($phtml =~ /^<p><span/ || $phtml =~ /^<p><a/);
			$answer = $phtml;
			last;
		}
	}

	# Formatierungen, damit es schöner aussieht, html Tags werden gelöscht
	$answer =~ s/<br[( \/)]?>/\n/g;
	$answer =~ s/<\/p>/\n/g;
	$answer =~ s/<li>/\n/g;
	$answer =~ s/<.*?>//g;

	$answer = decode_entities($answer);
	utf8::decode($answer);

	return $answer."Siehe auch: http://de.wikipedia.org/wiki/$t";
}

sub getWikiDef {
	my $bot = shift;
	my $user = shift;
	my @searchlist = @_;
	foreach my $word (@searchlist){
		$word = ucfirst($word);
	}
	my $searchword = join("_",@searchlist);
	my $answer = getWiki($searchword);
	return $answer;
}

Plugins::registerPlugin("wiki",\&getWikiDef,"Schlägt eine Wikipedia Definition nach\nUsage: \nwiki <wort>\n\nBeispiel:\nwiki jabber","Wikipdia Definitionen");
