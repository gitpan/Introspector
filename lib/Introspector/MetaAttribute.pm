package Introspector::MetaAttribute; # Structural Feature in UML

#################################################################
#
# MODULE  : MetaAttribute.pm
# Author  : James Michael DuPont
# Date    : 7.9.01
# Generation    : Second Generation
# Status        : To review
# Category      : Meta Data - Classes
# Purpose       : Stores the attributes of an object
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



use Class::Contract; # a contract class
use strict;
use warnings;

use Introspector::MetaFeature; # a contract class
use Introspector::CodeFormatter;
use Introspector::DebugPrint;
contract
{
    inherits 'Introspector::MetaFeature'; # like in uml core

    ctor 'new'; impl {
#	warn  "MetaAttribute(" . join ("," ,@_) . ")";
	my $name =shift;
	my $type =shift;
	${self->_type} = $type;
	${self->_name} = $name;
    };

    attr '_type' => 'SCALAR';# for now MetaType; #  HASH,SCALAR,ARRAY, Class

#      method 'gencode';
#      impl
#      {    
#  	my $name = ${self->_name};
#  	my $type = ${self->_type};
#  	my $codestr = tabs . "attr \'" . $name  . "\' => \'" . $type . "\';"; 
#  # generate the code
#  	$codestr .= self->MetaFeature::gencode;
#  	return  $codestr;
#      };

    method 'instanciate_code';
    impl
    {
	my $package = shift;  #what package is this contained in

	my $name = ${self->_name};
        my $type = ${self->_type};
        # call the contract
        {
	    debugprint "Added Attribute $name of type $type\n";
	    Contract::attr($name   =>  $type); # instanciate a contract attribute
	}
	return  1;
    }
};
1;

package Introspector::MetaAttributeOpt; # optional attribute that contains a simple value!
use strict;
use warnings;

use Class::Contract; # a contract class
use Introspector::MetaFeature; # a contract class
contract {
    inherits 'MetaAttribute'; # 
};
1;

  package Introspector::MetaAttributePointer; # optional attribute that contains a typed value
use strict;
use warnings;

  use Class::Contract; # a contract class
  use Introspector::MetaFeature; # a contract class

  contract {
      inherits 'MetaAttribute'; # 
      attr '_possibletype' => 'SCALAR'; # a hash of possible types
  };
  1;

package Introspector::MetaAttributeReference; # a reference (cannot be null) to an object of one type
use strict;
use warnings;

use Class::Contract; # a contract class
use Introspector::MetaFeature; # a contract class
contract {
    inherits 'MetaAttribute'; # 
};
1;

package Introspector::MetaAttributeMulti; # a reference (cannot be null) to an object of many types type
use strict;
use warnings;

use Class::Contract; # a contract class
use Introspector::MetaFeature; # a contract class
contract {
    inherits 'MetaAttribute'; # 
    attr '_possibletypes' => 'HASH'; # a hash of possible types
    ctor 'new'; impl {
	
        my $name =shift;
	my $type =shift;
 	my $possible_types =shift;
	${self->_type} = $type;
	${self->_name} = $name;
	%{self->_possibletypes} = %{$possible_types};
  	if (@_)
  	{
  	    debugprint("#created MetaAttributeMulti($name,$type,");
  	    debugprint(join(",",keys %{$possible_types}));
	    debugprint(")\n"); 
	}
    };
    # invariable on the setting of the value,
    # the type of the value must be one of the prescribed types!
};
1;

package Introspector::MetaAttributePointerMulti; # optional pointer to multiple types
use strict;
use warnings;
use Class::Contract; # a contract class
use Introspector::MetaFeature; # a contract class
contract {
    inherits 'MetaAttributeMulti'; # 
};
1;

package Introspector::MetaAttributeReferenceMulti; 
use strict;
use warnings;
# mandatory reference to multiple types.
# you must choose one of the many
use Class::Contract; # a contract class
use Introspector::MetaFeature; # a contract class
contract {
    inherits 'MetaAttributeMulti'; # 

    # METHOD - add mandatory type
    #        - add 
};
1;


#  package MetaAttributeList; # this is a pointer attribute that is really a list!
#  use Class::Contract; # a contract class
#  use MetaFeature; # a contract class
#  use strict;
#  use warnings;
#  # each element in the pointer chain should be then added to the parent in the end.
#  # so we have a list head and a list element,each element is then added to the head
#  contract {
#      inherits 'MetaAttributeMulti'; # 
#  };

1;





