#################################################################
#
# MODULE  : MetaInheritance.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Status        : To review
# Generation    : Second Generation
# Category      : Meta Data - Class
# Purpose       : Stores information about inheritance
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

package Introspector::MetaInheritance; # Structural Feature in UML
use Class::Contract; # a contract class
use strict;
use warnings;
use Introspector::CodeFormatter;
use Introspector::DebugPrint;
contract
{
    # construct
    ctor 'new'; impl {
	my $baseclass =shift;
	${self->_baseclass} = $baseclass;
    };

    # base class
    attr '_baseclass' => 'SCALAR';


    method 'instanciate_code';
    impl
    {
	my $package = shift;  #what package is this contained in
	my $baseclass = ${self->_baseclass};
        my $packagename = ${$package->_name};

        debugprint "MetaInheritance::Added Inheritance from $packagename to $baseclass\n";
        Class::Contract::inherits($baseclass); 
    };

      # generate code
#      method 'gencode'; impl {    
#          my $baseclass = ${self->_baseclass};
#          my $codestr = tabs . "inherits \'node_" . $baseclass  . "\';"; 
#  	return  $codestr;
#      }    
};
