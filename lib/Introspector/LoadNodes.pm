package Introspector::LoadNodes;
###############################################################################
#
# MODULE        : LoadNodes.pm
# Author        : James Michael DuPont
# Generation    : Second Generation
# Status        : To Replace by the database
# Category      : Meta Data loading
# Purpose       : to load the output of the compiler incrementally from a perl file
# Date          : 24.7.01
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
@EXPORT = qw(LoadNodes InstallCallbacks);
use Carp qw(cluck confess);
use Introspector::DebugPrint;
use Introspector::dyncall;
use Introspector::FileHandling;
#my $relout;
#my $vals;
#my $PASS2XML;

# now we will read in a file that was dumped from the compiler
sub LoadNodes($$$)
{
    my $repository = shift;
    my $filename = shift;
    die "Filename is empty" unless $filename;

#    my $statementhandler = shift;
#    die unless $statementhandler;

    my $maxcount = shift;
    die unless $maxcount;

     ############################################################    
    # now we will load the tree.pl and eval it!
    my $infile= OpenReadFile $repository,$filename;

    my $tree = new MetaPackage "gcctree";

    my $statement ="";
    my $count =0;
    while (<$infile>)
    {

	# on line could be a problem.
	#split into lines
	map 
	{	
	    $statement .= $_ . ";";
	    if ($statement !~ /use (\w+);/) # skip the use strict and use gcc!
	    {
		# do somthing!

		if ($statement =~ /node/)
		{
		    if ($maxcount > 0 )
		    {
			if ($count > $maxcount)
			{
			    return 1; # for debugging, we dont want to load all the nodes
			}
		    }
#		    if ($statementhandler)
#		    {
#			&$statementhandler($statement); # call a callback
#		    }
		    $tree->SafeEval($statement,0 ); # eval the statement, dont print it!
		    $count ++;
		}
		$gcc::self = {};			# overwrite the old self!
	    }
	    else
	    {
		$tree->use($1); # tell the meta module to use
	    }	   
	    $statement = "";             # reset the statement
	} split (/\s*;\s*/); # split into statements
	# the idea was to reverse the loading
    }
    CloseFile($repository,$infile);
}

sub CheckDependancy($$) # 
# this node has all the nodes it needs
{
    my $repository = shift;
    my $self = shift;
    die "No Self " if not $self;
    die "No Self ID" if not $self->{id};

    my $wait =0;
    foreach my $ref (keys %{$self->{refs}})
    {
	# for each type of field store the fact that it has been referenced
	# get a pointer to the other, it has been created in the ref object
	my $other = $self->{refs}->{$ref}; # who is referenced?
	# are they all there yet?
	my $otherid       = $other->{id};
	my $other_node    = $newnodes{$otherid};
	if ( not $other_node)
	{
	    # ok we are waiting for this other node!
	    $waiting{$otherid}{$self->{id}}++; #  we are waiting! for this one
	    $wait ++;
	}
    }

    # no dependancy
    if (!$wait)
    {
	my $id  =$self->{id};
	debugprint "No Dependancies for $id\n";
	NoDependancy ($id); # RECURSIVE CALL(CheckDependancy-->NoDependancy) 
    }
    return $wait;
}

sub DependancyResolved($$$) # called by NoDependancy
{
    my $repository = shift;

    # the object is not used by this other object,
    my $otherid = shift; # that other one was needed by this one
    my $thisid  = shift; # this one needed the other one
    die unless $otherid;
    die unless $thisid;
    ##############################################################    
    print "depend $otherid -> $thisid \n";	# dependancy resolved
    my $self = $nodes->{$thisid};	# a reference to the node
    CheckDependancy ($repository,$self);	# CALL(DependancyResolved-->CheckDependancy) : recalculate the dependancy of this node
};

# called by FinishPass1, which is called by NoDependancy, 
# calls CheckDependancy->ProcessRefs
sub ProcessRefs($$$$)
{
    my $repository = shift;
    my $self = shift;
    my $node = shift;
    my $outfile = shift;

    die unless $self;
    die "Node missing!" unless $node;
    die unless $outfile;

    my $typename = "node_".$self->{_type};

    foreach my $ref (keys %{$self->{refs}})
    {
	# for each type of field store the fact that it has been referenced
	# get a pointer to the other, it has been created in the ref object
	my $other = $self->{refs}->{$ref}; # who is referenced?			   
	my $otherid       = $other->{id};
	my $otherobj  = $nodes->{$otherid};
	my $othertypename = "node_".$otherobj->{_type};	
	my $other_node    = $newnodes{$otherid};

	if (!$other_node)
	{
	    # this should normally not occur
	    # processrefs should be called after all nodes are loaded.
	    # what nodes were loaded?
	    print "<MissingNode id=\"" . $other->{id} . "\" used_by=\"" . ${$node->id} . "\"/>";
    }
    else
    {
#		my $setstring = "\${\$node->$ref}=\$other_node";		

	if (($node))
	{
	    my $methodname = "Set$ref"; #$typename . "::Set
	    #if ($ret)
	    {
		my $ret = dyncall::methodcall($node,$methodname,$other_node);
#		my $ret = &{"$methodname"}($node,$other_node);
#		    $${\$node->$ref} = $other_node;
	    }
	}
	else
	{
	    warn "Other Node is bad $node $ref  $othertypename\n";
	}
#		$${\$node->$ref} = $otherid . ":" . $otherobj->{_type};

	my ($fromtype) = $node =~ /node_(.*)=/;
	my ($totype) = $other_node =~ /node_(.*)=/;
	
	# the relationships
	print $outfile join("\t",
			   (
			    $node->Getid(),
			    $fromtype, 	
			    $ref,
			    $other_node->Getid(),
			    $totype
			    )
			   ) . "\n" or die "Cannot print RELOUT $@";

	##
	## HERE WE CALL A CALLBACK!
	##                  
	$other_node->OnUsed(
			    $fromtype,# type             
			    $ref,              # field
			    $node
			    );# node
			    }
}
}

sub ProcessValues($$$)
{
    my $repository = shift;
    my $self    = shift;
    my $node    = shift;
    die unless $self;
    die unless $node;

# PROCESS ALL THE VALUES
    foreach my $field (keys %{$self->{vals}})
    { 
	my $val = $self->{vals}{$field};	# store the values of the fields that are note references
	if ($val)	{
	    my $typename = "Introspector::node_".$self->{_type};
	    my $methodname = $typename . "::Set$field";
#	    my $ret = &{"$methodname"}($node,$val);
#	    my $ret = $node->$methodname($val);
	    my $ret = dyncall::methodcall($node,$methodname,$val);
#	    $node->Set$field($val);
	}
    }
}
sub FinishPass1($$$) # FinishPass1 is called by NoDependancy
{
    my $repository = shift;
    my $nodeid = shift;
    die unless $nodeid;

    my $reffile = shift;
    die unless $reffile;

    my $self = $nodes->{$nodeid};     # this node
    my $node = 	$newnodes{$nodeid}; # ref the node

    # check the nodes
    die "self is missing Nodeid $nodeid " if not $self;
    die "node is missing Nodeid $nodeid " if not $node;

    ${$node->id} = $nodeid; # store the id of the node
    ProcessValues($repository,$self,$node); # PROCESS ALL THE VALUES  : CALL(FinishPass1-->ProcessValues($self,$node))
    ProcessRefs($repository,$self,$node,$reffile);    # PROCESS ALL THE FIELDS : CALL(FinishPass1-->ProcessRefs($self,$node))
    $node->OnPointersVisited(); # now we have processed all the references : CALL(FinishPass1-->OnPointersVisited)
# PRINT OUT THE NODE
# print to the pass1.xml
#print PASS1XML $node->PrintXML;
}

sub NoDependancy($$$) # this node has all the nodes it needs
{
    my $repository = shift;
    my $thisid= shift;    # called 
    my $reffile = shift;

    die unless $thisid;
    die unless $reffile;

    if (!$done{$thisid})    {	# now were can say yahoo!!
	debugprint "\tNode $thisid says Yeah!\n";
	$done{$thisid}++;
	FinishPass1 ($repository,$thisid,$reffile);  # CALL(NoDependancy-->FinishPass1)
	map {	       	# anyone need us, tell them.
	    my $other_who_is_waiting = $_;
	    delete $waiting{$thisid}->{$other_who_is_waiting}; # remove the dependancy of that to this!	    
	    DependancyResolved($repository,$thisid,$other_who_is_waiting); 	    # CALL(NoDependancy-->DependancyResolved)	    
	} keys %{ $waiting{$thisid}};	    
	debugprint "Finished " . $thisid . "\n";
	delete $waiting{$thisid}; # remove the dependancy of that to this!
    }	
}

sub DefaultPostProcess($$$$$) { #b LoadNodes::DefaultPostProcess
    # node is the param
    # we have all the references resolved
    my $repository = shift;
    my $self     = shift;
    my $valfile = shift;
    my $RefFile  = shift;
    my $PASS2XML = shift;

    die if not $self;
    die if not $PASS2XML;
    die if not $valfile;
    die if not $RefFile;

    my $typename = "node_".$self->{_type};
    my $node     = $newnodes{$self->{id}}; # get my node object

    if (not $node)
    {
	confess "Node missing!" . $self->{id};
    }
    
# node is the param
# ok now see if we can instanciate a derived type,
# and lets get rid of this obj distinction	    
# now we can copy the data over"
# for each values in $self
# for each references in $self	
    ProcessRefs ($repository,$self,$node,$RefFile); # CALL(CALLBACK(NodeProcess::PostProcess)-->ProcessRefs)


#    die if not $vals;# the output file

    foreach my $field (keys %{$self->{vals}})
    {
	my $toid = $self->{vals}{$field};
	# store the values of the fields that are note references


	print $valfile 
	    $self->{id}    . "\t" ;

	print $valfile
	    $typename      . "\t";

	print $valfile
	    $field         . "\t";

	print $valfile
	    $toid  . "\n";
	
    }

    if ($node)
    {
	print STDERR "!";
#	warn "Visit Node" . $node . ref($node);
	# here we call a function that has been installed into the newly created classes
	$node->OnPointersVisited(); # CALL(CALLBACK(NodeProcess::PostProcess)-->$node->OnPointersVisited);now we have processed all the refernces
	print $PASS2XML $node->PrintXML;#CALL(CALLBACK(NodeProcess::PostProcess)-->$node->PrintXML)
	}
    else
    {
	debugprint  "Missing Node for id " . $self->{id} . "\n";
    }

}; # end of sub

sub DefaultPreProcess($$) {  #b LoadNodes::DefaultPreProcess

    my $repository = shift;
    my $self = shift;    

    confess "Bad Self!" unless $self;

##########################
    if (! $self->{_type})	{
	confess "Bad Type!";
    }

    # here we select the class of the node
    my $typename = "introspector::node_".$self->{_type};	## VISIT NODE	
    DebugScratch("+");	

    # use the type
    eval "use $typename";

    # create a new node from this  this is blessed!
    my $node = new $typename;	# the new should create a object out of this one	

    
    # the preprocess must see all the nodes before the postprocess
    my $nodeid = $self->{id};
    $newnodes{$nodeid}= $node; # ref the node	# a reference to the node
    print  "NodeProcess::PreProcess\(${nodeid}\); #Seen\n;";
    
    $node->Setid($self->{id}); # store the id of the node
    ProcessValues $repository,$self,$node;#CALL(NodeProcess::PreProcess-->ProcessValues) PROCESS ALL THE VALUES
        $node->OnFirstVisit(); # CALL(NodeProcess::PreProcess-->node->OnFirstVisit) no parameters        # just for a test of the dispatch
};

sub InstallCallbacks
{
    *NodeProcess::PreProcess = *DefaultPreProcess;
    *NodeProcess::PostProcess = *DefaultPostProcess;
}

1;


