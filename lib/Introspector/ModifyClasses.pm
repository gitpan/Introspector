package Introspector::ModifyClasses;
################################################################
#
# MODULE        : ModifyClasses.pm
# Author        : James Michael DuPont
# Date          : 07.09.01
# Status        : Important
# Generation    : Second Generation
# Category      : Meta Data - Class manipulation API
# Description   : This is an important API for describing and manipulating classes at a high level
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
@EXPORT = ("FindClass",
	   "FindReplaceField",
	   "NameLike",
	   "FindField",
	   "AddValue",
	   "AddField",
	   "AddPointerField",
	   "AddArrayField"  ,
	   "AddHashField"   ,
	   "AddInheritance" ,
	   "AddClass"       ,
	   "AddScalarClass" ,
	   "AddBuiltInClass",
	   "RemoveField",
	   "AddInterfaceClass", # Declare an interface class
	   "AddInterface",      # Just add a simple implements to the class hash
	   "ImplementInterface", # Add in an member to implement and interface and the interface itself
	   "FindReplaceFieldInterface",   # Find and replace, but use and interface
	   "AddClassComment",	         
	   "AddMemberComment",
	   "ImplementSimpleInterface"
	   );
use strict;
use warnings;
use Carp qw(confess);
#use Introspector;
use Introspector::DebugPrint; # implementation
#######################
# Remove Field
# Part of DynLoad
# this is a very important method.
# it allows a field of a type to be deleted from a class
# we delete the fields from the derived classes and replace them 
# in the base classes
sub RemoveField($$$$)
{
    my $repository = shift;
    debugprint "RemoveField " . join (",",@_) . "\n";
    my $typename  = shift;
    my $fieldname = shift;
    my $fieldtype = shift;
    ##

    if (exists ($repository->{types}->{$typename}{std}{refs}{$fieldname}))
    {
#	debugprint " Types ($typename,$fieldname) " . join (",", keys %{$repository->{types}->{$typename}{std}{refs}{$fieldname}}) . "\n";	
	# extract the field from the hash
	delete $repository->{types}->{$typename}->{std}{refs}{$fieldname}{$fieldtype}; # if it is a ref
    }
    elsif (exists ($repository->{types}->{$typename}{vals}{$fieldname}))
    {
	debugprint " vals  ($typename,$fieldname) " . $repository->{types}->{$typename}{vals}{$fieldname} . "\n";
	# values are not subclassed into std, yet!
	delete $repository->{types}->{$typename}->{vals}{$fieldname}; # if it is a vals
    }
}

sub FindClass($$)
{
    my $repository = shift;
    my $classname= shift;

    # add new class as an abstract base class
    return $repository->{types}->{$classname};
}

# declare a new class
sub AddClass($$)
{
    my $repository = shift;
    my $classname= shift;

    # add new class as an abstract base class
    $repository->{types}->{$classname}->{abstract}=1; 
    $repository->{types}->{$classname}->{count}=0; 
    $repository->{types}->{$classname}->{id}=$classname;
};

sub AddScalarClass($$)
{
    my $repository = shift;
    my $classname= shift;
    AddClass($repository,$classname);
    $repository->{types}->{$classname}->{"built-in"}="\$";
}

sub AddBuiltInClass($$$)
{
    my $repository = shift;
    my $classname= shift;    
    my $class_definition= shift;

    AddClass($repository,$classname);
    $repository->{types}->{$classname}->{"built-in"}=$class_definition;    

}

# add in inheritance
sub AddInheritance($$$)
{
    my $repository = shift;
    my $from=shift;
    my $to=shift;
    if (! exists($repository->{types}->{$from}->{inheritshash}->{$to})) # for inheritance, preserve ordering!
    { # dont add them twice
#	print STDOUT "$from $to\n";
	$repository->{types}->{$from}->{inheritshash}->{$to}++;
	push @{$repository->{types}->{$from}->{inherits}},$to; # for inheritance, preserve ordering!
    }
}
sub AddInterface($$$)
{
    my $repository = shift;
    my $from=shift;
    my $to=shift;
    confess "From missing" if not $from;
    confess "to missing" if not $to;
    if (! exists($repository->{types}->{$from}->{inheritshash}->{$to}) ) # for inheritance, preserve ordering!
    {

	$repository->{types}->{$from}->{inheritshash}->{$to}++;
	push @{$repository->{types}->{$from}->{interface}},$to; # for implements, preserve ordering!
    }
    if (! exists($repository->{types}->{$to})) # has the interface been defined yet
    {
	AddInterfaceClass($repository,$to);
    }

}
sub AddInterfaceField($$$$)
{
    my $repository = shift;
    my $typename  = shift;
    my $fieldname = shift;
    my $fieldtype = shift;

    AddField($repository,$typename,$fieldname,$fieldtype);
    $repository->{types}{$typename}{std}{refs}{$fieldname}{interface}++; # mark as an interface fields

}

# add in a field
sub AddField($$$$)
{
    my $repository = shift;
    my $typename  = shift;
    my $fieldname = shift;
    my $fieldtype = shift;
    confess "typename" if not $typename;
    confess "fieldname" if not $fieldname;
    confess "fieldtype" if not $fieldtype;
    print  "AddField :";
    print   $typename ."\t";
    print   $fieldname."\t";
    print   $fieldtype."\n";

    $repository->{types}{$typename}{std}{refs}{$fieldname}{$fieldtype}++; # added in by me!

}

# this is a field that is OPAQUE, 
# it will not automatically be created 
# when the object is created
sub AddPointerField($$$$)
{
    my $repository = shift;
    my $typename  = shift;
    my $fieldname = shift;
    my $fieldtype = shift;
    
    return AddField($repository,$typename,$fieldname,"POINTER");
}
sub AddArrayField($$$$)
{
    my $repository = shift;
    my $typename  = shift;
    my $fieldname = shift;
    my $fieldtype = shift;
    
    return AddField($repository,$typename,$fieldname,"ARRAY");
}
sub AddHashField($$$$)
{
    my $repository = shift;
    my $typename  = shift;
    my $fieldname = shift;
    my $fieldtype = shift;
    
    return AddField($repository,$typename,$fieldname,"HASH");
}

sub AddValue($$$)
{
    my $repository = shift;
    my $typename  = shift;
    my $fieldname = shift;
    $repository->{types}->{$typename}->{vals}{$fieldname}++; # added in by me!
}

# here we look for all the fields of a type
sub FindField($$$)
{
    my $repository = shift;
    my $fieldname = shift;
    my $fieldtype = shift;
    my $found; # return hashref
    # we have a fields collection? lets use that!
    my $fields = $repository->{fields}; # get a reference to the fields
    map {
	my $recordtype = $_;	


	my $obj = $fields->{$fieldname}->{$recordtype};
	my $reftype = ref $obj;
	if ($reftype eq "HASH")
	{
	    debugprint    "FIELD $fieldname \t $recordtype \n";


#	if ( $test_type eq $fieldtype) # the exact test

	    map 
	    {
		my $test_type =    $_;

		if ( $test_type =~ $fieldtype) # the similar test
		{
		    $found->{types }->{$recordtype}++;	    # found a type
		    $found->{fields}->{$test_type}++;	    # store the fieldtypes
		}
		else
		{
		   # debugprint "TEST $test_type $fieldtype\n";
		}
	    }
	    keys %{$fields->{$fieldname}->{$recordtype}};
	}
	else
	{
	    #a value field
	    #debugprint "type value $fieldname " . ref $fields->{$fieldname} . "\n";
	    debugprint "value $fieldname\n";
	    $found->{types }->{$recordtype}++;	    # found a type
	    $found->{fields}->{'val'}++;	    # store the fieldtypes
	}
    }
    keys %{$fields->{$fieldname}}; # for each type that uses this name
    
    return $found;
};

sub NameLike($$)
{
    my $repository = shift;
    my $criteria = shift;
    return grep { 
	my $element = $_;
	$element =~ $criteria ;
	} 
    keys %{$repository->{types}}
}

# here we will replace all the instances of a field with another field.
sub FindReplaceField($$$$)
{
    my $repository = shift;
    my $fieldname = shift;    
    my $fieldtype = shift;    # this can be a wild card
    my $replace = shift;

    my $found = FindField($repository,$fieldname,$fieldtype);

    my @typelist = keys %{$found->{types}};
    my $types = $repository->{types};

    map {
	my $typename= $_;	
	# get the types record
	map 
	{
	    RemoveField($repository,$typename,$fieldname,$_); # remove the field
	}  keys %{$found->{fields}}; # iterate over found fields

	# add an inheritance that handles the role of that field
	AddInheritance($repository,$typename,$replace); # because of usage, this field has inheritance
    
	# what about the refed from this field?
	# if a field is refed
    }@typelist;

    # ok now go to this set of classes and extract the fields from them, before they are translated
    # return an array of types handled
    return $found;
}

sub ImplementSimpleInterface($$$$$$)
{
    my $repository = shift;
    my $found = shift; # the results of find
    my $oldfieldname=shift;
    my $interface_type = shift;
    my $newfieldname=shift;
    my $fieldtype=shift;

    my @typelist = keys %{$found->{types}};
    map {
	my $typename= $_;	
	# get the types record
	map 
	{
	    RemoveField($repository,$typename,$oldfieldname,$_); # remove the field
	}  keys %{$found->{fields}}; # iterate over found fields

	ImplementInterface($repository,$typename,         # the class to add to
			   $interface_type,      # the interface to derive from
			   $newfieldname,# the member to add to implement the interface
			   $fieldtype	      # the type of member to add
			   );
    
	# what about the refed from this field?
	# if a field is refed
    }@typelist;
}

# here we will replace all the instances of a field with another field.
sub FindReplaceFieldInterface($$$$)
{
    my $repository = shift;
    my $fieldname = shift;    
    my $fieldtype = shift;    # this can be a wild card
    my $replace = shift;
    my $interface_type = $replace; # the Interface
    AddClass($repository,$replace);
    my $found = FindField($repository,
			  $fieldname,
			  $fieldtype
			  );

    my @typelist = keys %{$found->{types}};
    my $types = $repository->{types};
    map {
	my $typename= $_;	
	# get the types record
	map 
	{
	    RemoveField($repository,$typename,$fieldname,$_); # remove the field
	}  keys %{$found->{fields}}; # iterate over found fields

	# add an inheritance that handles the role of that field
	#AddInheritance($repository,$typename,$replace); # because of usage, this field has inheritance

	ImplementInterface($repository,$typename,         # the class to add to
			   $interface_type,      # the interface to derive from
			   
			   # name the field how it should be named
			   $fieldname,# the member to add to implement the interface
			   $replace	      # the type of member to add
			   );
    
	# what about the refed from this field?
	# if a field is refed
    }@typelist;

    # ok now go to this set of classes and extract the fields from them, before they are translated
    # return an array of types handled
    return $found;
}


sub AddInterfaceClass($$)
{
    my $repository = shift;
    my $classname= shift;
    confess "Classname is missing " if not $classname;

    # add new interface  as an abstract base class
    $repository->{types}->{$classname}->{abstract}=1; 
    $repository->{types}->{$classname}->{isinterface}=1; 
    $repository->{types}->{$classname}->{count}=0; 
    $repository->{types}->{$classname}->{id}=$classname;

    # this is to make the database happy!
    if ($classname ne "base_interface")
    {
	AddInterface($repository,$classname,"base_interface");
    }
};

sub ImplementInterface($$$$$)
{
    my $repository = shift;
    my $classname  = shift;# the class to add to
    my $interface  = shift;# the interface to derive from
    my $membername = shift;# the member to add to implement the interface
    my $membertype = shift;# the type of member to add
    confess "classname missing " if not $classname;
    confess "interface missing " if not $classname;
    confess "membername missing " if not $classname;
    confess "membertype missing " if not $classname;

    AddInterface($repository,$classname,$interface); # add in an interface
    
    # add in a member to help implement the functionality    
    AddInterfaceField($repository,$classname,$membername,$membertype);

}

sub AddClassComment($$$)
{
    my $repository = shift;
    my $classname = shift;
    my $comment = shift;
    $repository->{types}->{$classname}->{comment}=$comment; # TODO print it out     
}

sub AddMemberComment($$$$)
{
    my $repository = shift;
    my $classname = shift;
    my $membername = shift;
    my $comment = shift;
    $repository->{types}->{
	$classname
	}->{fields}{
	    $membername
	    }->{comment}=$comment;# TODO print it out     
}


1;
