#!/usr/bin/perl

# RDF_Stats.pl is a statistics extractor for RDF
# perl RDF_Stats.pl ~/rdf/owl.n3 ~/rdf/owl.test http://www.w3.org/2000/01/rdf-schema#Class
# perl RDF_Stats.pl ~/gcc-main/gcc-introspector-0.1/gcc/xml/tmp_rdf-core.h_.tu__global__Mon_Dec_16_23_38_43_2002_34-dump.rdf  http://purl.oclc.org/NET/introspector/2002/11/24/gcc/node_fields#tree-code

# taken from 
# example.pl - Redland eaxmple Perl program
#
# $Id: RDF_Stats.pl,v 1.1.1.1 2003/01/19 13:46:16 mdupont Exp $
# Copyright (C) 2002-2003 James Michael DuPont

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

# statement of functionality.
# collect the frequency of the following things :
# types of subjects, objects, and predicates
# types of predicates an subject type has
# types of predicates an object  type has

# 1. extraction of the commonly used number of properties that an subject
# has. 

# 2 what is the total number of subjects in the file
# the total number of unique instances of a certain type, we count up one when we add a new object to the hash of unique usage of given uri.
# this is stored in the #total subject of the output file

# the total number of unique subjects is interesting for determining if
# there is a field that all objects contain.

# 2. Deterimining the statistics of an URI, does a predicate always have
# a different object, the same object or is there a fixed number of
# objects that have a certain frequency.

# 3. Is there a field that is a key, that all objects have in common, or
# is there a mutually exclusive set of fields(predicates) that we can
# look for all the objects that have that, and we will find each subject
# only once. Put simply, is there a primary key or a set of primary key
# fields for accessing all the objects?
# 4. Can we treat a give object as being dependant on another, or is it
# used/referenced by multiple objects. For each predicate we will try and
# determine the cardinality of the relationships defined by a predicate :
# are they associations, aggregation or composition? Are the 1-1,
# (0:1)-(1), m-n, 1-m etc.

package Introspector::NodeBase;
sub grok_field{
    my $self =shift;
#    $self->{predi}
#    $self->{obji}
    my $value = $self->{value};

    # now what is the value of the subject
    $self->{world}->{data_model}->{values}->{$value}->{predicates}->{   $self->{predi}->{value}	}++;
};

# design pattern :
# take the values of a hash and turn them into a subroutine
sub new
{
    my $class = shift;
    my $value = shift;
    my $handler = shift;
    my $type   = shift;
    my $world   = shift;
    return  bless { 
	value => $frag, 
	psub => $val,
	type => $type,
	world => $self
	}, $class;
}
1;
package Introspector::Node;
sub get_uri{
    return shift->{value};
}
our @ISA=qw(Introspector::NodeBase);
1;
package Introspector::URI;
our @ISA=qw(Introspector::NodeBase);
1;
package Introspector::Atom;
our @ISA=qw(Introspector::NodeBase);
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

# extract an id from the url
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

# copy the uri
sub get_uri
{
    my $self = shift;
    my $string = $self->uri->as_string;
    if ($string)
    {
	my $uri = RDF::Redland::Node->new_from_uri_string($string);
	return $uri;
    }
    else
    {
	return RDF::Redland::Node->new_from_uri_string("http://null.org");
    }
}

# get our data pointer that we store in the node out
#sub GetInstance
#{
#    my $self = shift;
#    return $self->{introspector};
#}
1;

package Introspector::Learner;

#this subroutine collects data about an uri
sub grokfield
{
    my $self=shift;
    my $name=shift;
    my $val =shift;

    if ($val->type eq 1)
    {
	my $subject_uri = $val->uri->as_string();
	my $u      = URI->new($subject_uri);
	my $host   = $u->host;       
	my $path   = $u->path;       
	my $frag   = $u->fragment;  
  

	if($path eq $self->{filename})
	{
	    # local URI
	    $self->{uri}->{LOCAL}->{$frag}->{usage}++;
	    Introspector::Node->new($frag,$val,"localuri",$self);
	}
	else
	{
	    if (! exists($self->{datamodel}->{$subject_uri}->{$name}))
	    {		
		$self->{totals}->{$name} ++; # the totals of the types
	    }
	    $self->{datamodel}->{$subject_uri}->{$name}->{count} ++; # another uri
	    Introspector::URI->new($subject_uri,$val,"otheruri",$self);

#	    return  bless { 
#		value => $subject_uri , 
#		psub => $val,
#		type => "otheruri",
#		world => $self
	#    },"Introspector::URI";
	}
    }
    else
    {
	# here we store the type of the literal
	#$self->{datamodel}->{$name}->{literal}->{$val->type}++;

	    Introspector::Atom->new($val->literal_value(),$val,"type",$self);
#	      return  bless { 
#	    value => $val->literal_value() , 
#	    psub  => $val,
#	    type  => "type",
#	    world => $self
#	}, "Introspector::Atom";
#	return $val->literal_value();
    }
}
sub learn_statement
{

}
1;

package Introspector::GCC::Handler;

use strict;
use warnings;
use RDF::Redland;
use RDF::Redland::Serializer;
use Data::Dumper;
use Data::BFDump qw[Dumper];
use URI;

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
sub open_output
{
    my $self = shift;
    ##################
    $self->{out}->{storage}=new RDF::Redland::Storage("hashes", "test-out", 
						      "new='yes',hash-type='bdb',dir='.'");
    die "Failed to create output RDF::Redland::Storage\n" unless $self->{out}->{storage}; 
    # this is the output model
    $self->{out}->{model}=new RDF::Redland::Model($self->{out}->{storage}, "");
    die "Failed to create RDF::Redland::Model for storage\n" unless $self->{out}->{model};
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


sub handle_statement
{
    my $self = shift;
    my $stmt = shift;
    my $s = shift;

    die unless $stmt;
    $s->{predi}=Introspector::Learner::grokfield ($self,
						  "predicates",
						  $stmt->predicate());

    $s->{obji }=Introspector::Learner::grokfield ($self,
						  "objects",
						  $stmt->object());

    # now, what subjects have what predicates
    $s->grok_field();

    if ($s)
    {
	if ($self->{handler}->{$s->{predi}})
	{
	    my $sub = $self->{handler}->{$s->{predi}};
	    &$sub($s);
	}
	else
	{
	    
	    # now we learn about something new
	    $self->{handler}->{$s->{predi}} = Introspector::Learner::learn_statement($self,$s);
	}
    }
    
    

}

sub finish_subject
{
    my $self  = shift;    
    my $stmt  = shift;
    my $s     = shift;    
    my $count = shift;
    # here we process 
    print "  Subject: ",$stmt->subject->as_string," has $count statements\n";    

}

sub getfields
{
    my $self = shift;
    my $stmt = shift;
    die "you need to pass a statement" unless $stmt; # 
    my $subj =$stmt->subject;
    die "you need a subject of the  statement" unless $subj; # 

    my $str = $subj->uri->as_string;
    if ($str)
    {
	my $uri = RDF::Redland::Node->new_from_uri_string($str);
	
	# create the subject object
	my $s =Introspector::Learner::grokfield ($self,"subject",$stmt->subject);
	
	my $stmtq=RDF::Redland::Statement->new_from_nodes( $uri, undef,undef); 
	my $stream=$self->{model}->find_statements($stmtq);
	my $count = 0;
	while(!$stream->end) {

	    my $statement2=$stream->current;
	    $count ++;

	    $self->handle_statement($statement2,
				$s
				);
	    $stream->next;
	}
	$self->finish_subject($stmt,$s,$count);
#    finish($s);
	$stream=undef;

    }
	


}

sub interpret_type
{
    my $self    =shift;
    my $subject =shift;
    my $object  =shift;
    
# now we rebless the subject pass this type in
    bless $subject,"Introspector::Redland::Subject";

    # here we break down the path
    my $u = URI->new($object->uri->as_string());
    my $host   = $u->host;       
    my $path   = $u->path;       
    my $frag   = $u->fragment;  
    
    # check a hash of uris
    #$self->{knowledge}->{$host}->{$path}->{$frag}++;
    
}
# here we find the nodes on the first classfier attribute, 
# the tree code
sub findallnodes
{
    my $self = shift;
    my $uri = shift;
    my $statement=
	RDF::Redland::Statement->new_from_nodes(undef
						, 
						RDF::Redland::Node->new_from_uri_string(
											
											$uri
											), 
						undef);
    
    my $stream=$self->{model}->find_statements($statement);

    my @sub;

    while(!$stream->end) {

	my $statement2=	$stream->current;
	my $subject=$statement2->subject;
	my $object=$statement2->object;
	
	#$self->interpret_type($subject,$object);
			
	$self->getfields($statement2,$subject);
	$stream->next;
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
	my $stmt = $stream->current();


	# collect stats on statement	
	# on the first pass, we just look at what occurances we have in the different fields
	if ($stmt ne 0)
	{
	    Introspector::Learner::grokfield ($self,"subject",$stmt->subject);
	      
	      Introspector::Learner::grokfield ($self,"predicates",$stmt->predicate);
	      Introspector::Learner::grokfield ($self,"objects",$stmt->object);
	  }
	$model->add_statement($stmt);
	$stream->next();

	$count++;
    }
    $stream=undef;
    warn "Parsing added $count statements\n";
}

sub print_output
{
    my $self = shift;
    my $filename  = shift;
    my $uri=new RDF::Redland::URI("file:$filename");
    my $serializer=new RDF::Redland::Serializer("rdfxml");
    die "Failed to find serializer\n" if !$serializer;
    my $model = $self->{out}->{model};
    $serializer->serialize_model_to_file("$filename", $uri, $model);
    $serializer=undef;
#     warn "\nPrinting all statements\n";
#     my $stream=->serialise;
#     my $cur;
#     while(!$stream->end) {
# 	$cur = $stream->next;
# 	print "Statement: ",$cur->as_string,"\n";
#     }
#     $stream=undef;
}

sub finish 
{
    my $self = shift;
#    print Dumper($self) . "Finished";
#    print Dumper($self->{datamodel}) . "Finished";

    my $model = $self->{out}->{model};    
  
    
    ########################
    # here we write the totals of the subjects, objects and predicates
    foreach my $type (sort keys %{$self->{totals}})
    {
	my $count =$self->{totals}->{$type};
	my $c = RDF::Redland::Node->new_from_uri_string("http://introspector.sourceforge.net/2002/12/22/stats.daml#count-$type");
	my $s= RDF::Redland::Node->new_from_uri_string("#total");
	my $v= RDF::Redland::Node->new_from_literal("$count", "", 0);
	my $stmt=RDF::Redland::Statement->new_from_nodes($s,
							 $c,
							 $v);
	die "Failed to create RDF::Redland::Statement\n" unless $stmt;	    
	$model->add_statement($stmt);	    
    }

    ####################

    foreach my $uri (sort keys %{$self->{datamodel}})
    {	
	foreach my $t (keys %{$self->{datamodel}->{$uri}})
	{
	    my $count =$self->{datamodel}->{$uri}->{$t}->{count};
	    my $c = RDF::Redland::Node->new_from_uri_string("http://introspector.sourceforge.net/2002/12/22/stats.daml#count-$t");
	    my $s= RDF::Redland::Node->new_from_uri_string("$uri");
	    my $v= RDF::Redland::Node->new_from_literal("$count", "", 0);
	    my $stmt=RDF::Redland::Statement->new_from_nodes($s,
							     $c,
							     $v);
	    die "Failed to create RDF::Redland::Statement\n" unless $stmt;	    
	    $model->add_statement($stmt);	    
	}
    }
}

1;

#################################
use strict;
use warnings;
use RDF::Redland;
use RDF::Redland::Serializer;
use Data::Dumper;
use Data::BFDump qw[Dumper];
use URI;

sub main
{
    my $test_file =shift (@ARGV) || die "missing first parameter (in file) "; # this is the file
    my $outfile =shift (@ARGV) || die "missing second parameter (out file) "; # this is the file
    my $baseuri  =shift (@ARGV) || die "missing third parameter (baseuri) "; # this is the predicate/attribute to search for
    
    my $introspector = Introspector::GCC::Handler->new($test_file);
    my $read =0;

    $introspector->open_output();
    if ($read)
    {
	$introspector->read_storage();
    }
    else
    {	
	$introspector->new_storage();
	$introspector->add_statements();
    }


    
    #$self->{BASE_URI};;

    # this goes over the data one more time
    $introspector->findallnodes($baseuri);

    $introspector->finish();
    $introspector->print_output($outfile);
    $introspector= undef;   
}

main;

