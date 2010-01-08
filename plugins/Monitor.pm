package Monitor;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8;

use lib "../modules";
use Plugins;
use Configs;


# Var: $admin
#
# Name of admin user
my $admin = Configs::getAdmin();


# 
# Sub: getTop
#
# Returns:
#   Output of top command
sub getTop {
	my $bot = shift;
	my $user =shift;
	$user =~ s/(.*)\/.*/$1/;

	if($user eq $admin) {
		system("top -n 1 -b > top.out");
		my $top = "";
		open(DATEI, "<top.out");
		my $x=0;
		while (<DATEI>) { # TODO: nicht alle zeilen ausgeben
			$top .= $_;
			$x++;
			if($x>20){
				last;
			}
		}
		close(DATEI);
		return $top;
	} else {
		return "Diese Funktion steht nur dem Admin zur Verfuegung";
# in english: This function is only available for the admin
	}
}


# 
# Sub: getDf
#
# Returns:
#   Output of command df -h 
sub getDf {
	my $bot = shift;
	my $user =shift;
	$user =~ s/(.*)\/.*/$1/;
	
	if($user eq $admin) {
		system("df -h > df.out");
		my $df = "";
		open(DATEI, "<df.out");
		my $x=0;
		while (<DATEI>) { # TODO: nicht alle zeilen ausgeben
			$df .= $_;
			$x++;
			if($x>20){
				last;
			}
		}
		close(DATEI);
		return $df;
	}
	else {
		return "Diese Funktion steht nur dem Admin zur Verfuegung";
# in english: This function is only available for the admin
	}
}

Plugins::registerPlugin("df",\&getDf,"Sendet die Ausgabe von 'df -h' zurueck. Dieser Befehl ist nur fuer den Admin verfuegbar","Ausgabe von df -h");
# in english: Sends back the output of 'df -h'. This command is only available for admins
Plugins::registerPlugin("top",\&getTop,"Sendet die Ausgabe von 'top' zurueck. Dieser Befehl ist nur fuer den Admin verfuegbar","Ausgabe von top");
# in english: Sends back the output of 'top'. This command is only available for admins
