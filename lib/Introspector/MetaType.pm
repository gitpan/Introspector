#################################################################
#
# MODULE  : MetaType.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Status        : To review
# Generation    : Second Generation
# Category      : Meta Data - Classes
# Purpose       : Stores known types
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

package Introspector::DerivedType;
1;

package Introspector::BaseType;
1;

package Introspector::MetaType;
use Carp qw(cluck confess);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
		 BaseType
		 TypeRef
		 TypeLookup
		 GetTypeList
             );
use strict;
use warnings;
my $package   ="org.gnu.gcc.introspector";
#my $typeprefix = "$package\.node_";
my $typeprefix = "node_";

#my %types; store in repository

sub GetTypeList($)
{
    my $repository = shift;
    return $repository->{_types};
}
sub AddAlias($$$)
{
    my $repository = shift;
    my $name = shift;
    my $typeref = shift;
    $repository->{_types}->{$name} = $repository->{_types}->{$typeref};
}

sub TypeLookup($$)
{
    my $repository = shift;
    my $typename= shift;
    if (not $typename)
    {
	cluck "TypeLookup $typename";
	return undef;
    }

    my $ret =$repository->{_types}->{$typename}; #->{val}

    if (! $ret )
    {	
#	warn "Unknown Type $typename";	
	if ($typename !~ /^org./)
	{
#	    warn "Unknown Type, going to fix:$typename";	
	    $ret = TypeRef($repository,$typename);	
	    AddAlias($repository,$typename,$ret);
	    return $ret;
	}
	else
	{
	    warn "Unknown Type Fine $typename";	
	    $ret = AddTypeRef($repository,$typename);
	    AddAlias($repository,$typename,$ret);
	    return $repository->{_types}->{$typename}->{val};
	}
    }
#    warn "$typename used->$ret";
    return $repository->{_types}->{$typename}->{val};
}

sub TypeReport($)
{
    my $repository = shift;
    foreach my $type (keys %{$repository->{_types}})
    {
	print $type . "\t"  .  $repository->{_types}->{$type}->{val} . "\t\t\t"  . $repository->{_types}->{$type}->{count}.  "\n";
    }
}

sub TypeRef($$)
{
    my $repository = shift;
    my $typename = shift;
    my $ret= $typeprefix . $typename;
    return AddTypeRef($repository,$ret);
    return $ret;
}

sub AddTypeRef($$) # dont need a prefix
{
    my $repository = shift;
    my $typename = shift;
    my $ret= $typename;
    $repository->{_types}->{$typename}->{val}=$ret;
    $repository->{_types}->{$typename}->{count}++;
    return $ret;
}

sub BaseType ($$)
{
    my $repository = shift;
    my $typename = shift;
    $repository->{_types}->{$typename}->{val}=$typename;
    $repository->{_types}->{$typename}->{count}++;
    return $typename;
}



1;

