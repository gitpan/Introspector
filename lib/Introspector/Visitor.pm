package Introspector::Visitor;
#-Standard-Strictures-
use strict;
use warnings;
#use warnings::register;

#################################################################
#
# MODULE  : Visitor.pm
# Purpose : Translates the classes created into something usefull
# Author  : James Michael DuPont
# Date    : 24.7.01
# Generation : Third Generation
# Status     : Under Development
# Category      : Tree Walker
# Description:  CreateClasses  to create all the class descriptions based on the 
# statistics collected from the first pass over the nodes
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

#-Debugging-Error-Reporting-Modules-
use Carp qw(carp croak cluck confess);
#use Carp::Assert qw(assert should shouldnt DEBUG);

#-Standard-Constants-And-Globals-
# DEBUG is defined above

use vars qw/$VERSION $WARN_LEVEL/;
use constant P_DEBUG    => 1;

# Additional modules dependecies later


=head1 NAME

Visitor - Class|Package for ...

=head1 VERSION

Version '0.1'

=cut

BEGIN {

$VERSION='0.1';
#$WARNLEVEL=1;

};

=head1 SYNOPSIS

  use Visitor;
  ...

=head1 DESCRIPTION

Visitor is intended to ...

=cut



#=head1 EXPORTS

#*EXPORT_TAGS*

#*EXPORT_OK*

#*EXPORT*

#=cut



# Uncomment this to provide exporter functionality
# use base qw/Exporter/;
# use vars qw/%EXPORT_TAGS @EXPORT_OK @EXPORT/;

# Uncomment and configure one or all of the following

# This allows declaration	use PACKAGE_NAME ':all';
# %EXPORT_TAGS = ( 'all' => [ qw() ] );

# Things we export if asked
# @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

# Things we export without being asked (should be none)
# @EXPORT = qw();

#-Dependencies-

=head1 DEPENDENCIES

Visitor uses the following pragmas, packages and classes.

=over 4

=item Pragmas Used

L<strict|strict> L<warnings|warnings> L<warnings::register|warnings::register> L<vars|vars> L<constant|constant> L<database::queries|database::queries> L<db_node_ref|db_node_ref> L<introspector::node_call_expr|introspector::node_call_expr> L<introspector::node_function_decl|introspector::node_function_decl> L<introspector::node_function_type|introspector::node_function_type> L<introspector::node_string_cst|introspector::node_string_cst> L<introspector::node_tree_list|introspector::node_tree_list>

=cut

# Additional Pragmas
#
# attributes autouse base blib bytes charnames constant
# diagnostics enum fields filetest integer less lib locale
# open ops overload perllocal private protected public re
# sigtrap subs utf8
# 
    use database::queries;
use db_node_ref;
use introspector::node_call_expr;
use introspector::node_function_decl;
use introspector::node_function_type;
use introspector::node_string_cst;
use introspector::node_tree_list;


=item Modules Used

L<Carp|Carp> L<Carp::Assert|Carp::Assert> L<Data::Dumper|Data::Dumper> L<SOAP::Lite|SOAP::Lite> L<XMLRPC::Lite|XMLRPC::Lite>

=cut

# Additional Modules Go Here
#
# use Data::Dumper;
# use CGI;
# use HTML::Template;
# 
    use Data::Dumper;
    use SOAP::Lite;
use XMLRPC::Lite;


#-Module-Globals-

=head1 PACKAGE GLOBALS

...

=cut

use vars qw//; #*PACKAGE_GLOBALS

BEGIN {
	# *INIT_PACKAGE_GLOBALS*
}

### GLOBAL
my $serial = new SOAP::Serializer;   #$serial->serialize();
my $serial2= new XMLRPC::Serializer; #$serial2->envelope("method","testFunc",
$serial->{_level}=2; # no headers and such
$serial->{_readable}=1; # make it readable
my $nullnode = "()";
my $nullnodeobj = { $nullnode=>1 };
my $global_conn = new database::queries;
my $node_base_name = "node_base*";
#my $node_base_name = "node_base2";

#my $global_file  ="tree_empty.c";
#my $global_function ="___global";

my $global_file  ="c-dump.c";
my $global_function ="dequeue_and_dump_nochain";



#-Methods-

=head1 METHODS

=cut

#-Constructors-

=head2 CONSTRUCTORS

=cut

#-Sub-New-

=head3 CLASS->new()

Creates a new Visitor object. Returns the new object or undef.

Takes 

=cut

sub new ()
{
    my $class = shift;

    my $self = {
	depth => 0     , #  current level
	max_depth => 10, #  dont go deeper
	found_decls=>{}, #  hash of decl found
	found_types=>{}, #  hash of types found
	cache=>{} # all the seen objects
    };

    bless $self,$class; # bless!
    return $self;
};
#-Object-Methods-

=head2 OBJ METHODS

=cut



=head3 OBJ->get_details($conn$id$node_type$nfile$nfunc)

get_details is used to ...

Takes $conn$id$node_type$nfile$nfunc

Returns in scalar context ... and in list context ...

=cut

sub get_details
{
    my $self = shift;
    my $conn = shift;
    my $id = shift;
    my $node_type = shift;
    my $nfile = shift;
    my $nfunc = shift;

    warn "\t\tget_details " . $id  if $self->{debug};

    if ($self->{cache}->{$id})
    {
	if ($self->{cache}->{$id}->{detail})
	{
	    return $self->{cache}->{$id};
	}
    }

    # query hash ref
    my $ary3 = $conn->query_hashref( 
				     "select       * 
                                      from     
                                              node_${node_type} 
                                       where            
                                              id = $id and     node_file = '$nfile' 
                                          and     
                                              node_function = '$nfunc'
    ");
    
    my $ret = $ary3->[0];   #  Dumper 
    $ret->{detail} =1;
    $self->{cache}->{$id} =$ret;
    return $ret;

}




=head3 OBJ->get_data_type($conn$id$nfile$nfunc)

get_data_type is used to ...

Takes $conn$id$nfile$nfunc

Returns in scalar context ... and in list context ...

=cut

sub get_data_type
{
    my $self = shift;
    my $conn = shift;
    my $id = shift;
    my $nfile = shift;
    my $nfunc = shift;
    warn "\t\t\tget_data_type " . $id  if $self->{debug};
    my $type ;

    if ($self->{cache}->{$id})
    {
	my $ret  = $self->{cache}->{$id};
	return ($ret->{id},$ret->{type});
    }
    ($id,$type)= $self->get_data($conn,$id,$nfile,$nfunc);
    $self->{cache}->{$id} = {
	id=> $id,
	node_type => $type 
	};
    return "$id->$type";
}


=head3 OBJ->get_data($conn$id$nfile$nfunc)

get_data is used to ...

Takes $conn$id$nfile$nfunc

Returns in scalar context ... and in list context ...

=cut

sub get_data
{
    my $self = shift;
    my $conn = shift;
    my $id = shift;
    my $nfile = shift;
    my $nfunc = shift;
    warn "\t\t\tget_data " . $id  if $self->{debug};
    return $nullnode unless $id;

    if ($self->{cache}->{$id})
    {
	return ($self->{cache}->{$id}->{id},$self->{cache}->{$id}->{node_type});	
    }
    my $ary2 = $conn->query_list("select      node_function, id, node_file, node_type from     ${node_base_name} where            id = $id and     node_file = '$nfile' and     node_function = '$nfunc'");
    my ($node_function, $id, $node_file, $node_type) = 	@{$ary2->[0]};
    $self->{cache}->{$id} = {
	id=> $id,
	node_file => $node_file,
	node_function=> $node_function,
	node_type => $node_type 
	};
    return ($id,$node_type);
}

## called by get_node
  # calls get_data to get the base node
  # calls get_details to get the detailed record


=head3 OBJ->get_data_details($conn$id$nfile$nfunc)

get_data_details is used to ...

Takes $conn$id$nfile$nfunc

Returns in scalar context ... and in list context ...

=cut

sub get_data_details
{
    my $self = shift;
    my $conn = shift;
    my $id = shift;
    my $nfile = shift;
    my $nfunc = shift;
    my $type ;
    ##
    warn "\t\t\tget_data_details " . $id  if $self->{debug};

    if ($self->{cache}->{$id})
    {
	warn "get_data_details cached " . $id  if $self->{debug};

	return $self->{cache}->{$id};
    }

    ($id,$type)= $self->get_data ($conn,$id,$nfile,$nfunc);
    
    return $self->get_details ($conn,$id,$type,$nfile,$nfunc);
}



=head3 OBJ->get_node($id)

get_node is used to ...

Takes $id

Returns in scalar context ... and in list context ...

=cut

sub get_node
{
    my $self = shift;
    my $id = shift;

    warn "\tget_node " . $id  if $self->{debug};

    if ($self->{cache}->{$id})
    {
	warn "get_node cached " . $id  if $self->{debug};
	return $self->{cache}->{$id};
    }
    if ($id)
    {
	my $node= $self->get_data_details($global_conn,$id,$global_file,$global_function);
	delete $node->{node_file};
	delete $node->{node_function};
	delete $node->{'interface_name'};
	return $node;
    }
    else
    {
	return $nullnodeobj;
    }
}



=head3 OBJ->get_name($obj)

get_name is used to ...

Takes $obj

Returns in scalar context ... and in list context ...

=cut

sub get_name 
{
    my $self = shift;
    my $obj = shift;
    warn "--get_name " . $obj->{id}  if $self->{debug};
    # get the name if the node has one?
    if ($obj->{strg} and $obj->{node_type} eq 'identifier_node')
    {
	return $obj->{strg};
    }
    elsif ($obj->{name})
    {
	my $name = $self->get_node($obj->{name});	
	return $self->get_name($name);
    }
    else
    {
	# now we look for decls that point to the node that have a name
    } 
}



=head3 OBJ->get_size($obj)

get_size is used to ...

Takes $obj

Returns in scalar context ... and in list context ...

=cut

sub get_size
{
    my $self = shift;
    my $obj = shift;
    warn "--get_size " . $obj->{id}  if $self->{debug};
    # get the name if the node has one?
    if ($obj->{size})
    {
	my $size = $self->get_node($obj->{size});
	my $size_cst = $size->{low} . "-" . ($size->{high} ? $size->{high}:"NULL") ;
	return $size_cst
	}
    else
    {
	return $nullnode;
	# now we look for decls that point to the node that have a name
    } 
}



=head3 OBJ->get_cst($obj)

get_cst is used to ...

Takes $obj

Returns in scalar context ... and in list context ...

=cut

sub get_cst
{
    my $self = shift;
    my $obj = shift;
    warn "--get_cst " . $obj->{id}  if $self->{debug};
    return $serial->serialize($obj); # for now, just dump    
}


# just extract what is needed


=head3 OBJ->grok_record_type($obj)

grok_record_type is used to ...

Takes $obj

Returns in scalar context ... and in list context ...

=cut

sub grok_record_type
{
    my $self = shift;
    # just extract the name and the type of the record
    my $obj = shift;
    warn "--grok_record_type " . $obj->{id}  if $self->{debug};
    return "<RECORD type=\"". $obj->{str} ."\" name=\"". $obj->{name} . "\"/>";
}

# will build a try from the nodes.
#      to_type    | count 
#  ---------------+-------
#   array_type    |   229
#   enumeral_type |  1264
#   function_type |  1722
#   integer_type  |  2810 
#   pointer_type  |   615
#   record_type   |   172
#   union_type    |    19
#   void_type     |     2
###############################
#   boolean_type  |     1  --- like an integer
#   complex_type  |     4  ---
#   real_type     |     3  ---



=head3 OBJ->grok_type($obj)

grok_type is used to ...

Takes $obj

Returns in scalar context ... and in list context ...

=cut

sub grok_type
{
    my $self = shift;
    my $obj = shift;

    warn "grok_type " . $obj->{id}  if $self->{debug};

    # undefined
    return "<UNDEF/>" unless $obj;
    # NO ID
    return "<NO_ID/>"  unless $obj->{id};

    # try and figure a name out
    $obj->{name} =    $self->get_name ($obj);
    $obj->{size} =    $self->get_size ($obj);


    if ($obj->{type})
    {
	my $type = $self->get_node($obj->{type});
	$obj->{type} = $self->grok_type($type);
    }

    if ($obj->{ptd})
    {
	my $ptd = $self->get_node($obj->{ptd});
	return  "<PTR id=\"". $obj->{id} ."\" >" .  $self->grok_type($ptd) . "</PTR>";
    }
    elsif (
	   ($obj->{node_type} eq "record_type")
	   or  
	   ($obj->{node_type} eq "union_type")
	   )
    {
	return $self->grok_record_type($obj);
    }
    elsif (
	   ($obj->{node_type} eq "integer_type")
	   )
    {
	return "<INTTYPE id=\"". $obj->{id} ."\"" .
	    " name=\"" . $obj->{name} . "\"" .
		" size=\"" . $obj->{size} . "\"" .
		    " prec=\"" . $obj->{prec} . "\"" .
			" algn=\"" . $obj->{algn} . "\"" .
			    "/>";
    }
    elsif (
	   ($obj->{node_type} eq "boolean_type")
	   )
    {
	return "<BOOL id=\"". $obj->{id} ."\" name=\"". $obj->{name} ."\"" .
	    " size=\"" . $obj->{size} . "\"" .
		" prec=\"" . $obj->{prec} . "\"" .
		    " algn=\"" . $obj->{algn} . "\"" .
			"/>";
    }
    elsif (
	   ($obj->{node_type} eq "complex_type")
	   )
    {
	return "<COMPLEX id=\"". $obj->{id} ."\" name=\"". $obj->{name} ."\"" .
	    " size=\"" . $obj->{size} . "\"" .
		" algn=\"" . $obj->{algn} . "\"" .
		    "/>";
    }
    elsif (
	   ($obj->{node_type} eq "real_type")
	   )
    {
	return "<REAL id=\"". $obj->{id} ."\" name=\"". $obj->{name} ."\"" .
	    " size=\"" . $obj->{size} . "\"" .
		" prec=\"" . $obj->{prec} . "\"" .
		    " algn=\"" . $obj->{algn} . "\"" .
			"/>";
    }
    elsif (
	   ($obj->{node_type} eq "complex_type")
	   )
    {
	return "<COMPLEX id=\"". $obj->{id} ."\" name=\"". $obj->{name} ."\"" .
	    " size=\"" . $obj->{size} . "\"" .
		" prec=\"" . $obj->{prec} . "\"" .
		    " algn=\"" . $obj->{algn} . "\"" .
			"/>";
    }

    elsif (
	   ($obj->{node_type} eq "reference_type")
	   )
    {
	my $refd = $self->get_node($obj->{refd});
	$refd = "<REFD id=\"". $obj->{id} ."\" >" .  $self->grok_type($refd) . "</REFD>";
	$obj->{refd} = $refd;
	return "<REFERENCE name=\"". $obj->{name} ."\"" .
	    " size=\"" . $obj->{size} . "\"" .
		" prec=\"" . $obj->{prec} . "\"" .
		    ">" . $obj->{refd} . "</REFERENCE>";
    }

    elsif (
	   ($obj->{node_type} eq "array_type")
	   )
    {
	my $elts = $self->get_node($obj->{elts});
	$elts = "<elts>" .  $self->grok_type($elts) . "</elts>";
	#################################
	my $domn = $self->get_node($obj->{domn});
	$domn = "<domn>" .  $self->grok_type($domn) . "</domn>";
	#################################

	return "<ARRAY id=\"". $obj->{id} ."\" name=\"". $obj->{name} ."\"" .
	    " size=\"" . $obj->{size} . "\">" . $domn . " " . $elts . "</ARRAY>";
    }
    elsif (
	   ($obj->{node_type} eq "void_type")
	   )
    {
	if ($obj->{'qualconst'})
	{
	    return "<VOID id=\"". $obj->{id} ."\" const=1/>";
	}
	else
	{
	    return "<VOID id=\"". $obj->{id} ."\" >";
	}
    }
    elsif (
	   ($obj->{node_type} eq "enumeral_type")
	   )
    {
	return "<ENUM id=\"". $obj->{id} ."\" name ='". $obj->{name} ."'/>";
    }
    elsif (
	   ($obj->{node_type} eq "function_type")
	   )
    {
	return $self->query_function_type ();
    }
    # last resort
#    return $obj;
    return $serial->serialize($obj);
}



=head3 OBJ->query_function_type($id)

query_function_type is used to ...

Takes $id

Returns in scalar context ... and in list context ...

=cut

sub query_function_type
{
    my $self = shift;
    my $id = shift;

    my @params;
    #print "Load Function Type $id\n";
    # load the object
    my $obj =  $self->get_node($id);

    # get the size (is this always 64?) yes, so let's skip it!
    # my $size= get_size($obj);
    $obj->{name} =    $self->get_name ($obj);

    # get the parameter list
    my $prms= $self->get_node($obj->{prms});
    
    # walk the chain
    while ($prms->{chan})
    {
	# get the type of parameter
	my $type = $self->grok_type(get_node($prms->{valu}));

	push @params, $type;

	# fetch next
	if($prms->{chan})
	{
	    $prms= $self->get_node($prms->{chan});
	}
    }

    # get type information
    my $retn= $self->grok_type(get_node($obj->{retn}));

    my $ret = {
	params  =>\@params,
	retn    =>$retn,
#	size    =>$size,
	id      =>$obj->{id}
    };

    my $xml = "<FUNCTION_TYPE" .
	" id=\'" . $obj->{id} . "\' ".
	    "name=\'" . $obj->{name} . "\' ".	    
		"retn=\'" . $retn . "\'>";

    foreach (@params)
    {
	$xml .= "<PARM>$_</PARM>";
    }
    $xml .= "</FUNCTION_TYPE>";

    print $xml . "\n";
}



=head3 OBJ->query_functions()

query_functions is used to ...

Takes 

Returns in scalar context ... and in list context ...

=cut

sub query_functions
{
    my $self = shift;
    my $ary2 = $global_conn->query_list("select id from $node_base_name where node_type = \'function_type\'");
    foreach my $node (@{$ary2})
    {
	my $id = $node->[0];
	$self->query_function_type ($id);
    }
}

# get all the type_decls who's type is function_type
# get all the function_decl who's type is a function_type

# the name of a function_type can be a type_decl
#query_functions;

#select * from node_base2 where node_type like '%type%' and not exists (select from_id from node_usage2 where to_id = id);


=head3 OBJ->get_decl($obj)

get_decl is used to ...

Takes $obj

Returns in scalar context ... and in list context ...

=cut

sub get_decl
{
    my $self = shift;
    my $obj = shift;

    warn "get_decl " . $obj->{id}  if $self->{debug};

    $obj->{name} =    $self->get_name ($obj);
    $obj->{size} =    $self->get_size ($obj);

    my $xml = "<DECL " .
	"type=\'" . $obj->{node_type} . "\' ".
	    "id=\'" . $obj->{id} . "\' ".
		"type=\'" . $obj->{type} . "\' ".
		    "srcp=\'" . $obj->{srcp} . "\' ".
			"srcl=\'" . $obj->{srcl} . "\' ".
			    "name=\'" . $obj->{name} . "\' ".	    
				"size=\'" . $obj->{size} . "\' ".	    
				    "\'>";

    ### Only return something if there is something to return!
    if ($obj->{srcp})
    {
	return $xml ;
    }
    else
    {
	return "";
    }
}



=head3 OBJ->find_decl($id)

find_decl is used to ...

Takes $id

Returns in scalar context ... and in list context ...

=cut

sub find_decl
{
    my $self = shift;
    my $id = shift;
    my @ret;
    warn "visit $id " if $self->{debug};

    if (scalar(keys (%{$self->{found_decls}})))
    {
	warn "we found something already $id " if $self->{debug};
	return ;
    }
    
    if ($self->{cache}->{$id})
    {
	return "SEEN! $self"; # stop the recursion!
    }
    # lookup the object
    my $obj= $self->get_node($id);    


    # just get them all!
    my $sql = "select from_id from node_usage2 where to_id = $id";
    
    # and usage in (\'type\',\'valu\',\'op_0\',\'op_1\') and to_type not like (\'%_cst\') ";
    # and from_type not in (\'field_decl\', \'var_decl\',\'const_decl\' ,\'parm_decl\' ) ";
    # and from_type like '%_decl'
    # function_decl, type_decl, tree_list, expr
    
    my $main = "_";
    my $obj =  $self->get_node($id);	    
    if ($obj->{name})
    {
	my $name =  $self->get_node($obj->{name});
	$main= $self->get_name($name);	    
    }
    my $decl= $self->get_decl($obj);	
    my $ary2 = $global_conn->query_list($sql);
    if ($#$ary2 >= 0)
    {
	foreach my $node (@{$ary2})
	{
	    
	    my $id = $node->[0];
	    my $obj= $self->get_node($id);    
	    my $ret = "";
	    
	    # if it is like a decl, then return
	    if ($obj->{node_type} =~ /.*cst/)
	    {
		$ret = $self->get_cst($obj);
		
		my $strg= $decl. ":". $main . ":". join (",\n",@ret);	    
		print $strg;
		return $strg;
	    }
	    elsif ($obj->{node_type} =~ /.*decl/)
	    {		 
		$ret = $self->get_decl($obj);
		my $strg = $decl. ":". $main . ":". join (",\n",@ret);	    
		$self->{found_decls} =$strg;		    
		print $strg;
		return $strg;
	    }
	    elsif ($obj->{node_type} eq "array_type")
	    {
		# get the array,
		my $elts = "<elts>" .  $self->find_decl($obj->{elts}) . "</elts>";		    
		# just stop here
		my $strg = $decl. ":". $main . ":". join (",\n",@ret);	    
		$self->{found_decls} =$strg;		   
		print $strg;
		return $strg;		
	    }		
	    elsif ($obj->{node_type} eq "pointer_type")
	    {
		# get the pointer
		$ret = "<PTR>" . $self->find_decl($obj->{ptd}) . "</PRT>";
		# just stop here
		
		my $strg= $decl. ":". $main . ":". join (",\n",@ret);	    
		$self->{found_decls} =$strg;		    
		print $strg;
		return $strg;		
	    }
	    else
	    {
		$ret = $serial->serialize($obj);
		
		# the object is not known, just look
#		my $strg= "<UNKNOWN>" . $self->find_decl($id) . "</UNKNOWN>\n";
#		print $strg;
#		$ret .=$strg;
	    }	    
	    if ($ret ne '')
	    {
		push @ret,$ret;
	    }
	}
	# join them togeather
	my $strg= $decl. ":". $main . ":". join (",\n",@ret);	    
	print $strg;
	return $strg;
    }
    else
    {
	my $strg= "<UNKOWN>" . $serial->serialize($obj) . "</UNKNOWN>";
	print $strg;
	return $strg;
    }
    
}



=head3 OBJ->query_enums($conn)

query_enums is used to ...

Takes $conn

Returns in scalar context ... and in list context ...

=cut

sub query_enums
{
    my $self = shift;
    my $conn = shift;

    my $ary = $conn->query_list("
select  
     et.csts 
from 
     node_enumeral_type et,  
     node_identifier_node id,
     node_identifier_node ide,
     node_tree_list tl
where       
     et.csts = tl.id
and
     tl.purp = ide.id
and
     et.name = id.id
and 
     et.node_function = '$global_function'
and  
     id.node_function = '$global_function'
and
     ide.node_function = '$global_function'
and
     tl.node_function = '$global_function';
");

    my @ids = map {$_->[0]; } @{$ary};

    my @enums = map 
    {
	my $listid = $_; # the begin of the 
	my @strings;
	
	while ($listid)
	{
	    my $ary2 = $conn->query_list(
					 "select  
     ide.strg,
     tl.chan
from
     node_identifier_node ide,
     node_tree_list tl
where       
     tl.purp = ide.id
and
     ide.node_function = '$global_function'
and
     tl.node_function = '$global_function'
and  
     tl.id = $listid;
");
	    my $string = $ary2->[0][0];
	    my $newlistid     = $ary2->[0][1];
	    #print "FOUND $listid, $string,$newlistid\n";
	    push  @strings, $string;		
	    $listid = $newlistid;

	}
	#print "FINISHED". ",",@strings . "\n";
	
    } @ids;

    #print "ALLIDS" . join ",",@ids;
#print join ",",@strings;
}





=head3 OBJ->recurse_refs($conn$node$level)

recurse_refs is used to ...

Takes $conn$node$level

Returns in scalar context ... and in list context ...

=cut

sub recurse_refs
{
    my $self = shift;
    my $conn  = shift; 
    my $node  = shift;
    my $level = shift;
    return "" unless $node;

    my $nfile = $node->{"node_file"};
    my $nfunc = $node->{"node_function"};

    my $id = $node->{id};
    my $type = $node->{node_type};

    my $ret = 
    { 	
	__id => $id,
	__type => $type
	};

    foreach my $key (keys %{$node})
    {
	if (	
		$key =~ /^strg$/  
		|| $key =~ /^low$/ 
		|| $key =~ /^high$/ 
		|| $key =~ /^srcl$/ 
		|| $key =~ /^srcp$/ 
		|| $key =~ /^used$/ 
		|| $key =~ /^node_type$/ 
		)
	{
	    $ret->{"_v" . ${key}} = $node->{$key};
    }
    ###
    if (	
		$key =~ /^op/ 
		||$key =~ /^name$/ 
		||$key =~ /^argt$/ 
		)
    {
	my $value = $node->{$key};
	my $details = $self->get_data_details ($conn,$value,$nfile,$nfunc);
	$ret->{"_" . ${key}} = $self->recurse_refs($conn,$details,$level +1);	

    
    if ($ret->{"_" . ${key} })
{
    my $totype  = $ret->{"_" . ${key} }->{__type};

my $fromtype= $ret->{__type};
my $key     = ${key};

####

{
#		    printf ("checkjoin (\$conn,%-25s,%-25s,%-25s);\n", "q[".$fromtype."]", "q[".$totype."]", "q[".$key."]");
#		    checkjoin ($conn, $fromtype,$totype,$key);
}

}
}
}



return $ret; # not all the info
}



=head3 OBJ->get_data_recurse($conn$id$nfile$nfunc)

get_data_recurse is used to ...

Takes $conn$id$nfile$nfunc

Returns in scalar context ... and in list context ...

=cut

sub get_data_recurse #($conn, $id, $nfile, nfunc)
{
    my $self = shift;
    my $conn = shift;
    my $id = shift;
    my $nfile = shift;
    my $nfunc = shift;
    my ($node)= $self->get_data_details ($conn,$id,$nfile,$nfunc);

    my $str =$self->recurse_refs($conn,$node,1);
#    $str =~ s/\s+/ /g;
    return $str;
}




=head3 OBJ->get_link($conn$id$file$function$listnode)

get_link is used to ...

Takes $conn$id$file$function$listnode

Returns in scalar context ... and in list context ...

=cut

sub get_link
{
    my $self = shift;
    my $conn       = shift;
    my $id         = shift;
    my $file       = shift;
    my $function   = shift;
    my $listnode   = shift;# this is an introspector::node_tree_list

	my $sql = "select  tl.node_type, tl.chan,tl.valu,tl.purp, tl.node_file, tl.node_function from          node_tree_list tl 
where
  tl.id = $id  
and 
  tl.node_file = '$file' 
and 
  tl.node_function = '$function'
";

    my $ary2 = $conn->query_list($sql);
    my $row = $ary2->[0];
    my $type = $row->[0]; 
    my $chan = $row->[1]; 
    my $valu = $row->[2];
    my $purp = $row->[3];
    my $nfile = $row->[4];
    my $nfunc= $row->[5];

    my $valud = "NUL";
    my $purpd = "NUL";

    if ($valu) {
	$valud =$self->get_data_recurse($conn,$valu,$nfile,$nfunc) 
#	$valud =get_data_type($conn,$valu,$nfile,$nfunc) 
	};
    if ($purp) {
	$purpd =$self->get_data_recurse($conn,$purp,$nfile,$nfunc) 
#	$purpd =get_data_type($conn,$purp,$nfile,$nfunc) 
	};

    my $list = new introspector::node_tree_list;
    $list->Setid(      $id);
    $list->Setnode_file(    $file);
    $list->Setnode_function($function);
    $list->Setchan(    
		       new db_node_ref($chan,
				       $file,
				       $function,
				       $conn,
				       "chan") # the context!
		       );
    $list->Setvalu(    $valud);
    $list->Setpurp(    $purpd);

    #print "\t\tchain(\[$id\],$type,$chan, $valud, $purpd)\n";

    return ($chan,$nfile,$nfunc,$list); 
}


=head3 OBJ->walk_chain($conn$id$file$function)

walk_chain is used to ...

Takes $conn$id$file$function

Returns in scalar context ... and in list context ...

=cut

sub walk_chain
{
    my $self = shift;
    my $conn = shift;
    my $id = shift;
    my $file = shift;
    my $function = shift;
    #print "BEGIN $id $file $function\n";
    my ($chan,$nfile,$nfunc,$list);
    my @return;# collect a return object
	while ($id)
	{

	    ($chan,$nfile,$nfunc,$list) = $self->get_link($conn,$id,$file,$function,$list);
	    push @return,$list;# add the link to a list!

		$id = $chan; # next!
	}
    #print "END $id,$nfile,$nfunc\n";
    return @return;

}


=head3 OBJ->CheckSubs()

CheckSubs is used to ...

Takes    

Returns in scalar context ... and in list context ...

=cut

sub CheckSubs
{
    definesub("c-dump.i","%",\&meta_anyfunc, \&meta_function_type, \&meta_function_decl);
}

=head3 OBJ->CheckList()

CheckList is used to ...

Takes    

Returns in scalar context ... and in list context ...

=cut

sub CheckList
{
    my $self = shift;
    my $filename = shift;
    my $function = shift;
    my $id       = shift;
    
    print "Start : $filename, $function,$id \n";
    $self->walk_chain ($global_conn,$id,$filename,$function);
}

1;
