#! perl -w
#################################################################
#
# MAIN
# MODULE  : ParseGCCXML.pm
# Author  : James Michael DuPont
# Status        : In use
# Generation    : Third Generation
# Category      : XML Parser- Meta Data Loader
# Description   : Reads in the XML data from the compiler
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

package Introspector::Handler;
use strict;
use Data::Dumper;
use Introspector::FileHandle;
# b Handler::start_element, Handler::end_element_node
use Introspector::Eval;

=head1

CHANGES TO DO : 
1. For each list, we want to point to the owner.
    
2. For each attribute, insert into the useage table

3. Insert into base node table for each node that is put in a derived table.
    3.1 base_node contains id and type
    3.2 derived node the same data.
 
    Just Double Book them......
    we can use inheritance if the db supports it.

    3.3
    Or we can make on big fat base table that has all of the fields.
    That way we can get all the data with one fetch.

    3.4
    We can encode the table name into the id, so that we can choose the right table.
    and use the base table to find the basic data.
    
    3.5 we can store the entire node as a single xml string that has to be parsed.
    
    
4. For each node, find the closest decl

=cut

sub new
{
    my $self = {};
    my $class = shift;
    bless $self,$class;
    return $self;
}

sub start_document
{

}
sub start_element_xmlroot{
    my $self = shift;    my $element = shift;
}
sub end_element_str{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{str} = "'" . $element->{text} . "'";

}   
sub quote
{
    my $str = shift;

    # look for a \' and replace it
    $str =~ s/\'/\\\'/g; # add a backslash!

    return "'" . $str . "'";
}
  
sub end_element_strg{
    my $self = shift;
    my $element = shift;      
    my $parentelement = @{$self->{estack}}[-2];	
#    $parentelement->{"fields"}{strg} = "'" .  

    $parentelement->{"fields"}{strg} = quote $element->{text}

#	. "'";
}
sub end_element_used{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	$parentelement->{"fields"}{used} = "'" . $element->{text} . "'";
}
sub end_element_algn{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{algn} = $element->{text};
}

sub end_element_prec{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{prec} = $element->{text};
}

#sub start_element_built_in{}
sub end_element_high{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{high} = $element->{text};

}
sub end_element_low{
    my $self = shift;my $element = shift;
    
    if (defined($element->{text})) # low is a string
    {	
	my $parentelement = @{$self->{estack}}[-2];
	$parentelement->{"fields"}{low} = $element->{text};
    }
    else # low is a reference!
    {
	handle_field($self,$element);
    }
    

}
sub end_element_line{
    my $self = shift;my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];$parentelement->{"fields"}{line} = $element->{text};
 
}

sub end_element_lngth{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{lngth} = $element->{text};

}
sub end_element_qualconst{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{qualconst} = "'". $element->{text} . "'";

}
sub end_element_qualrest{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{qualrest} = "'". $element->{text} . "'";

}
sub end_element_qualvol{
    my $self = shift;
    my $element = shift;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{qualvol} = "'". $element->{text} . "'";

}
sub end_element_srcl{
    my $self = shift;
    my $element = shift;
    # add this to the parents node
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{srcl} = $element->{text};
}
sub end_element_srcp{
    my $self = shift;
    my $element = shift;
    # add this to the parents node
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{srcp} =  "'" . $element->{text} . "'";
}


sub open_files
{
    my $self = shift;

    my $outfile = "./xml/"  . "_" . $self->{cur_funcname} . ".xml";
    $self->{outfile} = $outfile;


    $self->{status} = "READ";
    warn "Open File" . $outfile;
    
    
    my $reportfile = $outfile. ".rep";
    my $sqlreportfile = $outfile. ".sql";
    
    warn $reportfile;
    warn $sqlreportfile;
    
    my $fh = new FileHandle;
    $fh->open(">$reportfile") or die;
    $self->{report} = $fh;
    $self->{reportfile} = $reportfile;
    
    $fh = new FileHandle;
    $fh->open(">$sqlreportfile") or die;
    $self->{sqllog}=$fh;
    $self->{sqllogfile} = $sqlreportfile;
    
    return $outfile;

}

sub start_element_xml_cfile{
    my $self = shift;

    my $element = shift;
    # the name of the file is in the attribute "name"
    my $filename =$element->{Attributes}->{name};  # extract the node name from the attribute  
    $self->{cur_filename} =$filename;
    
    # add to the database
    $self->{conn}->add_file($filename);
    
    $self->open_files;
}


sub start_element_xml_cfunction{
    my $self = shift;
    my $element = shift;

    # the name of the file is in the attribute "name"
    my $functionname =$element->{Attributes}->{name};  # extract the node name from the attribute  
    $functionname =~ s/^\.//;
    $self->{cur_funcname} =$functionname;

    # add to the database
    $self->{conn}->add_function($self->{cur_filename},$functionname);

#    $self->open_files;
    my $outfile = "./xml/"  . "_" . $self->{cur_funcname} . ".xml";
    warn "FILENAME" . $outfile;
    $self->{outfile} = $outfile;

# turn off skip!
#    if ((-f $outfile)  or (-f $outfile . ".gz"))
#    {
#	$self->{status} = "SKIP";	
#	die "SKIP File" . $outfile; # inside of eval!
#    }
#    else
    {
	$self->{status} = "READ";
	warn "Open File" . $outfile;


	my $reportfile = $outfile. ".rep";
	my $sqlreportfile = $outfile. ".sql";
	
	warn $reportfile;
	warn $sqlreportfile;
	
	my $fh = new FileHandle;
	$fh->open(">$reportfile") or die;
	$self->{report} = $fh;
	
	$fh = new FileHandle;
	$fh->open(">$sqlreportfile") or die;
	$self->{sqllog}=$fh;
	return $outfile;

    }

}

##########################################################################################
##########################################################################################
#
##########################################################################################
##########################################################################################
sub handle_field
{
    my $self          = shift;
    my $element       = shift;
    my $idx           = $element->{Attributes}->{idx};    
    my $fieldname     = $element->{Name};
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{$fieldname} = $idx;
}
sub handle_field2
{
    my $self          = shift;
    my $element       = shift;
    my $name          = shift;
    my $idx           = $element->{Attributes}->{idx};    
    my $fieldname     = $name;
    my $parentelement = @{$self->{estack}}[-2];	
    $parentelement->{"fields"}{$fieldname} = $idx;
}
##########################################################################################
sub start_element_name{ handle_field @_}
sub start_element_type{ handle_field @_}
sub start_element_unql{ handle_field @_}
sub start_element_size{ handle_field @_}
sub start_element_min{ handle_field @_}
sub start_element_max{ handle_field @_}
sub start_element_args{ handle_field @_}
sub start_element_prms{ handle_field @_}
sub start_element_scpe{ handle_field @_}
sub start_element_flds{ handle_field @_}
sub start_element_body{ handle_field @_}



# for the tree
sub start_element_chan{ handle_field @_}
sub start_element_valu{ handle_field @_}

##
sub start_element_op_0{ handle_field @_}
sub start_element_op_1{ handle_field @_}
sub start_element_op_2{ handle_field @_}
sub start_element_val{ handle_field @_}
sub start_element_purp{ handle_field @_}
sub start_element_next{ handle_field @_}


# we have torename
sub start_element_else{ handle_field2 "else_stmt",@_}
sub start_element_then{ handle_field2 "then_stmt",@_}
sub start_element_cond{ handle_field @_}
sub start_element_csts{ handle_field @_} #constant
sub start_element_fn  { handle_field @_} #call expr
sub start_element_ptd { handle_field @_} #pointer
sub start_element_refd{ handle_field @_} #reference of a node
sub start_element_retn{ handle_field @_} #return of a function
sub start_element_init{ handle_field @_} #expr
sub start_element_elts{ handle_field @_} #array
sub start_element_domn{ handle_field @_} #arra
sub start_element_expr{ handle_field @_} #expr stmt
sub start_element_argt{ handle_field @_} #expr stmt


sub start_element_node
{
    my $self = shift;
    my $element= shift;

    my $nodename =$element->{Attributes}->{node_name};  # extract the node name from the attribute      
    $element->{fields}->{id} = $element->{Attributes}->{idx};# store the id!
    $element->{fields}->{node_type} = "'$nodename'";# store the id!
    $element->{fields}->{node_file} = "'". $self->{cur_filename} . "'";# store the id!
    $element->{fields}->{node_function} = "'". $self->{cur_funcname} . "'";# store the id!

    eval {
	my $methodname= "start_element_node" . $nodename;
	no strict 'refs';
	&$methodname($self,$element);
    };  
    #Eval::safe_eval_check; 

}

sub get_text
{
    my $element = shift;
    my $elementname = $element->{Name};
    my $nodename =$element->{Attributes}->{node_name};  # extract the node name from the attribute  

    return "$nodename" if $nodename;
    return "$elementname";   
}

sub start_element
{
    my $self =  shift;
    my $element = shift;
    my $elementname = $element->{Name};

    push @{$self->{estack}}, $element; #add the name to the stack

    push @{$self->{stack}}, $element->{Name}; #add the name to the stack
    die "no element name" unless $elementname;

#    my $nodename =$element->{Attributes}->{node_name};  # extract the node name from the attribute  
#    if ($nodename)
#    {
#	$self->{nodes}->{$nodename}->{count}++; # count the node names
#	push @{$self->{elementstack}}, $nodename; #add the name to the stack
#    }
    $self->{elements}->{$elementname}->{count}++;

    eval {
	my $methodname= "start_element_" . $element->{Name};
	no strict 'refs';
	&$methodname($self,$element);
    };
  #Eval::safe_eval_check;

    if ($@) #default,
    {
	my $lastelement = @{$self->{estack}}[-1];	
	my $parentelement = @{$self->{estack}}[-2];	
	my $grandparentelement = @{$self->{estack}}[-3];	
	
	$self->{
	    'nodes'
	    }->{get_text($parentelement)}->{
		'children'
		}->{get_text($lastelement)}++; #add the name to the stack	   

#	$self->{nodes}->{get_text($lastelement)}->{Attributes}->{$elementname}++; #add the name to the stack
	foreach my $attr (keys %{$element->{Attributes}})
	{
	    my $val =$element->{Attributes}->{$attr};
	    if ($self->{verbose}){	
		print  $attr.  "=". $val  . ",";
	    }
	    if ($attr eq "idx")
	    {

	    }	    
	    elsif ($attr eq "ref_node_name")
	    {
		# here we add the types of attributes
		$self->{relationships}->{get_text($parentelement)."\t".get_text($lastelement)."\t$val" }++; #add the name to the stack
	    }
	    else
	    {
		# add to the elements
		$self->{nodes}->{get_text($lastelement)}->{Attributes}->{$attr}++; #add the name to the stack
	    }
	}

    if ($self->{verbose}){	
	print  "\t" x scalar(@{$self->{stack}}) ; # the height of the stack
	print "+";
	print $element->{Name};
	print "\n";
    }

    }
}

sub end_element_node_identifier_node
{
    my $self = shift;
    my $element = shift;
    my $strg = shift;
}

sub end_element_node_function_decl
{
    my $self = shift;
    my $element = shift;

    $self->{report}->print( "function:" . 
	$element->{srcp} . "\t" .
	$element->{srcl} . "\t" .
	$element->{name} . "\n")
}

sub end_element_node
{
    my $self = shift;
    my $element = shift;

    
    eval {
	my $nodename =$element->{Attributes}->{node_name};  # extract the node name from the attribute  
	return unless $nodename;
	my $methodname= "end_element_node_" . $nodename;
	

	my ($errorMessage,$oid,$cmdStatus,$sql) = $self->{conn}->add_node($nodename,$element->{fields});

	my $sqlret = join ",",($errorMessage,$oid,$cmdStatus,$sql);
	warn $errorMessage . "\n" if $errorMessage =~ "ERROR";

	$self->{sqllog}->print($sql);
	$self->{report}->print($sqlret);

	

	# for reporting
	foreach (keys %{$element->{fields}})
	{
	    $self->{nodes}->{$nodename}->{subobjects}{$_}++;# add them in
	}

	no strict 'refs';
	&$methodname($self,$element);
       	
    };   
    #Eval::safe_eval_check; 

    # now insert into the database

}

sub end_element
{
    my $self =  shift;
#    my $element = shift;
    my $element = @{$self->{estack}}[-1];

    $self->{report}->print("-");

    if ($self->{verbose}){	
	print "\t" x scalar(@{$self->{stack}}) ; # the height of the stack
	print "-";
	print $element->{Name};
	print "\n";
    }

#    my $nodename =$element->{Attributes}->{node_name};  # extract the node name from the attribute  
    eval {
	my $methodname= "end_element_" . $element->{Name};
	no strict 'refs';
	&$methodname($self,$element);
    };
#  Eval::safe_eval_check; 

    pop @{$self->{estack}}; # get the object off the stack
    pop @{$self->{stack}}; # pop it off
#    if ($nodename)
#    {
#	pop @{$self->{elementstack}}; #add the name to the stack    
#    }
    if ($@) #default,
    {
	
    }

}
sub characters
{
    my $self= shift;
    my $element = shift;
    # if the parent is looking for a text.
    my $lastelement = @{$self->{estack}}[-1];	

    $lastelement->{text} .= $element->{Data};
#    $self->{lasttext}= $element->{Data};
    if ($self->{verbose}){	
	print "!";
    }
}

sub print_element_types
{
    my $self = shift;
    foreach my $element (keys %{$self->{elements}})
    {
	$self->{report}->print ("element_types\t$element\n");
    }
}

sub print_relations_types
{
    my $self = shift;
    foreach my $element (keys %{$self->{relationships}})
    {
	my $key =$self->{relationships}->{$element};
	$self->{report}->print  ("RELTYPE:$element\t$key\n");
    }    
}

sub print_attributes
{
    my $self = shift;
    foreach my $element (keys %{$self->{nodes}})
    {
	foreach my $attr (keys %{$self->{nodes}->{$element}->{Attributes}})
	{
	    $self->{report}->print("ATTR:$element\t$attr\n");
	}
    }    
}

sub print_element_types
{
    my $self= shift;

    foreach my $element (keys %{$self->{nodes}})
    {
	$self->{report}->print("NODETYPEDEF: \"$element\" => \{");       	
	{
	    $self->{report}->print("\"subtypes\" => {");
	    foreach my $attr (keys %{$self->{nodes}->{$element}->{subobjects}})
	    {
		$self->{report}->print("'$attr' => 1, ");
	    }
	    $self->{report}->print("},");
	}
	$self->{report}->print("},\n");
    }

}

sub end_document
{
    my $self = shift;
    print_relations_types($self);
    print_attributes($self);
    print_element_types($self);
#    print Data::Dumper::Dump($self);
}

1;

package ParseGCCXML;

use strict;
use XML::Parser::PerlSAX;
use database::queries;

#my $filename = "/home2/gccxml/c-dump.c.dequeue_and_dump.tu";
#		   /home2/gccxml/libgcc2.c.tu		    
#  		   /home2/gccxml/c-parse.c.tu
#  		   /home2/gccxml/toplev.c.tu
#  		    /home2/gccxml/c-decl.c.tu
#  		    /home2/gccxml/c-lang.c.tu
#  		    /home2/gccxml/c-common.c.tu
#  		    /home2/gccxml/stmt.c.tu
#  		    /home2/gccxml/function.c.tu
#		    /home2/gccxml/version.c.tu
#my @filenames = qw (
#		    /home2/gccxml/params.c.tu
#
#	    );
use File::Copy;

$SIG{__DIE__} = sub {
    #print "DIE!";
#      File::Copy::move $filename, "error.xml";	
    };

# b ParseGCCXML::Parse
sub Parse
{
    my $type = shift;
    my $filename = shift;
    my $parser   = XML::Parser::PerlSAX->new( );
    my $handler  = new Handler;
    my $conn     = new database::queries;
    $handler->{conn} = $conn;

    $handler->{cur_filename} ="___global";
    $handler->{cur_funcname} ="___global";

    die "$filename missing" unless -f $filename;
    # the file does not have an intelligent file name, yet.
    print "File $type $filename\n";	

    eval {
	print "File $type $filename\n";	
	my $result = $parser->parse(
				    Source=>{
					SystemId=>$filename
					    
					},
				    DocumentHandler => $handler
				    );

	warn "move " . $filename . " ->". $handler->{outfile};
        File::Copy::move $filename, $handler->{outfile} or warn "cannot move";

	# compress the file!

	$handler->{report}->close;
	$handler->{sqllog}->close;


	unlink $handler->{outfile} . "gz";
	unlink $handler->{outfile} . ".sql.gz";
        unlink $handler->{outfile} . ".rep.gz";


	warn "OUTFILE" . $handler->{outfile};
	system "gzip " . $handler->{outfile};


	warn "SQLFILE" . $handler->{outfile} . ".sql";
	system "gzip " . $handler->{outfile} . ".sql";


	warn "REPORTFILE" . $handler->{outfile} . ".rep";
	system "gzip " . $handler->{outfile} . ".rep";
	
#############
	unlink $handler->{outfile};
	unlink $handler->{outfile} . ".sql";
        unlink $handler->{outfile} . ".rep";

	# move the files out!
	
	$conn->disconnect;
#	if ($result ne 1)
#	{
#	  File::Copy::move $filename, scalar(time())."error2.xml";	
#	    die $@ . "$result";
#	}


    };
    # skip files
    if ($handler->{status} ne "SKIP")
    {
      Eval::safe_eval_check; 
    }
    else
    {  
	print "outfile : ". $handler->{outfile} . "\n";
	print "Status " . $handler->{status} . "\n";
	print "skipping and delete $filename\n";
	unlink $filename; # get rid of the temp files

    }

}

1;


