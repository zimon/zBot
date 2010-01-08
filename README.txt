Title: About zBot

Welcome to zBot:

zBot is a Jabber bot written in Perl.

It uses the cpan library Net::Jabber::Bot for all the XMPP and Jabber stuff.

Type 'hilfe' to get a list of all available commands. With 'hilfe command' you the description of the plugin is displayed.

Sorry, but all strings are in german. The documentation is in english so it should be easy to translate (maybe I make an english version later)
I wrote the english translations as comments to the strings.

Installation and Usage:
To install zBot just copy all files to your webserver. Edit the modules/Configs.pm to your own needs (here is username and password of the bot stored).

Start zBot with

zbot.pl &


Plugins:

You can easily add Plugins by writing a perl module and put it into plugins. The Helloworld plugin is a good place to start. Important is to call the <Plugins::registerPlugin> method.


Author:

This bot was written by zimon
* Email: zimon@gmx.net
* Jabber: zimon@zinformatik.de
* Homepage: http://zinformatik.de
