#! /usr/local/bin/perl 
################################################################
# Author        : James Michael DuPont
# Status        : To Update
# Generation    : Second Generation
# Category      : Main Driver
# Description   : Coordinates all the modules

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

#
package intrspctr;

=head1 NAME 

intrspctr - IntrOspEctOr Driver

The Introspector main driver routine
 
=head1 SYNOPSIS

  use SamplePackage;
  blah blah blah

=head1 DESCRIPTION

This is the main driver for introspector project


=head2 EXPORT

The main routine does not export anything.

=head1 AUTHOR

James Michael DuPont

=head1 COPYRIGHT

Copyright 2001 James Michael DuPont

=head1 LICENCE

Licence : Perl Artistic Licence 

=head1 SEE ALSO


L<Introspector>
L<gcc>
L<perl>

=cut

if ($] > 5.61)
{
    do LoadIntrospector; 
# Introspect &LoadIntrospector::runimport(); # try calling it manually
}
use strict;
use warnings;
use Introspector;
use Introspector::LoadNodes;        # LOAD THE NODES FROM A DUMP FILE
use Introspector::NodeVisitors;
use Introspector::gcc;
use Data::Dumper;
use Introspector::TranslateClasses;
use Introspector::DebugPrint;
use Introspector::FileHandling;
use Introspector::MetaType;
use Introspector::Breaker;
use Introspector::XMLPrinter;
use Introspector::Repository;
use Introspector::database::queries;

my $VERSION = '0.02'; # we are on the second version

#Introspector.pm:90:	$LoadNodes::relout = $relout;
#Introspector.pm:93:	$LoadNodes::vals = $valsout;
#Introspector.pm:96:	$LoaNodes::PASS2XML = $pass2out;

#  ########################################################################
#  # Used by class contract
#  ########################################################################
#  our $attr;                # attributes
#  our $classname;           #
#  our $clause;              #
#  our $ctor;                #
#  our $current;             # Current object
#  our $depth;     # dcopy
#  our @class_dtors;
#  our @context;
#  our @value;
#  ########################################################################
#  ########################################################################

#  ### Introspector  ###############
#  our $BaseClass;   # node_base- the base class of the componenent being created
#  our $PASS2XML;    # File handle for XML output object
#  our $inputbase;   # loader input files
#  ###########################
#  our %type; # MetaInfo::DeclareID:$type{$type}->{$id}=$identifiers{$id}; # store the index by type
#  our %types;   # dynload,                 # read from type_overview.pm
#  our %usage;   # CrossReference
#  our %waiting; # LoadNodes::CheckDependancy
#  ######Gcc
#  our $nodes;
#  our $users;			# relationship id uses    id 
#  our $used;			# relationship id used by id 
#  our %tovisit;
#  #gcc::node::level_pass_types
#  our $types;   # our %tovisit; # gcc::PostProcess         
#  #    my $out = OpenOutputFile("type_overview_new.pm");#
#  #    $types->{$type}->{count}++; # add to the count    # count the types
#  #    $types->{$type}->{vals}->{$field}++; # the types of fields
#  #    $types->{$type}->{$attribute_string}->{count}++; process_references 
#  #    $types->{$type}->{$attribute_string}->{refs}->{$ref}->{$othertype }++;# the referenced typs
#  #    $types->{$othertype}->{std}->{refd}->{$ref}->{$type      }->{$attribute_string}++; # refererenced types
#  # gers written to field_overview_new
#  our $fields;  # our $fields;  # gcc::process_values
#                # fieldname --> fieldtype               = count  # simple field
#                # fieldname --> fieldtype --> othertype = count  # reference field
#  # this is a temporary object created by the parsing of fields
#  our $self;			# this is created by the individual function calls,
####################################################################################

####################################################################################
####################################################################################
# CREATE A TABLE OF WEIGHTS.
#   1. Create a table of possible relationships
#   2. Create a table of loops, by processing the nodes depth first 
#      starting with the nodes as identifiers.
# when a cycle is detected, register it based on type and relationship, not by value.
    # break at NodeVisitors::ProcessIdentifier
#   3. Break the loops by introducing weights.
####################################################################################
####################################################################################

####################################################################################
## USED BY THE ITERATOR 
####################################################################################
#package ITERATOR;
sub LoadWeights($)
{
    my $repository = shift;

    
    if(ExistsFile($repository,"weights.txt"))
    {
	
	my $weightf=OpenReadFile($repository,"weights.txt");
	my $i =0;
	while (<$weightf>)
	{	
	    chomp;
	    my $line = $_;
	    map 
	    {
		$i++;
		# is there a hash at the beginning
		if ($_ !~ /^\#/)
		{
		    $repository->{weights}->{$_} = $i; #store the position as the weight
		}
	    } 
	    split(/\n+/,$line);
	};	
	close $weightf;
	$repository->{maxweight}= $i;
    }
}

####################################################################################
####################################################################################

#my %links; # the connections betweek nodes
# NAME          XML      VARIABLE
# TO            to       ${$node->id};        
# RELATIONSHIP  rel      $relationship
# FROM          from     ${$other_node->id}

#	$links{${$node->id}}->{count}++; # How many nodes
#	$links{${$node->id}}->{node}     = $node;          # THE NODE TO PROCESS                    OBJECT

#       lowest weight input object
#	$links{${$node->id}}->{lowestw}  # LOWEST WEIGHT INPUT into this node that was found so far
#	$links{${$node->id}}->{lowestw}  = 

# lowest node
#	$links{${$node->id}}->{lowestn}  = $other_node;    # THE OTHER NODE PROCESSED               OBJECT
#	$links{${$node->id}}->{lowestn}  # LOWEST N

# lowest relationship
#	$links{${$node->id}}->{lowestr}  = $relationship;  # THE RELATIOSHIP BETWEEN THE TWO NODES  STRING
#	$links{${$node->id}}->{lowestr}  = undef;	

# forward?
# ProcessLinks::push(@{$links{${$other_node->id;}}{'forward'}{$w};}, $node);
# forward is an array of nodes that leave a given node
#       $links{${$node->id}}->{forward}  = undef;    


# The type is gotten by NodeVisitors::GetNodeType
# FROMTYPE      fromtype $other_type     ot  
# FROMNODE      fromnode $other_node  

# WEIGHT        weight   $weight;        # THE WEIGHT OF THE LINK                 INTEGER
# RELATIONSHIP  rel      $relationship
# LOWEST        lowest   $lowestw

# TOTYPE        totype   $type
# TONODE        to       $node

 ###################################################    	



# CALLED FROM TranslateClasses::EventHandlerOverride
# which is called by GCC::ProcessRefs
# called by GCC::FinishPass1, 
# GCC::DependancyResolved  -->GCC::CheckDependancy
# GCC::CheckDependancy     -->GCC::NoDependancy       # if wait = false
# GCC::NoDependancy        -->GCC:DependancyResolved     
# GCC:DependancyResolved   -->GCC::CheckDependancy    # one dependancy resolved

#################################################################################################################
#################################################################################################################
# 
#################################################################################################################
#################################################################################################################

#gcccompiler-->c-dump->generate_perl->node
#CALL(gcc::node-->NodeProcess::PreProcess)
            #CALL(NodeProcess::PreProcess-->ProcessValues)
            #CALL(NodeProcess::PreProcess-->node->OnFirstVisit)
#CALL(gcc::node-->process_values($reference))

########################################################
#CALL(intrspctr::main-->GCC::PostProcess)
#CALL(GCC::PostProcess-->GCC::preprocess)
#CALL(GCC::PostProcess-->GCC::process_references)
#CALL(GCC::process_references-->gcc::visit_users)
#CALL(GCC::visit_users-->NodeProcess::PostProcess)
#CALL(CALLBACK(NodeProcess::PostProcess)-->$node->OnPointersVisited)
#CALL(CALLBACK(NodeProcess::PostProcess)-->$node->PrintXML)
#CALL(CALLBACK(NodeProcess::PostProcess)-->ProcessRefs)
#                                     CALL(ProcessRefs-->CallBack(OtherNode,OnUsed)
###########################################################################################################
#                                                                                                         #
#CALL(DependancyResolved-->CheckDependancy)1    <-------------------------------+                         #
#                     CALL(CheckDependancy-->NoDependancy)                      |                         #
#                                       CALL(NoDependancy-->DependancyResolved) |Recurse!                 #
#                                       CALL(NoDependancy-->FinishPass1)                                  #
#                                                      CALL(FinishPass1-->ProcessValues($self,$node))     #
#                                                      CALL(FinishPass1-->ProcessRefs($self,$node))       #
#                                                                    CALL(ProcessRefs-->CallBack(OtherNode,OnUsed)
#                                                      CALL(FinishPass1-->$node->OnPointersVisited)
#                                                                                                         #
###########################################################################################################


sub HandleWeight($$$$) # FROM-NODE, RELATIONSHIP, OTHER_NODE
{
    my $repository = shift;
    my $node = shift;          #    my $self = shift;             # A NODE OBJECT
    my $relationship = shift;  #    my $Field  = shift;       # THE RELATIONSHIP TO LOOK AT
    my $other_node = shift;                                       # the other node other 

    my $type            = Introspector::NodeVisitors::GetNodeType($node);       # TYPE OF NODE
    my $linkobject      = $repository->{links}{${$node->id}};                   # the link leading to this object
    my $attrs           = Introspector::NodeVisitors::ProcessAttributes($node); # CALLBACK FOR ATTRIBUTES

    # now weight the relationship
    my $weight = $repository->{weights}->{$relationship}; 

# The other object
    my $other_type= Introspector::NodeVisitors::GetNodeType($other_node);       # TYPE OF NODE
    my $otherlinkobject = $repository->{links}{${$other_node->id}};             # the other object

    print "<VisitWeight1 ";                       # this weighted path is being walked
    print "to=\"".   ${$node->id}  . "\"";
    print "rel=\"".  $relationship . "\"";
    print "from=\"". ${$other_node->id} . "\"";
    print ">\n"; # what node we have seen	

    # there is no lowest weight set, that means it has not been visited
    # INIT THE NODE 
    if (! $linkobject->{lowestw}) 
    {
	$linkobject->{count}++;                 # what node we have seen	
	$linkobject->{lowestw}  = $repository->{maxweight};   # $maxweight is a max weight constant
	$linkobject->{lowestn}=                 # the lowest node that leads to this one
	    $linkobject->{lowestr}=             # the relationship that leads to this node
		$linkobject->{forward}=undef;   # the nodes are nulled out
    }

    # is the other object linked
    # INIT THE NODE
    if (! $otherlinkobject->{lowestw} ) 
    {
	$otherlinkobject->{count}++;               # what node we have seen	
	$otherlinkobject->{lowestw}  = $repository->{maxweight}; # $maxweight is a max weight constant
	$otherlinkobject->{lowestn}  = undef;      # the lowest node that leads to this one
	$otherlinkobject->{lowestr}  = "forward";  # we dont know what relationship leads to this node
        $otherlinkobject->{forward}  = undef;      # 
    }
    # lowest weight
    my $lowestw  = $linkobject->{lowestw};  
    my $lowestn  = $linkobject->{lowestn};
    my $lowestr  = $linkobject->{lowestr};	    

# LOOKUP THE WEIGHT of the object
# 
    if (not $weight)
    {
#	warn "<unknown relationship=\"$relationship\"/>\n";
    }
    else
    {
	# now find the lowest weight in the bunch
	print "<VisitWeight2 to=\"". ${$node->id} . "\"";
        print "rel=\"". $relationship      . "\" ";
        print "from=\""  . ${$other_node->id} . "\" ";
        print "weight=\"$weight\" ";
        print "lowest=\"$lowestw\" ";
        print "totype=\"$type\" ";
        print "fromtype=\"$other_type\"/>\n"; # what node we have seen	    
        if ($weight < $lowestw)
         {
	     if ($lowestw ne $repository->{maxweight})
	     {
		 # overwrite a existing value, a lowest node has been found
		 print "<Replace id=\"" . $linkobject->{lowestr} . "\" with=\"" . $relationship . "\"/>\n"; 	
	 } 
	$linkobject->{node}     = $node;          # THE NODE TO PROCESS                    OBJECT
	$linkobject->{lowestw}  = $weight;        # THE WEIGHT OF THE LINK                 INTEGER
	$linkobject->{lowestn}  = $other_node;    # THE OTHER NODE PROCESSED               OBJECT
	$linkobject->{lowestr}  = $relationship;  # THE RELATIOSHIP BETWEEN THE TWO NODES  STRING

        print "<SaveWeight from=\"". ${$node->id} . "\" type=\"". $type . "\" rel=\"".
          $relationship      . "\" to=\"" . 
          ${$other_node->id} . "\" othertype=\"$other_type\" weight=\"$weight\" lowest=\"$lowestw\">\n"; # what node we have seen	    
         print "<New_Relationship rel=\"" . $linkobject->{lowestr} . "\" ";
         print "weight=\"" . $linkobject->{lowestw} . "\"/>\n";
         print "</SaveWeight>";

    }
    elsif ($weight == $lowestw) # duplicate name for example!
    {
#	$repository->{links}{${node->id}}->{lowestw}  = $weight; 
#	$repository->{links}{${node->id}}->{lowestn}  = [$repository->{links}{$node->id}->{lowestn},$other_node]; # create a tree
#	$repository->{links}{${node->id}}->{lowestr}  = $relationship;
      }
    }
   print "</VisitWeight1>\n"; 

}

sub HandleNode($$$$) # FROM-NODE, RELATIONSHIP, OTHER_NODE
{
    my $repository = shift;
    my $node = shift;          #    my $self = shift;             # A NODE OBJECT
    my $type            = Introspector::NodeVisitors::GetNodeType($node);       # TYPE OF NODE
    my $linkobject      = $repository->{links}{${$node->id}};                   # the link leading to this object
    my $attrs           = Introspector::NodeVisitors::ProcessAttributes($node); # CALLBACK FOR ATTRIBUTES

    my $relationship = shift;  #    my $Field  = shift;       # THE RELATIONSHIP TO LOOK AT
    # now weight the relationship
    my $weight = $repository->{weights}->{$relationship}; 

# The other object
    my $other_node = shift;                                       # the other node other 
    my $other_type= Introspector::NodeVisitors::GetNodeType($other_node);       # TYPE OF NODE
    my $otherlinkobject = $repository->{links}{${$other_node->id}};             # the other object

    print "<VisitWeight1 ";                       # this weighted path is being walked
    print "to=\"".   ${$node->id}  . "\"";
    print "rel=\"".  $relationship . "\"";
    print "from=\"". ${$other_node->id} . "\"";
    print ">\n"; # what node we have seen	
   print "</VisitWeight1>\n"; 

}

# process the linkes, use the weights
sub ProcessLinks($)
{
    my $repository = shift;

#    my $rels = $repository->{rels};
    foreach my $id (keys %{$repository->{links}})
    {
#    ${node->id}
# add in the forward chain	
	my $node = $repository->{links}{$id}->{node};
	my $other_node = $repository->{links}{$id}->{lowestn};
	if (!$other_node)
	{
	  # if the linke was only created via a forward, 
	  # it has no nodes that go anywhere
	  print "<bad_forward id=\"$id\"/>";
	}
	else
	{
	    my $otherlinkobject = $repository->{links}{${$other_node->id}};
	    $otherlinkobject->{node}  = $other_node;
	    my $ot   = NodeVisitors::GetNodeType($other_node);
            my $type = NodeVisitors::GetNodeType($node);
     	    my $w    = $repository->{links}{$id}->{lowestw} ;
            my $r    = $repository->{links}{$id}->{lowestr};     
            print "<Forward from=\"" . ${$other_node->id} . "\" weight=\"$w\" to=\"" . ${$node->id} . "\"/>\n";
    
        # VERY IMPORTANT
push (
      @{$repository->{links}                       # IN THE LINKS
	{
	    ${
	    $other_node->id          # OTHER NODE
	    }}->{
		'forward'              # FORWARD NODE
		}->{
		    $w               # The weight
		    }
  },
    $node
    ); # store an array of nodes by weight
           # Weight- array of ids

	if (! $w ) { 
	    warn "Weight missing $id -> $type". Dumper($repository->{links}{$id});       
	    }
	if (! $r ) { 
	    warn "Rel missing $id -> $type" . Dumper($repository->{links}{$id});
	}
	$repository->{rels}->{"$type\t$r\t$ot\t$w"}->{count}++;
	$repository->{rels}->{"$type\t$r\t$ot\t$w"}->{from} = $ot;
	$repository->{rels}->{"$type\t$r\t$ot\t$w"}->{to} = $type;
	$repository->{rels}->{"$type\t$r\t$ot\t$w"}->{rel} = $r;
	$repository->{rels}->{"$type\t$r\t$ot\t$w"}->{weight} = $w;
      }
    }
}

# print the relationships
sub PrintRelationships($)
{
    my $repository = shift;
#    my $rels = shift;
    print "<relationships>";
    foreach my $id (keys %{$repository->{rels}})
    {
	my $price = $repository->{rels}->{$id}->{count} * $repository->{rels}->{$id}->{weight};
	print "<relationship price=\"" .$price               . "\" ";
	print "weight=\"" .$repository->{rels}->{$id}->{weight} . "\" ";
	print "count=\"" .$repository->{rels}->{$id}->{count}  . "\" ";
	print "from=\"" . $repository->{rels}->{$id}->{from}  . "\" ";
	print "rel=\"" .$repository->{rels}->{$id}->{rel}    . "\" ";
	print "to=\"" .$repository->{rels}->{$id}->{to};
	print "\"/>\n" ; # the results
    }
    print "</relationships>";
}

#################################################################################
# the object seens so far 
# part of a 
# interation/path/route
# visitor/tourist/interator
# visit/tour/traversal
#my %seen;  # to avoid cycles, we use the seen.

#################################################################################

sub ProcessToDo($$)
{
    my $repository = shift;
    my $todo = shift;
    my $stack = shift;
    my $id = pop @{$todo};

#    print "\t" x ($#$todo +1);
    print "<POP id=\"$id\" size=\"". ($#$todo +1) ."\"/>\n";
    # why are they being POPPED in the wrong order? 
#    print "\t" x ($#$todo +1);
    PrintNode($id);  # 

    my $from     = $repository->{links}{$id}->{node};     # TO   NODE
    my $toobjs       = $repository->{links}{$id}->{forward};  # FROM NODE
    if ($toobjs)
    {
	foreach my $weight (sort {int($a) <=> int($b)} keys %{$toobjs})
	{
#	  print "<Handle Weight=\"$weight\"/>\n";
	    if ($weight) # the weight
	    {
		my $toids = $toobjs->{$weight}; # look up the objects with this weight
	        foreach my $toobj (@{$toids}) # all the ids with the same weight
		{
		    my $toid = ${$toobj->id};# the object
		    if ($toid)
		    {
			if (!$repository->{seen}{$toid})
			{
			    print "<PUSH id=\"" .$toid ."\"/>";
			    unshift(@{$todo},$toid); # push it on, what order?
			    push (@{$stack},$toid); # push it on
			    $repository->{seen}{$toid}++;# dont visit twice
#			    print "\t" x ($#$todo +1);
			    print "<REL from=\"$id\" to=\"$toid\" lev=\"". ($#$todo +1) ."\"/>\n";
			    #PrintNode($toid);
			    $repository->{seen}{$id}++; # mark a node a seen
			}
		    }
		}
	    }
        }
    } # toobject
}
#################################################################################
#################################################################################

sub ChainBack($$)
{
    my $repository = shift;
    # uses global SEEN
    my $startid = shift;
    my $id =$startid;
    return unless $id;
    return if ($repository->{seen}{$id});
    $repository->{seen}{$id}++;# dont visit twice
    my @stack;
    print "<RootVisit id=\"$id\">";

    ###### FORWARD CHAIN
    $id = $startid;
    # is the from pointed to?, the go back to who points to it.    
    my @todo;
    push @todo,$id;
    while (@todo)
    {
	ProcessToDo(\@todo,\@stack);
    }
    print "</RootVisit>";
}
#################################################################################
#################################################################################
# visit the links
sub VisitLinks($)
{
    my $repository = shift;
    foreach my $id (sort {int($a) <=> int($b)} keys %{$repository->{links}})
    {       
	# Sort the links by id
	ChainBack($repository,$id);
    }
}
#################################################################################
#################################################################################
#################################################################################



#  sub PostProcess($)
#  {
#      my $repository = shift;
#    #gcc::PostProcess; # post process the nodes, oh and call the callbacks
#      map # lets make this really simple!
#      {
#        NodeProcess::PostProcess ($repository,
#  				$_,				
#  				); ## all the refences are in place and all information is there
#      } 
#      values %{$gcc::nodes};    
#      # print Dumper(\%NodeVisitors::identifiers); # all the indentifiers
#      # print Dumper(\%NodeVisitors::Modules);     # all the modules
#  };

sub MainLoadNodes($)
{
    my $repository = shift;
    my $filename = shift;
#    my $process_node = do {print "µ"};
    
  LoadNodes::LoadNodes(
		       $repository,
		       $filename, # incrementally load the nodes
#		       $process_node,
		       1 # just load one!
#		       -1 # do them all!
		       );

}

sub CustomizeClassesMain($)
{
    my $repository = shift;
    # now we will install the processing of the nodes into the base classes as needed
    # now add a method for on used
  Introspector::TranslateClasses::EventHandlerOverride( $repository,# this will override the event handler in a class
					  "OnUsed", # when the node is used
					  'base', 
					  \&ProcessLinks# previously HandleWeight # redirect to an existing sub
					  ); # when an ID is used, call this function!
};



# The main
sub main
{
    my ($filename) = @ARGV; # the name of the dump file to load
    $filename = "test_tree.pl" unless $filename; # the name of the perl file to read in

    my $repository = new Repository();
    Introspector::gcc::setrepository($repository);

# TODO
#    my $conn = new Introspector::database::queries;
#    $repository->{conn} = $conn; # grab a connection!
   
    my $debug= OpenOutputFile($repository,"DEBUG.XML");
    select $debug;
    print "<DEBUG>";

#   ITERATOR OBJECT
    LoadWeights($repository);# load the weights of the travesal
    print "<ReadNodes>";
    my $customizeclasses = \&CustomizeClassesMain;
    my $loadnodes = sub {print "Skip loading!"};
	#\&MainLoadNodes;

#  Introspector::Breaker::breakpoint();
  Introspector::start($repository,
		      $filename,
		      $loadnodes,
		      $customizeclasses
		      );

    print "</ReadNodes>";
########################################################
#    my %rels;
    print "<ProcessLinks>";
    ProcessLinks ($repository);#,\%rels
    print "</ProcessLinks>";
########################################################
# Print them out
    PrintRelationships ($repository);#,\%rels
# NOW WE WILL VISIT THE CHAINs
########################################################
    print "<VisitLinks>";
    VisitLinks ($repository);
    print "</VisitLinks>";
########################################################
    print "</DEBUG>";
    CloseFile ($repository,$debug);
    select STDOUT;


    my $typereport= OpenOutputFile($repository,"TypeReport.txt");
    select $typereport;
    Introspector::MetaType::TypeReport($repository);
    CloseFile ($repository,$typereport);

##    $conn->disconnect;


}

&main;


#&LoadIntrospector::runimport(); # try calling it manually


#########################################
1;
