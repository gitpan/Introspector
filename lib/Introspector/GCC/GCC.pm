#! perl -w
# this script streams out xml from the compiler, and then parses it when done.
#################################################################
#
# MODULE  : Introspector::GCC;
# Generation : Fourth Generation
# Status     : Clean and ready to go
# Category   : compiler interface
# Description: Handles an incoming stream of xml from the compiler
#              and alternativly reads an berkley db
#
# LICENSE STATEMENT
#    This file is part of the GCC XML Node Introspector Project
#    Copyright (C) 2001-2002  James Michael DuPont
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.     
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.     
# 
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#    Or see http://www.gnu.org/licenses/gpl.txt
###############################################################################

package Introspector::Redland::Storage;

use strict;
use warnings;
#use RDF::Redland;

# this module is for handling the input of the redland storage
# see also : 
# http://www.redland.opensource.ac.uk/docs/pod/RDF/Redland/Storage.html

sub new
{
    my $class = shift;
    my $self = {};
    $self->{storage}=
	new RDF::Redland::Storage(
				  "hashes", 
				  "gccdu", #
				  "new='no',hash-type='bdb',dir='.'"
				  );
    die "Failed to create RDF::Redland::Storage\n" unless $self->{storage};

    $self->{model}  =new RDF::Redland::Model($self->{storage}, "");

# add
# add_statement
# add_statements
# add_string_literal_statement
# arc
# arcs
# arcs_iterator
# contains_statement
# find_statements
# new
# new_from_model
# new_with_options
# remove_statement
# serialise
# serialize
# size
# source
# sources
# sources_iterator
# target
# targets
# targets_iterator

    return bless $self,$class;
}

sub dump
{
    my $self = shift;
    warn "\nPrinting all statements\n";
    my $stream=$self->{model}->serialise;
    while(!$stream->end) {
	print "Statement: ",$stream->current->as_string,"\n";
	$stream->next;
    }
    $stream=undef;
}
1;
######################################################
package Introspector::GCC::GCC;

use 5.006;
use strict;
use warnings;
use Errno;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Introspector::GCC ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);
our $VERSION = '0.01';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    our $AUTOLOAD;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    croak "& not defined" if $constname eq 'constant';
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($!{EINVAL}) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined Introspector::GCC macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	if ($] >= 5.00561) {
	    *$AUTOLOAD = sub () { $val };
	}
	else {
	    *$AUTOLOAD = sub { $val };
	}
    }
    goto &$AUTOLOAD;
}

bootstrap Introspector::GCC $VERSION;


# Autoload methods go after =cut, and are processed by the autosplit program.

my $verbose = $ENV{INTROSPECTOR_VERBOSE} || 0;


#push @INC,"/development/projects/sourceforge/introspector_root/";
#use ParseGCCXML;
#require '/development/projects/sourceforge/introspector_root/ParseGCCXML.pm';

sub process
{
    my $type          = shift;
    my $outfile       = shift;
    my $filename      = shift;
    my $dump_type     = shift;
    my $function_name = shift;

    my $timestr .= scalar(localtime()); # add on the time
    $timestr =~ s/\s/_/g; # remove spaces
    $timestr =~ s/:/_/g;  # remove colons
    
    my $random = rand();  

    $outfile = "./xml/tmp_" . 
	$filename  ."_"  . 
	$dump_type ."_"  .
	$function_name   . "_" .
	$timestr         . "_" .
        int(($random * 100))          . 
	$outfile;
    warn "Opening $outfile\n";
    open OUT, ">$outfile" or die "cannot open $outfile" ;   
    if (@_)
    {
	my $file = shift @ARGV;
	warn "trying to open from $file";
	open IN,$file or die $file;	
    }
    else
    {
	warn "trying to open from STDIN";
	*IN=*STDIN;
    }
    while (<IN>)
    {
	# this will print out the xml
	print $_ 	if ($verbose);

	print OUT $_;
    }
    close IN;
    close OUT;    

    # now we call the parser to read this file
   # ParseGCCXML::Parse($type,$outfile); # turned off the xml parsing
}

sub process_stream
{
    process "main","test.xml", @_;
}

#sub process_func_stream
#{
#    process "func","testfunc.xml", @_;
#}

sub stream
{
    warn "Inside stream";
    my $filename = shift;
    my $dumptype = shift;
    my $functionname = shift || "_global_";

# create the xml directory
    if (! -d "./xml")
    {
	mkdir ("xml");
    }
    
    
    warn "streaming from GCC in $0 ARGS:" . join("\t," ,($filename,$dumptype,$functionname)) . "\n";
    process ("main","-dump.ntriple", $filename,$dumptype,$functionname);



    # this is turned off for now
    # my $x =Introspector::Redland::Storage->new();
    # my $x->dump(); # serialize

}
1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Introspector::GCC - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Introspector::GCC;


=head1 DESCRIPTION

this is the simple gcc interaface

=head2 EXPORT

None by default.


=head1 AUTHOR

James Michael DuPont, E<lt>mdupont777@yahoo.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
