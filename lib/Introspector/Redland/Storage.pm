package Introspector::Redland::Storage;

use strict;
use warnings;
use RDF::Redland;

# this module is for handling the input of the redland storage
# see also : 
# http://www.redland.opensource.ac.uk/docs/pod/RDF/Redland/Storage.html

sub new
{
    my $class = shift;
    my $self = {};
    $self->{storage}=storage=
	new RDF::Redland::Storage(
				  "hashes", 
				  "gcc_storage", #
				  "new='no',hash-type='memory'"
				  );
}

1;
