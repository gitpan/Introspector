package gcc::node;
#################################################################################
# MODULE  : gcc::node
# Author  : James Michael DuPont
# Generation : First Generation
# Status     : To Review
# Category   : Loading of data
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

use Data::Dumper;

sub new
{
    my $class= shift;
    my $self = shift; # the self is older data!
   # my $data = shift;    
    bless $self,$class;
    $self->process_new ($data);
    return $self;
}

sub process_new
{
    my $self =shift;

    # ok, we now should have an 
    foreach my $ref (keys %{$self->{refs}})
    {
	# for each type of field store the fact that it has been referenced
	# get a pointer to the other, it has been created in the ref object
	my $other = $self->{refs}->{$ref}; # who is referenced?

	$self->$ref($other); # try and set the object via a method!
    }

    # each value objects
   # foreach my $field (keys %{$self->{vals}})
   # {
	# store the values of the fields that are note references
	#$types->{$type}->{vals}->{$field}++;
   # }

}
no strict "refs";    
sub initfields
{
    # initializes the types of fields
    my $package = shift; # where to install the subroutines into!
    my $fields = shift;  # a hash of fields
    foreach my $fieldname (keys %{$fields})
    {

	# get a ref to the field object
	my $fieldobj = $fields->{$fieldname};
	my $functionname = $package . "::". $fieldname;

	*$functionname = sub {
	    my $self = shift;
	    my $value = shift;
	    if ($value)
	    {
		# check the type
		if ($fieldobj->check($value))
		{
		    # set the value
		    $self->{$fieldname}=$value;
		}
		else
		{
		    gcc->type_error($fieldobj,$value);
		}
	    }
	    return $self->{$fieldname};
	}# end of sub
    }
};
sub dump
{
    my $self= shift;
    print Dumper $self;
}

our %level_pass_types;
sub process
{
    # this is an empty sub for implementing the functions needed
    my $self = shift;
    my $level = shift; # what level of the graph,
    my $pass = shift;  # what pass of the 

    my $type = ref $self;
    print join " ", "process", $type, $self->{id}, "\n";


    $level_pass_types{$level}->{$pass}->{$type}++;

    1; # it is called after new on each node!
}

1;


