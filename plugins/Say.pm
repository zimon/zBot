package Say;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8;

use lib "../modules";
use Plugins;
use Config;


sub say {
	my $bot = shift; 
	my $user = shift; 
	my $roomname = shift; 
	my @parameters = @_; 
	my $message = join(" ",@parameters);
	my $conferenceserver = Configs::getConferenceServer;
	if($roomname =~ /@/) {
		$conferenceserver = $roomname;
		$conferenceserver =~ s/.*@(.*)/$1/;
	} 
	if($roomname eq "ignoriere") {
		my $forum = $parameters[0];
		$forum .= "\@".Configs::getConferenceServer if(not($forum =~ /@/));
		Configs::removeForum($forum);
		$bot->SendGroupMessage($roomname, "Raum $parameters[0] wird jetzt ignoriert."); # in english: Room $parameters[0] is ignored now.
		return ""; 
	} else {
		if(not(Configs::isOwnConferenceOnly) or ($conferenceserver eq Configs::getConferenceServer)){
			$roomname .= "\@".Configs::getConferenceServer if(not($roomname =~ /@/));
			if(not Configs::isInForum($roomname)) {
				Configs::addForum($roomname);
				$bot->JoinForeignForum($roomname,Configs::getBotName);
			}
			$bot->SendGroupMessage($roomname, $message);
			sleep 1;
			return "Nun ists gesagt.";
			# in english: Now its said.
		}
		return "Es darf nur in Räumen auf dem eigenen Conference-Server gesprochen werden.";
		# in english: It's only allowed to speak in rooms on the own conference server
	}
}

my $description = "Sagt im Groupchat, einen eingegebenen Text.\n";  
$description .= "Usage:\nsag <roomname> <text>\n\n";  
$description .= "Beispiel: sag testraum Hallo Welt\nAusgabe im Raum 'testraum' auf dem eigenen Conference-Server:\nHallo Welt\n\n";
$description .= "Beispiel2 (nur wenn in Configdatei erlaubt): sag testraum\@conference.jabber.org Hallo Welt\nAusgabe im Raum 'testraum' auf 'conference.jabber.org':\nHallo Welt\n\n";
$description .= "Der Bot bleibt danach im Raum und antwortet nach 20 Sekunden auch auf Befehle.\nDamit er nicht mehr antwortet folgenden Befehl benutzen:\n";
$description .= "sag ignoriere <roomname>\nBeispiel: sag ignoriere testraum\nBeispiel2: sag ignoriere testraum\@conference.jabber.org";

# in english: Says an entered text in an groupchat\n
# Usage: sag <roomname> <text>\n\n
# Example: sag testroom hello world\nOutput in Room 'testroom' on the own conference-server:\nhello world\n\n
# Example2 (Only when allowed in configfile): sag testroom\@conference.jabber.org hello world\nOutput in room 'testroom' on server 'conference.jabber.org:\nhello world\n\n
# After that the bot stays in the room and begins to answer to commands after 20 seconds. To make him not to answer any more use following command:\n
# sag ignoriere <roomname>\nExample: sag ignoriere testroom\nExample2: sag ignoriere testroom\@conference.jabber.org


Plugins::registerPlugin("sag",\&say,$description,"Sagt etwas im angegeben Raum");
