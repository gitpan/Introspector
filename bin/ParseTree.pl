#! perl -w

package Handler;
use strict;

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

sub end_document
{
    my $self = shift;


    print 'my @element_types = qw(';
    foreach my $element (keys %{$self->{elements}})
    {
	print "\t$element\n";
    }
    print ');' . "\n";

    print '$nodes_types = {';
    foreach my $element (keys %{$self->{nodes}})
    {
	print "\t\"$element\" => \{\n";
	foreach my $attr (keys %{$self->{nodes}->{$element}->{Attributes}})
	{
	    print "\t\t". $attr . '=> 1,'. "\n";
	}
	print "\t" . '}' . ",\n";
    }
    print '};'. "\n";
}

sub start_element_superroot{}
sub start_element_str{}     
sub start_element_strg{}
sub start_element_used{}
sub start_element_algn{}
#sub start_element_built_in{}
sub start_element_high{}
sub start_element_low{}
sub start_element_line{}
sub start_element_xmlroot{}
sub start_element_lngth{}
sub start_element_qualconst{}
sub start_element_qualrest{}
sub start_element_qualvol{}
sub start_element_srcl{}
sub start_element_srcp{}

sub end_element_node
{
    my $self = shift;
    pop @{$self->{elementstack}}; #add the name to the stack    
}

sub start_element_node
{
    my $self = shift;
    my $element= shift;
    my $nodename =$element->{Attributes}->{node_name};  # extract the node name from the attribute  
    $self->{nodes}->{$nodename}->{count}++; # count the node names
    push @{$self->{elementstack}}, $nodename; #add the name to the stack    
}

sub start_element
{
    my $self =  shift;
    my $element = shift;
    my $elementname = $element->{Name};

    push @{$self->{stack}}, $element->{Name}; #add the name to the stack
    die "no element name" unless $elementname;

    $self->{elements}->{$elementname}->{count}++;

    eval {
	my $methodname= "start_element_" . $element->{Name};
	no strict 'refs';
	&$methodname($self,$element);
    };
    if ($@) #default,
    {

	my $lastelement = @{$self->{elementstack}}[-1];	

	$self->{nodes}->{$lastelement}->{Attributes}->{$elementname}++; #add the name to the stack


	foreach my $attr (keys %{$element->{Attributes}})
	{
	    my $val =$element->{Attributes}->{$attr};
	    if ($self->{verbose}){	
		print $attr.  "=". $val  . ",";
	    }
	    # add to the elements
	    $self->{elements}->{$element->{Name}}->{Attribute}->{$attr}++;
	}

    if ($self->{verbose}){	
	print "\t" x scalar(@{$self->{stack}}) ; # the height of the stack
	print "+";
	print $element->{Name};
	print "\n";
    }

    }
}
sub end_element
{
    my $self =  shift;
    my $element = shift;
    if ($self->{verbose}){	
	print "\t" x scalar(@{$self->{stack}}) ; # the height of the stack
	print "-";
	print $element->{Name};
	print "\n";
    }
    pop @{$self->{stack}}; # pop it off

    eval {
	my $methodname= "end_element_" . $element->{Name};
	no strict 'refs';
	&$methodname($self,$element);
    };
    if ($@) #default,
    {
	
    }

}
sub characters
{
    my $self= shift;
    my $element = shift;
    # if the parent is looking for a text.
    $self->{lasttext}= $element->{Data};
    if ($self->{verbose}){	
	print "!";
    }
}

1;
use strict;
use XML::Parser::PerlSAX;
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
my @filenames = qw (

		    /home2/gccxml/params.c.tu


		    );

my $parser = XML::Parser::PerlSAX->new( );
my $handler = new Handler;

foreach (@filenames)
{
    print "File $_";
    my $result = $parser->parse(
				Source=>{
				    SystemId=>$_
					
				    },
				DocumentHandler => $handler
				);
}



