# Author  : James Michael DuPont
# Copyright James Michael DuPont 2001
# Licence : Perl Artistic Licence 
package dynload;

use FileHandling;
use LoadMetaInfo; # load

# global data
our $types;   # filled out by loadmetainfo
our $fields;


use strict;
use warnings;
use Carp qw(confess);

sub lookup
{
    my $id = shift;
    
    if (not $types->{$id})
    {
      LoadMetaInfo::load();# try and load on demand
    }
    if (not $types->{$id}) # if that does not work!
    {
	print "available types ". join (",\n",keys %{$types});

	confess "Cannot Find the type \"$id\"";
    }

    return $types->{$id};
}

sub has_field
{
    my $type = shift;    
    my $field = shift;
    my $typeobj = $types->{$type};
    if (exists($typeobj->{std}->{refs}->{$field}))
	{
	    return "Ref : $type - $field";
	}
    if (exists($typeobj->{vals}->{$field}))
	{
	    return "Val : $type - $field";
	}
    return "(NIL)";
}

sub GetFieldNames # list of fieldnames
  {
    my $name = shift;
    my @fieldnames = (keys %{
	$types->{$name}{std}{refs}
    },
		      keys %{
			  $types->{$name}{vals}
		      });
    return @fieldnames;
#    return keys %{$identifiers{$name}->{fields}};
  }

sub CalculateOptionalFields
{
    my $type = shift;
    #
    my $std ; # the standard objects, union of all types
    my $count ; # the standard objects, union of all types
    my $values ; # the standard objects, union of all types
    my %variants ; # the standard objects, union of all types

    $count = 	   $types->{$type}{'count'};

    my %return;

#    map
#    {
#	if ($_ eq 'std')
#	{
    $std = 	   $types->{$type}{std};
    #$variants{$subtype} = 	   $types->{$type}{$subtype};
    map {
	# the subtype
	my $field  = $_;
	my %subtype; # the set of the subtypes of this field!
	my $subtotal =0;
	my $typecount=0;
	map 
	{
	    my $ftype = $_; #the type of the field
	    
	    #the count
	    my $subcount =$types->{$type}{std}{refs}{$field}{$ftype};
	    #debugprint "#Relationship(Type,Field,Type) :(" . join(",",$type,$field,$ftype) . ")\n"; # debug print
	    if ($subcount eq $count)
	    {
		$return{refs}{single_type}{$field} = $ftype;
		$typecount =1;
	    }
	    else
	    {
		$subtype{$ftype} += $subcount;
		$subtotal += $subcount;
		$typecount++;
	    }
	    
	}keys %{$types->{$type}{std}{refs}{$field}};
	
	###################################################################
	# now we check if the field is the same as the object
	
	# the multitype fields 
	if($subtotal eq 0)
	{
	    # single type of field!
	}
	elsif ($subtotal eq $count)
	{
	    # mandatory multicount
	    $return{refs}{multi_type}{$field} = \%subtype;
	}
	elsif ($typecount eq 1)
	{
	    my ($single_type) = keys %subtype;
	    $return{refs}{optional_type}{$field} = $single_type;
	}
	else
	{
	    #optional 
	    $return{refs}{optional_multi_type}{$field} = \%subtype;
	}
	#######################################################################
    } keys %{$types->{$type}{std}{refs}};

###########################################################
    map {	       
	my $field = $_;
	if ($types->{$type}{'vals'}{$_} eq $count)
	{
	    $return{vals}{mandatory}{$field} = 1;
	}
	else
	{
	    $return{vals}{optional}{$field} = 1;
	}
    } keys %{$types->{$type}{'vals'}};
#	}
#	elsif ($_ eq 'count')
#	{
#	    $count = 	   $types->{$type}{$_};
#	}
#	else
#	{
#	    # one of the variants
#	    my $subtype = $_;
#	    $variants{$subtype} = 	   $types->{$type}{$subtype};
#	    map {
#		# the subtype
#		my $field  = $_;
#		#the count
#		$subcount ={$types->{$type}{$subtype}{$field};
#		
#	    } %{$types->{$type}{$subtype}};
#	}
#    }
#    (keys %{
#	 $types->{$type}
#     });
    
   # now,
   # for each variants refs field, the should all occur the same amount
   # does the field occur as often as the main field
   return \%return;
}

###################################
sub field_list
{
    my $type = shift;    
    my $typeobj = $types->{$type};
    my %ret;

    # the references
    map {
	$ret{$_}++
	}  keys %{
	    $typeobj->{std}->{refs}
	};
    ##############################
    # store 
    map {
	$ret{$_}++
	 } keys %{
	$typeobj->{vals}
    };
    return \%ret;
}

sub field_index
{
    
    my %ret;

    map {
	my $type = $_;    
	my $typeobj = $types->{$type};

	# the references
	map {	
	    my $field= $_;
	    map {
		my $fieldtype = $_;
		$ret{$field}->{$fieldtype}->{$type}++;
	    } keys %{
		$typeobj->{std}->{refs}->{$field}
	    };

	}  keys %{
	    $typeobj->{std}->{refs}
	};
	
	##############################
	# store 
	map {
	    $ret{$_}->{'node_base'}->{$type}++
	    } keys %{
		$typeobj->{vals}
	    };

    } keys %{$types};   
    return \%ret;
}

sub class_field_index
{
    
    my %ret;
    my $type = shift;    
    my $typeobj = $types->{$type};
    
    # the references
    map {	
	my $field= $_;
	map {
	    my $fieldtype = $_;
	    $ret{$field}->{$fieldtype}->{$type}++;
	} keys %{
	    $typeobj->{std}->{refs}->{$field}
	};
	
	}  keys %{
	    $typeobj->{std}->{refs}
	};
    
    ##############################
    # store 
    map {
	$ret{$_}->{'node_base'}->{$type}++
	} keys %{
	    $typeobj->{vals}
	};    
    return \%ret;
}

sub top_level
{
    return  keys %{$types};
}

#############################################
sub names_of_fields
{

    # go over all fields
    # see who has the same fields
    # build all the permutations of the types of fields
    # see what classes we can make 
    my @keys = keys %$fields;
    # splice out bindata and binlength
    @keys = map {if ($_ !~ /bindata|binlen/) {$_} else {();}} @keys;
    return \@keys;    
}


1;








