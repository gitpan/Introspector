package Introspector::db_node_ref;

################################################################################
# MODULE  : db_node_ref
# Author  : James Michael DuPont
# Generation : Third Generation
# Status     : To Review
# Category   : Database interaction
# Description: 
# creates a node that is a database reference
# it is derived from the node_base
# it could be part of the node base
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

use introspector::node_base;
@ISA = qw(introspector::node_base);

sub new 
{
    my $class    = shift;
    my $id       = shift;
    my $file     = shift;
    my $function = shift;
    my $con      = shift;

    my $self = bless (
		      {			  
			  _id            => $id,
			  _node_file     => $file,
			  _node_function => $function,
			  _con      => $con			      
		      },
		      $class
		      );
    return $self;
};

sub deref
{
    # interprets the node and creates a new more detailed object from its description in the
    # database
}

1;
