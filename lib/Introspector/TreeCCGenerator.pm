package Introspector::TreeCCGenerator;
# copyright mdupont 2001 
# exports TranslatePackagesToTreeCC
use strict;
use warnings;
use File::Path;
require Exporter;
use CrossReference; # Who uses what, GetUsersH
our @ISA = qw(Exporter);
our @EXPORT = qw(TranslatePackagesToTreeCC);
our %eventhandler;
our %event_types;

use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::MetaType;
use Carp qw(confess);
my $package   ="introspector";
my $BaseClass = TypeRef("base");

sub GetIncludes
{
}
sub TranslatePackageToTreeCC($)
{
    my $type = shift;
    my $package_name =  TranslateName($type);             # the name of the package
    my $typeinfo = dynload::lookup($type);
    my $package = CreatePackageTreeCC ($type,$typeinfo,$package_name);	# create load and test the package	
    mkpath  "./output/treecc/org/gnu/gcc/introspector/";
    open TREECCOUT,">./output/treecc/org/gnu/gcc/introspector/$package_name.tc";

    print TREECCOUT "
/**
 * Package $package_name part of the GCC Introspector Project 
 * Copyright James Michael DuPont 2001
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
**/


%option lang = \"C#\"

";
#%option lang = \"C\"
# "C", "C++", "Java", or "C#".
# %output \"$package_name.cs\"
    my $uses  = 
	join ("\n",map{ "%include /*%readonly*/ \"$_.tc\"" } GetUsedA($package_name));

    print TREECCOUT $uses;

    print TREECCOUT $package;
    close TREECCOUT;

#    CreateEventHandlersTreeCC ($type,$typeinfo,$package);
#    $package->generate_code(); # this creates the code on the fly using closures
}

#############################################################
sub Class   ($)
{
    my $name = shift; 
    return "
/**
* node part of the GCC Introspector Project
* 
**/
%node $name";
     
};

sub InterfaceClass   {
    my $name = shift; 
    return "
/**
* interface part of the GCC Introspector Project\n *
**/
%node $name ";

};

sub Inherits($)
{
    my $name = shift;
    #$package\.
    return " $name"; # use the extends
#    return "public $name ihrts_$name;\n"; # 
};

sub ImplementsInterface ($)
{
    my $name = shift; 
    return " /* no interfaces yet $name */\n"; # Put in the header
};
sub Member  ($$$)
{
    my $name = shift;
    my $type = shift;
    my $comment = shift;
    confess  "type missing " if not $type;
    confess  "name missing " if not $type;
    $type = TypeLookup($type); # if the type was not set...
    warn "MEMBER public $type * $name;//$comment\n";
    
    return 
"
\t/**
\t* Attribute of name $name
\t* Attribute of type $type
\t*  $comment
\t**/

\t $type * $name;//$comment
";

};
#############################################################
# here we will try and translate between two object models
sub CreateEventHandlersTreeCC($$$)
{
    my $type     = shift;
    my $typeinfo = shift;
    my $pack     = shift;  # the package object
    if ($eventhandler{$type})
    {      
	map 
	{
	    my $eventtype = $_;
	    my $code_str = $eventhandler{$type}{$eventtype};
	    my $code_str_withself = sub  { # VERY DANGEROUS!
		no strict;		
		my $self = Class::Contract::self; # HA!
		$code_str->($self,@_); # add an extra parmeter
	    };	    
	    my $method_name = $event_types{$eventtype}{"MethodName"}; # the type of event	    		    
	    print  "Going to add method $method_name " . $code_str . "to package $type\n";
	    $pack->add_method(new MetaMethod(
					     $method_name, # the name of the 
					     $code_str_withself        # 
					     )
			      );       
	} keys %{$eventhandler{$type}};
    }
}

sub CreatePackageTreeCC($$$)
{
    my $id = shift;       # the name id of the object
    my $typeobj = shift;  # the type information collected from the nodes
    my $package_name = shift;
    
    # the class is created here
    my $code = "";
    # is it an interface or a class?
    my $pack = "";
    if ($typeobj->{isinterface})
    {	
	$pack = InterfaceClass($package_name);;    # create a class
    }
    else
    {
	$pack = Class($package_name);;    # create a class
    }
    
    # variables that hold the following
    my $members = "";
    my $methods = "";
    my $inherits = "";
    
    # here we create inheritance
    ########################################################################################
    # the names of the fields
    ########################################################################################
    my @fieldnames = dynload::GetFieldNames($id); # check the field names from the last run    
    my %parentsseen; # for multiple inheritance
    map {
	my $totype = $_;	
	if (not $parentsseen{$totype})
	{	
	    $inherits .= Inherits(TranslateName($totype));	    
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
	    push @tovisit,TranslateName($totype);
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance
    # to visit
    if (@tovisit)
    {
	$inherits .= ImplementsInterface(
					 join(
					      ","
					      ,
					      @tovisit
					      )
					 );
    }

    
    # add handling for associations
    $members .= "  ///////////////////////////////////////\n  //associations";

    ######################################################################
    my $rFields = dynload::CalculateOptionalFields ($id);
    map {
	my $fieldname = $_;
	# now we check if the attribute is in all objects, or is optional
	$members .= Member(
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
	$members .= Member($fieldname,"String","Option:No Type");	
    } keys %{$rFields->{vals}{optional}};
    
    #########################################################################
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{single_type}{$_};
	$members .= Member($fieldname,TypeLookup($fieldtype),"Single_Type:$fieldtype");
    } keys %{$rFields->{refs}{single_type}};
    # the pointer types, the go to one type, but are optional
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_type}{$fieldname};
	confess "Missing Fieldname $fieldname" if not $fieldname;
	confess "Missing FieldType $fieldtype" if not $fieldtype;
	$members .= Member(
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
	$members .= Member($fieldname,$BaseClass,"MultiType : $types");
    } keys %{$rFields->{refs}{multi_type}};
    #########################################################################

    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};	
	my $types  =  join (",",(keys %{$fieldtype}));
	$members .= Member($fieldname,$BaseClass,"Optional Multi Type : $types");

    } keys %{$rFields->{refs}{optional_multi_type}};
    #########################################################################

    if ($inherits eq "")
    {
	$inherits = "%typedef";
    }
    #########################################################################
    return  "$pack $inherits = {\n"  . "\n". $members . "\n". $methods . "\n}\n" ; # all the code at once!
}



sub TranslatePackagesToTreeCC
{

    # the standard package
    TranslatePackagesAbstract( \&TranslatePackageToTreeCC);

};

1;
