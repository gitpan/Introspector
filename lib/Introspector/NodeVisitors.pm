#################################################################
#
# MAIN
# MODULE  : NodeVisitors.pm
# Purpose : to allow simple debugging of the visting of nodes.
#           act as a central repository of the handling of nodes
# Author  : James Michael DuPont
# Date    : 24.7.01
# Status        : To Review
# Generation    : First Generation
# Category      : Tree Walker
# Description   : One of the first walker classes
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

package Introspector::NodeVisitors;
require Exporter;
use Class::Contract;
use Carp qw(cluck);
use Introspector::DebugPrint;

my %Modules;
my %identifiers; # the symbol table!

@ISA = qw(Exporter);
@EXPORT = (
	   VisitIdentifier,
	   SeeIdentifier,
	   %identifiers,
	   %Modules
	   );
use strict;
use warnings;

my $seen = {};
my $namelookup = {
 #   "node_indentity_type" =>{
    "mngl"   => { 
	node_function_decl  => 0
	}
    ,
    "name"   => {
	node_const_decl => 1,
	node_function_decl=> 1,
	node_type_decl=> 1,
	node_var_decl=> 1,
	
	node_enumeral_type=> 1,
	node_integer_type=> 1,
	node_record_type=> 1,
	node_union_type=> 1,
	
	node_parm_decl=> 0,
	node_field_decl=> 0
	}
    ,
    "purp" =>{
	node_tree_list => 0
	}
};


# this is called from the XML Print function when a sub node is printed
sub XMLPrint
{
    my $value= shift;     # the value of the field
    my $node = shift;     # the caller
    my $attrname = shift; # the name of the field
    my $valtype = ref $value;
    if ($valtype)
    {
	# now we can recurse via XML
#	return $value->PrintXML();;
    }
    else
    {
	return $value; # just return the value
    }
}

sub Node_OnPointersVisited
{
    my $node = shift; 
    DebugScratch("."); # this is generally usefull
}

#OnPointersVisited
sub ProcessDecl
{
    my $self = shift;
    # called for every decl there is!
    # this is power!
    AddToModule($self,$self->Getsrcp(),$self->Getsrcl());
    # call for all contained things, we will find them
}
sub AddToContainer
{
    my $parent = shift;
    my $child = shift;
#(${$self->scpe},$self);
}
sub ProcessSubDecl
{
    my $self = shift;
    ProcessDecl($self);
    # called for every decl there is!
    # this is power!
    AddToContainer($self->Getscpe(),$self);
    # call for all contained things, we will find them
}
# when a node is added to a package
# InPackage is called

sub AddToModule
{
    my $self = shift;
    my $packagename = shift;
    my $linenum = shift || -1;

    $Modules{$packagename}->{$self}++; # just store it
}

###############################################################
# this function extracts information about a node
# that we should have in class contract
# we need to know what fields are really implementations
# of associations
##############################################################
sub ProcessAttributes
{
    my $node = shift;
#    my $tabs = shift;
    my @attrs = Class::Contract::GetAttrNames ($node);     

    #print "<!-- $tabs FIELDS :". join(",",@attrs) ."-->\n";
    my $return = {
	val   => {}, # what values are there
	refs   => {}, # what referenced elements are there
	chan => undef   # what chained elements are there
    };
    map {
	my $attrname = $_;             # name of attribute

	my $val = &{
	    ref($node)  .
		"::Get" .
		    ${attrname}
    }($node); # value of attribute

        my $valtype = ref $val;        # type of value
        if ($valtype)
	{
	    if ($valtype ne "HASH")
	    {
		# skip the chain if 		
		if ($attrname ne "chan")
		{
		    # must be a references
		    $return->{refs}{$attrname} = $val;
		}
		else
		{
		    $return->{chan} = $val;
		}
	    }
	}
        else
	{
	    # attribute
	    if ($val)
	    {
		$return->{val}{$attrname} = $val;
	    }
	    else
	    {
		$return->{val}{$attrname} = '';
	    }
	}
 } @attrs;
 return $return;
}
# PROCESS THE ATTRIBUTES
sub ProcessAttrs
{
    my $attrname = shift;
    my $val      = shift;
    my $tabs    = shift;
    print "$attrname = \'$val\'\t";
}
sub GetNodeType
{
    my $val = shift;
    my ($type) = $val =~ /node_(.*)=/;
    return $type;
}
sub ProcessReference
{
    my $attrname = shift;
    my $val      = shift;
    my $stack    = shift;
    my $tabs     = shift;
    print "<!-- $tabs  Going to visit $attrname : $val -->\n";

    my ($type) = $val =~ /node_(.*)=/;

    if ($stack)
    {
	push @{$stack},"($attrname,$type)";
    }
    print "<Relationship type=\"$type\" val=\"$val\" />\n";
    #ProcessNode($val,$stack,1); # recurse
    if ($stack)
    {
	pop  @{$stack};
    }
}

sub ProcessChain
{
    my $val      = shift;
    my $stack    = shift;
    my $tabs     = shift;

    $val->OnChain(
		  # pass an anonymous subroutine reference as a parameter
		  sub {  				      
		      print "<!-- $tabs  Going to visit CHAIN $val -->\n";
		      my ($type) = $val =~ /node_(.*)=/;

		      if ($stack)
		      {
			  push @{$stack},"(chan,$type)";
		      }
		      # must be a references
		      #VisitRefsChain($val,$stack); # recurse
		      print "<chain to=\"$val\" />\n";
		     if ($stack)
		     {
			 pop  @{$stack};
		     }
		  }
    );
}


sub ProcessNode
{
    my $node = shift;
    my $stack = shift;
    my $handlechain = shift;
    if (not defined ($handlechain)) # do we process the chain or leave it for later
    {
	$handlechain =1;
    }

    ##############
    my $level =0;
    if ($stack)
    {
	my $level =@{$stack};	
    }


    my $tabs = "\t" x $level;

    my ($type) = $node =~ /node_(.*)=/;


    if ($seen->{$node}) # what has been seen
    {
	print "<noderef id =\'". $node->Getid() . "\' type=\'". $type . "\'/>\n";
	#return $node;
        # lets print it again, we are not recursing anyway!
    }
    $seen->{$node}++; # what has been seen    
    if ($stack)
    {
	print "<!-- $tabs STACK  :" . join(",",@{$stack}) . " -->\n";
    }
    # is it a chained element or normal one?
    my $fields = ProcessAttributes ($node,$tabs);    
    # Print out all the attributes as attributes 

    print "$tabs<$type ";
    my $field;
    foreach $field (
		    keys %{
			$fields->{val}
		    }
		    )
    {
	my $val = $fields->{val}{$field};
	ProcessAttrs ($field,$val,$tabs);
    }

    print ">\n"; # end of the attributes, now for the contained objects

    # Print out all the relationships as sub objects 
#    foreach $field (keys %{$fields->{refs}})
#    {
#	my $val = $fields->{refs}{$field};       
#	ProcessReference ($field,$val,$stack,$tabs);
#    }

    # Tail Recurse of the chains if need be
    if ($handlechain)
    {
	if ($fields->{chan})
	{
#	    ProcessChain ($fields->{chan},$stack,$tabs);
	}
    }

    # end the tag
    print "$tabs</$type>\n";

}


sub VisitRefsChain
{
    my $node  = shift;
    my $stack = shift;

    print "<!-- \nBEGIN CHAIN\n -->\n";
    while ($node)
    {
	print "<!-- \nSTART LINK\n -->\n";
	ProcessNode($node,$stack,0); # dont follow the chain, we will handle it
	print "<!-- \nEND LINK\n -->\n";
	$node = $node->Getchan(); # this will invalidate node on the last one!
    }
    print "<!-- \nEND CHAIN\n -->\n";


    return 1;
};


#  sub VisitRefs
#  {
#      my $node = shift;
#      my $stack = shift;
#  #    my $handlechain = shift || 1; # do we process
#      my $level = @{$stack};
#      my $tabs = "\t" x $level;
#      if ($seen->{$node}) # what has been seen
#      {
#  	print "#$tabs$node has been seen already\n";
#  	return $node;
#      }
#      $seen->{$node}++; # what has been seen    

#      my @attrs = $node->GetAttrNames;    
#      print "#$tabs -- STACK  :" . join(",",@{$stack}) . "\n";
#      print "#$tabs -- FIELDS :". join(",",@attrs) ."\n";
#      map {
#  	my $attrname = $_;
#  	my $val = ${$node->$attrname};
#          my $valtype = ref $val;
#          if ($valtype)
#  	{
#  	    if ($valtype ne "HASH")
#  	    {
#  		# skip the chain if 
		
#  		if ($attrname ne "chan")
#  		{
#  		    print "#$tabs  -- Going to visit $attrname $val $valtype\n";
#  		    my ($type) = $node =~ /node_(.*)=/;
#  		    push @{$stack},"($attrname,$type)";
#  		    # must be a references
#  		    VisitRefs($val,$stack); # recurse
#  		    pop  @{$stack};
#  		}
#  		else
#  		{
#  		    $val->OnChain(
#  				  # pass an anonymous subroutine reference as a parameter
#  				  sub {  				      
#  				      print "#$tabs  -- Going to visit CHAIN $attrname $val $valtype\n";
#  				      my ($type) = $node =~ /node_(.*)=/;
#  				      push @{$stack},"($attrname,$type)";
#  				      # must be a references
#  				      VisitRefsChain($val,$stack); # recurse
#  				      pop  @{$stack};
#  				  }
#                      );
#                 }
#  	    }
#  	}
#          else
#  	{
#  	    # attribute
#  	    if ($val)
#  	    {
#  		print "$attrname = \'$val\'\t";
#  	    }
#  	    else
#  	    {
#  		print "$attrname = \''\t";
#  	    }
#  	}
#    } @attrs;
#    return 1;
#  };


sub SeeIdentifier
{
    # the identifier is seen for the first time.
}

# when will its reference be seen?
# NAME, FROM TYPE

# b NodeVisitors::VisitIdentifier
sub VisitIdentifier
{
    my $self = shift;  # node visited?
    die "Self is missing" unless ($self);
    my $type = shift;  # visitor type?
    my $field = shift; # access by field?
    my $other = shift; # who visited?    

    if ($other)
    {
	# achtung this has a quote already!
	print "<Used id=" . $self->Getstrg() . " field=\"$field\" type=\"$type\" other=\"$other\" />\n";
    }
    else
    {
	print "<Used id=" . $self->Getstrg() . " field=\"$field\" type=\"$type\"  other=\"\" />\n";
    }
    my $othertype =ref $other;
    if ($NodeVisitors::namelookup->{$field}->{$othertype})
    {
	#add the identifier
	print "<Name_Collision/>" if $NodeVisitors::identifiers{$self->Getstrg()};
	$NodeVisitors::identifiers{$self->Getstrg()} = $self; # 
        debugprint "<Added id=\"$self->Getstrg()\"/>\n"; # 
    }
    if ($other)
    {
    # it other other one is there
    # TODO store which identifier is pointing to this node
#    $self->name->named($other); # this identifier points to that object

}
# is user a decl?
# is user a scoped?
# is user a type?
# is user a list?
};
sub NamedByIdentifier
{
    my $identifier = shift;
    return values %{${$NodeVisitors::identifiers{$identifier}->named}};
}

sub ProcessIdentifier
{
    my $identifier = shift;

    if ($NodeVisitors::identifiers{$identifier})
    {       
	map { 
	    $seen = {}; # reset the seen list!
	    print "\n<!-- NODE BEGIN -->\n";	
	    ProcessNode($_,[]);
	    print "\n<!-- NODE END -->\n";	
	} NamedByIdentifier($identifier);
    }
    else
    {
	print "<unknown id=\"$identifier\" />\n";
    }
    1;  
}


1;
#DEBUG : NodeVisitors::ProcessIdentifier($NodeVisitors::identifiers{'"tree_decl"'})
# nice break points
#        b NodeVisitors::ProcessChain
#        b NodeVisitors::VisitRefsChain
#        b NodeVisitors::ProcessIdentifier
