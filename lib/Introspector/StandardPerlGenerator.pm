package Introspector::StandardPerlGenerator;

#################################################################
#
# MODULE  : StandardPerlGenerator.pm
# Author  : James Michael DuPont
# Status        : In Use
# Generation    : Second Generation
# Category      : Code Generator
# Description   : Writes out nice and simple perl classes
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

# f StandardPerlGenerator::CreatePackagePerl
# debug b StandardPerlGenerator::CreatePackagePerl
# b StandardPerlGenerator::TranslatePackageToPerl
# exports TranslatePackagesToPerl
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(TranslatePackagesToPerl);

use strict;
use warnings;
use File::Path;

#my %eventhandler;
#my %event_types;
#my $basepackage = "Introspector";

use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::MetaType;
use Carp qw(confess);
use Introspector::Eval;
use Introspector::CrossReference; # Who uses what, GetUsersH
#use B::IntrospectorDeparse; # turn the code into strings
#my $deparse = undef;# the deparse object

sub Inheritance($$)
{
    my $repository= shift;
    my $typeobj =shift;
    my %parentsseen; # for multiple inheritance
    map {
	my $totype = $_;	
	if (not $parentsseen{$totype})
	{	
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
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance

    return keys %parentsseen;

}


#############################################################
sub Class   ($$)
{
    my $repository= shift;
    my $name = shift; 
    return "
package $repository->{basepackage}::${name};

";
     
};

sub InterfaceClass($$)   {
    my $repository= shift;
    my $name = shift; 
    return "
# interface part of the GCC Introspector Project\n

package $repository->{basepackage}::${name};

";

};


# put all of these into a ISA
sub Inherits($$)
{
    my $repository= shift;
    my $name = shift;
    #$package\.
    return "introspector::$name "; # like in uml core
};

sub ImplementsInterface ($$)
{
    my $repository= shift;
    my $name = shift; 
    return "\t introspector::$name "; # Put in the header
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
    
    my $typeobj = Introspector::ModifyClasses::FindClass($repository,$type);
    my $ret;
    my $builtin= $typeobj->{"built-in"}; # the built in class
    if ($builtin)
    {

#	$ret = "\t  '_$name';\t\t\t\t\#$comment\n";
################################################################
    	
    }
    else
    {
#	$ret = "\tattr  '_$name'\t\t\t=>\'introspector::$type\';\t\t\t \#$comment\n";
    }


# make get and set routines for scalars for now
	$ret .= "sub  Get" . $name . "
                {
                          my \$self = shift;
                          return  \$self->{_$name};
                };
";
################################################################
	$ret .= "sub  Set" .$name ."
                {
		    my \$self = shift;
                    my \$newval = shift;
		    return  \$self->{_$name} = \$newval;
                };
";

    return $ret;

};
#############################################################
# here we will try and translate between two object models
sub CreateEventHandlersPerl($$$$$) #b StandardPerlGenerator::CreateEventHandlersPerl
{
    my $repository= shift;
    my $type     = shift;
    my $typeinfo = shift;
    my $pack     = shift;  # the package object
    my $package_name     = shift;  # the package object
    my $subbodies=""; # return
#sort keys %{$repository->{eventhandler}}
    if ($repository->{eventhandler}{$type})
    {      
	map 
	{
	    my $eventtype = $_;
	    my $code_str = $repository->{eventhandler}{$type}{$eventtype};

	    my $method_name = $repository->{event_types}{$eventtype}{"MethodName"}; # the type of event	    		    
	    print  "Going to add method $method_name " . $code_str . "to package $type\n";
	 
	    ###########	    ###########	    ###########	    ###########	    ###########
	    #  
	    ###########	    ###########	    ###########	    ###########	    ###########
	    my $code_text = "{ \n #todo\n };";
	    #$deparse->coderef2text($code_str);

	    # remove the package statment
	    $code_text =~ s/\n\s*package\s*(.+)\s*;\s*/\# package $1 removed\n/g;
	    
	    my $subbody = "
####################################################
#package $package_name;
sub $method_name # $eventtype
$code_text;

";
	    print $subbody;
	    $subbodies .= $subbody; # collect all method bodies
	} keys %{$repository->{eventhandler}{$type}};
    }


    return $subbodies;
}

# this should be replaced by something more dynamic
sub CreateXMLPrint($$$$)
{
    my $repository= shift;
    my $type     = shift;
    my $typeinfo = shift;
    my $pack     = shift;  # the package object
    # loop over the attributes
    # refs
    # values
    my $printstmt = "\$xmlstr .= \$tabstr . ";

    my $method_body = ""; # EMPTY
    $method_body .= "return \$xmlstr;\n"; # return a string!
    
    return  "
sub  PrintXML
{
  my \$self = shift;
  Introspector::XMLPrinter::printObjectXML(\$self);
};
";
}

sub CreatePackagePerl($$$$) ## StandardPerlGenerator::CreatePackagePerl
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

    my $methods = CreateEventHandlersPerl ($repository,$id,$typeobj,$package_name,$package_name);# Install the methods

    $methods  .= CreateXMLPrint($repository,$id,$typeobj,$package_name);


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
	    $inherits .= ImplementsInterface($repository,TranslateName($repository,$totype));	    
	    #push @tovisit,TranslateName($totype);
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance
    # to visit
    if (@tovisit)
    {
#	$inherits .= ImplementsInterface(
#					 join(
#					      ","
#					      ,
#					      @tovisit
#					      )
#					 );
    }

    
    # add handling for associations
    $members .= " ";

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
	$members .= Member($repository,
			   $fieldname,
			   $repository->{baseclass},
			   "MultiType : $types");

    } keys %{$rFields->{refs}{multi_type}};
    #########################################################################

    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};	
	my $types  =  join (",",(keys %{$fieldtype}));
	$members .= Member($repository,
			   $fieldname,$repository->{baseclass},"Optional Multi Type : $types");

    } keys %{$rFields->{refs}{optional_multi_type}};
    #########################################################################

    #########################################################################

    my $uses  = 
	join ("\n",
	     map 
	      { 
		  if ($_)
		  {
		      "use ". $repository->{basepackage} . "::$_;" ;
		      
		  }
		  else
		  {
		      "# use unknown";
		  }
	      } GetUsedA($repository,$package_name));
	    
 
#    my @modules_used = Introspector::dynload::GetExternalModules($id); # check the field names from the last run    

$uses .= "
use ". $repository->{basepackage} . "::" . $repository->{baseclass} .";";
    
    return "

$pack

# INHERITS
\@ISA = qw[ $inherits ];

# USES
$uses

sub new # simple contructor with no implementation
{
    my \$proto = shift;
    my \$class = ref(\$proto) || \$proto;    
    my \$self = {};
    bless (\$self,\$class);
    return \$self;

}


# MEMBERS
$members 

#METHODS
$methods

sub GetAttrs
{
   my \$self = shift;
   return \$self;
}

sub GetData
{
    my \$self = shift;
    return \$self;
}

sub test
{
    my \$self = shift;
    print 'test ". $repository->{basepackage}  . "::$package_name\n'  ;
}

1; # return a true
" ; # all the code at once!

}



sub TranslatePackageToPerl($$)
{
    my $repository= shift;
    my $type = shift;
    my $package_name =  TranslateName($repository,$type);             # the name of the package "node_base"
    my $typeinfo = Introspector::dynload::lookup($repository,$type);
    my $package = CreatePackagePerl ($repository,$type,$typeinfo,$package_name);	# create load and test the package	

    my $outdir = "./".$repository->{basepackage};
    mkpath $outdir;

    open PERLOUT,">" . $outdir . "/$package_name.pm" or die "cannot open $outdir/$package_name.pm";
    my $time =  scalar(localtime(time()));
    print PERLOUT "
#  Package $package_name part of the GCC Introspector Project 
#  Copyright James Michael DuPont 2001
#  Licenced under the Perl Artistic Licence
#  Package generated at $time
";
#    print PERLOUT "package $repository->{basepackage};\n";
    # now remove any package statements in the code

    print PERLOUT $package;

    close PERLOUT;



#    $package->generate_code(); # this creates the code on the fly using closures
}

sub TestPackage
{
    my $repository= shift;
    my $type = shift;
    my $package_name =  TranslateName($repository,$type);             # the name of the package "node_base"

    # now use the package and test it
        my $classname = $repository->{basepackage} . "::$package_name";
    Eval::safe_eval "
	# use the package
	use $classname;
	my \$x = new $classname;
	\$x->test;
#        \$x->PrintXML(1); # take this out for now
    ";

}
sub TranslatePackagesToPerl($)
{
    my $repository= shift;
#    $deparse = new B::IntrospectorDeparse;
    # the standard package
    
    my $package   ="Introspector";
    my $BaseClass = TypeRef($repository,"base");
    my $rootclass =   "node_base";
    $repository->{rootclass} =$rootclass;
    $repository->{baseclass} =$BaseClass;
    $repository->{package} =$package;
    $repository->{basepackage} = $package;
    TranslatePackagesAbstract($repository, \&TranslatePackageToPerl);

 #   $deparse = undef;
};

sub TestPackages($)
{
    my $repository= shift;
    TranslatePackagesAbstract($repository, \&TestPackage);
}

1;


