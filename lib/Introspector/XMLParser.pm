package introspector::XMLParser;
use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::CrossReference; # Who uses what, GetUsersH
use Introspector::MetaType;
use Introspector::dynload;
use Introspector::PerlGenerator;
use Introspector::FileHandling;
use File::Path;
use warnings;
use strict;
use Introspector::Breaker;
use Cwd ();
use Data::Dumper;
use Carp qw (confess croak );

use XML::Simple;

sub Parse
{
    my $filename = shift;
    my $node = XMLin($filename);
    return $node;
}

1;
