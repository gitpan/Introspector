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
drop index field_name ;on node_field_decl (name,node_functi;-- on,node_file);
drop index field_owner ;-- on node_field_decl (scpe,node_functi;-- on,node_file);
drop index named_name ;-- on node_identifiable (name,node_functi;-- on,node_file);
drop index record_name ;-- on node_record_type (name,node_functi;-- on,node_file);
drop index type_decl_name ;-- on node_type_decl (name,node_functi;-- on,node_file);
drop index field_main ;-- on node_field_decl (id,node_functi;-- on,node_file);
drop index record_main ;-- on node_record_type (id,node_functi;-- on,node_file);
drop index type_decl_main ;-- on node_type_decl (id,node_functi;-- on,node_file);
drop index identifier_main ;-- on node_identifier_node (id,node_functi;-- on,node_file);
drop index string_cst_strg ;-- on node_string_cst (strg,node_functi;-- on,node_file);
drop index identifier_node_strg ;-- on node_identifier_node (strg,node_functi;-- on,node_file);
drop index function_decl_main ;-- on node_functi;-- on_decl (id,node_functi;-- on,node_file);
drop index parm_decl_main ;-- on node_parm_decl (id,node_functi;-- on,node_file);
drop index parm_decl_name ;-- on node_parm_decl (namem,node_functi;-- on,node_file);
drop index function_decl_name ;-- on node_functi;-- on_decl (name,node_functi;-- on,node_file);
drop index node_call_expr_main ;-- on node_call_expr (id,node_functi;-- on,node_file);
drop index node_addr_expr_main ;-- on node_addr_expr (id,node_functi;-- on,node_file);
drop index node_call_expr_func ;-- on node_call_expr (fn,node_functi;-- on,node_file);
drop index node_call_addr_addr ;-- on node_addr_expr (op_0,node_functi;-- on,node_file);
