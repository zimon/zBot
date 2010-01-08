package Todo;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8; 
use File::Copy;

use lib "../modules";
use Plugins;

# set the right paths for basedir and todoscript here:

my $basedir = "/path_to_zbot/plugins/todo";
my $exampleconfig = "$basedir/example";
my $todoscript = "$basedir/todo.sh -p -v -f";

# ------------------------------------------------------------------- #

sub createConfig {
	my $configdir = shift;

	my $string = "# === EDIT FILE LOCATIONS BELOW ===\n\n# Your todo.txt directory\nTODO_DIR=\"$basedir/$configdir\"\n\n";
	my $examplefile = "";
	open(FILE,"<$exampleconfig/todorc");
	while (<FILE>) { 
		$examplefile .= $_;
	}
	close(FILE);
	
	mkdir("$basedir/$configdir");
	open(FILE2,">$basedir/$configdir/todorc") or die "Coudln't open $basedir/$configdir/todorc";
	print FILE2 $string;
	print FILE2 $examplefile;
	close(FILE2);

	open(TODOTXT,">$basedir/$configdir/todo.txt") or die "Coudln't open $basedir/$configdir/todo.txt";
	print TODOTXT "1";
	close(TODOTXT);

	open(DONETXT,">$basedir/$configdir/done.txt") or die "Coudln't open $basedir/$configdir/done.txt";
	close(DONETXT);

	open(REPORTTXT,">$basedir/$configdir/report.txt") or die "Coudln't open $basedir/$configdir/report.txt";
	close(REPORTTXT);

	open(TODOTMP,">$basedir/$configdir/todo.tmp") or die "Coudln't open $basedir/$configdir/todo.tmp";
	close(TODOTMP);

	open(IDFILE,">$basedir/$configdir/id.txt") or die "Coudln't open $basedir/$configdir/id.txt";
	close(IDFILE);

	open(HISTFILE,">$basedir/$configdir/history.txt") or die "Coudln't open $basedir/$configdir/history.txt";
	close(HISTFILE);
	
	mkdir("$basedir/$configdir/comments");

}

sub todo {
	my $bot = shift; 
	my $user = shift;
	my $username = $user;

	my $response = "\n";
	if($username =~ /conference/) { 
		return "Todo ist im Chat nicht verfügbar";
	} else {
		$username =~ s/(.*)@.*/$1/;
	}	
	my @parameters = @_; 
	my $message = join(" ",@parameters);
	my $configdir = $user;
	$configdir =~ s/@/./g;
	$configdir =~ s/(.*)\/.*/$1/g;
	$configdir .= ".todo";
	if(not(-e "$basedir/$configdir")){
		createConfig($configdir);
	}
	open FH, "$todoscript -d $basedir/$configdir/todorc $message |" or $response = "Ein Fehler ist aufgetreten. Bitte überprüfe ob in der Todo.pm alle Pfade richtig gesetzt sind.";
	while(<FH>) {
		chomp;
		$response = $response.$_."\n";
	}
	close FH;
	chomp($response);
	if (($response eq "\n") || $response eq "") {
		$response = $response."Nothing to display for command todo $message."
	}
	utf8::decode($response);
	return $response;
}

Plugins::registerPlugin("todo",\&todo,"Führt todo.sh mit angegebenen Parametern aus. Für weitere Infos todo ohne weitere Parameter eingeben.\nEs wird todo.sh von http://todotxt.com benutzt. Dort gibt es noch mehr Informationen.","Verwaltet eine Todoliste"); 

