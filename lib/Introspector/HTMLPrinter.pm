die "this module is not ready to roll yet";
package Introspector::HTMLPrinter;
use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::CrossReference; # Who uses what, GetUsersH
use Introspector::MetaType;
use Introspector::dynload;
use Introspector::PerlGenerator;

sub LookupType
{
    my $self = shift;
    my $type = ref $self;
    $type =~ s/introspector:://g; # strip of base class

    $type =~ s/node_//g; # strip of node of the  class

    my $package_name =  TranslateName($type);             # the name of the package
    my $typeinfo = dynload::lookup($type);
  
    return {
	self     => $self,
	packname => $package_name,
	typeinfo => $typeinfo,	
	type => $type	
	};
}

# now we will create a CGI output for each node
# we will create a DataDumper output for each node
# we will create a file for each now

sub printObjectHTML
{
    my $self = shift; # the object to print

    my $typestuff = LookupType    $self;
    
    my $type     = $typestuff->{type};
    my $typeinfo = $typestuff->{typeinfo};
    my $pack     = $typestuff->{packname};

    my $tablevel = shift || 1;
    my $xmlstr;
    my $tabstr = "\t" x $tablevel;

    $xmlstr .= $tabstr .  "<". $pack;


    my @fields = dynload::GetFieldNames($type); # check the field names from the last run    

    # produce the attributes as simple values
    map {
	# each attribute
	my $attrname    = $_;       
	my $methodname = scalar(ref $self) . "::Get$attrname";
	my $val = &{"$methodname"}($self);
	my $getstring = " ";
	if ($val)
	{
	    if (!ref($val))
	    {
		    $getstring   = " $attrname = \'$val\'"; # NORMAL VALUE
	    }
	}
	else
	{
	   $getstring   = " $attrname = \'NULL\'"; # UNDEFINED VALUE
	}
        $xmlstr .= $getstring; #  if $val;
    }   @fields;
    # end of the method body
    $xmlstr .=">\n";
    # now for the parents!
    map {
	my $basename    = TranslateName($_);       

	#$self->introspector::node_base::PrintXML()     
	$xmlstr .= "<$basename/>\n"; #  if $val;

#	my $method =  "introspector::" . $basename . "::PrintXML";
#	&{"$method"}( $self, $tablevel+1); # call the parents

	
    } PerlGenerator::Inheritance($typeinfo);   # add all the inheritance
    # data of the fields contained
    map {
	my $attrname    = $_;
	my $methodname = scalar(ref $self) . "::Get$attrname";
	my $val = &{"$methodname"}($self);
	my $getstring;

	if ($val)
	{
	    if ($$val)
	    {
		$getstring   = " <subnode><$attrname>";
		$getstring   .= $val->PrintXML($tablevel + 1);
		$getstring   = "</$attrname></subnode>";
	    }
	    else
	    {
		$getstring   = "<subnode><$attrname/></subnode>";
	    }

        $xmlstr .= $getstring . "\n"; #  if $val;

	}
    }   @fields;

    # the end of the class
    $xmlstr .= $tabstr . "</". $pack . ">\n";

    return $xmlstr;
    
}

1;

