#################################################################
#
# MODULE  : MetaAttribute.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Generation    : Second Generation
# Status        : To review
# Category      : Meta Data - Classes
# Purpose       : Stores the constraint of an object

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


package Introspector::MetaConstraint;
use Class::Contract; # a contract class
use strict;
use warnings;

contract {

    attr 'type';          # pre,post,invar
    attr 'condition';     # a reference to a code block
    attr 'error_message'; # the error message if it fails

    ctor 'new'; impl {};

    method 'instanciate_code';
    impl
    {
	my $package = shift;  #what package is this contained in

	## this is a little complex
	my $function_name  =  "Class::Contract::"  . ${self->type};
	&$function_name (  ${self->condition} ); # call the pre or post with a code block
    }

#      method 'gencode';
#      impl {
#  	my $codestr = ${  self->type} . " { " . ${self->condition} . " }; ";
#  	$codestr .= "failmsg 'error_message " . ${self->error_message} . "}; " if (${self->error_message});
#      }
};
1;
