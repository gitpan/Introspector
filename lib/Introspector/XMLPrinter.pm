package Introspector::XMLPrinter;
#b introspector::XMLPrinter::printObjectFile
#b introspector::XMLPrinter::printObjectXML
use Introspector::TranslateClasses; # use the basic functions for translation of the classes, just do it differently
use Introspector::CrossReference; # Who uses what, GetUsersH
use Introspector::MetaType;
use Introspector::dynload;
use Introspector::PerlGenerator;
use Introspector::FileHandling;
use File::Path;
use warnings;
use strict;
use Introspector::Breaker;
use Cwd ();
use Data::Dumper;
use Carp qw (confess croak );
use Introspector::gcc;
sub LookupType($$)
{
    my $repository= shift;
    my $self = shift;

    my $type = ref $self;
    $type =~ s/introspector:://g; # strip of base class
    $type =~ s/node_//g; # strip of node of the  class
    my $package_name =  TranslateName($repository,$type);             # the name of the package
    my $typeinfo = dynload::lookup($repository,$type);
  
    return {
	self     => $self,
	packname => $package_name,
	typeinfo => $typeinfo,	
	type => $type	
	};
}

# this sub will open an output file and print just this node to it.
# the file for the node should be 
# we can create a make entry for the node

sub printObjectFile($$$)
{
    my $repository = shift;
    my $self = shift;
    my $xmlstr = shift;
    die "Self Missing" unless $self;
#    die "bad type " unless UNIVERSAL::isa($self, "introspector::node_base");
    my $cwd = Cwd::cwd();

    my $nodetype = ref ($self);

    $nodetype =~ s/::/\//g; # replace
    
    my $id = $self;
    eval "
	\$id = \$self->Getid;
    ";
    $id = -1 unless $id;
    my $filename = sprintf("ID%d",$id);

    my $basedir  = "nodes/$nodetype"; # this is where we will store the stuff

    if (! -d "./output/$basedir")
    {
	mkpath "./output/$basedir" or die "cannot mkdir $basedir";
    }


    my $indexbase ="/home/mdupont/nodes/index";
    
    if (! -d $indexbase)
    {
	mkpath "$indexbase" or die "cannot mkdir $indexbase";
    }

 #   warn "Going to open $basedir/$filename";

  #Breaker::breakpoint();

    my $fileh = FileHandling::OpenOutputFile($repository,"$basedir/" . $filename);
#    warn "opened $basedir/$filename";
    # just print the node as xml to a file
    print $fileh $xmlstr;
    
    FileHandling::CloseFile($repository,$fileh);


#    warn "ln   -s  $cwd/output/$basedir/$filename $indexbase/$filename \n";# create a link
    if (! -f "$indexbase/$filename")
    {
	system "ln -s  $cwd/output/$basedir/$filename $indexbase/$filename "; # create a link
	
    }

}

sub GetValue($$)
{
    my $self   = shift;
    my $method = shift;
    my $val = eval "$method";
    if ($@ ne "")
    {
	warn "Error" . $@;
	return "Error" . $@;
    }
    return $val;
}

# look here first
my %overrides_fields =
(
 #fieldname
 name => 1, # if it is a name field
 mngl => 1, # if it is a name field
 cnst => 1, # 
 min => 1, # 
 max => 1, # 
 dom => 1, # 
 elts => 1, # 
 size => 1,  # or a size field, include it in this
 ptd => 1,  # 
 refd => 1,  # 
 retn => 1,  # 
 init => 1  # 
);
# then here

# returning 0 means stop there and just create a references
sub calculate_depth_to_go($$$)
{
    my $from_type = shift;
    my $to_type   = shift;
    my $field     = shift;    
    my $ret =0;
    my $temp=0;
    if ($temp = $overrides_fields{$field})
    {
	$ret = $temp;
    }
    print "<traverse_node from=\"$from_type\" to=\"$to_type\" field=\"$field\" />";
    return $ret;
}

sub WalkChain($$$$$$)
{
    my ($repository,$other_type,$pack,$attrname,$val,$tablevel) = @_;
    # if you find something like : 
    # enumeral_type -> csts -> node_tree_list (valu -> integer_cst) *
    # or 
    # node_record_type ->flds -> node_field_decl -> chan (valu -> node_field_decl)*
    # or 
    # node_function_type -> prms -> tree_list ( valu -> type )
    # then put them in the node for the first node!
    my $xmlstring = "";
    my $curr = $val;
    my $next;
    my $list_value;
    my $purp_value;
    while (defined($val))
    {
	my $subxml = printObjectXML ($val);
	my $valustr ="";
	my $purp_val ="";
	if (defined($purp_value = $val->{_purp}))
	{
	    $purp_val = printObjectXML($purp_value);
	}
	if (defined($list_value = $val->{_valu}))
	{
	    $valustr = printObjectXML($list_value);	 
	}
	$xmlstring .="<FIELD><LIST>$subxml</LIST><PURP>$purp_val</PURP><VALUE>$valustr</VALUE></FIELD>";

	$val = $val->{_chan}; # NEXT!!!!
    }
    return "<NODELIST>$xmlstring</NODELIST>";

};

sub WalkChain_params($$$$$$)
{
    my ($repository,$other_type,$pack,$attrname,$val,$tablevel) = @_;
    return "<NULL/>" if not $val;
    # node_function_type -> prms -> tree_list ( valu -> type )
    my $curr = $val;
    my $next;
    my $list_value;

    my $xmlstring ="<PARAM>";
    $xmlstring .=WalkChain ($repository,$other_type,$pack,$attrname,$val,$tablevel);
    $xmlstring .="</PARAM>";
#    my $xmlstring = "<PARAM>$subxml</PARAM>";
    return $xmlstring;
}

sub WalkChain_enum($$$$$$)
{
    my ($repository,$other_type,$pack,$attrname,$val,$tablevel) = @_;
    # node_enumeral_type -> csts -> node_tree_list (valu -> integer_cst) *
    return "<NULL/>" if not $val;
#    my $subxml = printObjectXML ($val);
#    my $xmlstring = "<ENUM>$subxml</ENUM>";
    my $curr = $val;
    my $next;
    my $list_value;

    my $xmlstring ="<ENUM>";
    $xmlstring .=WalkChain $repository,$other_type,$pack,$attrname,$val,$tablevel;
    $xmlstring .="</ENUM>";

    return $xmlstring;
}

sub WalkChain_fields($$$$$$)
{
    my ($repository,$other_type,$pack,$attrname,$val,$tablevel) = @_;
    return "<NULL/>" if not $val;
    my $xmlstring ="<FIELDS>";
    # we are passed a field node_record_type ->flds
    # we then have to traverse it and then create an xml subnode and return it
    # we should also call the normal printObjectXML on the nodes, but process thier children again specially
    # node_record_type ->flds -> node_field_decl -> chan (valu -> node_field_decl)*
    $xmlstring .=WalkChain $repository,$other_type,$pack,$attrname,$val,$tablevel;
    $xmlstring .="</FIELDS>";

    return $xmlstring;
}
##############################
my $handle_chains = ## from type,field
{
 node_record_type =>{
     flds => \&WalkChain_fields
 }, # the record
 node_enumeral_type =>{
     csts => \&WalkChain_enum
 }, # the record
 node_function_type =>{
     prms => \&WalkChain_params
 } # the record

};

sub step_into($$$$$$$)
{
    my $repository = shift;
    my ($other_type,$pack,$attrname,$val,$tablevel,$leveltoadd) = @_;

    # here we calculate the level to traverse
    ####################################
    print STDERR "+" . $leveltoadd;

    ####################################
    # print xml 
    ####################################
    my $getstring   .= printObjectXML(
				   $val,
				   $tablevel + 1, 
				   $tablevel + $leveltoadd
				   );
    return $getstring;
}

sub process_reference($$$$$$)
{
    my $repository = shift;
    my ($other_type,$pack,$attrname,$val,$tablevel) = @_;

    my $getstring   .= "<subnode><$attrname>";
    #################
    my $handler = $handle_chains->{$pack}->{$attrname};
    if (defined($handler))
    {
	$getstring .= $handler->($repository,$other_type,$pack,$attrname,$val,$tablevel);
    }
    else
    {
	my $level_to_add = calculate_depth_to_go ($other_type,$pack,$attrname);
	$getstring .= step_into($repository,$other_type,$pack,$attrname,$val,$tablevel,$level_to_add);
    }
    #################
    $getstring   .= "</$attrname></subnode>";
    return $getstring;
}


sub printObjectXML # no prototype
{
    my $self = shift; # the object to print

    my $repository = gcc::getrepository();
    my $tablevel = shift || 1;    
    my $level_to_traverse = shift || $tablevel ; # just go one deeper by default

    confess "Self missing " unless $self;
    my $typestuff = LookupType ($repository,$self);
    
    my $type     = $typestuff->{type};
    my $typeinfo = $typestuff->{typeinfo};
    my $pack     = $typestuff->{packname};



    # this tells us how deep to go


    print STDERR ":$tablevel/$level_to_traverse";

    if ($tablevel > $level_to_traverse)
    {
	print STDERR ";\n";
	my $id = $self->{_id}; # stop deep recursion
	return "<noderef id='$id'/>\n";
    }
    my $xmlstr;
    my $tabstr = "";
    #"\t" x $tablevel;
    $xmlstr .= "<node>"; # the start of a node
    $xmlstr .= $tabstr .  "<". $pack; # the specific node type

    # produce the attributes as simple values
    map { 	
	$_=~ s/_(.*)/Get/;                 # Cut out the name	
	my $attrname = $1;                 # Get
	my $getstring = $_.$1;             # name of the method	
	my $val = 	eval "\$self->$getstring"; # call a method
	my $xmlgetstr = "";
	if ($val)                          # if there is a value
	    {
		if (!ref($val))            # it is not a reference
		{
		    $xmlgetstr   = " $attrname = \'$val\'"; # NORMAL VALUE
		}
		else
		{
		    
		}
	    }
	else
	{
	    $xmlgetstr   = " $attrname = \'NULL\'"; # UNDEFINED VALUE
	}
	$xmlstr .= $xmlgetstr; #  if $val;

    } keys %{$self->GetData};

    # end of the method body
    $xmlstr .=">\n";
    # now for the parents!

    # data of the fields contained
    $xmlstr .= "<SUBNODES>" . "\n"; #  if $val;
    map {
	my $attrname    = $_;
	my $val  = $self->GetData->{"_$attrname"};	
	my $getstring;
	if ($val)
	{
	    my $other_type = ref $val;
	    if ($other_type)
	    {
		if ($other_type ne "SCALAR")	   
		{
		    $getstring = process_reference ($repository,$other_type,$pack,$attrname,$val,$tablevel);
		}
	    }
	    else
	    {
		$getstring   = "<subnode><$attrname/></subnode>";
	    }
	}
	else
	{
	    # not a ref, an attribute
	}
	$xmlstr .= $getstring . "\n"; #  if $val;
    }  dynload::GetFieldNames($repository,$type); # check the field names from the last run
    $xmlstr .= "</SUBNODES>" . "\n"; #  if $val;    

    $xmlstr .= $tabstr . "</". $pack . ">\n";
    $xmlstr .= $tabstr . "</node>\n";


    # now print the node to a file
    printObjectFile ($repository,$self,$xmlstr);


    return $xmlstr;
    
}
    
#    $Data::Dumper::Purity = 1;
#    $Data::Dumper::Deepcopy = 1;       # avoid cross-refs
#    $Data::Dumper::Maxdepth = 4;       # no deeper than 3 refs down
    
#    $xmlstr .= $tabstr . "<dumper>\n";
#    $xmlstr .= Dumper($self->GetData);
#    $xmlstr .= $tabstr . "</dumper>\n";
    
#    $xmlstr .= $tabstr . "<typestuff>\n";
#    $xmlstr .= Dumper($typestuff);
#    $xmlstr .= $tabstr . "</typestuff>\n";
#    $xmlstr .= $tabstr . "<attrs>\n";
#    $xmlstr .= Dumper(    $self->GetAttrs);
#    $xmlstr .= $tabstr . "</attrs>\n";
#    $xmlstr .= $tabstr . "<fields>\n";
#    $xmlstr .= Dumper(\@fields);
#    $xmlstr .= $tabstr . "</fields>\n";



1;

#b introspector::XMLPrinter::printObjectFile
#b introspector::XMLPrinter::printObjectXML
#b 204
