#################################################################
#
# MODULE  : MetaPackages.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Status        : To review
# Generation    : Second Generation
# Category      : Meta Data - Classes
# Purpose       : Stores information about a bunch of packages
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

package MetaPackages;
use strict;
use warnings;
use Class::Contract; # a contract class
use MetaPackage;
use Eval;
# this is for simple meta information, it is hidden from the packages
contract {
    ctor 'new';
    method 'SafeEval';
    impl {
	my $code = shift;
	return Eval::safe_eval $code;	
    };

    method 'AddPackage';
    impl {
	my $package_object = shift; # package name

	my $package_name = $package_object->name;

	print "#Going to create package $package_name\n";
	my $package_body = $package_object->gencode();

	self->SafeEval($package_body);
};


    method 'TestPackage';
    impl {
	my $package = shift;
	###############
	# now we use the packages
	###############
	
	my $code = qq§
	    #use $package;
	    my \$x = new $package;
        \$x->test(); # try and test the object
	§;
	self->SafeEval($code);
   };


    method 'SelfTest';
    impl {
	## here we create the package list!
	for (1..10)
	{
	    my $package_name ="test_" . $_;
	    my $pack = new MetaPackage($package_name);
	    #####################################
	    $pack->add_attr(new MetaAttribute("Name","SCALAR"));
	    $pack->add_attr(new MetaAttribute("Size","SCALAR"));
	    $pack->add_attr(new MetaAttribute("Type","SCALAR"));
	    $pack->add_attr(new MetaAttribute("File","SCALAR"));
	    $pack->add_method(new MetaMethod('test',"print \"#in NEW of Package $package_name\""));
	    #####################################
	    self->AddPackage($pack);
	    self->TestPackage($package_name);
      }
    };
};
1;
# test main;
{
    my $packages = new MetaPackages;
    $packages->SelfTest;
}













