#!/usr/bin/perl

# This software is published under GPL. See http://www.gnu.org/licenses/gpl-2.0.html
# Author: zimon@gmx.net (Jabber: zimon@zinformatik.de)

use strict;
use warnings;

use Net::Jabber::Bot;
use Encode;
use utf8;


# 
# Var: $bot
#
# Object of Net::Jabber::Bot class
my $bot;


#
# Sub: backgroundChecks
#
# Is called in regular intervals defined at Configs "loop_sleep_time" in seconds (standard 15 seconds)
#
# The idle function of every plugin is called here (if defined and registered)
sub backgroundChecks {
	my @functions = Plugins::getIdleFunc();
	foreach my $func (@functions) {
		&{$func}();
	}
}

#
# Sub: newMessage
#
# Is called when Bot gets a message
# Should react on message, call plugins and answer
#
# Parameters:
#   Are set by instance of bot
sub newMessage {
	my @args = @_;
	my $user = $args[3];
	my $userMessage = $args[5];
	my $type = $args[7];
	my $reply = $args[9];

	my $botname = Configs::getBotName();
	my $logfile = Configs::getLogfile();
	if(Configs::getLogging() == 1){
		open(LOGFILE,">>$logfile");
		print LOGFILE "(".localtime(time).") $user: $userMessage\n\n";
	}
	
	my $botMessage = ""; 
	my @words=split(" ",$userMessage);
	
	if($userMessage =~ /\b$botname\b/i){
		unshift(@words,$botname);
	} # elsif here to add more words to match per regexp

	my $functionKey = shift(@words);
	my $function = Plugins::getFunc(lc($functionKey));
	if(! $function == 0) {
		$botMessage = &{$function}($bot,$user,@words);
#		if($type eq "groupchat") {
#			my $roomname = $user;
#			$roomname =~ s/(.*?)@.*/$1/;
#			$bot->SendGroupMessage($reply, $botMessage);
#		} else {
		if(not($type eq "groupchat") or Configs::isInForum($reply)) {
			$bot->SendJabberMessage($reply, $botMessage, $type,"");
			if(Configs::getLogging() == 1){
				print LOGFILE "(".localtime(time).") $botname: $botMessage\n\n";
				close(LOGFILE);
			}
		}
	}
}

#
# Sub: init
#
# Is called at startup. Loads modules and plugins. Initialises bot.
sub init {
# load all plugins from directory
	use lib "plugins";
	my @plugs = glob("plugins/*.pm");
	foreach my $p (@plugs){
		$p =~ s/plugins\/(.*)/$1/;
		require $p;
	}

	use lib "modules";
	use Configs;
	use Plugins;
	use Bot;

	$bot = new Bot(Configs::getBotConfig(\&newMessage,\&backgroundChecks));
}


init();
$bot->Start();
