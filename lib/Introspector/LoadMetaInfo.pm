package Introspector::LoadMetaInfo;

###############################################################################
#
# MODULE  : LoadIntrospector
# Author  : James Michael DuPont
# Generation    : Second Generation
# Status        : To Replace by the database
# Category      : Meta Data loading
# Description   : Loads the meta data extracted from the first pass over the compiler
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

use Introspector::FileHandling;
use Introspector::CreateClasses;    # Write our class format
use Introspector::dynload;    # Write our class format
use Introspector::Eval;
use strict;
#my $loaded =0;
sub load_types
{
    my $repository = shift;
    if (ExistsFile($repository,"type_overview.pm"))
    {
	my $type_overview = OpenReadFile($repository,"type_overview.pm");
	$/ = "";
	my $file = <$type_overview>;
	# warn $file;
	my $types= Eval::safe_eval($file);
	die "types error " . $@ if ! $types;
	load_fields($repository); # also load the fields
	CloseFile($repository,$type_overview); #close file
	$repository->{types} = $types;   
	return $repository;
    }
    else
    {
	return undef;
    }

};

sub load_fields
{   
    my $repository = shift;

    if (ExistsFile($repository,"field_overview.pm"))
    {
	my $field_overview = OpenReadFile($repository,"field_overview.pm");
	$/ = "";
	my $file = <$field_overview>;
	my $fields = Introspector::Eval::safe_eval($file);
	die "fields error " . $@ if ! $fields;
	CloseFile($repository,$field_overview);
	$repository->{fields}= $fields;
	return $fields;
    }
    else
    {
	return {};
    }

}

sub load
{    
    my $repository = shift;
    load_types ($repository);
    CreateClasses($repository); # here we add and remove fields and classes to make everything nice!
    return $repository;    
}

1;

