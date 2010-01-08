package Configs;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);
our @EXPORT = qw(getAdmin getBotConfig getBotName getLogfile getLogging addForum removeForum isInForum);


# --- Change Configuration Variables to your needs -------------#

# 
# Vars: Configuration Variables
#   $admin - JID of admin
#   $botname - Name of the Bot
#   $logfile - Name of file to log conversations
#   $enableLogging - 1 to enable logging in $logfile
#   $ownConferenceOnly - 1 to restrict access to own confernece server. 0 to allow bot to join rooms on other conference servers.
#   $conferenceServer - URL of own conference server
#   @keywords - List of Strings to react to in MUC (empty string means: react to everything)
#   %forums - Hash of MUCs to connect to with a reference to a list of Strings to react to.
#   %botConfig - Configuration hash for Net::Jabber::Bot
my $admin = 'name@server.tld';
my $botname = "Bruno";
my $logfile = "logfile.txt";
my $enableLogging = 1;
my $ownConferenceOnly = 0;
my $conferenceServer = 'conference.server.tld';

my @keywords = ("");
my %forums= ('test@conference.server.tld' => \@keywords);

my %botConfig = (
	server => 'server.tld',
	port     => '5222',
	username => 'user',
	password => 'pass',
	alias => $botname,
	resource => 'Bot',
	conference_server => $conferenceServer,
	digest   => '1',
	verbos  => '2',
	logfile => 'bruno.log',
	version => '1.0',
	status  => 'Online',
	loop_sleep_time => 15,
	process_timeout => 5,
	max_messages_per_hour => 100,
	max_message_size => 32000,
	ignore_server_messages => 1,
	ignore_self_messages => 1,
	out_messages_per_second => 5,
	forums_and_responses => \%forums,
);


#----------------- Do not change anything below this line ---------------------------------#

# 
# Sub: getBotConfig
# 
# Parameters:
# $newMessageFunc - Reference to function that should be called when a new Message (for the bot) arrives
# $backgroundChecks - Reference to function that is called in intervals of $botConfig{loop_sleep_time} seconds
#
# Returns:
#
# The configuration hash of the bot
sub getBotConfig{
	my $newMessageFunc = shift;
	my $backgroundChecks = shift;
	$botConfig{message_callback} = $newMessageFunc;
	$botConfig{background_activity} = $backgroundChecks;
	return \%botConfig;
}


# 
# Sub: getAdmin
#
# Returns:
#
# JID of admin
sub getAdmin {
	return $admin;
}

# 
# Sub: getBotName
#
# Returns:
#
# Name of the bot
sub getBotName {
	return $botname;
}

# 
# Sub: getLogfile
#
# Returns:
#
# Name of the logfile
sub getLogfile {
	return $logfile;
}

# 
# Sub: getLogging
#
# Returns:
#
# 1 if logging is enabled
sub getLogging {
	return $enableLogging;
}

# 
# Sub: addForum
# 
# Adds a Forum to the list of forums
#
# Parameters:
# 
# $forum - Forum to be added
sub addForum {
	my $forum = shift;
	$forums{$forum}=\@keywords if(!exists $forums{$forum});
}

# 
# Sub: removeForum
# 
# Removes a Forum from the list of forums
#
# Parameters:
#   $forum - Forum to be removed
sub removeForum {
	my $forum = shift;
	delete $forums{$forum}; # if(exists $forums{$forum});
}

# 
# Sub: isInForum
#
# Determines if Bot ins active in a given Forum
#
# Parameters:
#   $forum - Forum to be tested for activity
#
# Returns:
#   1 if bot is activce in the Forum, else 0
sub isInForum {
	my $forum = shift;
	return 1 if(exists $forums{$forum});
	return 0;
}

# 
# Sub: isOwnConferenceOnly
#
# Tests if bot is only allowed to enter rooms in own conference server
#
# Returns:
#   1 if bot is restricted to own conference server 
#
# See Also: 
#   <$ownConferenceOnly>
sub isOwnConferenceOnly {
	return $ownConferenceOnly;
}

# 
# Sub: getConferenceServer
#
# Returns:
#   URL of confernece server
sub getConferenceServer {
	return $conferenceServer;
}
