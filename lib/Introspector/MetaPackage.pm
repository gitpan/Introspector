#################################################################
#
# MAIN
# MODULE  : MetaPackage.pm
# Purpose : To allow the creation of new classes on the fly.
# Author  : James Michael DuPont
# Date    : 24.7.01
# Uses          : This package uses a modified version of the Contract Class
# Generation    : Second Generation
# Category      : Meta Data - Classes
# Purpose       : To Describe a perl class well enough to generate it 
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

package Introspector::MetaPackage;
use strict;
use warnings;
use Class::Contract; # a contract class
use Introspector::MetaAttribute;   # Attributes
use Introspector::MetaMethod;      # Methods
use Introspector::MetaInheritance; # Inheritance
use Introspector::CodeFormatter;   # Get those pesky tabs right
use Carp qw(confess cluck);
use Introspector::DebugPrint;
use Introspector::Eval;
# all packages created are derived from this
# 
contract {

#    ctor 'new'; # takes the name as a parameter
#    impl {
#	my $name = shift;
#	${self->_name}  = $name; # save the name of 
#    };

#########################################################
# NAME ATTRIBUTE
attr '_name'; # the name of the package, not to be confused with the name of the field of the derived class


##########################################################
# identifiers COLLECTION
# all identifiers in the package must be unique
attr 'identifiers' => 'HASH'; # list of attributes 
method 'add_identifier';
impl {
    my $element = shift;
    my $name    = ${$element->_name};
    my $rIds =  \%{self->identifiers};  # the package identifiers
    confess "name $name not unique " if (exists($rIds->{$name}));
    $rIds->{$name} = $element; ## add to the hash
};

#########################################################
# INHERITS Collection
     attr '_inherits' => 'ARRAY'; # list of attributes 
     method 'add_inherits';
     impl {
           my $inherits= shift;
           debugprint "Added Inheritances to " . ${$inherits->_baseclass} . "\n";

          push @{self->_inherits},$inherits;
      };
##########################################
# ATTRIBUTE COLLECTION
     attr '_attrs' => 'ARRAY'; # list of attributes 

     method 'add_attr';
     impl {
           my $attr= shift;
           self->add_identifier($attr); # die if it is duplicate
           push @{self->_attrs},$attr;
    };
##########################################
# METHOD COLLECTION

    #method 
    attr '_methods' => 'ARRAY'; # list of attributes 
    method 'add_method';
    impl {
	my $method= shift;
	self->add_identifier($method); # die if it is duplicate
	push @{self->_methods},$method;
    };
    #abstract 



method 'instanciate_code';
impl
{
    resettabs; 
    my $package_name = ${self->_name};

    print "instanciate code :$package_name\n";

    ###################################
    # WARNING : 
    # The following block can be confusing, we are creating code that is 
    # very simlar to the code in this package
    # we will create the source code for the current package and return it.
    ###################################
    # we will create a contract here 
no strict 'refs';
 Class::Contract::SetLocation($package_name); # hack the contract


#    my $block = \{     
#      Class::Contract::ctor 'new'; # simple contructor
#     if (self->_inherits) # if there elements in the collection
#     {
#	 map {
#	     $_->instanciate_code(self); # instanciate
#	 }
#	 @{self->_inherits};
#     }
#     
#     if (self->_methods) # if there elements in the collection
#     {
#	 map {
#	     $_->instanciate_code(self); # instanciate
#	 }
#	 @{self->_methods};
#     }    
#     if (self->_attrs) # if there elements in the collection
#    {
#	 map {
#	     $_->instanciate_code(self); # instanciate
#	 }
#	 @{self->_attrs};
#     }
#};
 Class::Contract::contract {   
   Class::Contract::ctor 'new'; # simple contructor
 };
 Class::Contract::SetLocation (undef); # so everyone is happy!
};

########################################
#######################################
#      method 'instanciate_attrs';
#      impl {
#          my $codestr = "";
#          if (self->attrs)
#  	{
#  	    map {
#  		$_->instanciatecode();
#  	    }
#  	    @{self->attrs};
#  	}
#  	return 1;
#      };
#      #attributes


### FOR HANDLING GENERATED CODE
method 'use';
impl {
     # we want to use another module
     my $package = shift;
     Eval::safe_eval "use $package";

};

method 'SafeEval';
impl {
    my $code = shift;
    my $noprint = shift;
 Eval::safe_eval $code;
};


#  ##########################################
#  # Invariants COLLECTION

#  #	'invars',   # invariants 
#      attr 'invars' => 'ARRAY'; # of MetaConstraint; # class or object attr this is on the class level

#      method 'gen_invars';
#      impl {
#  	my $codestr = "";
#  	if (@{self->invars})
#  	{
#  	    map {
#  		$codestr .= $_->gencode;
#  		$codestr .= "\n";
#  	    }
#  	    @{self->invars};
#  	}
#  	return $codestr;
#      };


#  ##########################################
#  # GENERATE CODE 
#  method 'gencode';
#  impl 
#  {
#      resettabs; 
#      my $package_name = ${self->_name};
#  ###################################
#  # WARNING : 
#  # The following block can be confusing, we are creating code that is 
#  # very simlar to the code in this package
#  # we will create the source code for the current package and return it.
#  ###################################
#      my $codestr = "package $package_name;\n";
#      $codestr .= "use GeneratedPackage; # a set of functions that help visit the nodes\n";
#       $codestr .= "our \@ISA = qw(GeneratedPackage); # all classes are derived from this!\n";
#      $codestr .= "use NodeVisitors; # a set of functions that help visit the nodes\n";
#      $codestr .= "use Class::Contract; # a contract class, but a local (modified) one!\n";
#      $codestr .= "contract { \n"; 
#      pushl;
#      $codestr .= tabs . "ctor 'new';\n";
#      $codestr .= self->gen_inherits;
#      $codestr .= self->gen_invars;
#      $codestr .= self->gen_methods;
#      $codestr .= self->gen_attrs;
#      popl;
#      $codestr .= "\n};#End of Class::Contract\n";
#      $codestr .= "print \"# Loaded Package " . ${self->_name} ."!\\n\";\n";
#      $codestr .= "1;\n";
#      $codestr .= "\n#". ("-" x 80) ."\n";
#  };


#      method 'gen_attrs';
#      impl {
#          my $codestr = "";
#          if (self->attrs)
#  	{
#  	    $codestr = "# ATTRIBUTES \n";
#  	    map {
#  		$codestr .= $_->gencode;
#  		$codestr .= "\n";
#  	    }
#  	    @{self->attrs};
#  	}
#  	return $codestr;
#      };

#      method 'gen_inherits';
#      impl {
#          my $codestr = "";
#  	if (self->_inherits)
#  	{
#  	    $codestr = "# INHERITANCE \n";
#  	    map {
#  		$codestr .= $_->gencode;
#  		$codestr .= "\n";
#  	    }
#  	    @{self->inherits};
#  	}
#  	return $codestr;
#      };

#      method 'gen_methods';
#      impl {
#          my $codestr = "";
#  	if (self->methods)
#  	{
#  	    $codestr = "# METHODS \n";
#  	    map {
#  		$codestr .= $_->gencode;
#  		$codestr .= "\n";
#  	    }
#  	    @{self->methods};
#  	}
#  	return $codestr;
#      };
#  };
#  ##########################################
#  # Load The Generated Code
#  method 'Load';
#  impl {
#      my $package_name =${self->_name};
#      print "# DEBUG Load -- Going to create package $package_name\n";
#      my $package_body = self->gencode;
#           self->SafeEval($package_body);
#      };

##########################################
# Test the Generated Code

method 'Test';
impl {
    my $package = ${self->_name};
    ###############
    # now we use the packages
    ###############
    #my $code = "#use $package;\n";
    #$code .= "my \$x = new $package;\n";
    #$code .= "\$x->test(); # try and test the object\n";
    #self->SafeEval($code);
    Eval::safe_eval 
    q[
       debugprint "\n\n GOING TO TEST $package\n";
        my $x = new $package;
	$x->test;
	debugprint "\n\n after TO TEST $package\n";
    ];
     debugprint "\n\n after TO TEST $package $@\n";

  };

};

# so that we can set a breakpoint
# b MetaPackage::SafeEvalError 
sub SafeEvalError 
{
    my $code     = shift;
    my $noprint  = shift;
    my $message =  "## DEBUG SafeEval returned UNDEF, error was $@ \n Code was : \n#-----------!\n$code\n#----------!" ;
    if (!$noprint) 
    { 
	confess $message;
    }
    else
    {
	print "Error $@\n";
	cluck $message; # we had some problems
    }
}

1;

