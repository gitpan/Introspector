package Introspector::CreateClasses;

# Category    : Important
# Category    : Meta-Programming- Definition and Modification of classes
# Description : This is a high level description of the classes of the GCC

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

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(CreateClasses);

use strict;
use warnings;

use Introspector::DebugPrint;
use Introspector::MetaType;
use Introspector::TranslateClasses;
use Introspector::ModifyClasses;
use Introspector::CrossReference; # Who uses what, AddExternalModules

################################################################
#
# MAIN
# MODULE  : CreateClasses.pm
# Purpose : use a high level language for describing the classes of the tree nodes

# Author  : James Michael DuPont
# Date    : 24.7.01
# Copyright James Michael DuPont 2001
# Licence : Perl Artistic Licence 

# EXPORTS CreateClasses  to create all the class descriptions based on the 
# statistics collected from the first pass over the nodes
#################################################################



# here we will collected data about our program
#my %identifiers; # all the identifiers, indexed by name
#my %modules;    # all the modules    , indexed by name

sub LibraryClasses($)
{
    my $repository = shift;

    # base classes from Java that have property editors
    AddScalarClass($repository ,'Boolean');
    AddScalarClass($repository ,'Byte');
    AddScalarClass($repository ,'Double');
    AddScalarClass($repository,'Float');
    AddScalarClass($repository,'Long');
    AddScalarClass($repository,'Short');
    AddScalarClass($repository,'String');
    AddScalarClass($repository,'identifier_text');
    AddScalarClass($repository,'long_text');
#    AddScalarClass($repository,'Char');
    AddScalarClass($repository,'Integer');




# pointer class

    # SQL
#    AddBuiltInClass($repository,'text'  ,"\$");
#    AddBuiltInClass($repository,'int4'  ,"\$");

    # java
    AddBuiltInClass($repository,'SCALAR'  ,"\$");
    AddBuiltInClass($repository,'POINTER' ,"\$");
    AddBuiltInClass($repository,'ARRAY'   ,"\@");
    AddBuiltInClass($repository,'HASH'    ,"\%");
    AddBuiltInClass($repository,'METHOD'  ,"\&");
};

sub CreateEvents($)
{
    my $repository = shift;
    DefineEvent($repository,'OnFirstVisit',  # When an object is visited for the first time from another
		{
		    Parameters => {
			# Name         Type
			"UsedBy"    => "Node",
			"Field"     => "FieldName",
			"NodeType"  => "NodeType",
		    }
		}
		);         # When a node it first visited
    
    DefineEvent($repository, 'InPackage', # When a node is found to be in a module
		 {
		     Parameters => {             # WHEN An object attached to it is also found there
			 # Name         Type
			 "PackageName" => "FileName"
			 }
		 });  # 
    
    
    DefineEvent($repository, 'OnPointersVisited',
		 {
		     Parameters => {
			 # Name         Type
		     }
		 }
		 );  # When all of its references are visited, but thier references have not been
    
    DefineEvent($repository, 'all_pointers_resolved',
		 {
		     Parameters => {
			 # Name         Type
		     }
		 } # When all of its references are resolved
	     );
    
    # When a Node is referenced by another node
    DefineEvent($repository, 'OnUsed'             ,
		 { # when referenced, this is called    

		     Parameters => {
			 # Name         Type
			 "UsedBy"    => "Node",
			 "Field"     => "FieldName",
			 "NodeType"  => "NodeType",
		     }
		 });
    
    DefineEvent($repository, 'printed'          , 
		 {

		     Parameters => {
			 # Name         Type
			 "UsedBy"    => "Node",
			 "Field"     => "FieldName",
			 "NodeType"  => "NodeType",
		     }
		 });
    DefineEvent($repository, 'OnChain'  ,
		 {

		     Parameters => {
			 # should we allow a function to be inserted?
			 # the next function is what is to be called when the chain fires
			 "NextFunction"    => "Closure" # THIS IS REALLY QUITE COMPLEX!
			 }
		 }
		 );         # When a node has a chain, what shall we do?
	     
}
sub BaseClass($)
{
    my $repository = shift;
    AddClass($repository,'base');                           # the class called ids
    AddField($repository,'base','id',BaseType($repository,'Integer'));            # the id of a field
    AddField($repository,'base','node_type',BaseType($repository,'String'));            # the id of a field
    AddField($repository,'base','node_file',BaseType($repository,'node_module'));            # the id of a field
    AddField($repository,'base','node_function',BaseType($repository,'identifier_text'));            # the id of a field

    # here we create an external modules
    AddExternalModules($repository,"node_base","XMLPrinter");
    AddExternalModules($repository,"node_base","DebugPrint");

    # now add a method for on used
#    EventHandler($repository,
#		 "OnPrintXML", # when the node is used
#		 'base', 
#		 sub {
#		     
#		 } # ABSTRACT!
#		 ); # when an ID is used, call this function!


    # now add a method for on used
    EventHandler($repository,
		 "OnUsed", # when the node is used
		 'base', 
		 sub {
		     
		 } # ABSTRACT!
		 ); # when an ID is used, call this function!

    EventHandler($repository,
		 "OnFirstVisit", # when the node is first visited
		 'base',          # 
		 sub {
		     my $self=shift;
		     &DebugScratch("^");
		 }               # abstract
		 ); # SIMPLE CALLBACK!

    EventHandler($repository,
		 "OnChain",   # when the node has a chain!
		 'base',      # 
		 sub {
		 }           # abstract
		 ); # SIMPLE CALLBACK!

    EventHandler($repository,
		 "OnPointersVisited",   # when the node has a chain!
		 'base',      # 
		 sub { 
		     my $self = shift;
		     NodeVisitors::Node_OnPointersVisited($repository,$self);
		 } # fine, call the function
		 ); # SIMPLE CALLBACK!        
##    EventHandler(
#		 "InPackage",   # when the node has a chain!
#		 'base',      # 
#		 'AddToPackage($self,$PackageName);'           # abstract
#		 ); # SIMPLE CALLBACK!
}



sub Identifiable($)
{
    my $repository = shift;
    # all classes that are given a name or have an id in the core.
    # not all the nameable are use thier names, some are just empty


    # nameable - contains - ids      
    # ids      - contains - named
    AddInterfaceClass($repository,'nameable');                                 # the class called ids



    #AddArrayField($repository,'nameable','identifier',TypeRef($repository,'ids'));# this can cause diamond shaped multiple inheritance
    AddClassComment($repository,'nameable'
		    ,"The Nameable class is anything that supports the function on being given a name
it contains a id object which can be a type_decl or an indentifier,
type_decls are named and indentifier nodes are identifiable"
			);

    AddClass($repository,'ids');                                 # the class called ids
    AddField($repository,'ids','named',TypeRef($repository,'named')); #  a hash of objects that are named by this id

    AddClassComment($repository,'ids',
	       "here we have the base class for the two types of ids
this has the method to be able to get the identifier string!
");
    AddMemberComment($repository,
		     'ids',
		     'named',
		     'the named are the nodes that were given a name via type_decl in the core'
		     );


    AddInterfaceClass($repository,'named');                                 # all named via a type decl
    AddInheritance($repository,'named','nameable');                # named is derived from nameable



    AddInterfaceClass($repository,'long_string');                                 # all named via a type decl
    AddField($repository,'long_string','strg',BaseType($repository,'long_text')); 

    my $named = FindReplaceField($repository,'strg',            # the field to look for
				 '*', # the type of the field
				 'long_string'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance


    # the identifiable have ids built right into them

    AddInterfaceClass($repository,'identifiable'); # all with a direct identifier pointer, this is an interface to the identifier

    AddField($repository,'identifiable','name',TypeRef($repository,'identifier_node')); #  a hash of objects that are named by this id

    AddInheritance($repository,'identifiable','nameable');# supports the namable interface,but contains an identifier

    AddInheritance($repository,'identifier_node','ids');         # the identifier is a id

#    #AddMember($repository,'named','name','type_decl');            # this member is not needed, because the base class supports it
#    my $named = FindReplaceField($repository,'name',            # the field to look for
#				 'type_decl', # the type of the field
#				 'named'            # the subclass to add to the user of the field
#				 ); # the will create useage based inheritance



#    debugprint "Nameable - Named " . join (",",keys %{$named->{types}}) . "\n" ;
    #Nameable - Named 

#    AddInheritance('identifier_node','base');        # the identifier is a id

#    ImplementInterface(  
#			 'type_decl',
#			 'ids',
#			 "id",
#			 "String"
#			 );               # the type_decl is used as an id


    # AddMember('identifiable','name','identifier_node'); # the member is not needed
    AddInheritance($repository,'decl','identifiable');#make all decls identifiables
    my $identifiable = FindField(
				 $repository,
				 'name',           # the field to look for
				 'identifier_node',# the type of the field, identifier_node
				 ); # the will create useage based inheritance
#				        'identifiable'    # the subclass to add to the user of the field
    
    # get the named fields,
    my $named2 = FindField(
			  $repository,
			  'name',           # the field to look for
			  'type_decl'       # the type of the field, identifier_node
			  ); # the will create useage based inheritance
#				        'nameable'    # the subclass to add to the user of the field
#    map  {
#	my $type = $_; # the named
#	delete $named->{types}->{$type}; # remove the identifiables from the named
#       	# these can be identified directly so we dont need a named
#    }
#    keys %{$identifiable->{types}}; # get the names of the types


                             
    ImplementSimpleInterface($repository,
			     $identifiable,   # find results
			     "name",          # field to look for
			     "identifiable",  # interface
			     "name",          # Fieldname
			     "ids");          # Typename
    ImplementSimpleInterface($repository,$named       ,"name","named"       ,"name","ids");

    print 
	"Nameable - Identifiable " . 
	    join (",", 
		  keys %{
		      $identifiable->{types}
		  }
		  ) 
		. "\n"
		   ;

    print 
    "Nameable - Named " . 
    join (",", 
	  keys %{
	      $named->{types}
	  }
	  ) 
          . "\n"
    ;

    AddInheritance($repository,'ids','base');         # the identifier is a id

    # Now we want to add a method to this class and 
    # a top level collection of ids to add to
#    AddConstructor($repository,'ids',"");    
    EventHandler($repository,
		 "OnUsed",
		 'ids',
		 sub {
		     my $self = shift;
		     my $NodeType = shift;
		     my $Field = shift;
		     my $UsedBy = shift;		     
		     # delegate to a base class
		     Introspector::node_base::OnUsed($repository,$self,$NodeType,$Field,$UsedBy); # call the base class
		     NodeVisitors::VisitIdentifier($repository,$self,$NodeType,$Field,$UsedBy);
		 }
		 ); # SIMPLE CALLBACK!

    EventHandler($repository,
	       "OnFirstVisit",
		 'ids',
		 sub {
		     my $self = shift;
		     NodeVisitors::SeeIdentifier($repository,$self);
		 }
		 ); # SIMPLE CALLBACK!


    # Nameable - Identifiable 
    # record_type,function_decl,union_type,type_decl,enumeral_type,integer_type,var_decl,field_decl,parm_decl,const_decl


    #pointer_type,complex_type,real_type,boolean_type,void_type

    # it is possible to be of type identifiable and named,
    # that means that the object can play both roles.
    # it turns out that all the objects that have identifiers also are typedefs!

    #####################################################
}    

sub Typed($)
{
    my $repository = shift;
    # what are all the classes that are used as types

        AddInterfaceClass($repository,'typed');       # all things that have a type
	# now we will add a field of typed that will point to type
	# this is a KEY!

	AddField($repository,'typed','type',TypeRef($repository,'type'));               
        # all the typed have some pointer to a type

#	AddInheritance($repository,'typed','base');         # the identifier is a id

    my $typed = FindField($repository,
			  'type',            # the field to look for
			  '.*'               # the type of the field

			  ); # the will create useage based inheritance			  			  # the recordtypes are then to be made into a class base on how they use things
	map{
	    ImplementInterface($repository,$_,       # the class to add to
			       'typed', # the interface to derive from
			       "type",   # the member to add to implement the interface
			       TypeRef($repository,"base")# the type of member to add
			       );
	} keys %{$typed->{types}}; # the types 

	# the fieldtypes  are then to be made into a class base on how they are used
	map { 
	    #AddInheritance($repository,$_,'type');                # this is used as a type of something
	    ImplementInterface($repository,$_,
			       "type",
			       "type",
			       TypeRef($repository,"type")
			       );

	} keys %{$typed->{fields}}; # the field types


};

############################
# here are the classifiers
sub SubTypes    ($)
{
    my $repository = shift;
        AddInterfaceClass($repository,'container');       # all things that are record type
        AddInterfaceClass($repository,'Icontainer');       # all things that are record type

#	AddInheritance($repository,'container','base');         # the identifier is a id
# it is not derived from base, because all containers are decls or types

# we have to rethink the FindReplaceFieldInterface Function
	AddField($repository,
		 'container',
		 'flds',
		 TypeRef($repository,'decl')
		 );            # in a chain can point to each other
# a container supports the traversal of the child elements
# but only in interface, it needs to get to the fields collection via the interface
# 
	my $fields = FindReplaceFieldInterface($repository,
					       'flds',           # the field to look for
					       '.*',             # the type of the field
					       'container'         # the subclass to add to the user of the field
					       ); # this will create usage based inheritance          


	map {
	    warn "container $_";
	    ImplementInterface($repository,$_,
			       'Icontainer',
			       "children",
			       TypeRef($repository,"decl") # this was a subdecl
			       );                # These are pointed to 
	} keys %{$fields->{types}}; # the field types       

	###############################
	# a field is a subdecl
#        AddClass($repository,'subdecl');       # all things that are declared inside something
    # UPDATE - we remove the scpe, but derive from decl anyway
	my $subdecls = FindReplaceFieldInterface($repository,
						 'scpe',           # the field to look for
						 '.*',             # the type of the field
						 'decl'  # the subclass to add to the user of the field
						 ); # this will create useage based inheritance               


#	AddField($repository,
#		 'subdecl',
#		 'scpe',
#		 TypeRef($repository,'container')
#		 );   # in a chain can point to each other

	AddField($repository,
		 'decl',
		 'scpe',
		 TypeRef($repository,'container')
		 );   # in a chain can point to each other

	# this is very important, 
	# we have a circular relationship
	# we are going to turn the backpointer into an object that is not created on demand
	# 

#	EventHandler($repository,
#		     "OnChain",   # when the node has a chain!
#		     'subdecl',      # 
#		     sub {
#			 my $self = shift;
#			 my $NextFunction = shift;
#			 &$NextFunction($self); # fine, call the function
#		     }
#		     ); # SIMPLE CALLBACK!

#	EventHandler($repository,
#		     "OnPointersVisited",   # when the node has a chain!
#		     'subdecl',      # 
#		     sub {
#			 my $self = shift;
#		       NodeVisitors::ProcessSubDecl($repository,$self); # fine, call the function
#		     }
#		     ); # SIMPLE CALLBACK!

};

sub Sizeable($)
    {
    my $repository = shift;
        AddClass($repository,'sized');       # all things that are in a chain
#	AddInheritance($repository,'sized','base');         # the identifier is a id
	AddField($repository,'sized','size',TypeRef($repository,'integer_cst'));            # in a chain can point to each other
	my $sized = FindReplaceFieldInterface($repository,'size',           # the field to look for
				       '.*',             # the type of the field
				       'sized'         # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
    };

sub Alignable  ($)
 {
     my $repository = shift;
        AddClass($repository,'aligned');       # all things that are in a chain
#	AddInheritance($repository,'aligned','base');         # the identifier is a id
	AddValue($repository,'aligned','algn');            # in a chain can point to each other
	my $aligned = FindReplaceFieldInterface($repository,'algn',           # the field to look for
				       '.*',             # the type of the field
				       'aligned'         # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
};
sub Chainable   ($){
    my $repository = shift;
    AddClass($repository,'chained');       # all things that are in a chain
#    AddInheritance($repository,'chained','base');         # the identifier is a id
    AddPointerField($repository,'chained','chan',TypeRef($repository,'chained'));            # in a chain can point to each other
    my $chained = FindReplaceFieldInterface($repository,'chan',           # the field to look for
				   '.*',             # the type of the field
				   'chained'         # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
};
############################
# base class
############################
sub list($)        {

    my $repository = shift;

#    AddClass($repository,'utils');                                  # Utils -- Whoopie a list!
    AddInheritance($repository,'tree_list','base');         # the identifier is a id
#    ImplementInterface($repository,'tree_list',"utils","");                # These are pointed to 

    EventHandler($repository,
		 "OnChain",   # when the node has a chain!
		 'tree_list',      # 
		 sub {
		     my $self = shift;
		     my $NextFunction = shift;
		     &$NextFunction($self);
		 }
		 ); # SIMPLE CALLBACK!

};
sub exprs($)       {
    my $repository = shift;
    AddClass($repository,'exprs');                                    # all things that are expressed
    AddInheritance($repository,'exprs','base');         # the identifier is a id
    AddInheritance($repository,"constructor",'exprs');                # constructors for arrays
    map { AddInheritance($repository,$_,'exprs') } NameLike ($repository,"_exp");
};


sub decls($)       {
    my $repository = shift;
    AddClass($repository,'decl');       # all things that are declared

    AddInheritance($repository,'decl','base');         # the identifier is a id




    # OnPointersVisited; have visited all pointers
    EventHandler($repository,
		 "OnPointersVisited",   # when the node has a chain!
		 'decl',      # 
		 sub {
		     my $self = shift;
		     NodeVisitors::ProcessDecl($repository,$self);
		 }           # 
		 ); # SIMPLE CALLBACK!


    AddClass($repository,'module');       # all things that are declared

    AddField($repository,'decl','srcl',BaseType($repository,'Integer'));            # in a chain can point to each other
    AddField($repository,'decl','srcp',TypeRef($repository,'module'));            # in a chain can point to each other


    my $sourcel = FindReplaceField($repository,'srcl',           # the field to look for
				 '.*',             # the type of the field
				 'decl'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
    my $sourcefile = FindReplaceField($repository,'srcp',           # the field to look for
				 '.*',             # the type of the field
				 'decl'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   


   # TODO if the source file is BUILTIN, then do something

   # The Decls support the typed interface
   # The Decls support the named interface
   # When we replace a field with a inheritance, 

};

sub namespace_decls($) { 		# mrlc
    my $repository = shift;		# mrlc
    AddClass($repository,'namespace_decl');       # mrlc
    AddInheritance($repository,'namespace_decl','decl');         	# mrlc
    AddField($repository,'decl','name',BaseType($repository,'String')); # mrlc
    AddField($repository,'decl','dcls',TypeRef($repository,'base')); 	# mrlc
}   									# mrlc

sub types($)       {
    my $repository = shift;
    AddClass($repository,'type');       # all things that are declared
    AddField($repository,'type','name',TypeRef($repository,'identifier_node'));            # in a chain can point to each other

    AddInheritance($repository,'type','base');         # the identifier is a id


    map { 
	AddInheritance($repository,$_,'type')  # is derived from a type 
	} 
    NameLike ($repository,"_type");

};
sub consts($)      {
    my $repository = shift;
    # has a field cnst



    AddClass($repository,'const');       # all things that are declared
    AddInheritance($repository,'const','base');         # the identifier is a id


    # this is a class that represents the base of all constants
    map { AddInheritance($repository,$_,'const') } NameLike ($repository,"_cst");

    AddClass($repository,"real_cst");
    AddInheritance($repository,'real_cst','const');         # 
    AddInheritance($repository,'real_cst','typed');         # 
    AddInheritance($repository,'real_cst','sized');         # 
    AddInheritance($repository,'real_cst','aligned');       # 

};
#############################

sub qualifiers($)  # added some stuff , mrlc
{
    my $repository = shift;
    #attr 'qualrest' => 'SCALAR';
    #attr 'qualconst' => 'SCALAR';
    #attr 'qualvol' => 'SCALAR';
    AddClass($repository,'qualified');       # all things that are declared
#    AddInheritance($repository,'qualified','base');         # the identifier is a id

    AddField($repository,'qualified','qualrest',BaseType($repository,'String'));            # in a chain can point to each other
    AddField($repository,'qualified','qualconst',BaseType($repository,'String'));            # in a chain can point to each other
    AddField($repository,'qualified','qualvol',BaseType($repository,'String'));            # in a chain can point to each other
    

    AddInheritance($repository,"function_type",'qualified');
    AddInheritance($repository,"function_type",'unqualified');

    my $qualrest = FindReplaceFieldInterface($repository,'qualrest',           # the field to look for
				 '.*',             # the type of the field
				 'qualified'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
    my $qualconst = FindReplaceFieldInterface($repository,'qualconst',           # the field to look for
				 '.*',             # the type of the field
				 'qualified'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
    my $qualvol = FindReplaceFieldInterface($repository,'qualvol',           # the field to look for
				 '.*',             # the type of the field
				 'qualified'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   

    AddField($repository,"node_base",'lngt',BaseType($repository,'Integer')); # mrlc
    AddField($repository,"node_base",'strg',BaseType($repository,'String')); # mrlc
    AddField($repository,"node_base",'id',BaseType($repository,'Integer')); # mrlc
    AddField($repository,"node_base",'algn',BaseType($repository,'Integer')); # mrlc
    AddField($repository,"node_base",'name',BaseType($repository,'String')); # mrlc
    AddField($repository,"node_base",'srcl',BaseType($repository,'Integer')); # mrlc
    AddClass($repository,'lang_type');		      # mrlc
    AddInheritance($repository,"node_lang_type",'node_base'); # mrlc
    AddInheritance($repository,"method_type",'function_type');  # mrlc
    AddField($repository,'method_type','clas',TypeRef($repository,'base')); # mrlc

}

sub unqualified_types($)
{
    my $repository = shift;
    # all types have a main variant -- c-dump.c
    # lots of object has a unqulified counterpart
    #attr 'unql' => 'SCALAR';
    AddClass($repository,'unqualified');       # all things that are declared
 #   AddInheritance($repository,'unqualified','base');         # the identifier is a id
    AddField($repository,'unqualified','unql',TypeRef($repository,'type'));            # the unqualified type 

    my $qualrest = FindReplaceFieldInterface($repository,'unql',           # the field to look for
				 '.*',             # the type of the field
				 'unqualified'            # the subclass to add to the user of the field
				 ); # the will create useage based inheritance   
}

sub     expressions_stmts 
{
    my $repository = shift;

    AddClass($repository,"stmt");
    AddInheritance($repository,'stmt','base');
    AddField($repository,'stmt','line',BaseType($repository,'Integer'));            
    AddField($repository,'stmt','next',TypeRef($repository,'stmt'));               AddField($repository,"stmt",'body',TypeRef($repository,'stmt')); 


    #expression
    AddClass($repository,"expr");
    AddInheritance($repository,'expr','base');
    AddField($repository,"expr",'type',TypeRef($repository,'type')); 

    AddClass($repository,"bin_expr");
    AddInheritance($repository,'bin_expr','expr');

    AddField($repository,"bin_expr",'op_1',TypeRef($repository,'base')); 
    AddField($repository,"bin_expr",'op_0',TypeRef($repository,'base')); 

    AddClass($repository,"ref_expr");
    AddInheritance($repository,'ref_expr','bin_expr');

    AddClass($repository,"unary_expr");
    AddInheritance($repository,'unary_expr','expr');
    AddField($repository,"unary_expr",'op_0',TypeRef($repository,'base')); 

    map 
    {
	AddClass($repository,$_);
	AddInheritance($repository,$_ . "_expr",'expr');
    }
    (
     "call", 
#     "addr",
     );



   map 
    {
	AddClass($repository,$_);
	AddInheritance($repository,$_ ."_expr",'unary_expr');
    }
    (     

	  "addr",
	  "convert"
     );

   map 
    {
	AddClass($repository,$_);
	AddInheritance($repository,$_ ."_expr",'bin_expr');
    }
    (
     "cond",
     "bit_and",
     "bit_ior",
     "compound",
     "eq",
     "gt",
     "lt",
     "minus",
     "modify",
     "mult",
     "ne",
     "non_lvalue",
     "nop",
     "plus",
     "postincrement",
     "preincrement",
     "trunc_mod",
     "truth_andif",
     "truth_orif",
     "bit_xor",
     "exact_div",
     "ge",
     "le",
     "lshift",
     "max",
     "min",
     "postdecrement",
     "predecrement",
     "rdiv",
     "rshift",
     "trunc_div",
     "bit_not",
     "fix_trunc",
     "float",
     "negate",
     "save",
     "stmt",
     "truth_xor"
     );

    AddField($repository,"cond_expr",'op_2',TypeRef($repository,'base')); 

   map 
    {
	AddClass($repository,$_);
	AddInheritance($repository,$_ ,'ref_expr');
    }
    (
     "array_ref",
     "component_ref",
     "indirect_ref"
     );


    AddField($repository,"call_expr","args",TypeRef($repository,'tree_list')); 
    AddField($repository,"call_expr",'fn',TypeRef($repository,'base'));  # can be an address or a function

#    AddField($repository,"addr_expr",'op_0',TypeRef($repository,'decl')); 

    AddClass($repository,"decl_stmt");
    AddInheritance($repository,'decl_stmt','stmt');
    AddField($repository,"decl_stmt",'decl',TypeRef($repository,'decl')); 


    AddInheritance($repository,'parm_decl','chained');
    AddField($repository,
	     'parm_decl',
	     'str',
	     BaseType($repository,'String')
	     );

    ####################################################

   map 
    {
	AddClass($repository,$_);
	AddInheritance($repository,$_,'stmt');
    }
    (
     "compound_stmt", 
     "return_stmt",
     "expr_stmt",
     "scope_stmt",
     "return_stmt",
     "for_stmt",
     "if_stmt",
     "label_stmt",
     "case_label", ## SPECIAL
     "switch_stmt",
     "goto_stmt",
     "break_stmt",
     "while_stmt",
     "asm_stmt",
     "do_stmt",
     "continue_stmt"

     );
    # add in the low value for the case label
    

    AddField($repository,'case_label','low',TypeRef($repository,'integer_cst'));

    ####
    AddClass($repository,"cond_stmt");    

    AddField($repository,"for_stmt","init",TypeRef($repository,'expr')); 
    AddField($repository,"for_stmt","expr",TypeRef($repository,'expr')); 
    AddField($repository,"cond_stmt","cond",TypeRef($repository,'expr')); 
    AddInheritance($repository,"cond_stmt","stmt"); 
    AddInheritance($repository,"if_stmt","cond_stmt"); 
    AddField($repository,"if_stmt","then_stmt",TypeRef($repository,'stmt')); 
    AddField($repository,"if_stmt","else_stmt",TypeRef($repository,'stmt')); 
    AddInheritance($repository,"for_stmt","cond_stmt"); 
    AddInheritance($repository,"case_stmt","cond_stmt"); 
    AddInheritance($repository,"while_stmt","cond_stmt");
    AddInheritance($repository,"switch_stmt","cond_stmt");
    

    AddField($repository,"expr_stmt",'decl',TypeRef($repository,'expr')); 



    AddField($repository,
		 'function_decl',
		 'body',
		 TypeRef($repository,'stmt') 
		 );   # the body of the function

#    AddField($repository,
#		 'compound_stmt',
#		 'body',
#		 TypeRef($repository,'stmt')
#		 );   # the body of the function

    AddField($repository,
		 'expr_stmt',
		 'expr',
		 TypeRef($repository,'expr')
		 );   # the body of the function

    AddField($repository,
		 'return_stmt',
		 'expr',
		 TypeRef($repository,'expr')
		 );   # the body of the function


    AddField($repository,
    'scope_stmt',
    'str',
    BaseType($repository,'String')

		 );   # the body of the function



}   

sub new_classes
{
    my $repository= shift;

    AddClass($repository,"result_decl");
    AddInheritance($repository,'result_decl','decl');         # the identifier is a id
    AddInheritance($repository,'result_decl','typed');         # 
    AddInheritance($repository,'result_decl','sized');         # 
    AddInheritance($repository,'result_decl','aligned');         # 


    AddClass($repository,"label_decl");
    AddInheritance($repository,"label_decl","decl");
    AddInheritance($repository,"label_decl","typed");

}

sub case_statement
{
    my $repository= shift;
    AddClass($repository,"case_label");

}

sub unkown 
{
my @ref = qw(
	     array_ref
	     component_ref
	     indirect_ref
	     );



my @stmt = qw(
	      break_stmt
	      compound_stmt
	      decl_stmt
	      expr_stmt
	      for_stmt
	      goto_stmt
	      if_stmt
	      label_stmt
	      return_stmt
	      scope_stmt
	      switch_stmt
	      while_stmt
	      );


my @decls = qw(
	       function_decl
	       label_decl
	       result_decl
	       var_decl	);

my @types = qw(
	       boolean_type
	       complex_type
	       enumeral_type
	       function_type
	       integer_type
	       pointer_type
	       real_type
	       record_type
	       union_type
	       void_type);
}

sub cpp_types
{
    my $repository = shift;
    AddClass($repository,'eh_spec_block');                           # the class called ids

    AddField($repository,
		 'eh_spec_block',
		 'body',
		 TypeRef($repository,'stmt')
		 );   # the body of the function
    AddInheritance($repository,"eh_spec_block","stmt"); # this is a type of statement


    AddField($repository,'record_type','fncs', TypeRef($repository,'base') );   # the functions of the class ::TODO figure out the types
   AddField($repository, 'record_type',	'vfld', TypeRef($repository,'base') );   # the vtable of the class ::TODO figure out the types
   
   AddField($repository, 'field_decl',	'mngl', TypeRef($repository,'base') );   # the vtable of the class ::TODO figure out the types

   AddField($repository, 'type',	'const', TypeRef($repository,'base') );   # the vtable of the class ::TODO figure out the types



}
# here we will install the base classes
sub CreateClasses($)
{
    my $repository = shift;
#############################
# main types of fields used
   # name
   # type
   # algn/size
   # chan
#############################
# main groups of classes
   # utils (id,list)
   # types
   # typed
      # consts
      # decls
      # expr

    AddInterfaceClass($repository,'base_interface');                                 # 

    AddField($repository,
		 'base_interface',
		 'interface_name',
		 'text'
		 );   # in a chain can point to each other

    LibraryClasses    $repository ;

    # define the top level events
    CreateEvents $repository;

# ROOT CLASS?
    BaseClass $repository;

    new_classes $repository;

    Identifiable $repository; # named
    Typed $repository;
    SubTypes $repository; # param and field
    Sizeable $repository;
    Alignable $repository;
    Chainable $repository;
    list $repository;
    exprs $repository;
    decls $repository;
    types $repository;
    consts $repository;
    qualifiers $repository;
    unqualified_types $repository;

    expressions_stmts $repository;
    cpp_types $repository;

};

1;

