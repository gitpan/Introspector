#!/usr/bin/perl

# process_file.pl
# taken from 
# example.pl - Redland eaxmple Perl program
#
# $Id: process_file.pl,v 1.1.1.1 2003/01/19 13:46:20 mdupont Exp $
# Copyright (C) 2002 James Michael DuPont
# Copyright (C) 2000-2001 David Beckett - http://purl.org/net/dajobe/
# Institute for Learning and Research Technology - http://www.ilrt.org/
# University of Bristol - http://www.bristol.ac.uk/
# 
# This package is Free Software or Open Source available under the
# following licenses (these are alternatives):
#   1. GNU Lesser General Public License (LGPL)
#   2. GNU General Public License (GPL)
#   3. Mozilla Public License (MPL)
# 
# See LICENSE.html or LICENSE.txt at the top of this package for the
# full license terms.
# 
# 
#
package Introspector::GCC::TypeRef;
use strict;
use warnings;
use overload '""'  => \&stringify, fallback => 1;
sub new
{
    my $class=shift;
    my $val  = shift;
    return bless \$val,$class;
};
sub stringify
{
    my $s =shift;
    return "gcc/node_types#".$$s;
}
1;
package Introspector::GCC::FieldRef;
use strict;
use warnings;
use overload '""'  => \&stringify, fallback => 1;
sub new
{
    my $class=shift;
    my $val  = shift;
    return bless \$val,$class;
};
sub stringify
{
    my $s =shift;
#    return "gcc/node_fields#".$$s;
   return $$s;
}
sub methodname
{
    my $s =shift;
    return $$s;
}
1;
package Introspector::GCC::Modifier;
use strict;
use warnings;

sub new
{
    my $class=shift;
    my $val  = shift;
    return bless \$val,$class;
};
1;

package Introspector::Logic::Boolean;
use strict;
use warnings;
sub new
{
    my $class= shift;
    my $val  = shift;
    return \$val,$class;
};
1;

package Introspector::Redland::Subject;
our @ISA=qw(RDF::Redland::Node);

sub new ($) {
  my($proto)=@_;
  my $class = ref($proto) || $proto;
  my $self  = {};
  $self = RDF::Redland::Node(@_);
  return $self;
}

sub get_id
{
    my $self= shift;
    my $env    = shift;
    
    my $u = URI->new($self->uri->as_string());
    my $path   = $u->path;       
    my $frag   = $u->fragment;  

    if($path eq $env->{filename})
    {
	if ($frag =~/id-(\d+)/)
	{
	    $path ="ID";
	    $frag = $1; # save the id
	    return  $1;
	}
    }
}

sub get_uri
{
    my $self = shift;
    my $uri = RDF::Redland::Node->new_from_uri_string($self->uri->as_string);
    return $uri;
}
sub SetType
{
    my $self = shift;
    my $type = shift;
    my $env = shift;

    # now 
    $self->{introspector}=$env->get_node($self->get_id($env));;
    my $typename= "introspector::node_" . $type;;
    eval "use $typename;";
    bless $self->{introspector},"introspector::node_" . $type;
}
sub GetInstance
{
    my $self = shift;
    return $self->{introspector};
}
1;
package Introspector::GCC::Handler;

use strict;
use warnings;
use RDF::Redland;
use RDF::Redland::Serializer;
use Data::Dumper;
use URI;
use introspector::node_base;


my $BASEHOST = "http://purl.oclc.org";
my $BASEPATH ="/NET/introspector/2002/11/24/";
my $BASEURI  =$BASEHOST.$BASEPATH; # the base URI

use introspector::node_base;
use introspector::node_base_interface;

use introspector::node_named;
use introspector::node_identifiable;
use introspector::node_chained;
use introspector::node_ityped;
use introspector::node_Ialigned;
use introspector::node_Ichained;
use introspector::node_Icontainer;
use introspector::node_Iqualified;
use introspector::node_Isized;
use introspector::node_Isubdecl_REF;
use introspector::node_Ityped;
use introspector::node_Iunqualified;
use introspector::node_aligned;
use introspector::node_qualified;
use introspector::node_unqualified;

use introspector::Boolean;
use introspector::Char;
use introspector::Integer;
use introspector::String;

use introspector::node_typed;

use introspector::node_IType;

use introspector::node_sized;

use introspector::node_Long;
use introspector::node_METHOD;
use introspector::node_POINTER;
use introspector::node_SCALAR;
use introspector::node_Short;
use introspector::node_Type;

use introspector::identifier_text;
use introspector::integer_cst;
use introspector::long_text;
use introspector::node_ARRAY;
use introspector::node_Boolean;
use introspector::node_Byte;
use introspector::node_Double;
use introspector::node_Float;
use introspector::node_HASH;

use introspector::node_addr;
use introspector::node_addr_expr;

use introspector::node_array_ref;
use introspector::node_array_type;
use introspector::node_asm_stmt;
use introspector::node_bin_expr;
use introspector::node_bit_and;
use introspector::node_bit_and_expr;
use introspector::node_bit_ior;
use introspector::node_bit_ior_expr;
use introspector::node_bit_not;
use introspector::node_bit_not_expr;
use introspector::node_bit_xor;
use introspector::node_bit_xor_expr;
use introspector::node_boolean_type;
use introspector::node_break_stmt;
use introspector::node_call;
use introspector::node_call_expr;
use introspector::node_case_label;
use introspector::node_case_stmt;

use introspector::node_complex_type;
use introspector::node_component_ref;
use introspector::node_compound;
use introspector::node_compound_expr;
use introspector::node_compound_stmt;
use introspector::node_cond;
use introspector::node_cond_expr;
use introspector::node_cond_stmt;
use introspector::node_const;
use introspector::node_const_decl;
use introspector::node_constructor;
use introspector::node_container;
use introspector::node_continue_stmt;
use introspector::node_convert;
use introspector::node_convert_expr;
use introspector::node_decl;
use introspector::node_decl_stmt;
use introspector::node_do_stmt;
use introspector::node_enumeral_type;
use introspector::node_eq;
use introspector::node_eq_expr;
use introspector::node_exact_div;
use introspector::node_exact_div_expr;
use introspector::node_expr;
use introspector::node_expr_stmt;
use introspector::node_exprs;
use introspector::node_field_decl;
use introspector::node_fix_trunc;
use introspector::node_fix_trunc_expr;
use introspector::node_float;
use introspector::node_float_expr;
use introspector::node_for_stmt;
use introspector::node_function_decl;
use introspector::node_function_type;
use introspector::node_ge;
use introspector::node_ge_expr;
use introspector::node_goto_stmt;
use introspector::node_gt;
use introspector::node_gt_expr;
use introspector::node_identifer_text;

use introspector::node_identifier_node;
use introspector::node_ids;
use introspector::node_if_stmt;
use introspector::node_indirect_ref;
use introspector::node_integer_cst;
use introspector::node_integer_type;

use introspector::node_label_decl;
use introspector::node_label_stmt;
use introspector::node_le;
use introspector::node_le_expr;
use introspector::node_long_string;
use introspector::node_long_text;
use introspector::node_lshift;
use introspector::node_lshift_expr;
use introspector::node_lt;
use introspector::node_lt_expr;
use introspector::node_max;
use introspector::node_max_expr;
use introspector::node_min;
use introspector::node_min_expr;
use introspector::node_minus;
use introspector::node_minus_expr;
use introspector::node_modify;
use introspector::node_modify_expr;
use introspector::node_module;
use introspector::node_mult;
use introspector::node_mult_expr;
use introspector::node_nameable;

use introspector::node_ne;
use introspector::node_ne_expr;
use introspector::node_negate;
use introspector::node_negate_expr;
use introspector::node_non_lvalue;
use introspector::node_non_lvalue_expr;
use introspector::node_nop;
use introspector::node_nop_expr;
use introspector::node_param_decl;
use introspector::node_parm_decl;
use introspector::node_plus;
use introspector::node_plus_expr;
use introspector::node_pointer_type;
use introspector::node_postdecrement;
use introspector::node_postdecrement_expr;
use introspector::node_postincrement;
use introspector::node_postincrement_expr;
use introspector::node_predecrement;
use introspector::node_predecrement_expr;
use introspector::node_preincrement;
use introspector::node_preincrement_expr;

use introspector::node_rdiv;
use introspector::node_rdiv_expr;
use introspector::node_real_cst;
use introspector::node_real_type;
use introspector::node_record_type;
use introspector::node_ref_expr;
use introspector::node_reference_type;
use introspector::node_result_decl;
use introspector::node_return_stmt;
use introspector::node_rshift;
use introspector::node_rshift_expr;
use introspector::node_save;
use introspector::node_save_expr;
use introspector::node_scope_stmt;

use introspector::node_stmt;
use introspector::node_stmt_expr;
use introspector::node_string_cst;
use introspector::node_subdecl;
use introspector::node_subdecl_REF;
use introspector::node_switch_stmt;
use introspector::node_text;
use introspector::node_tree_list;
use introspector::node_trunc_div;
use introspector::node_trunc_div_expr;
use introspector::node_trunc_mod;
use introspector::node_trunc_mod_expr;
use introspector::node_truth_andif;
use introspector::node_truth_andif_expr;
use introspector::node_truth_orif;
use introspector::node_truth_orif_expr;
use introspector::node_truth_xor;
use introspector::node_truth_xor_expr;
use introspector::node_type;
use introspector::node_type_decl;

use introspector::node_unary_expr;
use introspector::node_union_type;

use introspector::node_var_decl;
use introspector::node_void_type;
use introspector::node_while_stmt;

sub new
{
    my $class = shift;
    my $filename  = shift;
    my $self = {
	filename => $filename,
	datamodel => {
	    predicates=>{}
	},
	nodes => {
	
	},
       #http://purl.oclc.org/NET/introspector/2002/11/24/gcc/node_fields#tree-code
	handler => {
	    'tree-code' => sub {
		# should give us type information about a node
		my ($p,$s,$o)=@_;
		if($s)
		{
		    #$s->Setnode_type($o);
		    # now we rebless with the right type, no we did that
		}
	    },
	    'modifier' => sub {
		# todo 
		# look up the modifier,
		# extract the field
	    },
	    'filename' => sub {
		# should give us type information about a node
		my ($p,$s,$o)=@_;
		    if($s)
		    {
			$s->Setsrcp($o);
			# now we rebless with the right type, no we did that
		    }
		}
		,
	    'binf' => sub {
	    },

	    'linenumber' => sub {
		# should give us type information about a node
		my ($p,$s,$o)=@_;
		    if($s)
		    {
			$s->Setsrcl($o);
			# now we rebless with the right type, no we did that
		    }
		}
		,
	    'type' => sub    {
		# sets the type of this node
		my ($p,$s,$o)=@_;
		#$s->Setnode_type($o);
	    }
	}
    }; # self 


##################################
    return bless $self, $class;
}
sub read_storage
{
    my $self = shift;
    warn "Creating storage\n";
    $self->{storage}=new RDF::Redland::Storage("hashes", "test", 
						  "new='no',hash-type='bdb',dir='.'");


    die "Failed to create RDF::Redland::Storage\n" unless $self->{storage}; 
    # this gives the term "self storage a new meaning"

    warn "\nCreating model\n";
    $self->{model}=new RDF::Redland::Model($self->{storage}, "");
    die "Failed to create RDF::Redland::Model for storage\n" unless $self->{model};

}
sub new_storage
{
    my $self = shift;
    warn "Creating storage\n";
    $self->{storage}=new RDF::Redland::Storage("hashes", "test", 
						  "new='yes',hash-type='bdb',dir='.'");


    die "Failed to create RDF::Redland::Storage\n" unless $self->{storage}; 
    # this gives the term "self storage a new meaning"

    warn "\nCreating model\n";
    $self->{model}=new RDF::Redland::Model($self->{storage}, "");
    die "Failed to create RDF::Redland::Model for storage\n" unless $self->{model};
}
sub get_node($) # the id
{
    my $self = shift;
    my $id =shift;

    my $reference;
    if (not undef($reference= $self->{nodes}->{$id}))		# how it this object used?
    {
	$self->{nodes}->{$id}->{seen}++; # 
	$reference = $self->{nodes}->{$id};
	bless $reference,"introspector::node_base";
	$reference->Setid($id);
    }
    return $reference;
}

sub bookfield
{
    my $self=shift;
    my $name=shift;
    my $val =shift;

    if ($val->type eq 1)
    {
	my $u = URI->new($val->uri->as_string());
	my $path   = $u->path;       
	my $frag   = $u->fragment;  
  
	if ($path)
	{
	}
	if($path eq $self->{filename})
	{
	    if ($frag =~/id-(\d+)/)
	    {
		$path ="ID";
		$frag = $1; # save the id
#		$frag = 0;
		return  $self->get_node($1);
	    }
	    elsif($frag =~/filename-([\w\%\.]+)/)
	    {
		$path ="FILE";		
		$frag = $1; # save the id
		$self->{datamodel}->{$name}->{$path}->{$frag}++;
	    }
	}
	if ($path eq "/1999/02/22-rdf-syntax-ns#type")
	{
	    $path = $BASEPATH;
	    $self->{datamodel}->{$name}->{"qualifier"}->{$frag}++;	    
	    return Introspector::GCC::Modifier->new($frag);
	}
	if($path =~ s!$BASEPATH(.*)!INTROSPECTOR!)
	{
	    $self->{datamodel}->{$name}->{$path}->{$frag}++;
	    if ($1 eq 'gcc/node_fields')
	    {
		return Introspector::GCC::FieldRef->new($frag);
	    }
	    #gcc/node_fields

	    #gcc/node_types
	    elsif ($1 eq 'gcc/node_types')
	    {
		return Introspector::GCC::TypeRef->new($frag);
	    }
	    #gcc/node_modifiers
	    elsif ($1 eq 'gcc/node_modifiers')
	    {
		return Introspector::GCC::Modifier->new($frag);
	    }
	    #logic/boolean'
	    elsif ($1 eq 'logic/boolean')
	    {
		return Introspector::Logic::Boolean->new($frag);
	    }
	    $path = $1;
	}
	else
	{
	    $self->{datamodel}->{$name}->{$path}->{$frag}++;
	    return $path ."#". $frag;
	}

    }
    else
    {
	$self->{datamodel}->{$name}->{literal}->{$val->type}++;
	return $val->literal_value();
    }
}

sub handle_statement
{
    my $self = shift;
    my $stmt = shift;
    my $s = shift;


#    my $s =$self->bookfield ("subject",$stmt->subject);
    
    my $p =$self->bookfield ("predicates",$stmt->predicate);
    my $o =$self->bookfield ("objects",$stmt->object);
    $o=$self->get_node($o);;



    if ($s)
    {
	if ($self->{handler}->{$p})
	{
#	    warn "handler $p";
	    my $sub = $self->{handler}->{$p};
	    &$sub($p,$s,$o);
	}
	else
	{
	    warn "adding handler $p";
	    my $method = "Set". $p;
	    
	    my $sub =  sub 
	    {
		# default handler

		my ($pred,$subj,$obj)=@_;
		if($subj)
		{

		    eval  {
			$s->$method ($o);
		    };

		    if ($@ ne "")
		    {
			warn "ERROR $@";
		    }
			
		    # now we rebless with the right type, no we did that
		}
	    };
	    &$sub($p,$s,$o);
	    $self->{handler}->{$p}=$sub;# learn something new
	}
    }

}

sub getfields
{
    my $self = shift;
    my $subject = shift;
    my $uri = $subject->get_uri();;

    my $statement=RDF::Redland::Statement->new_from_nodes(
							  $uri,

							  undef,undef); 
    my $stream=$self->{model}->find_statements($statement);

    my $count = 0;
    while(!$stream->end) {
	my $statement2=$stream->next;
#	print "Matching Statement: ",$statement2->as_string,"\n";
#	my $subject=$statement2->subject;
#	print "  Subject: ",$statement2->subject->as_string,"\n";
#	print "  Predicate: ",$statement2->predicate->as_string,"\n";
#	print "  Object: ",$statement2->object->as_string,"\n";
	$count ++;

	$self->handle_statement($statement2,
				$subject->GetInstance()
				);
    }
    print "  Subject: ",$subject->as_string," has $count statements\n";    

#    finish($s);
    $stream=undef;
}

sub interpret_type
{
    my $self    =shift;
    my $subject =shift;
    my $object  =shift;
    
# now we rebless the subject pass this type in
    bless $subject,"Introspector::Redland::Subject";
    
    my $u = URI->new($object->uri->as_string());
    my $path   = $u->path;       
    my $frag   = $u->fragment;  
    
    if($path =~ s!$BASEPATH(.*)!INTROSPECTOR!)
    {
	#gcc/node_types
	if ($1 eq 'gcc/node_types')
	{
	    #return Introspector::GCC::TypeRef->new($frag);
	    # now we create a new instance of this
	    $subject->SetType ($frag,$self);


	}
	else
	{
	    die "bad type";
	}
    }      
    else
    {
	die "missing type";
    }
}
# here we find the nodes on the first classfier attribute, 
# the tree code
sub findallnodes
{
    my $self = shift;
    my $statement=
	RDF::Redland::Statement->new_from_nodes(undef
						, 
						RDF::Redland::Node->new_from_uri_string(
											
							   $BASEURI. 
							   "gcc/node_fields#tree-code"
											), 
						undef);
    
    my $stream=$self->{model}->find_statements($statement);

    my @sub;

    while(!$stream->end) {
	my $statement2=$stream->next;
	my $subject=$statement2->subject;
	my $object=$statement2->object;
	
	$self->interpret_type($subject,$object);
			
	$self->getfields($subject);
    }
    $stream=undef;
 }

sub add_statements
{
    my $self = shift;
    my $model = $self->{model};
    my $filename = $self->{filename};
    my $count =0;
    warn "\nParsing URI (file) $filename\n";
    my $uri=new RDF::Redland::URI("file:$filename");
   
    
    my $parser=new RDF::Redland::Parser("ntriples", "text/plain"); #//"raptor", "ntriples
    die "Failed to find parser\n" if !$parser;

    my $stream=$parser->parse_as_stream($uri,$uri);

    while(!$stream->end) {
	my $stmt = $stream->next();
	
	$model->add_statement($stmt);
	$count++;
    }
    $stream=undef;
    warn "Parsing added $count statements\n";
}

sub finish 
{
    my $self = shift;
    warn Dumper($self) . "Finished";
#    warn $self->PrintXML() . "Finished";
}

1;

#################################
use strict;
use warnings;
use RDF::Redland;
use RDF::Redland::Serializer;
use Data::Dumper;
use URI;
use introspector::node_base;


sub main
{
    my ($test_file)=@ARGV;
    
    my $introspector = Introspector::GCC::Handler->new($test_file);
    my $read =0;

    if ($read)
    {
	$introspector->read_storage();
    }
    else
    {	
	$introspector->new_storage();
	$introspector->add_statements();
    }

    $introspector->findallnodes();
    $introspector->finish();
    $introspector= undef;   
}

main;
