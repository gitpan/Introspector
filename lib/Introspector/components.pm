#################################################################################
# MODULE  : components.pm
# Purpose : 
# Author  : James Michael DuPont
# Generation : First Generation
# Status     : Obsolete
# Category   : meta-programming
# Description:
#    Here we will write and  use a high level language to specify objects.
#    we will document the structure of the nodes of the compiler.
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

use Data::Dumper;
use strict;
use warnings;


##############################
my %identifiers;
my $i = \%identifiers;
my %member; # group members
my %groups; # group members
my $program;
my %visit; # group members
##############################

sub Descend { # Descend onto a field

};
sub SuperGroup { # this group is made of these other groups
    my $name=  shift;
    my @array = @_;
    $identifiers{$name}->{members}= \@array;
    $identifiers{$name}->{supergroup}= \@array;
}; 

sub contains {# this node contains these nodes
    my $name=  shift;
    my $other_node = shift;
    my $field = shift;
    $identifiers{$name}->{contains}->{$field} = $other_node;
}; 

sub group {# this group contains these types
    my $name=  shift;
    my @array = @_;
    push @{$identifiers{$name}->{members}}, @array;
    push @{$groups{$name}->{members}}, @array;
    map {
	if (exists($member{$_}->{ofset}))
	    {
		my $membership = $member{$_}->{ofset};
		push(
		     @{$membership},
		     $name);		
	    }
	    else
	    {
		my $membership =$member{$_}->{ofset} = [];
		push(
		     @{$membership},
		     $name);		
	    };
       $identifiers{$_}->{membership}=$member{$_};# group member

     } @array;
    

#    $identifiers{$name}->{members}= \@array;

}; 

sub Field { # this group contains this field
    my $name    = shift;
    my $element = shift;

    $identifiers{$element}->{field}->{count}++; # is a field!
    $identifiers{$name}->{fields}->{$element}->{count}++;
};

sub FieldType
{
    my $record_type    = shift;
    my $field    = shift;
    my $field_type    = shift;
    $identifiers{$record_type}->{fields}->{$field}->{type}= $field_type;
    $identifiers{$field}->{field}->{type}                 = $field_type; # is a field!
    push @{$identifiers{$field}->{inrecord}},$record_type; # is a field!
}

sub Fields { # this group contains these fields
    my $name    = shift;
    my @array = @_;
    map {
	$identifiers{$_}->{field}->{inrec}=$name; # where is this field used?
	$identifiers{$name}->{fields}->{$_}->{used}=1; 
     } @_;
}

sub FieldInfo 
{ # this field has this mapping in the compiler. 
  # assuming the field is accesable via 
  # via a macro and that 
  # it is just a simple record and field!
    my $object_type = shift;
    my $xml_name    = shift;
    my $macro_name  = shift;
    my $record_name = shift;
    my $field_name  = shift;
    my $field_type  = shift;
    my $rec = {
       object_type => $object_type,
       xml_name    => $xml_name,
       macro_name  => $macro_name,
       record_name => $record_name,
       field_name  => $field_name,
       field_type  => $field_type
    };
    $identifiers{$object_type}->{fields}->{$xml_name}= $rec; 
    
};
sub find_membership
{
    my $id = shift;
    
}
sub synonym {# this type is equal to that type
    my $from=shift;
    my $to=shift;    
    $identifiers{$from} = $identifiers{$to};
}; 


sub Program 
{ # the program contains many visits
    my $name = shift; # the name of the program
    $program->{name} = $name;
}

sub Visit 
{ # we want to visit this node
    my $node_type  = shift;
    my $field_type = shift;
    $visit{$node_type}++;
}

########################################################################################################
########################################################################################################
sub LoadProgram
{
    group("ids",
	  qw(
	     identifier_node
	     )
	  );
    Fields('ids',qw(strg lngt));
    FieldInfo('identifier_node',"strg","IDENTIFIER_POINTER"  ,"identifier"        ,"id.str"); # pointer to string
    FieldInfo('identifier_node',"lngt","IDENTIFIER_LENGTH"   ,"identifier"        ,"id.len"); # length of identifier

################################
    group("list",
	  qw(
	     tree_list
	     )
	  );
    Fields("list",qw(purp valu chan));
    FieldInfo("purp","TREE_PURPOSE"  ,"list"        ,"purpose"); # pointer to string
    FieldInfo("valu","TREE_VALUE"    ,"list"        ,"value"); # pointer to string
    FieldInfo("chan","TREE_CHAIN"    ,"common"      ,"chain"); # pointer to string

################################
    group("decls",
	  qw(
	     const_decl
	     var_decl
	     type_decl
	     function_decl
	     )
	  );

     # const_decl
     # fields : 'chan,cnst,name,srcl,srcp,type'
     # const_decl is a decl
     # 'const_decl,field_decl,function_decl,parm_decl,type_decl,var_decl' => 'chan,name,srcl,srcp,type'
     #decl is chained
     # 'const_decl,field_decl,function_decl,parm_decl,tree_list,type_decl,var_decl' => 'chan',
     # decl is a named
     # 'boolean_type,complex_type,const_decl,enumeral_type,field_decl,function_decl,integer_type,parm_decl,pointer_type,real_type,record_type,type_decl,union_type,var_decl,void_type' => 'name'
     # decl is a typed
     # 'addr_expr,const_decl,constructor,field_decl,function_decl,integer_cst,nop_expr,parm_decl,string_cst,type_decl,var_decl' => 'type',
    Fields(
	   'const_decl', 
	   qw(
	      cnst
	      )
	   ); # a constant declaration has a constant value
    FieldInfo("cnst",         # xml output
	      "DECL_INITIAL", # macro
	      "tree_decl",    # the type of struct
	      "initial",      # the member in the struct
	      "const_decl",   # the object is of this type
	      "integer_cst"   # the field points to 
	      );              # the value of the const

################################
    group("consts",
	  qw(
	     integer_cst
	     string_cst
	     real_cst
	     complex
	     )
	  );
    Fields("integer_cst", qw(high low type));
    FieldType("integer_cst", "type", "integer_type"); #  the integer constant is of type integer!
    FieldInfo("integer_cst",
	      "high",  # xml output
	      "TREE_INT_CST_HIGH",    # macro
	      "tree_int_cst",         # the type of struct
	      "int_cst.int_cst.high", # the member in the struct
	      "integer"               # the field type
	      );                      # the high word value of the integer const

    FieldInfo("integer_cst",
	      "low",  # xml output
	      "TREE_INT_CST_LOW",     # macro
	      "tree_int_cst",         # the type of struct
	      "int_cst.int_cst.low",  # the member in the struct
	      "integer"               # the field type
	      );                      # the high word value of the integer const



    #####################################
    Fields('integer_type', qw(high low));

    #####################################
    group("simple-types",
	  qw(
	     integer_type
	     enumeral_type
	     boolean_type
	     reference_type
	     void_type
	     pointer_type
	     complex_type
	     real_type
	     )
	  );

# pointers to things
    group (
	   "pointers",
	   qw (
	       pointer_type 	 
	       reference_type
	       )
	   );
    
# more than just a type!
    group ("complex-types",
	   qw(
	      record_type
	      union_type
	      function_type
	      array_type
	      )
	   );

    Fields("array_type",qw(algn domn elts size));

    SuperGroup("all-types", qw (simple-types complex-types ));

    contains('function_type','parm_decl','prms'); # a function has parameters
#contains('function_type','','retn'); # a function has parameters

# different types of expressions
    group("expr",
	  qw(
	     addr_expr
	     nop_expr
	     )
	  );
# record_type and union_type are both records
    group("records",('record_type', 'union_type'));

# a record or a union contain list of fields that are visited using the chan operator
    contains("records","field_decl","chan"); 

# a function contains param_decl
    contains('function_type','parm_decl');

# what can be used to init an object
    group("init", qw (constructor addr_expr nop_expr ));

# all declarations held by other things
    group("sub-decls", qw (field_decl parm_decl));
    Fields('sub-decls', 
	   (
	    'algn',
	    'scpe',  # unique to a subdecl

	    "chan", # chainable
	    "name", # nameble

	    "size", #sizeable
	    "srcl", # decl
	    "srcp", # decl
	    "type"  # typed
	    )      
	   );

# all things declared
    SuperGroup("all-decls", qw (decls sub-decls ));

#          dump  fieldmacro           struct   struct.field  the name of the class!
    FieldInfo("all-decls","scpe","DECL_CONTEXT" ,"tree_decl"  ,"context"     );
    FieldInfo("typeable","elts","TREE_TYPE"    ,"common"     ,"type"        );
    FieldInfo("constructor", "elts","CONSTRUCTOR"  ,"exp"        ,"operands"    );

# the constructor
    Fields('constructor', qw(elts type));

# the fields
    Fields('field_decl', 
	   (
	    'bpos', # unique to field_decl
	    'str'   # not in the params
	    )
	   );
# this is a field that is accessed by a function and not a macro
   FieldInfo('field_decl',"bpos","bit_position"  ,"decl", "field_decl");


# all things with type!
    SuperGroup("typed",
	       qw(
		  init
		  all-decls
		  consts
		  )
	       );
    Field("typed","type");# contains a type


# types and decls have names, 
	SuperGroup("named", 
		   qw(
		      types
		      complex-types
		      all-decls
		      )
		   );
    Field("namable","name");# contains a name

	synonym("sizeable", "namable");
    Field("sizeable","size");# contains a name
	FieldInfo("size", # our name
		  "TYPE_SIZE", # macro name
		  "type", # type name
		  "size" # field name
		  ); # measured in bits

    synonym("sizeable", "alignable");
    Field("alignable","algn");
    FieldInfo("alignable",
	      "algn", # our name
	      "TYPE_ALIGN", # macro name
	      "type", # type name
	      "align" # field name
	      ); # measured in bits

# here we have a set of objects that are in the main chain..
# there are other things that use chain, but are not interesting
    SuperGroup("chained",
	       qw (decls)
	       );

# don't bother with visiting chained objects that are coming or going to a node with the chan operator
    Program("decls names and types");
    Visit("chained","chan");              # high level visit of all declarations
    Visit("decls","name");                # name of decl
    Descend("decls","const_decl");        # what is the decl?
    Visit("const_decl","cnst");           # the value of the constant
    Visit("decls","type");                # types of decl
    Visit("typed","name");                # name of decl
}
# The type of an integer constant is not as important as its value.
# Therefore we shall lower it's priority.
# consts have types, but they are not that interesting, 
# unless they are enums!
# how do we get from consts to chained?



sub ProcessProgram
{

    LoadProgram;    
    print "ids" . Dumper(\%identifiers);
#    print "member" . Dumper(\%member);
#    print "groups" . Dumper(\%groups);
}

ProcessProgram;
