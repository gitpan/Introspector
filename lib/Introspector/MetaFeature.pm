#################################################################
#
# MODULE  : MetaFeature.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Generation    : Second Generation
# Category      : Meta Data - Classes
# Purpose       : BaseClass of a Feature, methods and attributes
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


package Introspector::MetaFeature;

use strict;
use warnings;
use Class::Contract; # a contract class
use Introspector::MetaConstraint;

contract { # base class for methods and attributes

#    ctor 'new'; 
#    impl {
#	# the second paramet
#	warn  "MetaFeature(" . join ("," ,@_) . ")";
#    };

#####################################################
# used by the derived classes
    attr '_name';   # => 'SCALAR'
    attr '_shared'; #  => 'SCALAR'; # class or object attr
#####################################################
# used by this class
    attr '_pre';    # OPTIONAL   => 'MetaConstraint'; # class or object attr, OPTIONAL
    attr '_post';   # OPTIONAL  => 'MetaConstraint'; # class or object attr
 
    method 'instanciate_code';
    impl
    {
	my $package = shift;  #what package is this contained in
	my $name = ${self->_name};
        # call the contract
        {
	 
		if (self->_pre && ${self->_pre})
		{
		    self->_pre->instanciate_code}
		}
		if (self->_post && ${self->_post})
		{
		    self->_post->instanciate_code;
		}
          }
};



1;




