package Help;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use lib "../modules";
use Plugins;
use utf8;

sub printHelp {
	my $bot = shift;
	my $user = shift;
	my $command = shift;

	if(defined $command) {
		return "Hilfe für $command:\n".Plugins::getDesc($command)."\n";
	} else {
		my @commands = Plugins::getPlugins();
		my $string = "Hier die Lister aller Befehle:\n"; # in english: Here is the list of all commands
		foreach my $c (@commands) {
			my $desc = Plugins::getShortDesc($c);
			if($desc eq ""){
				$string .= "$c\n";
			} else {
				$string .= "$c \t - $desc\n";
			}
		}
		$string .="\nWeitere Informationen unter http://zinformatik.de/tipps-tricks/interessante-programme/zbot-ein-jabber-bot-in-perl/";
		return $string;
	}
}

sub printAbout {
	my $mesg = "zBot Version 0.2\n\nAuthor: zimon\nJabber ID: zimon\@zinformatik.de\nEmail: zimon\@gmx.net\nProjekt Homepage: http://zinformatik.de/tipps-tricks/interessante-programme/zbot-ein-jabber-bot-in-perl/";
	return $mesg;
}

my $desc = "Zeigt alle Befehle bzw. dessen Hilfe an. \n* Gib 'hilfe' ein um alle Befehle aufzulisten \n* Gib 'hilfe <Befehl>' ein um die Hilfe für <Befehl> anzuzeigen.\n\nBeispiel: hilfe sag\nWeitere Informationen unter: http://zinformatik.de/tipps-tricks/interessante-programme/zbot-ein-jabber-bot-in-perl/\nDamit der Bot ineinem Raum nicht mehr reagiert folgendes eingeben:\nsag ignore raumname\@conferneceserver.tld";
Plugins::registerPlugin("hilfe",\&printHelp,$desc,"Diese Hilfe");
# in english: Shows all commands or their help. \n* Type 'hilfe' to list all commands \n* type 'hilfe <command>' to get the help for <command>.\n\nExample: hilfe sag

Plugins::registerPlugin("about",\&printAbout,$desc,"Infos über diesen Bot");
