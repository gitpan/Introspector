#! perl
###############################################################################
#
# MODULE  : Introspector.pm
# Author  : James Michael DuPont
# Generation    : Second Generation
# Status        : To Review and Document
# Category      : Meta Programming Driver
# Description   : High level driver to generate SQL and Perl classes from First Generation code
#                 
#
# LICENCE STATEMENT
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





=head1 NAME

intrspctr - IntrOspEctOr Driver

=head1 SYNOPSIS

intrspctr.pl

=head1 DESCRIPTION

The Introspector main driver routine
Purpose : Driver for the introspector Project. 
Allows high level manipulation of program structures.
allows your programs to load themselves.


=cut

our $VERSION = '0.04'; # we are on the second version

# Author  : James Michael DuPont
# Copyright James Michael DuPont 2001
# Licence : Perl Artistic Licence 

# Date    : 24.7.01
# The Changes to the compiler are under Gnu Public Licence
# Uses    : The Project uses version 3.0 of the gnu compiler collection 
#           with a patch to allow xml output
###############################################################################
# USEFULL BREAKPOINTs :
# b NodeVisitors::ProcessNode

package Introspector;

my $justgenerate =0; # if the code is just generated!

use Introspector::FileHandling;
use Data::Dumper;             # for debugging output 
use strict;                   # be strict about it
use warnings;                 # warn me of problems
use Carp qw(cluck confess);   # be able to confess your sins

################################################################
# Tools Packages
#use BaseTypes;   # basic types of object hierachies
#use TestGroups;  # create class hierachies and test them
use Introspector::dynload;     # load the type information from the last run
use Introspector::MetaPackage; # create the packages on the fly!
use Introspector::MetaInheritance; # Inheritance relationship that will be created
use Introspector::gcc;         # FOR LOADING THE NODES, exports $nodes
use Introspector::NodeProcess; # CALLBACKS for processing the nodes!
use Introspector::NodeVisitors; # CALLBACKS for processing the nodes!
# BREAK ON : b NodeVisitors::VisitIdentifier

# Prototype meta classes
#use MetaInfo;    # Knowledge that I have added into the system
#use ProgramKnowledge; # Facts about the program, to be translated into a class hierarchy


#################################################
# dynload::load_types;
#use LoadMetaInfo;
#TestGroups::test_groups \%MetaInfo::type;
#TestGroups::get_elements \%MetaInfo::type;
#TestGroups::CheckInheritance; # use the real data
#use LoadNodes;        # LOAD THE NODES FROM A DUMP FILE
use Introspector::DebugPrint;
use Introspector::ModifyClasses;    # MODIFY OUR CLASSES before generateion
use Introspector::TranslateClasses; # TRANSLATE THE CLASSES FROM OUR FORMAT TO CLASS CONTRACT
#use Introspector::PerlGenerator; # experimental perl generator, produces code that you can read!
use Introspector::StandardPerlGenerator; # experimental perl generator, produces code that you can read! and debug without ClassContract
use Introspector::JavaGenerator; # experimental java generator
use Introspector::SQLGenerator; # experimental java generator
use Introspector::HTMLGenerator; # experimental html generator
use Introspector::CrossReference;
#use Introspector::CreateClasses;    # Write our class format
#use Introspector::CreateClassesTest;    # Write our class format
use Introspector::LoadNodes;        # Install Callbacks and read in perl file

sub start($$$$)
{
    my $repository = shift;
    my $filename = shift;
    die "Filename is empty" unless $filename;
    my $RunLoadNodes = shift; #what loads the nodes
    my $CustomizeClasses = shift; # a subroutine to customize the created classes

#  MetaInfo::meta($repository); # the meta information about the structure of the program.

    Introspector::LoadMetaInfo::load($repository); # try and load on demand

    $repository->{newnodes} = {}; # my %newnodes; # all the instances created of Contracted Nodes
    $repository->{waiting} = {}; # my %waiting; # who is waiting?
    $repository->{done} = {}; #my %done;    # who is done
#  ProgramKnowledge::ProcessProgram($repository);  # the program itself
    # here we can override the classes and add functions before they are generated
    &$CustomizeClasses($repository);

    CrossReferencePackages($repository);  # calculate the usage
#    PerlGenerator::TranslatePackagesToPerl; # Perl GENERATOR
    Introspector::StandardPerlGenerator::TranslatePackagesToPerl($repository);

#TODO: do we want to test them?
#    Introspector::StandardPerlGenerator::TestPackages($repository);

    TranslatePackagesToJava($repository); # JAVA GENERATOR
    TranslatePackagesToHTML($repository); # HTML GENERATOR
    TranslatePackagesToSQL($repository); # SQL GENERATOR
    InstallCallbacks($repository);
#    TranslatePackages; use the generated code

    if (! $justgenerate)
    {
	my $relout = OpenOutputFile ($repository,$filename . "_RELATIONSHIPS.txt");
	my $valsout = OpenOutputFile ($repository,$filename . "_VALUES.txt");
	my $pass2out = OpenOutputFile ($repository,$filename . "_PASS2.XML");

#	LoadNodes $filename; # incrementally load the nodes
# will be defined
	&$RunLoadNodes($repository,$filename); # pass the filename as a parameter
	# now we process all the nodes that were found.
	Introspector::gcc::PostProcess($repository,$valsout, $relout ,$pass2out); #! cool!	
	CloseFile($repository,$pass2out);  # close PASS2XML;
	CloseFile($repository,$relout  );  # close RELOUT;
	CloseFile($repository,$valsout );  # close vals	
    }
# we also want to handle the contents of the nodes
###############################################
# nice break beats b NodeVisitors::VisitRefsChain
    
}


1;
