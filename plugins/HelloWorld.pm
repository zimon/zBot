package Helloworld;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8; # important if you wnat to use special characters

use lib "../modules";
use Plugins;
use Configs; # Is only needed to get the Admin

#
# Sub: idlefunc
# This routine is called automaticaly every 15 seconds
sub idlefunc {
}

# 
# Sub: printHelloWorld
# This routine gets the user and parameters as arguments and should return the string that should be printed.
# The name of this routine can be choosen free.
sub printHelloWorld {
	my $bot = shift; # instance of bot class
	my $user = shift; # user who send the command
	my $username = $user;

	if($username =~ /conference/) { # is user in a muc (chat)?
		$username =~ s/.*\/(.*)/$1/;
	} else {
		$username =~ s/(.*)@.*/$1/;
	}	
	my @parameters = @_; # parameters of the commands
	my $admin = Configs::getAdmin(); # getting admin name

	return "Hallo $username, Du hast 'helloworld @parameters' eingegeben.\nDer Admin hier ist $admin";
	# in english: Hello $username, you typed 'helloworld @parameters'.\n The admin here is $admin

}

# here the plugin is registered. Arguments are:
# Keyword when the plugin should be called
# Functionpointer to the main routine of the plugin (in this example 'printHelloWorld')
# Description of Plugin for help command
Plugins::registerPlugin("helloworld",\&printHelloWorld,"Fuehrt Helloword aus","Ein Helloworld Plugin",\&idlefunc); # in english: calls Helloworld

