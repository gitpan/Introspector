/*
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
*/
select a.node_function, a.node_file,b.strg, d.strg
from 
     node_record_type a,      
     node_identifier_node b ,
     node_field_decl c ,
     node_identifier_node d
where 
      c.name = d.id and c.node_function = d.node_function and c.node_file = d.node_file	
and
      a.name = b.id and a.node_function = b.node_function and a.node_file = b.node_file 
and
       a.id = c.scpe and a.node_function = c.node_function and a.node_file = c.node_file 
group by 
	b.strg,d.strg, a.node_function, a.node_file

-----
------

select b.strg, d.strg
from 
     node_record_type a,      
     node_identifier_node b ,
     node_field_decl c ,
     node_identifier_node d
where 
      c.name = d.id and c.node_function = d.node_function and c.node_file = d.node_file	
and
      a.name = b.id and a.node_function = b.node_function and a.node_file = b.node_file 
and
       a.id = c.scpe and a.node_function = c.node_function and a.node_file = c.node_file 
group by 
	b.strg,d.strg;
-----
select strg from node_string_cst group by strg;
-----
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
drop index field_name ; 
drop index field_owner ;
drop index named_name ;
drop index record_name ;
drop index type_decl_name ;
drop index field_main ;
drop index record_main ;
drop index type_decl_main ;
drop index identifier_main ;
drop index string_cst_strg ;
drop index identifier_node_strg ;
drop index function_decl_main ;
drop index parm_decl_main ;
drop index parm_decl_name ;
drop index function_decl_name ;
drop index node_call_expr_main ;
drop index node_addr_expr_main ;
drop index node_call_expr_func ;
drop index node_call_addr_addr ;
drop index node_call_expr_args;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
create index field_name on node_field_decl (name,node_function,node_file);
create index field_owner on node_field_decl (scpe,node_function,node_file);
create index named_name on node_identifiable (name,node_function,node_file);
create index record_name on node_record_type (name,node_function,node_file);
create index type_decl_name on node_type_decl (name,node_function,node_file);
create index field_main on node_field_decl (id,node_function,node_file);
create index record_main on node_record_type (id,node_function,node_file);
create index type_decl_main on node_type_decl (id,node_function,node_file);
create index identifier_main on node_identifier_node (id,node_function,node_file);
create index string_cst_strg on node_string_cst (strg,node_function,node_file);
create index identifier_node_strg on node_identifier_node (strg,node_function,node_file);
create index function_decl_main on node_function_decl (id,node_function,node_file);
create index parm_decl_main on node_parm_decl (id,node_function,node_file);
create index parm_decl_name on node_parm_decl (namem,node_function,node_file);
create index function_decl_name on node_function_decl (name,node_function,node_file);
create index node_call_expr_main on node_call_expr (id,node_function,node_file);
create index node_addr_expr_main on node_addr_expr (id,node_function,node_file);
create index node_call_expr_func on node_call_expr (fn,node_function,node_file);
create index node_call_expr_args on node_call_expr (args,node_function,node_file);
create index node_call_addr_addr on node_addr_expr (op_0,node_function,node_file);

create index node_component_ref_main on node_component_ref (id,node_function,node_file);
create index node_component_ref_op1 on node_component_ref (op_1,node_function,node_file);
create index node_component_ref_op0 on node_component_ref (op_0,node_function,node_file);

create index node_tree_list_valu on node_tree_list( valu, node_file, node_function) ;
create index node_tree_list_main on node_tree_list( id, node_file, node_function) ;
create index node_tree_list_chan on node_tree_list( chan, node_file, node_function) ;
create index node_tree_list_purp on node_tree_list( purp, node_file, node_function) ;

drop index base_node_type;
create index base_node_type on node_base (node_type)
