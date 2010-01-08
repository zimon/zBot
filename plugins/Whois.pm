package Whois;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8;

use lib "../modules";
use Plugins;
use Configs;

sub getWhois {
	my $bot = shift;
	my $user =shift;
	my $domain = shift;
	if(not defined $domain){
		return "Keine Domain angegeben";
	}
    my $output = `whois $domain`;

    $domain =~ s/[^a-zA-Z0-9\._-]//g;
    print "domain=$domain\n";

	my $df = "Ausgabe von 'whois $domain':\n\n";

    my @outputLines = split(/\n\s*\n/,$output);           # split in paragraphs
    shift @outputLines;                                   # remove paragraph (because its the disclaimer)
    @outputLines = split("\n",join("\n\n",@outputLines)); # join paragraphs and split into lines
    
    for my $index(1..$#outputLines){
        $df .= $outputLines[$index]."\n";
        last if $index == $#outputLines;
    }

	return $df;
}

Plugins::registerPlugin("whois",\&getWhois,"Macht eine whois Abfrage der angegebenen Domain\nBeispiel:\nwhois zinformatik.de","Whois-Abfrage");

