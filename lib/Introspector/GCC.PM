###############################################################################
#
# MODULE  : GCC.pm
# Purpose : Reads nodes and produce and internal structure for the package
# Author  : James Michael DuPont
# Date    : 24.7.01
# Copyright James Michael DuPont 2001
# Licence : Perl Artistic Licence 
###############################################################################

package Introspector::gcc;
use Data::Dumper;
use Carp qw(cluck);
require Exporter;
@ISA=qw(Exporter);
@EXPORT=qw(node nref ntext $nodes);
use strict;
use warnings;
use gcc::noderef;
use Introspector::NodeProcess; # for callback functionality
use Introspector::FileHandling;
our $nodes;
our $users;			# relationship id uses    id 
our $used;			# relationship id used by id 
our %tovisit;
our $types;
our $fields;
our $self;			# this is created by the individual function calls,
# for cycle problems
#my %cyclecatch;  # this is to hold all the nodes seen
#my %cyclecatch2;  # this is to hold all the nodes seen
#my $cyclecaller; # this is to hold who called.
# the self collects the fields untill they are ready to be picked up.
# {processed} says if the object has been processed
# seen and processed are different
# id is the number of the node from the compiler
# id
#############
# seen       # has it been seen
# processed  # has it been processed
############### not needed # forward    # has it only been referenced, deleted when real objects is created
# count      # the count is used per type
# used
############# integer type
# min
# max
# size
############# integer cst
# low
# high
# type
############
# refs   # what does it refer to
# vals   # what values does it have
# refd   # who refers to this object
#############
sub node
  {
    my $id = shift;		# the id of the  object 
    $self->{id} = $id;
    # the self is created my
    # store the self using id of the object as a key
    $nodes->{$id}->{seen}++; # create the object if it is not there yet.
    my $reference = $nodes->{$id};
    ######################################################
    foreach my $key (keys  %{$self})
      {	  
	  $reference->{$key}  = $self->{$key};         
      }

    ######################################################
    my $type = shift;		# the type of the object
    $reference->{_type} = $type;


    $types->{$type}->{count}++; # add to the count    # count the types
    
    # the tovisit represents a list of things we have to do,
    # we cannot skip these nodes and will keep on reviewing them untill we have visited them all
    $tovisit{$id}++;		# here we mark the nodes to visit

    # process the values of the object and add them to a type
    process_values($reference); #CALL(gcc::node-->process_values($reference))

    NodeProcess::PreProcess($reference); # CALL(gcc::node-->NodeProcess::PreProcess) all the refences are in place and all information is there

    $self = {};			# overwrite the old self!

    return 1;
  }


sub process_values
  {
    my $self = shift;
    my $type = $self->{_type};
    # each value objects
    foreach my $field (keys %{$self->{vals}}) {
	
	next if ($field  =~ /bindata|binlen/); #skip these fields

	# store the values of the fields that are note references
	$types->{$type}->{vals}->{$field}++;
	
	# what about the field
	$fields->{$field}->{$type}++;
    }
  }

# this is a kluge
# there is a list of fields to ignore for certain types
# of course an intelligent algorithm does not need this
# but...
#  our $ignore={
#  	"const_decl"    => "chan",
#  	"type_decl"     => "chan",
#  	"var_decl"      => "chan",
#  	"function_decl" =>"chan",
#  ########################################## these are more annoying types
#  	"tree_list" =>"chan",
#  	"param" =>"chan",
#  	"field_decl" =>"chan",
#        };


sub nref
  {
    my $type = shift;
    my $id = shift;    
    my $other = $nodes->{$id};

    if (not exists($other->{id}))		# how it this object used?
      {
	# seen for the first time!
	# create a forward declaration to the other object
	$nodes->{$id}->{seen}++; # 
	$nodes->{$id}->{id} = $id;
#	$other = $nodes->{$id};
	$nodes->{$id}->{forward}=1; #  mark the node as a forward.
	$other = gcc::noderef->new($nodes->{$id}); # bless this node as a node ref
      }
    else
      {
	# it exists alread
	my $otherid = $other->{id};
	if ($id ne $otherid)
	  {
	    warn "Something is wrong!\n";
	  }
	  
      }
    # store a pointer to the other object
    $self->{refs}->{$type} = $other; 

    # store a reference to the current field in the other object
    # this is  not used is it?
    # $nodes->{$id}->{used}->{$type}++; # how it this object used?

    # count the type of references
    $self->{refs}->{$type}->{count}++; # how many members do we have?

    # the other object has been created, so we can reference it
  }

sub ntext
  {
    my $field = shift;
    my $val = shift;
    if ($field !~ /bin(len|data)/) # filter out the binary length
    {
	$self->{vals}->{$field} = $val; # the other object has been created, so we can reference it
    }
    #    return [$field,$val];
  }

sub type_error
{
    my $fieldobj = shift;
    my $valu = shift;
}

###########################################################################################
###########################################################################################
###########################################################################################



sub process_references 
  {
    my $self = shift;
    my $id = $self->{id}; 
    my $type = $self->{_type};
    # all the references that are going from this object

    #################################
    # the names of the keys
    my @rkeys = keys %{$self->{refs}};
    my @vkeys = keys %{$self->{vals}};
    # now to build subclasses, or configurations based on the fields available       
    my $attribute_string = join (",",sort @rkeys); # 
    $attribute_string .= ":" . join (",",sort grep {!/bindata|binlen/} @vkeys); # 

    ###################################
    $types->{$type     }->{$attribute_string}->{count}++;
    # here we track the size of the subclass!    
    ####################################

    foreach my $ref (keys %{$self->{refs}}) 
      {
	# get a pointer to the other, it has been created in the ref object
	my $other = $self->{refs}->{$ref}; # who is referenced?
#	my $other = $nodes->{$nodes->{id}};
	my $othertype = $other->{_type};


	# the other is referenced by an field of type $ref	
	$other->{refd}->{$ref}->{$type}++; # store the incoming nodes

	if ($othertype)
	{	    
	    $types->{$type     }->{$attribute_string}->{refs}->{$ref}->{$othertype }++;# the config
		$types->{$type     }->{std}->{refs}->{$ref}->{$othertype }++;
	    $types->{$othertype}->{std}->{refd}->{$ref}->{$type      }->{std}++; # reftype says who is pointing to us
	    #####################################################################################
	    $types->{$othertype}->{std}->{refd}->{$ref}->{$type      }->{$attribute_string}++; 
	    # reftype says who is pointing to us
	    #####################################################################################
	    
	    #         fld     my type   other type
	    $fields->{$ref}->{$type}->{$othertype}++;
	    #######################################################
	}
	else
	{
	    cluck "type is missing from node " . $other->{id} ."\n"; # 
	}

	# store the objects that are referring to this object
	# here we say who uses who!
	$users->{$other->{id}}->{$id}++;
	$used->{$id}->{$other->{id}}++; # this object is used by these
      }
    # NOW WE CAN PROCESS THE NODE BECAUSE WE HAVE ALL THE INFORMATION WE NEED
  }

sub preprocess # returns count of nodes processed
  {
    my $return =0;
    my $id = shift; # the id of the node
    my $try = shift;
    my $pass = shift;

    $try =0 if not $try;
    my $userobj = $nodes->{$id};
    my @used = keys %{$used->{$id}}; # this is used by?, oh, forget about the chains!
    my $count=0;
    if (@used)
      {
	$count = scalar(@used);
      }
    if ($count <= $try) # this is the tolerance that will be increased!
      {
	if (!$userobj->{processed}) 
	  {
	    $userobj->{processed} =1; # mark the node as processed
	    delete $tovisit{$id};	# remove from the tovisit collection
	    
#	    *NodeProcess::Process();
#	    $userobj->process($try,$pass);	# now we can do something cool!

	    $return++;
	    # called by 
	    visit_users ($userobj); # call(gcc::preprocess-->gcc::visit_users) now lets see who uses this node,
	  } 
	else
	  {
	    # it has been processed
	  }
      }
    else
      {

      }
    return $return;
  }
# called by preprocess
sub visit_users
  {
    # now we have an object that is complete.
    my $object = shift;
    if (not $object) {
      return -1;
    } 
    my $id = $object->{id};	# get the id
    # the object is used by other objects that are in turn used by nodes.
    # lets start visiting the users of this object and see if they can be resolved.
    if (
	($id)
	&&
	(
	 exists($users->{$id})
	)
	&&
	(
	 scalar( %{$users->{$id}}) ne 0)
       ) {

      # NOW WE WILL POST PROCESS THE NODE
	
      my $objtype = ref $object;
#      if ($objtype ne "gcc::noderef")
#      {
	NodeProcess::PostProcess ($object); # CALL(visit_users-->NodeProcess::PostProcess) all the refences are in place and all information is there
	  
	  {
	      foreach my $user (keys %{$users->{$id}}) # who is using this one!
	      {
		  # the user has a pointer to this object
		  # tell it the pointer is derefernced
		  my $other = $nodes->{$user}; # the other
		  delete $used->{$user}->{$id}; # remove this from the needs hash
		  delete $users->{$id}->{$user}; # remove this from the needs hash
	      }
	  }
#      }
#      else
#      {
#	  cluck "Tried to visit a noderef!\n";
#      }
    }
  };


sub PostProcess()  # CALL(intrspctr::main-->GCC::PostProcess)
{
############################################
    my $try =0;
    my $usage =0;
    my $left =0;
    my $pass =0;
    
    # now, we have to setup the pointers before we can visit them all!
    # process the references of the object and add them to a type
    foreach my $id (keys %tovisit) {
	process_references($nodes->{$id});#CALL(GCC::PostProcess-->GCC::process_references); do that here now so we have access to all data
	}
    
    # ok, now topological sort it
    while (($left = scalar(keys %tovisit)) ne 0) # while there are nodes to visit.
    {
	foreach my $id (keys %tovisit) {
	    
	    $usage += preprocess($id,$try,$pass);#CALL(GCC::PostProcess-->GCC::preprocess) now visit the nodes needed them!
	}
	print "---" x 100;
	print "\n" x 3;
	if ($usage eq 0)
	{
	    $try ++;
	    print "Came out empty handed, try again with $try and have $left to go\n";
	}
	else
	{
	    print "Used $usage and have $left to go\n";
	    $usage =0;
	}
	
	###########################################################################
	##
	## we want to  output one report per level!, but this will take more work!
	##
	###########################################################################
	
	$pass++; # raise the pass, lower the tolerance
    }
##########################################
    my $out = OpenOutputFile("type_overview_new.pm");
    print $out Dumper($types);
    CloseFile $out;
###########################################
    $out = OpenOutputFile("field_overview_new.pm");
    print $out Dumper($fields);
    CloseFile $out;
######################################
    $out = OpenOutputFile("type_levels_new.pm");
    print $out "Types :" . Dumper(\%gcc::node::level_pass_types); # Show the contants
    CloseFile $out;
######################################
    $out = OpenOutputFile("integer_csts_new.pm");
    print $out "Integer:" . Dumper($gcc::node::integer_cst::const_vals); # Show the contants
    CloseFile $out;
}

END {

}

1;


#  # gcc::node::integer_type::process
#  # gcc::node::integer_cst::process
#  # gcc::node::process
#  # types of objects
#  my $last_types = {
#            'identifier_node' => '4268',
#            'tree_list' => '3498',
#            'integer_cst' => '2252',
#            'string_cst' => '160',
#            'var_decl' => '323',
#            'const_decl' => '1361',
#            'type_decl' => '338',
#            'function_decl' => '1808',
#                'function_type' => '539',
#                   'parm_decl' => '15',
#  	  'record_type' => '132',
#  	      'field_decl' => '620',
#            'enumeral_type' => '41',
#            'boolean_type' => '1',
#            'integer_type' => '162',
#            'reference_type' => '1',
#            'void_type' => '4',
#            'pointer_type' => '179',
#            'complex_type' => '4',
#            'real_type' => '3',
#            'union_type' => '13',
#            'array_type' => '78',
#            'constructor' => '4',
#            'addr_expr' => '161',
#            'nop_expr' => '320',
#          };
