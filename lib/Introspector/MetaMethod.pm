#################################################################
#
# MODULE  : MetaMethod.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Generation    : Second Generation
# Status        : To review
# Category      : Meta Data - Classe
# Purpose       : Stores the method of a class
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


package Introspector::MetaMethod; # Structural Feature in UML
use Class::Contract; # a contract class
use Introspector::MetaFeature;
use strict;
use warnings;
use Introspector::CodeFormatter;
use Introspector::DebugPrint;
contract
{
    inherits 'Introspector::MetaFeature'; # like in uml core
    attr '_code' => 'SCALAR';# for now BODY of code

    ctor 'new'; impl {
	${self->_name} = shift;
	${self->_code} = shift;
    };

    method 'instanciate_code';
    impl
    {
	my $package = shift;  #what package is this contained in
	my $name = ${self->_name};
        my $packagename = ${$package->_name};
        debugprint "Adding Method ". ${self->_name} . " to : $packagename " .  ${self->_code}. "\n";
        Class::Contract::method(${self->_name});

        my $code= ${self->_code}; # call the function

        Class::Contract::impl(
		       sub {
			   &$code; # eval the code
                       } # rewrap the code
                  );
        self->MetaFeature::instanciate_code; # for pre and post conditions

	return  1;
    }

#  #      method 'gencode';
#  #      impl
#  #      {    
#  #  ######################################################
#  #  	my $codestr = tabs . "method"; 
#  #  	$codestr .=  " q[";
#  	$codestr .=  ${self->_name};
#  	$codestr .=  "]";
#  	$codestr .=  ";";
#  	$codestr .= "\n";
#  ######################################################
#          # backup 
#  	$codestr .= tabs ."impl {\n";
#  pushl;
#  	$codestr .= tabs . ${self->_code};
#          $codestr .= "\n";
#  popl;
#          $codestr .= tabs . "};\n";
#          # generate the code for pre and post condition 
#          $codestr .= self->MetaFeature::gencode;
#          return  $codestr; 
#       }    
};
1;

