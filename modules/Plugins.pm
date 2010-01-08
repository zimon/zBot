package Plugins;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);
our @EXPORT = qw(registerPlugin getFunc getIdleFunc getDesc getShortDesc getPlugins);

# TODO: finish idlefunctions

# 
# Vars: Plugin Hashes
#
# %plugins - Hash of plugins with key=command and value=reference to function in plugin
# @idlefunctions - List of refereces to idlefunctions of plugins (this function gets called every 15 seconds)
# %descriptions - Hash of plugins with key=command and value=description of plugin for help command
# %shortDescriptions - Hash of plugins with key=command and value=shortdescription of plugin to give a short description for each plugin at the help command
my %plugins;
my @idlefunctions;
my %descriptions;
my %shortDescriptions;

#
# Sub: registerPlugin
#
# Is called from each plugin to register
# Adds plugin to %plugins and %descriptions
#
# Parameters:
#
# $keyword - Command to activate plugin
# $function - Reference to plugin function
# $description - String with description of plugin for help command
sub registerPlugin {
	my $keyword = shift;
	my $callfunction = shift;
	my $description = shift;
	my $shortDescription = shift;
	my $idlefunction = shift;
	
	$plugins{$keyword}=($callfunction);
	$descriptions{$keyword} = ($description);
	$shortDescriptions{$keyword} = ($shortDescription) if(defined $shortDescription);
	push(@idlefunctions,$idlefunction) if(defined $idlefunction);
	return 1;
}
  
#
# Sub: getFunc
#
# Is called when Bot gets a message.
# Checks if the first word is key of a plugin. If it is then the reference to the pluginfunction is returned.
# Else 0 is returned.
#
# Parameters:
#
# $key - First word of received string. 
#
#
# Returns:
#
# Reference to plugin function or 0 (if no such plugin exists)
sub getFunc {
	my $key = shift;
	if (defined $plugins{$key} || exists $plugins{$key}){
		return $plugins{$key};
	} else {
		return 0;
	}
}


#
# Sub: getIdleFunc
#
# Is called every 15 seconds
#
# Parameters:
#
# $key - First word of received string. 
#
#
# Returns:
#
# List of References to idlefunctions of plugins
sub getIdleFunc {
 return @idlefunctions;
}

# 
# Sub: getDesc
#
# Looksup the description of a plugin
#
# Parameters:
#
# $key - Command of the plugin
#
# Returns:
#
# Description of plugin or errormessage (if plugin doesn't exists)
sub getDesc {
	my $key = shift;
	if(exists $descriptions{$key}){
		return $descriptions{$key};
	} else {
		return "Kein Hilfe gefunden"; # english: No help found 
	}
}

# 
# Sub: getPlugins
#
# Returns:
#
# a list of all plugin keys
sub getPlugins {
	return sort keys %plugins;
}

# 
# Sub: getShortDesc
#
# Returns:
#
# short Description for a Plugin
sub getShortDesc {
	my $key = shift;
	if(exists $shortDescriptions{$key}){
		return $shortDescriptions{$key};
	} else {
		return "";
	}
}


return 1;
