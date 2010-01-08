package Dice;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8; 

use lib "../modules";
use Plugins;

my $MAXDICES = 100000;
my $MAXSIDES = 10000000000;


sub rollDice {
	my $bot = shift;
	my $user = shift;
	my @p = @_;
	my $sidenumber = shift @p;
	my $dicenumber = shift @p;
	
	$sidenumber = 6 if(!defined $sidenumber);
	$dicenumber = 1 if(!defined $dicenumber);

	$dicenumber = $MAXDICES if($dicenumber > $MAXDICES);
	$sidenumber = $MAXSIDES if($sidenumber > $MAXSIDES);

	my $result = 0;
	for(my $i = 0;$i < $dicenumber;$i++){
		$result += int(rand($sidenumber)+1);
	}


	return "Es werden $dicenumber Würfel mit je $sidenumber Seiten gewürfelt. Das Ergebnis ist:\n$result";

}

Plugins::registerPlugin("wuerfel",\&rollDice,"Würfelt (quasi) beliebig viele Würfel mit beliebig vielen Seiten. \nUsage:\nwürfel [seiten] [anzahl]\n Beispiele:\nwürfel - würfelt einen 6-seitigen Würfel\nwürfel 12 - wüerfelt einen 12-seitigen Würfel\nwürfel 20 8 - würfelt 8 Würfel mit je 20 Seiten\n","Würfelt einen oder mehrere Würfel");



