package Introspector::CrossReference;

# Category    : Important
# Category    : Meta-Programming- Travesal of classes
# Description : This flattens out the relationship into users and uses

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

require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(CrossReferencePackages GetUsersA GetUsersH GetUsedA GetUsedH AddExternalModules);

use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::MetaType;
use Carp qw(confess);
use Data::Dumper;
# what is a node used by ?
# how can I track that?
# a. Usages of a type
# b. inheritance
# c. implements of an interface
#my %usage; # what type uses what type and what relationship
#my %used; # what type uses what type and what relationship


sub GetUsersA($$) # returns a hash of the users
{
    my $repository = shift;
    my $package=shift;
    return sort (

		 keys %{$repository->{usage}{$package}{'external'}}
		 ,
		 keys %{$repository->{usage}{$package}{'member-of'}}
		 ,
		 keys %{$repository->{usage}{$package}{'inheritance'}}
		 ,
		 keys %{$repository->{usage}{$package}{'implements'}}
	 );
}

sub GetUsersH($$) # returns a hash of the users
{
    my $repository = shift;
    my $package=shift;
    return $repository->{usage}{$package};
}

sub GetUsedA($$) # returns a hash of the users
{
    my $repository = shift;
    my $package=shift;
    return sort (
		 keys %{$repository->{used}{$package}{'external'}}
		 ,
		 keys %{$repository->{used}{$package}{'member-of'}}
		 ,
		 keys %{$repository->{used}{$package}{'inheritance'}}
		 ,
		 keys %{$repository->{used}{$package}{'implements'}}

		 );
}

sub GetUsedH($$) # returns a hash of the users
{
    my $repository = shift;
    my $package=shift;
    return $repository->{used}{$package};
}


sub CrossReferencePackage($$)
{
    my $repository = shift;
    my $type = shift;
    my $package_name =  TranslateName($repository,$type);             # the name of the package
    my $typeinfo = Introspector::dynload::lookup($repository,$type);
    my $id = $type;       # the name id of the object
    my $typeobj = $typeinfo;  # the type information collected from the nodes   
    # the class is created here
    my $code = "";
    # is it an interface or a class?
    my $pack = "";
    # variables that hold the following
    my $members = "";
    my $methods = "";
    my $inherits = "";
    
    # here we create inheritance
    ########################################################################################
    # the names of the fields
    ########################################################################################
    my @fieldnames = Introspector::dynload::GetFieldNames($repository,$id); # check the field names from the last run    
    my %parentsseen; # for multiple inheritance
    map {
	my $totype = $_;	
	if (not $parentsseen{$totype})
	{	
	    Inherits($repository,$package_name,TranslateName($repository,$totype));	    
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{inherits}};   # traverse all the inheritance

    # traverse the interfaces

    my @tovisit;
    map {
	my $totype = $_;	
	if (not $parentsseen{$totype})
	{	
	    ImplementsInterface($repository,$package_name,TranslateName($repository,$totype));
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance
    # to visit

    ######################################################################
    my $rFields = Introspector::dynload::CalculateOptionalFields ($repository,$id);
    map {
	my $fieldname = $_;
	# now we check if the attribute is in all objects, or is optional
	$members .= Member($repository,
			   $package_name,
			   $fieldname,
			   "String",
			   "Mandatory: No Type"
			   );   
    } keys %{
	$rFields->{vals}{mandatory}
    };
    ########################################################################
    map {
	my $fieldname = $_;
	$members .= Member($repository,$package_name,$fieldname,"String","Option:No Type");	
    } keys %{$rFields->{vals}{optional}};
    
    #########################################################################
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{single_type}{$_};
	$members .= Member($repository,$package_name,$fieldname,TypeLookup($repository,$fieldtype),"Single_Type:$fieldtype");
    } keys %{$rFields->{refs}{single_type}};
    # the pointer types, the go to one type, but are optional
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_type}{$fieldname};
	confess "Missing Fieldname $fieldname" if not $fieldname;
	confess "Missing FieldType $fieldtype" if not $fieldtype;
	$members .= Member($repository,$package_name,
			   $fieldname,
			   $fieldtype,
			   "Optional Type"
			   ); # "$package\.node_"
    } keys %{$rFields->{refs}{optional_type}};


    #########################################################################

    # all the pointers that are multiple types
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{multi_type}{$_};
	my $types  =  join (",",(keys %{$fieldtype}));
	$members .= Member(
			   $repository,
			   $package_name,
			   $fieldname,
			   $repository->{baseclass},
			   "MultiType : $types");# TODO find a class that includes all these
    } keys %{$rFields->{refs}{multi_type}};
    #########################################################################

    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};	
	my $types  =  join (",",(keys %{$fieldtype}));
	
	$members .= Member($repository,
			   $package_name,
			   $fieldname,
			   $repository->{baseclass}
			   ,
			   "Optional Multi Type : $types");

    } keys %{$rFields->{refs}{optional_multi_type}};
}

sub Inherits($$$)
{
    my $repository = shift;
    my $user = shift;
    my $name = shift;
    $repository->{usage}{$name}->{'inheritance'}->{$user}++;
    $repository->{used}{$user}->{'inheritance'}->{$name}++; # the reverse relationship
};

sub AddExternalModules($$$)
{
    my $repository = shift;
    my $from_module = shift;
    my $to_module   = shift;
    $repository->{usage}{$to_module}->{'external'}->{$from_module}++;
    $repository->{used}{$from_module}->{'external'}->{$to_module}++; # the reverse relationship
}

sub ImplementsInterface ($)
{
    my $user = shift;
    my $name = shift; 
    $repository->{usage}{$name}->{'implements'}->{$user}++;
    $repository->{used}{$user}->{'implements'}->{$name}++; 
};

sub Member  ($$$$$)
{
  #CrossReference::Member(
    #'Repository=HASH(0x8641134)', 
    #'node_array_type', 
    #'elts', 
    #undef, 
    #'MultiType : record_type,pointer_type,union_type,integer_type'
    #) called at CrossReference.pm line 162
    my $repository = shift;
    my $user = shift;
    my $name = shift;
    my $type = shift;
    my $comment = shift;
    confess if not $type;
    confess if not $user;
    my $cleantype = TypeLookup($repository,$type); # if the type was not set...
    confess if not $cleantype;

    $repository->{usage}{$cleantype}->{'member-of'}->{$user}++;
    $repository->{used}{$user}->{'member-of'}->{$cleantype}++;

};

sub CrossReferencePackages($)
{

    my $repository = shift;
    $repository->{baseclass}= TypeRef($repository,"base");
    # the standard package
    TranslatePackagesAbstract($repository, \&CrossReferencePackage);

    print Dumper(\%used);
};


1;
