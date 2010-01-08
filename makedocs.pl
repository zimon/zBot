#!/usr/bin/perl


use strict;
use warnings;
use vars qw (%ENV);


if (defined $ENV{NATURALDOCS_PATH} && $ENV{NATURALDOCS_PATH} ne "") {
    system
"$ENV{NATURALDOCS_PATH}/NaturalDocs -i . -o HTML ./documentation -p ./naturaldocs -xi ./makedocs.pl ./plugins_new";
} else {
    print "Environment variable \$NATURALDOCS_PATH not defined!\n";
}

