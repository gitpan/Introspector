package gcc::noderef; # this is a node that has not been seen yet!
#################################################################################
# MODULE  : gcc::noderef
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

sub new
{
    my $class= shift;
    my $self = shift; # the self is older data!
    bless $self,$class;
    return $self;
}

sub process
{
    # this is an empty sub for implementing the functions needed
    my $self = shift;
    print join " ", "process", ref $self, "\n";
    1; # it is called after new on each node!
}

1;
