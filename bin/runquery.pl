#! /usr/bin/perl;
# 	$Id: runquery.pl,v 1.1.1.1 2003/01/19 13:46:21 mdupont Exp $	

# Category    : Database Queries.
# Description : run querys against the database

# LICENCE STATEMENT
#    This file is part of the GCC XML Node Introspector Project
#    Copyright (C) 2002  James Michael DuPont
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

use strict;
use database::queries;
    use db_node_ref;
use introspector::node_call_expr;
use introspector::node_function_decl;
use introspector::node_function_type;
use introspector::node_string_cst;
use introspector::node_tree_list;
use Visitor;

=item Modules Used

L<Carp|Carp> L<Carp::Assert|Carp::Assert> L<Data::Dumper|Data::Dumper> L<SOAP::Lite|SOAP::Lite> L<XMLRPC::Lite|XMLRPC::Lite>

=cut

# Additional Modules Go Here
#
# use Data::Dumper;
# use CGI;
# use HTML::Template;
# 
use Data::Dumper;
use SOAP::Lite;
use XMLRPC::Lite;


### GLOBAL
my $serial = new SOAP::Serializer;   #$serial->serialize();
my $serial2= new XMLRPC::Serializer; #$serial2->envelope("method","testFunc",
$serial->{_level}=2; # no headers and such
$serial->{_readable}=1; # make it readable
my $nullnode = "()";
my $nullnodeobj = { $nullnode=>1 };
my $global_conn = new database::queries;
my $node_base_name = "node_base*";
#my $node_base_name = "node_base2";

#my $global_file  ="tree_empty.c";
#my $global_function ="___global";

my $global_file  ="c-dump.c";
my $global_function ="dequeue_and_dump_nochain";

###########################################################################################

###########################################################################################
# sub main
###########################################################################################

###########################################################################################

#use SOAP::Serializer;
#use SOAP::Schema::WSDL;
#SOAP::Schema::WSDL;
#use SOAP::XMLSchema::Serializer; # hmmm
#use SOAP::XMLSchema2001::Serializer; ##
my %cache; # all the checked connections!
# the queries

sub build_join
{
    my $tablea = shift;
    my $tableb = shift;
    my $fielda = shift;
    
    printf ("checkjoin (\$conn,%-25s,%-25s,%-25s);\n", "q[".$tablea."]", "q[".$tableb."]", "q[".$fielda."]");

    my $shorta = $tablea;
    my $shortb = $tableb;
    $tableb = "node_" . $tableb;
    $tablea = "node_" . $tablea;

    ###############################
    my @selects = (
		   qq[drop  index ${tablea}_main  ;],
	qq[    drop  index ${tableb}_main  ;],
    qq[    drop  index ${tablea}_${fielda}  ;],
    qq[    drop  view ${shorta}${shortb}${fielda}; ],
    qq[    create index ${tablea}_main  on ${tablea} ( node_file , node_function, id );],
    qq[    create index ${tableb}_main  on ${tableb} ( node_file , node_function, id );],
    qq[    create index ${tablea}_${fielda}  on ${tablea} ( node_file , node_function, ${fielda} );],
    qq[    create view ${shorta}${shortb}${fielda}  as select 
    ${tablea}_a.node_file,
    ${tablea}_a.node_function,
    ${tablea}_a.id AS ${tablea}_a_id,
    ${tablea}_a.${fielda} AS ${tableb}_a_${fielda},
    ${tableb}_b.id AS ${tableb}_b_id

    from 
    ${tablea} as ${tablea}_a, 
    ${tableb} as ${tableb}_b
    where
    (${tablea}_a.node_file = ${tableb}_b.node_file) AND 
    (${tablea}_a.node_function = ${tableb}_b.node_function) AND 
    (${tablea}_a.${fielda} = ${tableb}_b.id);]
    );
my $test= "select count(*) from ${shorta}${shortb}${fielda} ";

return (\@selects,$test);
}

sub check_all_connections
{
    
    my $conn = shift;
    my $_tablea = shift;
    my $keya = shift;
    my $tablea = "node_" .$_tablea ;
    my $sql = qq[
		 select 
		 b.node_type as type, 
		 count(*) as count
		 from 
		 ${tablea} as a, 
		     ${node_base_name} as b
    where
    (a.node_file = b.node_file) AND 
    (a.node_function = b.node_function) AND 
    (a.${keya} = b.id)
    group by b.node_type;
];

my $ary2 = $conn->query_list($sql);
#print Dumper($ary2) . "\n";

foreach my $rec ( @{$ary2})
{
    my $_tableb = $rec->[0];
    my $tableb = "node_" . $rec->[0];

    if (!($cache {$_tablea . $_tableb .$keya}++))
    {

	my ($selects,$test) = build_join $_tablea,$tableb,$keya;

	foreach my $sql  (@{$selects})
	{
	    my $res = $conn->exec($sql);
	    my $cmdStatus = $conn->{conn}->status; 
	    my $oid = $res->oidStatus;
	    my $errorMessage = $conn->{conn}->errorMessage;
	    #print join "\n",($errorMessage,$oid,$cmdStatus,$sql) . "\n";
	}
	my $ary3 = $conn->query_list($test);
	#print Dumper($ary3) . "\n";
    }
} 

}


sub checkjoin
{
    my $conn = shift;

    my $from = shift;
    my $to = shift;
    my $field = shift;

    check_all_connections $conn, $from,$field;

    if (!($cache {$from . $to .$field}++))
    {
	my ($selects,$test) = build_join @_;
	foreach my $sql  (@{$selects})
	{
	    my $res = $conn->exec($sql);
	    my $cmdStatus = $conn->{conn}->status; 
	    my $oid = $res->oidStatus;
	    my $errorMessage = $conn->{conn}->errorMessage;
	    #print join "\n",($errorMessage,$oid,$cmdStatus,$sql) . "\n";
	}
	my $ary2 = $conn->query_list($test);
	#print Dumper($ary2) . "\n";
    }


}

sub interesting_connections
{
    my $conn = shift;
    checkjoin ($conn,q[addr_expr]             ,q[string_cst]            ,q[op_0]                 );
    checkjoin ($conn,q[addr_expr]             ,q[var_decl]              ,q[op_0]                 );
    
    checkjoin ($conn,q[array_ref]             ,q[component_ref]         ,q[op_0]                 );
    checkjoin ($conn,q[array_ref]             ,q[integer_cst]           ,q[op_1]                 );
    checkjoin ($conn,q[array_ref]             ,q[var_decl]              ,q[op_1]                 );
    
    checkjoin ($conn,q[component_ref]         ,q[component_ref]         ,q[op_0]                 );
    checkjoin ($conn,q[component_ref]         ,q[field_decl]            ,q[op_1]                 );
    checkjoin ($conn,q[component_ref]         ,q[indirect_ref]          ,q[op_0]                 );

    checkjoin ($conn,q[compound_expr]         ,q[component_ref]         ,q[op_1]                 );
    checkjoin ($conn,q[compound_expr]         ,q[cond_expr]             ,q[op_0]                 );

    checkjoin ($conn,q[cond_expr]             ,q[call_expr]             ,q[op_1]                 );
    checkjoin ($conn,q[cond_expr]             ,q[convert_expr]          ,q[op_2]                 );
    checkjoin ($conn,q[cond_expr]             ,q[eq_expr]               ,q[op_0]                 );

    checkjoin ($conn,q[convert_expr]          ,q[integer_cst]           ,q[op_0]                 );

    checkjoin ($conn,q[eq_expr]               ,q[component_ref]         ,q[op_0]                 );
    checkjoin ($conn,q[eq_expr]               ,q[integer_cst]           ,q[op_1]                 );

    checkjoin ($conn,q[field_decl]            ,q[identifier_node]       ,q[name]                 );

    checkjoin ($conn,q[indirect_ref]          ,q[nop_expr]              ,q[op_0]                 );
    checkjoin ($conn,q[indirect_ref]          ,q[parm_decl]             ,q[op_0]                 );
    checkjoin ($conn,q[indirect_ref]          ,q[var_decl]              ,q[op_0]                 );

    checkjoin ($conn,q[nop_expr]              ,q[addr_expr]             ,q[op_0]                 );
    checkjoin ($conn,q[nop_expr]              ,q[component_ref]         ,q[op_0]                 );
    checkjoin ($conn,q[nop_expr]              ,q[nop_expr]              ,q[op_0]                 );

    checkjoin ($conn,q[parm_decl]             ,q[identifier_node]       ,q[name]                 );
    checkjoin ($conn,q[var_decl]              ,q[identifier_node]       ,q[name]                 );
}

sub new_queries
{
    my $conn = shift;
    checkjoin ($conn,q[addr_expr]             ,q[function_decl]    ,q[op_0]                  );
    checkjoin ($conn,q[addr_expr]             ,q[parm_decl]        ,q[op_0]                  );
    checkjoin ($conn,q[addr_expr]             ,q[string_cst]       ,q[op_0]                  );
    checkjoin ($conn,q[addr_expr]             ,q[var_decl]         ,q[op_0]                  );
    #------
    checkjoin ($conn,q[array_ref]             ,q[component_ref]    ,q[op_0]                  );
    checkjoin ($conn,q[array_ref]             ,q[var_decl]         ,q[op_0]                  );
    #---
    checkjoin ($conn,q[array_ref]             ,q[bit_and_expr]     ,q[op_1]                  );
    checkjoin ($conn,q[array_ref]             ,q[integer_cst]      ,q[op_1]                  );
    checkjoin ($conn,q[array_ref]             ,q[nop_expr]         ,q[op_1]                  );
    checkjoin ($conn,q[array_ref]             ,q[var_decl]         ,q[op_1]                  );
    #------
    checkjoin ($conn,q[component_ref]         ,q[array_ref]        ,q[op_0]                  );
    checkjoin ($conn,q[component_ref]         ,q[component_ref]    ,q[op_0]                  );
    checkjoin ($conn,q[compound_expr]         ,q[cond_expr]        ,q[op_0]                  );
    checkjoin ($conn,q[component_ref]         ,q[indirect_ref]     ,q[op_0]                  );
    checkjoin ($conn,q[component_ref]         ,q[var_decl]         ,q[op_0]                  );
    #----
    checkjoin ($conn,q[compound_expr]         ,q[component_ref]    ,q[op_1]                  );
    checkjoin ($conn,q[compound_expr]         ,q[ne_expr]          ,q[op_1]                  );
    checkjoin ($conn,q[component_ref]         ,q[field_decl]       ,q[op_1]                  );
    #------
    checkjoin ($conn,q[cond_expr]             ,q[bit_and_expr]     ,q[op_0]                  );
    checkjoin ($conn,q[cond_expr]             ,q[eq_expr]          ,q[op_0]                  );
    checkjoin ($conn,q[cond_expr]             ,q[ne_expr]          ,q[op_0]                  );
    checkjoin ($conn,q[cond_expr]             ,q[truth_andif_expr] ,q[op_0]                  );
    #----
    checkjoin ($conn,q[cond_expr]             ,q[call_expr]        ,q[op_1]                  );
    checkjoin ($conn,q[cond_expr]             ,q[integer_cst]      ,q[op_1]                  );
    checkjoin ($conn,q[cond_expr]             ,q[plus_expr]        ,q[op_1]                  );
    #----
    checkjoin ($conn,q[cond_expr]             ,q[convert_expr]     ,q[op_2]                  );
    checkjoin ($conn,q[cond_expr]             ,q[integer_cst]      ,q[op_2]                  );
    checkjoin ($conn,q[cond_expr]             ,q[var_decl]         ,q[op_2]                  );
    #------
    checkjoin ($conn,q[convert_expr]          ,q[call_expr]        ,q[op_0]                  );
    checkjoin ($conn,q[convert_expr]          ,q[component_ref]    ,q[op_0]                  );
    checkjoin ($conn,q[convert_expr]          ,q[integer_cst]      ,q[op_0]                  );
    checkjoin ($conn,q[convert_expr]          ,q[non_lvalue_expr]  ,q[op_0]                  );
    checkjoin ($conn,q[convert_expr]          ,q[parm_decl]        ,q[op_0]                  );
    checkjoin ($conn,q[convert_expr]          ,q[var_decl]         ,q[op_0]                  );
    #------
    checkjoin ($conn,q[eq_expr]               ,q[array_ref]        ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[call_expr]        ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[component_ref]    ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[indirect_ref]     ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[nop_expr]         ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[parm_decl]        ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[var_decl]         ,q[op_0]                  );
    checkjoin ($conn,q[eq_expr]               ,q[integer_cst]      ,q[op_1]                  );
    #------
    checkjoin ($conn,q[field_decl]            ,q[identifier_node]  ,q[name]                  );
    #------
    checkjoin ($conn,q[indirect_ref]          ,q[component_ref]    ,q[op_0]                  );
    checkjoin ($conn,q[indirect_ref]          ,q[cond_expr]        ,q[op_0]                  );
    checkjoin ($conn,q[indirect_ref]          ,q[convert_expr]     ,q[op_0]                  );
    checkjoin ($conn,q[indirect_ref]          ,q[nop_expr]         ,q[op_0]                  );
    checkjoin ($conn,q[indirect_ref]          ,q[parm_decl]        ,q[op_0]                  );
    checkjoin ($conn,q[indirect_ref]          ,q[postincrement_expr],q[op_0]                 );
    checkjoin ($conn,q[indirect_ref]          ,q[var_decl]         ,q[op_0]                  );
    #------
    checkjoin ($conn,q[nop_expr]              ,q[addr_expr]        ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[bit_and_expr]     ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[call_expr]        ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[component_ref]    ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[convert_expr]     ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[nop_expr]         ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[parm_decl]        ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[trunc_mod_expr]   ,q[op_0]                  );
    checkjoin ($conn,q[nop_expr]              ,q[var_decl]         ,q[op_0]                  );
    #------
    checkjoin ($conn,q[parm_decl]             ,q[identifier_node]  ,q[name]                  );
    checkjoin ($conn,q[var_decl]              ,q[identifier_node]  ,q[name]                  );      
}    


sub query_args
{
    my $conn = shift;

    my $function_name =shift;
    my $called =shift;
    my $file = shift;

    my $call_handler = shift;
    
    my $ary = $conn->query_list("
     select node_file, node_function, args, strg,id,fn from function_call_expr_func_details where node_function like \'$function_name\' and node_file = '$file' and strg like '$called' group by args , node_file, node_function, strg,id,fn
    "); 
    my @ids = map {
	my $file            = $_->[0]; 
	my $function        = $_->[1]; 
	my $args_id         = $_->[2]; 
	my $function_name   = $_->[3]; 
	my $call_id         = $_->[4]; 
	my $fn_id           = $_->[5]; 


	my @args = walk_chain ($conn,$args_id,$file,$function);       



	### CREATE A CALL EXPRESSION
	my $call = new introspector::node_call_expr;
	$call->Setid(      $call_id);
	$call->Setnode_file(    $file);
	$call->Setnode_function($function);

#	print "Start $function_name( ". $#args ." )\n";

	# set the function object
	$call->Setfn(
		     new db_node_ref($fn_id,
				     $file,
				     $function,
				     $conn,
				     "fn")
		     );

	$call->Setargs(\@args);

	eval {
#	    print "Going to call the handler";
	    $call_handler->(($function_name,@args));
	}

    } @{$ary};      
}

sub definesub # FILENAME, FUNCTIONNAME, FUNCTIONCALLHANDLER, FUNCTIONTYPEHANDLER
{
    my $filename        = shift;
    my $functionname    = shift;
    my $functioncallhandler = shift;# what perl sub to call if we find this
	my $functiontypehandler = shift;# what perl sub to call if we find this

	    query_args($global_conn,
		       "%",
		       $functionname, 
		       $filename,
		       $functioncallhandler); #queue_and_dump_index
}

sub meta_function_type # handler for function types
{
    my $function_type    = shift;
    my $function_return  = shift;
    my $function_args    = shift;
}

sub meta_function_decl # handler for function decl
{
    my $function_id      = shift; # function id
    my $function_file    = shift; # function file contained

    # function that contains this function! this should be the function itself!
    my $function_function = shift; 

    my $function_name    = shift; # function name
    my $function_type    = shift; # function type
    my $function_srcl    = shift; # source line
    my $function_srcp    = shift; # source file
    my $function_str     = shift; # modifier
    my $function_mngl    = shift; # mangled name
    my $function_args    = shift;
    my $function_body    = shift;
#    my $function_scpe    = shift; # scope not used in function
}

sub collect_strings # walker!
{
    my $node = shift;
    #string_cst
    # goes in and gets all objects that have a type of string
    my @ret;
    foreach my $key (keys %{$node})
    {
	my $val = $node->{$key};
	if (
	    ($key =~ /strg/)||
	    ($key =~ /low/) || 
	    ($key =~ /high/)  
	    )
	{
	    push @ret,$val;
	}
	else
	{
	    # taken from Data::Dumper
	    if (defined($val) && 
		(
		 (ref($val) eq 'HASH') 
		 ||		 (ref($val) =~ /^node/)
		 )#  ||		 (ref($val) =~ /^db_node/)
		)
	    {
		#recurse!
		push @ret,collect_strings($val);# recurse
		}
	}
    }
    return @ret;
}

sub meta_c_dump_queue_and_dump_index
{
    my $functionname = shift;
    my $dump_info_p = shift;
    my $name        = shift;
    my $tree        = shift;
    my $indent      = shift;
    
    # create a cache of metas!
    print "cache_meta_c_dump_queue_and_dump_index({";
    print "name => qw[". join(" ",collect_strings($name)) .  "],\t";
    print "expr => qw[". join("\t",collect_strings($tree)) .  "]});\n";
    print "#---------------------------------------\n";

}

sub meta_anyfunc
{
    my $functionname = shift;
    my @param = @_;
    
    print "metacall(q[$functionname],";
    foreach (@param)
    {
	print "parm(q[". join("],q[",collect_strings($_)) .  "]}),\t";
    }
    print ");\n";

}

# the enums
#query_enums($con);
#interesting_connections $conn;
#query_args($conn,"%","fprintf"             , "c-dump.i"); #queue_and_dump_index
# translate all the calls to this function
# into a call to the meta_function!
# and also be able to handle the function ahead of time via
# the function pointer,
# do we want to run a translation of the function decl first? why not


#definesub("c-dump.i",	  "queue_and_dump_index", \&meta_c_dump_queue_and_dump_index, \&meta_function_type,   \&meta_function_decl);



sub load_containment
{
};
sub load_attribute
{   
};
sub load_pointer
{   
};
sub load_chain
{   
};

sub load
{
};
sub load_path
{

}

sub stringify
{
}

sub dumpvalue
{
    
    my $element = shift;
    my $field = shift;

    if (my $f =$element->{$field})
    {
	if (REF($f) eq "HASH")
	{
	    print "$field = \""  . $element->{$field}->{_id}     . "\" ";
	}
	else
	{
	    print "$field = \""  . $element->{$field}     . "\" ";
	}
    }
};

sub CheckLists
{
# here are some examples for list checks or global arrays.
# now lets look at

    my $sql = "select * from global_tree_lists a where not exists (select chan from global_tree_lists as g2 where g2.chan = a.id)";
    
    my $ary2 = $global_conn->query_list($sql);
    foreach my $node (@{$ary2})
    {
	my $string = $node->[0];
	my $id     = $node->[1];
	print "<NODE_LIST ID=\"$id\" STRING=\"$string\">\n";
	my @list = CheckList("$global_file","$global_function",$id); # the beginning of the tree_code_name array.
	foreach my $element (@list)
	{
	    print "<LIST_ELEMENT ";
	    print "id = \""  . $element->{_id}     . "\" ";
	    dumpvalue $element, "_purp";
	    dumpvalue $element, "_valu";
	    dumpvalue $element, "_chan";

	    print $serial->serialize($element);
	    print "</NODE_ELEMENT>\n";
	}
	print "</NODE_LIST ID=\"$id\">\n";
	
    }
#      print "NODES------2743\n";
#      my @list = CheckList("$global_file","$global_function",2743); # the beginning of the tree_code_name array.
#      print Dumper(@list);
    
#      print "NODES------2772\n";
#      my @list = CheckList("$global_file","$global_function",2772); # the beginning of the tree_code_name array.
#      print Dumper(@list);
    
#      print "NODES------2800\n";
#      my @list = CheckList("$global_file","$global_function",2800); # the beginning of the tree_code_name array.
#      print Dumper(@list);
}

# Find all the list nodes that dont get referenced by other nodes


sub HandleUsage
{
    my $field = shift;
    my $table = shift;

    my $sql = "insert into  node_usage2 
select 
t.id                     as from_id, 
int4(t.${field})         as to_id, 
t.node_type               as from_type, 
b.node_type              as to_type, 
varchar(20) \'${field}\' as usage   
from 
        $node_base_name b, 
	${table} t 
where  
	t.${field} = b.id 
	and 
        b.node_file = t.node_file 
        and 
        t.node_file = \'$global_file\' 
        and 
        b.node_function = \'$global_function\'  
        and 
        b.node_function = t.node_function";

    
    # run the query
    my $ary = $global_conn->query_list($sql);

}


# CollectTypes gets all the typed fields and put's them in the usage table
sub CollectTypes
{
    my @typed = qw(node_typed   
		   node_field_decl  
		   node_function_decl 
		   node_label_decl  
		   node_parm_decl  
		   node_result_decl  
		   node_type_decl
		   node_var_decl  
		   node_const_decl 
		   node_integer_cst 
		   node_string_cst  
		   node_constructor  
		   node_real_cst 
		   );

    ### 
    foreach my $type (@typed)
    {
	HandleUsage "type",$type;
	# get the types
	
    }
}


# TransferRelationships
# HandleUsage


sub TransferRelationships
{   
    my $sql = "select /*relkind, pg_class.oid,atttypid,*/ relname, attname from pg_attribute, pg_class where relname like 'node%' and pg_class.oid= attrelid and atttypid= 23 and attname <> 'id' and pg_class.oid <= 7721585 and relkind = 'r' order by attname ;";

    my $ary2 = $global_conn->query_list($sql);

    my @ids = map {

	my $table= $_->[0]; 
	my $rel  = $_->[1];
	# get the usage
	print "$rel,$table\n";
	HandleUsage $rel,$table;
    } @{$ary2};
    
    
}

#HandleUsage "ptd","node_pointer_type";
#HandleUsage "retn","node_function_type";
#HandleUsage "prms","node_function_type";
#HandleUsage "init","node_for_stmt";
#HandleUsage "expr","node_for_stmt";



#What is named?

sub collect_names
{
    my @names = qw(
		   node_union_type 
		   node_decl 
		   node_enumeral_type 
		   node_field_decl 
		   node_function_decl 
		   node_parm_decl 
		   node_type_decl 
		   node_var_decl 
		   node_const_decl 
		   node_integer_type 
		   node_record_type 
		   node_label_decl 
		   node_result_decl 
		   );

    foreach my $type (@names)
    {
	HandleUsage "name",$type;
	# get the types	
    }


}
#CollectTypes;
#CheckLists;
#TransferRelationships;

# 

sub testquery
{
    my $tuple_list = shift;
    
}


sub attributes
{
    load 'attribute'  ,"identifier_node", "_vstrg";
    load 'attribute'  ,"identifier_node", "_id";
    load 'attribute'  ,"integer_cst"    , "_low";

    load 'containment',"type_decl"      , "_name", "nameable";
    load 'pointer'    ,"tree_list"      , "_purp";
    load 'pointer'    ,"tree_list"      , "_valu";
    load 'chain'      ,"tree_list"      , "_chan";
    load 'pointer'    ,"pointer_type"   , "_type";
};

sub test
{
    testquery (
	       [
		tuple(qw(function_decl   name   identifier_node )),
		tuple(qw(function_decl   type  function_type )),
		tuple(split "|", 'function_type  | size  | integer_cst'),
		tuple(split "|", 'function_type  | prms  | tree_list'),
		]
	       );
}


sub loadtuple
{
    my ($obj, $from, $rel, $to)=@_;
    print $serial->serialize(@_);
};


sub query_types
{
#  select from_type,to_type,count(*) from node_usage2 where usage =  'type' group by from_type,to_type;
#  introspector=#    from_type   |    to_type    | count 
#  ---------------+---------------+-------
#   addr_expr     | pointer_type  |   145
#   const_decl    | enumeral_type |  1219
#   constructor   | array_type    |     3
#   field_decl    | array_type    |    44
#   field_decl    | enumeral_type |     6
#   field_decl    | integer_type  |   323
#   field_decl    | pointer_type  |   175
#   field_decl    | record_type   |    44
#   field_decl    | union_type    |     6
#   function_decl | function_type |  1714
#   integer_cst   | integer_type  |  2101
#   nop_expr      | pointer_type  |   145
#   parm_decl     | integer_type  |    58
#   parm_decl     | pointer_type  |    62
#   string_cst    | array_type    |   147
#   type_decl     | boolean_type  |     1
#   type_decl     | complex_type  |     4
#   type_decl     | enumeral_type |    32
#   type_decl     | function_type |     8
#   type_decl     | integer_type  |   131
#   type_decl     | pointer_type  |    19
#   type_decl     | real_type     |     3
#   type_decl     | record_type   |   119
#   type_decl     | union_type    |    13
#   type_decl     | void_type     |     2
#   var_decl      | array_type    |    35
#   var_decl      | enumeral_type |     7
#   var_decl      | integer_type  |   197
#   var_decl      | pointer_type  |    69
#   var_decl      | record_type   |     9

    my $ary2 = $global_conn->query_list("select to_id from node_usage2 where usage = \'type\' group by to_id");
    foreach my $node (@{$ary2})
    {
	my $id = $node->[0];
	print STDOUT "/home/mdupont/introspector/output/types/$id.xml\n";
	open OUT, ">/home/mdupont/introspector/output/types/$id.xml" or die "cannot open $id";
	
	my $OLD = select OUT;
	

	my $obj= get_node($id);    

	print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<DUMPNODE id='$id' xsi:type=\"namesp1:SOAPStruct\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\"  xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\" xmlns:namesp1=\"http://xml.apache.org/xml-soap\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n";

	print "<DUMP id='$id'>";
	print $serial->serialize($obj);
	print "</DUMP>\n";

	print "<DUMPTYPE id='$id'>";
	print grok_type ($obj);	
	print "</TYPE>\n";

	print "<DUMPDECL ID='$id'>";
	print find_decl ($id);
	print "</DUMPDECL>\n";

	print "</DUMPNODE>\n";
	
	select $OLD;

	close OUT;

    }
}

use Data::Dumper;

sub ReloadBase
{
    my $sql = "delete from node_base2";
    
    my $ary2 = $global_conn->query_list($sql);


    my $sql = "insert into node_base2 select * from node_base* 
               where 
                    node_file = '$global_file' and node_function='$global_function'";

    
    my $ary2 = $global_conn->query_list($sql);


}

# get the types
#query_types;
my $visitor = new Visitor();
#$visitor->{debug} =1;
#print $visitor->find_decl(4618);
print Dumper($visitor->CheckList("$global_file", "$global_function",2743));
#print Dumper($visitor);
# in debug "O warnLevel=0"
#ReloadBase;
#TransferRelationships;


