package Introspector::JavaGenerator;

###############################################################################
#
# MODULE  : JavaGenerator.pm
# Author  : James Michael DuPont
# Generation    : Second Generation
# Status        : To Review and Document
# Category      : Meta Programming Generator
# Description   : Generates Java Code from Object Description
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
@EXPORT = qw(TranslatePackagesToJava);

use strict;
use warnings;
use File::Path;

use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::MetaType;
use Carp qw(confess);

sub TranslatePackageToJava($$)
{
    my $repository = shift;
    my $type = shift;
    my $package_name =  TranslateName($repository,$type);             # the name of the package
    my $typeinfo = Introspector::dynload::lookup($repository,$type);
    my $package = CreatePackageJava ($repository,$type,$typeinfo,$package_name);	# create load and test the package	
    mkpath  "./output/java/org/gnu/gcc/introspector/";
    open JAVAOUT,">./output/java/org/gnu/gcc/introspector/$package_name.java";

    print JAVAOUT "
/**
 * Package $package_name part of the GCC Introspector Project 
 * Copyright James Michael DuPont 2001
 * Licenced under the Perl Artistic Licence
**/
";
    print JAVAOUT "package org.gnu.gcc.introspector;\n";
    print JAVAOUT "import java.util.*;\n";
    print JAVAOUT "import org.gnu.gcc.introspector.*;\n";

    print JAVAOUT $package;
    close JAVAOUT;

#    CreateEventHandlersJava ($type,$typeinfo,$package);
#    $package->generate_code(); # this creates the code on the fly using closures
}

#############################################################
sub Class   ($$)
{
    my $repository = shift;
    my $name = shift; 
    return "
/**
* class part of the GCC Introspector Project
* 
**/
public class $name";
     
};

sub InterfaceClass($$)   {
    my $repository = shift;
    my $name = shift; 
    return "
/**
* interface part of the GCC Introspector Project\n *
**/
public interface $name";

};

sub Inherits($$)
{
    my $repository = shift;
    my $name = shift;
    #$package\.
    return " extends $name"; # use the extends
#    return "public $name ihrts_$name;\n"; # 
};

sub ImplementsInterface ($$)
{
    my $repository = shift;
    my $name = shift; 
    return " implements $name\n"; # Put in the header
};
sub Member  ($$$$)
{
    my $repository = shift;
    my $name = shift;
    my $type = shift;
    my $comment = shift;
    confess  "type missing " if not $type;
    confess  "name missing " if not $type;
    $type = TypeLookup($repository,$type); # if the type was not set...
    print "MEMBER public $type $name;//$comment\n";
    return 
"
\t/**
\t* Attribute of name $name
\t* Attribute of type $type
\t*  $comment
\t**/

\tprivate $type $name;//$comment
\tpublic void set" . uc($name) . "($type _". $name .") {
\t\t$name = _" . $name . ";
\t}
              
\tpublic $type get" . uc($name) . "() {
\t\treturn $name;
\t}

";

};
#############################################################
# here we will try and translate between two object models
sub CreateEventHandlersJava($$$$)
{
    my $repository = shift;
    my $type     = shift;
    my $typeinfo = shift;
    my $pack     = shift;  # the package object
    if ($repository->{eventhandler}{$type})
    {      
	map 
	{
	    my $eventtype = $_;
	    my $code_str = $repository->{eventhandler}{$type}{$eventtype};
	    my $code_str_withself = sub  { # VERY DANGEROUS!
		no strict;		
		my $self = Class::Contract::self; # HA!
		$code_str->($self,@_); # add an extra parmeter
	    };	    
	    my $method_name = $repository->{event_types}{$eventtype}{"MethodName"}; # the type of event	    		    
	    print  "Going to add method $method_name " . $code_str . "to package $type\n";
	    $pack->add_method(new MetaMethod($repository,
					     $method_name, # the name of the 
					     $code_str_withself        # 
					     )
			      );       
	} keys %{$repository->{eventhandler}{$type}};
    }
}

sub CreatePackageJava($$$$)
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
	    #$inherits .= ImplementsInterface($repository,TranslateName($repository,$totype));	    
	    push @tovisit,TranslateName($repository,$totype);
	    $parentsseen{$totype}++;	
	}
    }
    @{$typeobj->{interface}};   # traverse all the inheritance
    # to visit
    if (@tovisit)
    {
	$inherits .= ImplementsInterface($repository,
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
	$members .= Member($repository,$fieldname,$repository->{java}{baseclass},"MultiType : $types");
    } keys %{$rFields->{refs}{multi_type}};
    #########################################################################

    # these are optionally filled out
    map {
	my $fieldname = $_;
	my $fieldtype = $rFields->{refs}{optional_multi_type}{$_};	
	my $types  =  join (",",(keys %{$fieldtype}));
	$members .= Member($repository,$fieldname,$repository->{java}{baseclass},"Optional Multi Type : $types");

    } keys %{$rFields->{refs}{optional_multi_type}};
    #########################################################################

    #########################################################################
    return  "$pack $inherits {\n"  . "\n". $members . "\n". $methods . "\n}\n" ; # all the code at once!
}



sub TranslatePackagesToJava($)
{
    my $repository = shift;

    $repository->{java}->{package}   ="org.gnu.gcc.introspector";
    $repository->{java}->{baseclass} = TypeRef($repository,"base");

    # the standard package
    TranslatePackagesAbstract($repository, \&TranslatePackageToJava);

};


# BeanInfo
#c:/downloads/netbeans-src/beans/src/org/netbeans/modules/beans/resources/templates/
#BeanInfoNoIcon.template
#import java.awt.Image;
#import java.beans.*;
#contained class
#public static class DefaultBeanInfo extends SimpleBeanInfo {
#        private static BeanDescriptor descr;
#        private static Image icon;
#        private static Image icon32;
#        ResourceBundle bundle = NbBundle.getBundle(IndentEngineBeanInfo.class);
#        private static PropertyDescriptor[] prop;
#            descr.setDisplayName (bundle.getString("LAB_IndentEngineDefault"));
#            descr.setShortDescription (bundle.getString("HINT_IndentEngineDefault"));
#    public Image getIcon (int type) {
#    public PropertyDescriptor[] getPropertyDescriptors () {
#    public BeanDescriptor getBeanDescriptor () {
#    public BeanInfo[] getAdditionalBeanInfo () {
#    public Image getIcon(int type) {
#        if (icon == null) {
#            icon = loadImage("/org/netbeans/core/resources/indentEngines.gif"); // NOI18N
#            icon32 = loadImage("/org/netbeans/core/resources/indentEngines32.gif"); // NOI18N
#        }
#        if ((type == java.beans.BeanInfo.ICON_COLOR_16x16) || (type == java.beans.BeanInfo.ICON_MONO_16x16))
#            return icon;
#        else
#            return icon32;
#    }
# Version
1;
