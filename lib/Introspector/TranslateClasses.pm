#################################################################
#
# MODULE  : TranslateClasses.pm
# Author  : James Michael DuPont
# Date    : 24.7.01
# Status        :  In Use?, to review
# Generation    :  Second Generation
# Category      :  Code Generator
# Description   :  Translates the classes created into something usefull
#                  CreateClasses  to create all the class descriptions based on the 
#                  statistics collected from the first pass over the nodes
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


package Introspector::TranslateClasses;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(TranslatePackages 
             DefineEvent
             EventHandler
             CreatePackage
             TranslateName
             TranslateClasses
             CreatePackage
	     TranslatePackagesAbstract 
             );

use strict;
use warnings;

if ($] > 5.61)
{
#    do B::IntrospectorDeparse;
}

use Carp qw(cluck confess);
use Introspector::DebugPrint;
use Introspector::MetaType;
use Class::Contract;

#my %event_types;# what types of events are available?
#my $deparse;
#my %eventhandler; # PACKAGE - EVENT - CODE


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

    $method_body .= "my \$tablevel = shift || 1;\n";
    $method_body .= "my \$xmlstr;\n";
    $method_body .= 'my $tabstr = "\t" x $tablevel;' . "\n";
    $method_body .= "$printstmt \"<". ${$pack->_name} . "\"; \n";

    # produce the attributes
    map {
	# each attribute
	my $attrname    = ${$_->_name};       
        my $valuestring  = "\$\{self->$attrname\}";
        
    
        my $getstring   = "$attrname = \\'$valuestring\\'\t";
        #my $getstring   = "$attrname =  XMLPrint($valuestring,self,$attrname)\t"; # call a function

        $method_body  .= "\t$printstmt \"$getstring\" if $valuestring;\n";
    } @{$pack->_attrs};    

    # end of the method body
    $method_body .= "\t$printstmt \">\\n\";\n";
  
    # now for the parents!
    map {
	my $basename    = TranslateName(${$_->_baseclass});       
        my $code_str = "\t $printstmt self->" . $basename . "::PrintXML(\$tablevel+1);\n"; # call the parents
#print "$code_str\n";
        $method_body  .= $code_str;
    }
    @{$pack->_inherits};   # add all the inheritance
    
    # the end of the class
     $method_body .= "\t$printstmt \"</". ${$pack->_name} . ">\\n\";\n";

    $method_body .= "return \$xmlstr;\n"; # return a string!

    $pack->add_method(new Introspector::MetaMethod('PrintXML',
				     sub { 
					 Introspector::Eval::safe_eval($method_body);
					 }
				     ));
}

sub TranslateName($$)
{
    my $repository = shift;
    my $name = shift;   
    #return "node_" .$name ;
    return TypeLookup($repository,$name);
}

# here we will try and translate between two object models
sub CreatePackage($$$$)
{
    my $repository = shift;
    my $id = shift;       # the name id of the object
    my $typeobj = shift;  # the type information collected from the nodes
    my $package_name = shift;
    # prefix all the classes with the word node


    my $pack = new Introspector::MetaPackage($package_name);    # create a meta package
    my @fieldnames = Introspector::dynload::GetFieldNames($repository,$id); # check the field names from the last run

    my %parentsseen; # for multiple inheritance
    # here we create inheritance
    map {
	my $totype = $_;
	
	if (not $parentsseen{$totype})
	{	
	    my $inherits = new Introspector::MetaInheritance(TranslateName($repository,$totype));
	    $pack->add_inherits($inherits); 
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{inherits}};   # add all the inheritance
    my $rFields = Introspector::dynload::CalculateOptionalFields ($repository,$id);
    map {
	my $fieldname = $_;
	# now we check if the attribute is in all objects, or is optional
#	my $isoptional = Introspector::dynload::OptionalField($id,$fieldname);
	$pack->add_attr(
			new Introspector::MetaAttribute( 
					   $fieldname
					   ,
					   "SCALAR"
					   ) # make them all scalars
			);
    } keys %{
	$rFields->{vals}{mandatory}
    };

    map {
	my $fieldname = $_;
	# now we check if the attribute is in all objects, or is optional
#	my $isoptional = Introspector::dynload::OptionalField($id,$fieldname);
	$pack->add_attr(
			new Introspector::MetaAttributeOpt( 
					   $fieldname
					   ,
					   "SCALAR"					   
					   ) # make them all scalars
			);
    } keys %{$rFields->{vals}{optional}};


    map {
	my $fieldname = $_;
	my $fieldtype = TypeLookup($repository,$rFields->{refs}{single_type}{$_});

	# now we check if the attribute is in all objects, or is optional
#	my $isoptional = Introspector::dynload::OptionalField($id,$fieldname);
	$pack->add_attr(
			new Introspector::MetaAttributeReference( 
						    $fieldname
						    ,
						    $fieldtype
#						    'SCALAR'
						    ,
						    $fieldtype
						    ) # make them all scalars
			);
    } keys %{$rFields->{refs}{single_type}};

    # all the pointers that are multiple types
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{multi_type}{$_};

	# now we check if the attribute is in all objects, or is optional
#	my $isoptional = Introspector::dynload::OptionalField($id,$fieldname);
	$pack->add_attr(
			new Introspector::MetaAttributeReferenceMulti( 
						    $fieldname
						    ,
						    "node_base"
#						    $fieldtype # a hash of types
#						    'SCALAR'
						    ,
						    $fieldtype # a hash of types
						    ) # make them all scalars
			);
    } keys %{$rFields->{refs}{multi_type}};


    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};

	# now we check if the attribute is in all objects, or is optional
#	my $isoptional = Introspector::dynload::OptionalField($id,$fieldname);
	$pack->add_attr(
			new Introspector::MetaAttributePointerMulti( 
						    $fieldname
						    ,
						    'node_base'
#						    'SCALAR'
#						    $fieldtype # a hash of types
						    ,
						    $fieldtype # a hash of types
						    ) # make them all scalars
			);
    } keys %{$rFields->{refs}{optional_multi_type}};

    # the pointer types, the go to one type, but are optional
    map {
	my $fieldname = $_;
	my $fieldtype = TypeLookup($repository,$rFields->{refs}{optional_type}{$_});
	# now we check if the attribute is in all objects, or is optional
#	my $isoptional = Introspector::dynload::OptionalField($id,$fieldname);
	$pack->add_attr(
			new Introspector::MetaAttributePointer( 
						    $fieldname
						    ,
						    $fieldtype # a hash of types
#						    'SCALAR'
						    ,
						    $fieldtype # a hash of types
						    ) # make them all scalars
			);
    } keys %{$rFields->{refs}{optional_type}};

    my $method_body = sub { 
	
	warn "<test_package name=\"$package_name\"/>\n";
	Class::Contract::PrintMetaInfo(Contract::self());# print out the meta infor	

	Class::Contract::self->OnPointersVisited();
	Class::Contract::self->OnFirstVisit();
	Class::Contract::self->OnUsed();
	Class::Contract::self->OnChain();

     };
    $pack->add_method(new 
		      Introspector::MetaMethod(
				 'test',
				 $method_body
				 )
		      );
    return $pack;
}

sub DefineEvent($$$)
{
    my $repository = shift;
    my $id = shift;
    my $params = shift;
    $params->{"MethodName"} = $id;
    print "#Registered an event type of $id\n";
    print "#$id Parameters : " .  join (",", (keys %{$repository->{event_types}->{$id}->{Parameters}})) . "\n";
    $repository->{event_types}->{$id}= $params; # just store it from now
    return  $repository->{event_types}->{$id};
}


# 'Relationship_Visited'  => {} # when a relationship between two types of nodes is visited



sub EventHandler($$$$)
{

    my $repository  = shift;
    my $eventtype= shift;
    my $package = shift; # the package
    my $body    = shift; # the constructor

    confess "event type $eventtype unknown " if not $repository->{event_types}->{$eventtype};
    debugprint "registered event type $eventtype for $package\n";
    # used is the event
    confess "event type $eventtype $package is double booked" if $repository->{eventhandler}->{$package}{$eventtype}; # store the event        
    $repository->{eventhandler}->{$package}{$eventtype} = $body; # store the event        
};

# the override can only override existing functions.
sub EventHandlerOverride($$$$)
{
    my $repository = shift;
    my $eventtype= shift;
    my $package = shift; # the package
    my $body    = shift; # the constructor

    confess "event type $eventtype unknown " 
	if not $repository->{event_types}{$eventtype};

    debugprint "registered event type $eventtype for $package\n";
    # used is the event
    die "event type $eventtype $package is not there booked" if not $repository->{eventhandler}{$package}{$eventtype}; # store the event
    $repository->{eventhandler}{$package}{$eventtype} = $body; # store the event
};

#
#
# CreateEventHandlers is an important function,
# it will install methods to be called by the visitor function
# 
sub CreateEventHandlers($$$$)
{
    my $repository = shift;
    my $type     = shift;
    my $typeinfo = shift;
    my $pack     = shift;  # the package object
    
    my $package_name =  TranslateName($repository,$type);             # the name of the package

    if ($repository->{eventhandler}{$type})
    {      
	map 
	{
	    my $eventtype = $_;
	    my $code_str = $repository->{eventhandler}{$type}{$eventtype};

	    my $code_text ="";
	    if ($] > 5.61)
	    {
#		$code_text = $deparse->coderef2text($code_str);
	    }

	    my $method_name = $repository->{event_types}{$eventtype}{"MethodName"}; # the type of event	    		    
	    my $subbody = "
####################################################
package $package_name;
sub $method_name # $eventtype
$code_text;

";

	    warn $subbody;

	    my $code_str_withself = sub  { # VERY DANGEROUS!
		no strict;		
		my $self = Class::Contract::self; # HA!
		$code_str->($self,@_); # add an extra parmeter
	    };	    

	    debugprint "Going to add method $method_name " . $code_str . "to package $type\n";
	    $pack->add_method(new Introspector::MetaMethod(
					     $method_name, # the name of the 
					     $code_str_withself        # 
					     )
			      );       
	} keys %{$repository->{eventhandler}{$type}};
    }

}

# ok, now we will translate the objects into new classes!

sub TranslatePackage($$)
{
    my $repository = shift;
    my $type = shift;


    {
        my $typeinfo = Introspector::dynload::lookup($repository,$type);


	my $package_name =  TranslateName($repository,$type);             # the name of the package
	my $package = CreatePackage ($repository,$type,$typeinfo,$package_name);	# create load and test the package

	CreateXMLPrint      ($repository,$type,$typeinfo,$package);
	CreateEventHandlers ($repository,$type,$typeinfo,$package);

#     	$package->instanciate_code(); # this creates the code on the fly using closures

#	if ($package->Load())
	{
	    my $qual_package_name ="introspector::".$package_name;
	    warn "use $qual_package_name; # TOTEST\n";
	    warn "my \$${package_name}_node= new $qual_package_name; # TOTEST\n";
	    warn "\$${package_name}_node->test(); # TOTEST\n";

	    $package->Test();
	}
#	else
#	{
#	    die "Package $type failed to load";
#	}  
#	$ret = $metapackages{$type} =$package;
#    }
	# return the object
	#   return $ret;
    }
}

# this implements a DFS on the inheritance
sub VisitInheritance($$$$$)
{   
    my $repository = shift;
    my $type = shift;       # the name of this type
    my $typeobj = shift;    # the object of this type
    my $tovisit = shift;    # the nodes to visit
    my $seen    = shift;    # the nodes seen    

    return -1 if $seen->{$type};         # have you seen me? 

    map 
    {	    
	# now visit the children
	my $typeinfo = Introspector::dynload::lookup($repository,$_); # lookup this obj
	if (! exists ($seen->{$_}))
        {
	   VisitInheritance ($repository,$_,$typeinfo,$tovisit,$seen); # recurse!
       }
    }
    @{
	$typeobj->{inherits}
    };   # add all the inheritance

    # visit the parents first
    $seen->{$type}++;         # have you seen me? 
    push @{$tovisit},$type; # push myself

};



sub TranslatePackagesAbstract($$)
{
    my $repository = shift;
    # get the top level elements
    my $TranslateFunction = shift;
    my @toplevel = Introspector::dynload::top_level($repository);    
    my $type;
    # now we will sort the nodes by thier dependancies
    my @tovisit; # the nodes to visit in order
    my %seen; # the nodes to visit in order
    # the visitor sub	
    for $type ( @toplevel)
    {	
	my $typeinfo = Introspector::dynload::lookup($repository,$type);
	# now we will see who this is derived from,
	# and if we have generated them yet!
	# use the inheritance field in the metapackage
	# no, wait use our metainfo	
	if (not $seen{$type})
	{	  
	    VisitInheritance ($repository,$type,     # the name of the object to visit
			      $typeinfo, # the object to vist
			      \@tovisit, # the stack
			      \%seen);   # have we seen anyone yet?
	}
    }
    # now we can traverse the 
    foreach (@tovisit)
    {
	$TranslateFunction->($repository,$_); # ok, now generate the package
    } 
}

# translate the packages

sub TranslatePackages($)
{    
    my $repository = shift;
    if ($] > 5.61)
    {
#	$deparse = new B::Introspector;
    }
    # the standard package
    TranslatePackagesAbstract($repository, \&TranslatePackage); 
}

1;

