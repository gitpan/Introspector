package Introspector::HTMLGenerator;
###############################################################################
#
# Author  : James Michael DuPont
# Generation    : Second Generation
# Status        : Working
# Category      : Meta Programming Code Translator 
# Description   : Translates Object Descriptions into HTML
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
# exports TranslatePackagesToHTML
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(TranslatePackagesToHTML);

use strict;
use warnings;
use File::Path;

#my %eventhandler;
#my %event_types;

use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::MetaType;
use Carp qw(confess);
use Introspector::CrossReference;

# what is a node used by ?
# how can I track that?
# a. Usages of a type
# b. inheritance
# c. implements of an interface

sub TranslatePackageToHTML($$)
{
    my $repository= shift;
    my $type = shift;
    my $package_name =  TranslateName($repository,$type);             # the name of the package
    my $typeinfo = Introspector::dynload::lookup($repository,$type);
    my $package = CreatePackageHTML ($repository,$type,$typeinfo,$package_name);	# create load and test the package	

    my $filename = "./output/html/node/$package_name.html";
#    warn $filename;
    mkpath "./output/html/node/";
    open HTMLOUT,">$filename" or die "$filename";

    print HTMLOUT "
<!--
 Package $package_name part of the GCC Introspector Project 
 Copyright James Michael DuPont 2001
 Licenced under the Perl Artistic Licence
-->
";
    print HTMLOUT "<html>\n";
    print HTMLOUT "<head>\n";
    print HTMLOUT "</head>\n";
    print HTMLOUT "<body>$package";
    my $users=GetUsersH($repository,$package_name);
    map {
	    print HTMLOUT "<h1>USEDBY : $_</h1>";
	    print HTMLOUT "<table>";
	    map 
	    {
		print HTMLOUT "<tr><td>";
		print HTMLOUT HREF($repository,$_);
		print HTMLOUT 	"</td></tr>";
	    }
	    sort keys %{$users->{$_}};
	    print HTMLOUT "</table>";
	} keys %{$users};
    print HTMLOUT "</body>";
    close HTMLOUT;
}

#############################################################
sub Class   ($$)
{
    my $repository= shift;
    my $name = shift; 
    return "
<h2>
public class $name</h2>
";
     
};

sub InterfaceClass ($$)  {
    my $repository= shift;
    my $name = shift; 
    return "
<h2>
public interface $name
</h2>
";

};

sub HREF($$)
{
    my $repository= shift;
    my $name = shift;
    return "<a href=\"$name.html\">$name</a>\n";
}

sub HREFField($$)
{

    my $repository= shift;
    my $name = shift;
    return "<a href=\"field_$name.html\">$name</a>\n";

}

sub Inherits($$)
{
    my $repository= shift;
    my $name = shift;
    #$package\.
    return "<p>extends ". HREF($repository,$name). "</p>"; # use the extends
};

sub ImplementsInterface ($$)
{
    my $repository= shift;
    my $name = shift; 
    return "<h3>implements <table>". $name. "</table></h3>\n"; # Put in the header
};
sub Member  ($$$$)
{
    my $repository= shift;
    my $name = shift;
    my $type = shift;
    my $comment = shift;

    confess  "type missing " if not $type;
    confess  "name missing " if not $type;
    $type = TypeLookup($repository,$type); # if the type was not set...
    print "MEMBER public $type $name;//$comment\n";
    return 
	"\n<tr><td>public</td><td>". $name  . "</td><td>" . HREF($repository,$type) . "</td><td>". $comment ."</td></tr>\n";

};

sub CreatePackageHTML($$$$)
{
    my $repository= shift;
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
	    $inherits .= Inherits($repository,TranslateName($repository,$totype));	    
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
	    #$inherits .= ImplementsInterface(TranslateName($totype));	    
	    push @tovisit,TranslateName($repository,$totype);
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance
    # to visit
    if (@tovisit)
    {	
	$inherits .= 
	    ImplementsInterface($repository,
				join(
				     ""
				     ,
				     map { 
					 "<tr><td>".HREF($repository,$_)."</td></tr>"
					 } @tovisit
				     )
				);
    }
    
    
    # add handling for associations
    $members .= "  ///////////////////////////////////////\n  //associations";

    ######################################################################
    my $rFields = Introspector::dynload::CalculateOptionalFields ($repository,$id);
    map {
	my $fieldname = $_;
	# now we check if the attribute is in all objects, or is optional
	$members .= Member($repository,
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
	$members .= Member($repository,$fieldname,"String","Option:No Type");	
    } keys %{$rFields->{vals}{optional}};
    
    #########################################################################
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{single_type}{$_};
	$members .= Member($repository,$fieldname,TypeLookup($repository,$fieldtype),"Single_Type:$fieldtype");
    } keys %{$rFields->{refs}{single_type}};
    # the pointer types, the go to one type, but are optional
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_type}{$fieldname};
	confess "Missing Fieldname $fieldname" if not $fieldname;
	confess "Missing FieldType $fieldtype" if not $fieldtype;
	$members .= Member($repository,
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
	$members .= Member($repository,$fieldname,
			   $repository->{baseclass}
			   ,"MultiType : $types");
    } keys %{$rFields->{refs}{multi_type}};
    #########################################################################

    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};	
	my $types  =  join (",",(keys %{$fieldtype}));
	$members .= Member($repository,$fieldname,

			   $repository->{baseclass}
			   ,"Optional Multi Type : $types");

    } keys %{$rFields->{refs}{optional_multi_type}};
    #########################################################################

    #########################################################################
    return  "$pack $inherits <table>\n"  . "\n". $members . "\n". $methods . "\n</table>\n" ; # all the code at once!
}

sub CreateIndex($)
{
    my $repository= shift;
    my $types = GetTypeList($repository);

    my $filename = "./output/html/node/index.html";
    mkpath "./output/html/node/";
    open INDEX,">$filename" or die "$filename";

    print INDEX "<head>";
    print INDEX "</head>";
    print INDEX "<body>";
    print INDEX "<h1>Types<h1>";    
    print INDEX "<table>";    
    foreach my $key (sort keys %{$types})
    {   
	print INDEX "<tr>";
	print INDEX "<td>";
	print INDEX HREF($repository,$key); # the type
	print INDEX "</td>";
	print INDEX "</tr>";
    }
    print INDEX  "</table>";

    my $fields = Introspector::dynload::field_index($repository);
    print INDEX "<h1>Fields<h1>";    
    print INDEX "<table border=1>";    
    foreach my $key (sort keys %{$fields})
    {   
	print INDEX "<tr>";
	print INDEX "<td>";
	print INDEX HREFField($repository,$key); # the type
	print INDEX "</td>";
	print INDEX "<td>";
	print INDEX "<ul>";
	map {
	    print INDEX "<li>";
	    my $type = TypeLookup($repository,$_);
	    print INDEX HREF($repository,$type); # the type
	    print INDEX "</li>";
	}keys %{
	    $fields->{$key}
	    };
	print INDEX "</ul>";
	print INDEX "</td>";
	print INDEX "</tr>";
    }
    print INDEX  "</table>";       
    print INDEX "</body>";
    close INDEX;

}

sub TranslatePackagesToHTML
{
    my $repository = shift;
    CreateIndex $repository;
    $repository->{package}   ="html/node/"; # the html goes to the path html/node
    $repository->{baseclass} = TypeRef($repository,"base");

    # the standard package
    TranslatePackagesAbstract($repository, \&TranslatePackageToHTML);
};

1;
