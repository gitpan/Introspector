package Introspector::SQLGenerator; # for postgres SQL
# exports TranslatePackagesToSQL
#################################################################
#
# MODULE  : SQLGenerator.pm
# Author  : James Michael DuPont
# Status        : To update and make mysql compatible
# Generation    : Second Generation
# Category      : Code Generator
# Description   : Writes out postgres SQL tables
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

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(TranslatePackagesToSQL);
use strict;
use warnings;
use File::Path;
use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::MetaType;
use Carp qw(confess);


my $translate = 
{
    "String" => "varchar(50)",
    node_module => "varchar(255)",
    "text" => "varchar(50)",
    "node_text" => "varchar(50)",
	"Char"     =>  "varchar(2)",
    "long_text" => "text",
    "identifier_text" => "varchar(255)",
};

sub SQLType
    {
	my $type = shift;
	my $sql =  $translate->{$type};
	if ($sql)
	{
	    return $sql;
	}
	else
	{
#	    warn "type : $type\n";
	    return "int4";
	}
	# string
	# int
	# ref
    };

sub TranslatePackageToSQL($$)
{
    my $repository = shift;
    my $type = shift;
    my $package_name =  TranslateName($repository,$type);             # the name of the package
    my $typeinfo = Introspector::dynload::lookup($repository,$type);
    my $package = CreatePackageSQL ($repository,$type,$typeinfo,$package_name);	# create load and test the package	
    mkpath  "./output/SQL/";
    open SQLOUT,">./output/SQL/$package_name.SQL";

    print SQLOUT "
--
-- table $package_name part of the GCC Introspector Project 
-- Copyright James Michael DuPont 2001/2002
-- Licenced under the Perl Artistic Licence
--
";
    print SQLOUT $package;
    close SQLOUT;
}

#############################################################
sub Class   ($$)
{
    my $repository = shift; 
    my $name = shift; 
    return "
---
--- table part of the GCC Introspector Project
--- 
---
--- drop table $name;

create table $name";
     
};

sub InterfaceClass($$)   {
    my $repository = shift; 
    my $name = shift; 
    return "
--
-- interface part of the GCC Introspector Project\n 
--
create table $name";

};

sub Inherits($$)
{
    my $repository = shift; 
    my $name = shift;
    return " INHERITS ($name)";
};

#sub ImplementsInterface ($)
#{
#    my $name = shift; 
#    return " INHERITS ($name)\n"; # Put in the header
#};
sub Member  ($$$$)
{
    my $repository = shift;
    my $name = shift;
    my $type = shift;
    my $comment = shift;
    confess  "type missing " if not $type;
    confess  "name missing " if not $type;

    $type = SQLType($type);
#    $type = TypeLookup($repository,$type); # if the type was not set...
#    warn "MEMBER public $type $name;//$comment\n";
    return 
"
$name $type --$comment
";

};

sub CreatePackageSQL($$$$)
{
    my $repository = shift;
    my $id = shift;       # the name id of the object
    my $typeobj = shift;  # the type information collected from the nodes
    my $package_name = shift;
    
    # the class is created here
    my $code = "";
    # is it an interface or a class?
    my $pack = "";
    if ($typeobj->{isinterface})
    {	
	$pack = InterfaceClass($repository,$package_name);;    # create a class
    }
    else
    {
	$pack = Class($repository,$package_name);;    # create a class
    }
    
    # variables that hold the following
    my $members = "";
    my @members ;
    my $methods = "";
    my $inherits = "";
    
    # here we create inheritance
    ########################################################################################
    # the names of the fields
    ########################################################################################

    # traverse the interfaces
    my @tovisit;
    my @fieldnames = Introspector::dynload::GetFieldNames($repository,$id); # check the field names from the last run    
    my %parentsseen; # for multiple inheritance
    map {
	my $totype = $_;	
	if (not $parentsseen{$totype})
	{	
	    push @tovisit,TranslateName($repository,$totype);
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{inherits}};   # traverse all the inheritance

    map {
	my $totype = $_;	
	if (not $parentsseen{$totype})
	{	
	    #$inherits .= ImplementsInterface(TranslateName($totype));	    
	    push @tovisit,TranslateName($repository,$totype);
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance

    # to visit
    if (@tovisit)
    {
	$inherits .= Inherits($repository,
					 join(
					      ","
					      ,
					      @tovisit
					      )
					 );
    }
    
    # add handling for associations

    ######################################################################
    my $rFields = Introspector::dynload::CalculateOptionalFields ($repository,$id);
    map {
	my $fieldname = $_;
	# now we check if the attribute is in all objects, or is optional
	push @members, Member($repository,
			   $fieldname,
			   "text",
			   "Mandatory: No Type"
			   );   
    } keys %{
	$rFields->{vals}{mandatory}
    };
    ########################################################################
    map {
	my $fieldname = $_;
	push @members, Member($repository,$fieldname,"text","Option:No Type");	
    } keys %{$rFields->{vals}{optional}};
    
    #########################################################################
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{single_type}{$_};
	push @members, Member($repository,$fieldname,TypeLookup($repository,$fieldtype),"Single_Type:$fieldtype"      );
    } keys %{$rFields->{refs}{single_type}};
    # the pointer types, the go to one type, but are optional
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_type}{$fieldname};
	confess "Missing Fieldname $fieldname" if not $fieldname;
	confess "Missing FieldType $fieldtype" if not $fieldtype;
	push @members, Member($repository,
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
	push @members, Member($repository,$fieldname,"id","MultiType : $types");
    } keys %{$rFields->{refs}{multi_type}};

    #########################################################################
    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};	
	my $types  =  join (",",(keys %{$fieldtype}));
	push @members, Member($repository,$fieldname,"id","Optional Multi Type : $types");
    } keys %{$rFields->{refs}{optional_multi_type}};

    $members = join (",", @members);

    #########################################################################
    #########################################################################
    return  "$pack (\n"  . "\n". $members . "\n) $inherits \n" ; # all the code at once!
}



sub TranslatePackagesToSQL($)
{

    my $repository = shift;
    # the standard package
    TranslatePackagesAbstract($repository, \&TranslatePackageToSQL);

};

1;
