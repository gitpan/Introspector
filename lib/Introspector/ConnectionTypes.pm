package Introspector::ConnectionTypes;

# Category    : Obsolete, Maybe can delete?
# Category    : Meta-Programming- Object Traversal
# Description : Dispatches differenct types of relationship types

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

# We need to see what an elegant way to handle the following problems :
#  1. How we want to interpret the nodes
#     What operations we want to apply

#  2. How we want to represent the nodes
#     What data structures we want to use

#  3. How we want to traverse the node trees
#     What algorithms on those data structures

###################################

sub new
{
    my $class = shift;
    my $self  = {};

    # from this type, there is a field with the attribute of this name
    # who is associated with this other type

    # fromtype -> attributes ==> totype

}

sub attribute
{
    my ($self,$fromtype,$totype,$field)=@_;
    
}
sub subobject
{
    my ($self,$fromtype,$totype,$field)=@_;
}
sub reference
{
    my ($self,$fromtype,$totype,$field)=@_;
}
sub usage
{
    my ($self,$fromtype,$totype,$field)=@_;
}

sub connectiontype # self, connectiontype, fromtype, totype, field
{
    my $self = shift;
    my $connectiontype =shift;
    my ($fromtype,$totype,$field)=@_;

    if ($connectiontype eq "reference")
    {
	reference $self,@_;
    }
    elsif ($connectiontype eq "subobject")
    {
	subobject $self,@_;
    }
    elsif ($connectiontype eq "attribute")
    {
	attribute $self,@_;
    }
    elsif ($connectiontype eq "usage")
    {
	usage $self,@_;
    }
}
# now we want to look up a connection and get a way of traversing it back out
1;
