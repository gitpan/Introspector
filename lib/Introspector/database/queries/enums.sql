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
select  et.id,id.strg,et.csts from node_enumeral_type et,  node_identifier_node id where       et.name = id.id;

select  et.id,  id.strg from node_enumeral_type et,  node_identifier_node id where       et.name = id.id
where et.node_function = '___global'


select et.id,id.strg from node_enumeral_type et, node_type_decl td, node_identifier_node id where et.name = td.id and td.name = id.id;

select  et.id,  id.strg from node_enumeral_type et,  node_identifier_node id where       et.name = id.id union select et.id,id.strg from node_enumeral_type et, node_type_decl td, node_identifier_node id where et.name = td.id and td.name = id.id;

select  et.id,id.strg,et.csts from node_enumeral_type et,  node_identifier_node id where       et.name = id.id;
select  id,chan,valu,purp from node_tree_list where id = 142;
select * from node_base* where id = 149;
select id,strg from node_identifier_node* where id = 149;
select id,strg from node_identifier_node where strg like '%EXPR%' order by strg;

# all global ids
select node_file,node_function,id,strg from node_identifier_node where node_function = '___global' order by strg ;

select  et.id,id.strg, et.csts from node_enumeral_type et,  node_identifier_node id where       et.name = id.id and et.node_function = '___global';

 
select * from node_base* nb, node_tree_list tl where  tl.node_function = '___global'
and tl.purp = nb.id and nb.node_type <> 'tree_list'


select * from node_base* nb, node_tree_list tl where  tl.node_function = '___global'
and tl.purp = nb.id and nb.node_type = 'identifier_node'
and nb.node_function = '___global';


-- select enum, and the first element
select  
     et.id,id.strg,et.csts, ide.strg 
from 
     node_enumeral_type et,  
     node_identifier_node id,
     node_identifier_node ide,
     node_tree_list tl
where       
     et.csts = tl.id
and
     tl.purp = ide.id
and
     et.name = id.id
and 
     et.node_function = '___global'
and  
     id.node_function = '___global'
and
     ide.node_function = '___global'
and
     tl.node_function = '___global';


-- select one identifier attached to a tree list
select  
     ide.*,
     tl.purp
from
     node_base* ide,
     node_tree_list tl
where       
     tl.purp = ide.id
and
     ide.node_function = '___global'
and
     tl.node_function = '___global'
and  
     tl.id = 8029;


-- select a string that is attached to a
--- select the function names

create view function_names as select fd.node_function,fd.id ,idn.strg from node_function_decl fd, node_identifier_node idn  where idn.node_function = fd.node_function and fd.name = idn.id ;

---- What is in the call_expr?
select nb.* from node_call_expr ce, node_base* nb where ce.fn = nb.id and ce.node_function =nb.node_function;

-------------------------------------------------------------------------------------------
---- who calls who
select op0.* from node_call_expr ce, node_addr_expr nb , function_names op0 where ce.fn = nb.id and ce.node_function =nb.node_function and nb.node_function= op0.node_function and nb.op_0 = op0.id;

drop view who_calls_who;
--queue_and_dump_index
create view who_calls_who as 
select op0.node_function, ce.node_file, ce.id as call_id,ce.args as args,op0.id as functionid, op0.strg as name  from node_call_expr ce, node_addr_expr nb , function_names op0 where ce.fn = nb.id and ce.node_function =nb.node_function and nb.node_function= op0.node_function and nb.op_0 = op0.id;

---- what about node_non_lvalue_expr?

-------- operator 1
select idn.strg from 
       node_non_lvalue_expr* nb, 
       node_var_decl op2,
       node_identifier_node idn
 where 
       nb.node_function = op2.node_function  
       and 
       nb.op_0 = op2.id
       and
       idn.id = op2.name group by strg;
---------------
select idn.strg from 
       node_non_lvalue_expr* nb, 
       node_var_decl op2,
       node_identifier_node idn
 where 
       nb.node_function = op2.node_function  and idn.node_function = nb.node_function
       and 
       nb.op_0 = op2.id
       and
       idn.id = op2.name group by strg;

-----

select * from node_record_type rt, node_type_decl td,  node_identifier_node id where rt.name = td.id and rt.node_function = td.node_function and rt.node_file = td.node_file and td.name = id.id and td.node_function = id.node_function and td.node_file = id.node_file

-----
select strg from node_string_cst group by strg;

-----
select strg from node_identifier_node group by strg;

------
select strg from node_record_type rt, node_type_decl td,  node_identifier_node id where rt.name = td.id and rt.node_function = td.node_function and rt.node_file = td.node_file and td.name = id.id and td.node_function = id.node_function and td.node_file = id.node_file group by strg;
------
drop view field_names;

create view field_names as 
select 
       a.id,
       a.node_function,
       a.node_file,
       strg 
from node_field_decl a,  node_identifier_node b where a.name = b.id and a.node_function = b.node_function ;
---group by strg, a.id, a.node_function, a.node_file
------
select a.id, a.node_function, a.node_file,strg from node_record_type a, node_type_decl td,  node_identifier_node id where a.name = td.id and a.node_function = td.node_function and a.node_file = td.node_file and td.name = id.id and td.node_function = id.node_function and td.node_file = id.node_file group by strg;
--------
select a.id, a.node_function, a.node_file, strg from node_field_decl a,  node_identifier_node b where a.name = b.id and a.node_function = b.node_function group by a.id, a.node_function, a.node_file,strg;
---------
select a.id, a.node_function, a.node_file,strg 
from 
     node_record_type a, node_type_decl td,  node_identifier_node id where a.name = td.id and a.node_function = td.node_function and a.node_file = td.node_file and td.name = id.id and td.node_function = id.node_function and td.node_file = id.node_file group by strg,a.id, a.node_function, a.node_file;
-------------------
select a.id, a.node_function, a.node_file,strg 
from 
     node_record_type a,      
     node_identifier_node id 
     where 
     a.name = id.id and a.node_function = id.node_function and a.node_file = id.node_file 
group by strg,a.id, a.node_function, a.node_file;
------------------------
create view record_fields1
as select 
       a.node_function, 
       a.node_file,
       a.id	as record_id,
       b.strg	as record_name, 
       c.id	as field_id,
       d.strg	as field_name
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
       a.id = c.scpe and a.node_function = c.node_function and a.node_file = c.node_file;
--group by 
--	b.strg,d.strg, a.node_function, a.node_file

---------------------------------
select b.node_type from node_base* b ,who_calls_who c where b.id = c.args and b.node_file = c.node_file and b.node_function = c.node_function group by b.node_type

---component_ref
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

select b.node_type from node_component_ref a, node_base *  b where a.op_0  = b.id and a.node_file = b.node_file and a.node_function = b.node_function;
--# array_ref
--# component_ref
--# indirect_ref
--# var_decl

--- What fields
--- are stored in op_0
--- in a component ref?
###########################################
create view node_component_ref_op_fields as
select 
       a.*,
       b.*
       from 
       node_component_ref a, 
       field_names        b 

where 
      a.op_1  = b.id 
      and 
      a.node_file = b.node_file and a.node_function = b.node_function
#######################################

select 
       a.*,
       b.strg
       from 
       node_component_ref a, 
       field_names        b 

where 
      a.op_1  = b.id 
      and 
      a.node_file = b.node_file and a.node_function = b.node_function;;   
     

select 
       b.strg
       from 
       node_component_ref a, 
       field_names        b 

where 
      a.op_1  = b.id 
      and 
      a.node_file = b.node_file and a.node_function = b.node_function
group by 
      b.strg
     ----
SELECT 
fd.node_function, 
fd.id, 
idn.strg

FROM 
node_function_decl fd, 
node_identifier_node idn 
WHERE 
idn.node_file = fd.node_file 
and
idn.node_function = fd.node_function
AND 
fd.name = idn.id;

----

drop view        function_call_expr_func_details;
create view      function_call_expr_func_details 
as 
   SELECT t2.node_file, t2.args, t2.node_function, t5.strg, t2.id, t2.fn FROM node_call_expr t2, node_addr_expr t3, node_function_decl t4, node_identifier_node t5 WHERE (((((((((t3.op_0 = t4.id) AND (t2.fn = t3.id)) AND (t4.name = t5.id)) AND (t2.node_function = t3.node_function)) AND (t2.node_file = t3.node_file)) AND (t4.node_function = t3.node_function)) AND (t4.node_file = t3.node_file)) AND (t4.node_function = t5.node_function)) AND (t4.node_file = t5.node_file));


select * from function_call_expr_func_detail fd, node_tree_list tl, node_tree_list tl2 where fd.args = tl.id and fd.node_file = tl.node_file and fd.node_function = tl.node_function and tl2.id = tl.chan and tl2.node_file = tl.node_file and tl2.node_function = tl.node_function;

select * from function_call_expr_func_details fd, node_tree_list tl, node_tree_list tl2 where fd.args = tl.id and fd.node_file = tl.node_file and fd.node_function = tl.node_function and tl2.id = tl.chan and tl2.node_file = tl.node_file and tl2.node_function = tl.node_function and fd.strg = 'queue_and_dump_index';

select * from node_nop_expr a, node_nop_expr b, node_addr_expr c, node_string_cst d, function_call_expr_func_details fd, node_tree_list tl, node_tree_list tl2 where fd.args = tl.id and fd.node_file = tl.node_file and fd.node_function = tl.node_function and tl2.id = tl.chan and tl2.node_file = tl.node_file and tl2.node_function = tl.node_function and fd.strg = 'queue_and_dump_index'
and (a.node_file = b.node_file) AND (a.node_function = b.node_function) AND (a.op_0 = b.id) AND
(b.node_file = c.node_file) AND (b.node_function = c.node_function) AND (b.op_0 = c.id) AND
(c.node_file = d.node_file) AND (c.node_function = d.node_function) AND (c.op_0 = d.id) 

