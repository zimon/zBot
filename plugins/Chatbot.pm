package Chatbot;
require Exporter;
use strict;
use warnings;
our @ISA    = qw(Exporter);

use utf8;
use lib "../modules";
use Plugins;



sub getAnswer {
	my $bot = shift;
	my $contact = shift;
	my @words = @_;
	my $text = join(" ",@words);


	my $user = $contact;
	if($user =~ /conference/) { 
		$user =~ s/.*\/(.*)/$1/;
	} else {
		$user =~ s/(.*)@.*/$1/;
	}	

	srand;

# Unterhalten	
	if ($text =~ /\bhallo\b/i || $text =~ /\bhi\b/i || $text =~ /\bhey\b/i)
	{
		my @lines = ('Hallöchen auch ','Hi ','Hallihallohallöle ', 'Hallo ');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i].$user);
	}
	elsif($text =~ /\btest\b/i) {
		return "bestanden";
	}
	elsif ($text =~ /\bhast\b/i and $text =~ /\bhomepage\b/i || $text =~ /\bwebseite\b/i || $text =~ /\bwww\b/i || $text =~ /\bhp\b/i)
	{
		my @lines = ('Ja klar doch, schau hier http://www.bruno.hat-gar-keine-homepage.de','Nein, aber nimm doch diese http://www.jey-key.de');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
	elsif ($text =~ /\bmein name\b/i || $text =~ /\bheisse\b/i || $text =~ /\bheisse\b/i)
	{
		my @lines = ('Angenehm, ich bin Bruno.','Schöner Name, ich bin der Bruno','Ich heisse Bruno');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
	elsif ($text =~ /\bfreundin\b/i || $text =~ /\blover\b/i || $text =~ /\bfreund\b/i)
	{
			return 'Was denkst Du wie sich Bruno\'s vermehren? Durch Zellteilung?...tztztz';
	}
	elsif ($text =~ /\bzigarette\b/i || $text =~ /\bziggi\b/i || $text =~ /\bkippe\b/i || $text =~ /\bzigarre\b/i)
	{
		my @lines = ('Rauchen gefährdet die Gesundheit','Rauchen verursacht Krebs','Wer das Rauchen aufgibt, verhindert das Entstehen schwerer Erkrankungen');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
	elsif ($text =~ /\bwie\b/i and $text =~ /\balt\b/i || $text =~ /\bjung\b/i)
	{
		my @lines = ('Das verrat ich nicht ;)','Hmm, weiss ich nicht genau. Frag mal den Chat-Master!','Viel zu Alt für Dich ;D');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
	elsif ($text =~ /\bmich\b/i and $text =~ /\bmagst\b/i || $text =~ /\bliebst\b/i)
	{
		my @lines = ('Ich liebe nur mich','Ja, möchtest Du mich heiraten?','Natürlich, ich mag jeden Chatter hier');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
	elsif ($text =~ /\bhuhu\b/i)
	{
		return 'Huhu';
	}
# Nette Gesten
	elsif ($text =~ /\bkeks\b/i)
	{
		return 'Hier hast du einen Keks.';
	}
	elsif ($text =~ /\btaschentuch\b/i || $text =~ /\btraurig\b/i || $text =~ /\bheulen\b/i || $text =~ /\bweinen\b/i)
	{
		return 'Hier hast du ein Taschentuch'; 
	}
	elsif ($text =~ /\bhunger\b/i || $text =~ /\bhungrig\b/i)
	{
		return 'Ich könnte einen Burger oder eine Pizza anbieten'; 
	}
	elsif ($text =~ /\bdurst\b/i || $text =~ /\bdurstig\b/i)
	{
		return 'Was hättest Du denn gerne?'; 
	}
	elsif ($text =~ /\bkalt\b/i)
	{
		return 'Hier hast du eine warme Decke und einen heissen Tee '; 
	}


# Als Kellner
	elsif ($text =~ /\bwasser\b/i)
	{
		return 'Ein Wasser: kommt sofort'; 
	}
	elsif ($text =~ /\bcoke\b/i || $text =~ /\bcola\b/i)
	{
		return 'Eine Cola: kommt sofort'; 
	}
	elsif ($text =~ /\blimo\b/i || $text =~ /\blimonade\b/i || $text =~ /\bFanta\b/i || $text =~ /\bsprite\b/i)
	{
		return 'Eine Limonade: kommt sofort'; 
	}
	elsif ($text =~ /\bcappu\b/i)
	{
		return 'Ein Cappuccino: kommt sofort ';
	}
	elsif ($text =~ /\btee\b/i)
	{
		return 'Ein Tee: kommt sofort ';
	}
	elsif ($text =~ /\beis\b/i)
	{
		return 'Ein Eis: hier bitte '; 
	}
	elsif ($text =~ /\bpizza\b/i)
	{
		return 'Eine Pizza: hier bitte '; 
	}
	elsif ($text =~ /\bburger\b/i || $text =~ /\bwhopper\b/i)
	{
		return 'Ein Burger: kommt sofort '; 
	}
	elsif ($text =~ /\bdanke\b/i)
	{
		my @lines = ('Gern geschehen','Keine Ursache','Kein Problem','Mach ich doch gerne.');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
#Zeile für neuen Eintrag
	elsif ($text =~ /\?$/)
	{
		return 'War das jetzt eine Frage oder eine Behauptung?';
	}
	else
	{
		my @lines = ('Sprich nicht so schnell, ich kann Dir nicht folgen','Tut mir leid, das vertehe ich nicht','Kannst du bitte Lauter sprechen? Ich versteh dich nicht','Ja, Ja hätt ich auch gesagt...**grins**','Dummmdidummmmmmmm','Lalalalalalalalal........', 'Aha', 'Mhhh ja', 'Wie bitte?');
		my $i = int(rand(@lines +1) -1);
		return ($lines[$i]);
	}
}



Plugins::registerPlugin(lc(Configs::getBotName()),\&getAnswer,"Chattet mit Dir. Fang Deinen Satz einfach mit Bruno an","Ein Chatbot Plugin");
