################################################################
#
# MODULE        : NodeProcess.pm
# Author        : James Michael DuPont
# Date          : 07.09.01
# Status        : Trivial
# Generation    : First Generation
# Category      : Obsolete- to delete
# Description   : Just a callback systems
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

package Introspector::NodeProcess;
use strict;
use warnings;

# here we will install callbacks that allow us to override functions on the fly

#sub ProcessNode{ 
#    # NULL IMPLEMENTATION FOR NOW
#};
sub PreProcess ($$)
{ 
    # repository
    # self
};

sub PostProcess ($$$$$)
{
    # repository
    # self
    # valfile
    # reffile
    # pass2xml
};

sub SimpleProcessing # install default - NO - processing
{
    *NodeProcess::PreProcess = sub ($$){ 
	# node is the param
	print "<"; # chickenscratch
    };
    
    *NodeProcess::PostProcess = sub ($$$$$){ 
	# node is the param
	print ">"; # chickenscratch
    };
    
}
SimpleProcessing;
1;
