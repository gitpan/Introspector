/*

#################################################################################
# MODULE  : database/introspector_schema.sql
# Author  : James Michael DuPont
# Generation : Third Generation
# Status     : To Clean Up
# Category   : Database Schema
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
*/

CREATE TABLE "file_function" (
	"filename" character varying(64) NOT NULL,
	"functionname" character varying(255) NOT NULL
);

CREATE TABLE "node_base" (
	"node_function" character varying(255),
	"id" int4,
	"node_file" character varying(255),
	"node_type" character varying(50)
);
CREATE TABLE "node_base_interface" (
	"interface_name" character varying(50)
);
CREATE TABLE "node_const" (
	
)
inherits ("node_base");
CREATE TABLE "node_long_string" (
	"strg" text
)
inherits ("node_base_interface");
CREATE TABLE "node_typed" (
	"type" int4
)
inherits ("node_base_interface");
CREATE TABLE "integer_cst" (
	"low" character varying(50),
	"high" character varying(50)
)
inherits ("node_const", "node_typed");
CREATE TABLE "function_call_expr_func" (
	"count" int4,
	"node_function" character varying(255),
	"strg" text
);
CREATE TABLE "node_icontainer" (
	
)
inherits ("node_base_interface");
CREATE TABLE "node_aligned" (
	"algn" character varying(50)
);
CREATE TABLE "node_chained" (
	"chan" int4
);
CREATE TABLE "node_container" (
	"flds" int4
)
inherits ("node_base_interface");
CREATE TABLE "node_expr" (
	"type" int4
)
inherits ("node_base");
CREATE TABLE "node_exprs" (
	
)
inherits ("node_base");
CREATE TABLE "node_ids" (
	"named" int4
)
inherits ("node_base");
CREATE TABLE "node_integer_cst" (
	"low" character varying(50),
	"high" character varying(50)
)
inherits ("node_const", "node_typed");
CREATE TABLE "node_nameable" (
	
)
inherits ("node_base_interface");
CREATE TABLE "node_named" (
	
)
inherits ("node_nameable", "node_base_interface");
CREATE TABLE "node_qualified" (
	"qualrest" character varying(50),
	"qualconst" character varying(50),
	"qualvol" character varying(50)
);
CREATE TABLE "node_sized" (
	"size" int4
);
CREATE TABLE "node_stmt" (
	"line" int4,
	"body" int4,
	"next" int4
)
inherits ("node_base");
CREATE TABLE "node_string_cst" (
	"lngt" character varying(50)
)
inherits ("node_long_string", "node_const", "node_typed");
CREATE TABLE "node_tree_list" (
	"valu" int4,
	"purp" int4
)
inherits ("node_base", "node_chained");
CREATE TABLE "node_type" (
	"name" int4
)
inherits ("node_base", "node_base_interface");
CREATE TABLE "node_unary_expr" (
	"op_0" int4
)
inherits ("node_expr");
CREATE TABLE "node_unqualified" (
	"unql" int4
);
CREATE TABLE "node_void_type" (
	
)
inherits ("node_named", "node_type", "node_aligned", "node_qualified", "node_unqualified");
CREATE TABLE "node_addr_expr" (
	
)
inherits ("node_unary_expr");
CREATE TABLE "node_array_type" (
	"domn" int4,
	"elts" int4
)
inherits ("node_named", "node_type", "node_sized", "node_aligned", "node_unqualified");
CREATE TABLE "node_asm_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_bin_expr" (
	"op_0" int4,
	"op_1" int4
)
inherits ("node_expr");
CREATE TABLE "node_bit_and_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_bit_ior_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_bit_not_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_bit_xor_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_boolean_type" (
	
)
inherits ("node_named", "node_type", "node_sized", "node_aligned");
CREATE TABLE "node_break_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_call_expr" (
	"fn" int4,
	"args" int4
)
inherits ("node_expr");
CREATE TABLE "node_case_label" (
	"low" int4
)
inherits ("node_stmt");
CREATE TABLE "node_complex_type" (
	
)
inherits ("node_named", "node_type", "node_sized", "node_aligned");
CREATE TABLE "node_compound_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_compound_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_cond_expr" (
	"op_2" int4
)
inherits ("node_bin_expr");
CREATE TABLE "node_cond_stmt" (
	"cond" int4
)
inherits ("node_stmt");
CREATE TABLE "node_constructor" (
	"elts" int4
)
inherits ("node_exprs", "node_typed");
CREATE TABLE "node_continue_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_convert_expr" (
	
)
inherits ("node_unary_expr");
CREATE TABLE "node_decl_stmt" (
	"decl" int4
)
inherits ("node_stmt");
CREATE TABLE "node_do_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_eq_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_exact_div_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_expr_stmt" (
	"decl" int4,
	"expr" int4
)
inherits ("node_stmt");
CREATE TABLE "node_fix_trunc_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_float_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_for_stmt" (
	"init" int4,
	"expr" int4
)
inherits ("node_stmt", "node_cond_stmt");
CREATE TABLE "node_function_type" (
	"prms" int4,
	"retn" int4
)
inherits ("node_qualified", "node_unqualified", "node_type", "node_sized", "node_aligned");
CREATE TABLE "node_ge_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_goto_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_gt_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_identifiable" (
	"name" int4
)
inherits ("node_nameable", "node_base_interface");
CREATE TABLE "node_identifier_node" (
	"lngt" character varying(50)
)
inherits ("node_long_string", "node_ids");
CREATE TABLE "node_if_stmt" (
	"else_stmt" int4,
	"then_stmt" int4
)
inherits ("node_stmt", "node_cond_stmt");
CREATE TABLE "node_integer_type" (
	"prec" character varying(50),
	"str" character varying(50),
	"min" int4,
	"max" int4
)
inherits ("node_identifiable", "node_named", "node_type", "node_sized", "node_aligned", "node_qualified", "node_unqualified");
CREATE TABLE "node_label_stmt" (
	
)
inherits ("node_stmt");
CREATE TABLE "node_le_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_lshift_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_lt_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_max_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_min_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_minus_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_modify_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_mult_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_ne_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_negate_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_non_lvalue_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_nop_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_plus_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_pointer_type" (
	"ptd" int4
)
inherits ("node_named", "node_type", "node_sized", "node_aligned", "node_qualified", "node_unqualified");
CREATE TABLE "node_postdecrement_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_postincrement_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_predecrement_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_preincrement_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_rdiv_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_real_cst" (
	
)
inherits ("node_const", "node_typed", "node_sized", "node_aligned");
CREATE TABLE "node_real_type" (
	"prec" character varying(50)
)
inherits ("node_named", "node_type", "node_sized", "node_aligned", "node_unqualified");
CREATE TABLE "node_record_type" (
	"str" character varying(50)
)
inherits ("node_identifiable", "node_named", "node_type", "node_container", "node_icontainer", "node_sized", "node_aligned", "node_qualified", "node_unqualified");
CREATE TABLE "node_ref_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_reference_type" (
	"refd" int4
)
inherits ("node_aligned", "node_type", "node_sized");
CREATE TABLE "node_return_stmt" (
	"expr" int4
)
inherits ("node_stmt");
CREATE TABLE "node_rshift_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_save_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_scope_stmt" (
	"str" character varying(50)
)
inherits ("node_stmt");
CREATE TABLE "node_stmt_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_switch_stmt" (
	
)
inherits ("node_stmt", "node_cond_stmt");
CREATE TABLE "node_trunc_div_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_trunc_mod_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_truth_andif_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_truth_orif_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_truth_xor_expr" (
	
)
inherits ("node_bin_expr");
CREATE TABLE "node_union_type" (
	"str" character varying(50)
)
inherits ("node_identifiable", "node_named", "node_type", "node_container", "node_icontainer", "node_sized", "node_aligned", "node_qualified", "node_unqualified");
CREATE TABLE "node_while_stmt" (
	
)
inherits ("node_stmt", "node_cond_stmt");
CREATE TABLE "node_array_ref" (
	
)
inherits ("node_ref_expr");
CREATE TABLE "node_case_stmt" (
	
)
inherits ("node_cond_stmt");
CREATE TABLE "node_component_ref" (
	
)
inherits ("node_ref_expr");
CREATE TABLE "node_decl" (
	"srcp" character varying(255),
	"scpe" int4,
	"srcl" int4
)
inherits ("node_identifiable", "node_base");
CREATE TABLE "node_enumeral_type" (
	"prec" character varying(50),
	"str" character varying(50),
	"min" int4,
	"csts" int4,
	"max" int4
)
inherits ("node_identifiable", "node_named", "node_type", "node_sized", "node_aligned", "node_qualified", "node_unqualified");
CREATE TABLE "node_field_decl" (
	"str" character varying(50),
	"bpos" int4
)
inherits ("node_identifiable", "node_typed", "node_decl", "node_sized", "node_aligned", "node_chained");
CREATE TABLE "node_function_decl" (
	"str" character varying(50),
	"args" int4,
	"mngl" int4,
	"body" int4
)
inherits ("node_decl", "node_identifiable", "node_typed", "node_chained");
CREATE TABLE "node_indirect_ref" (
	
)
inherits ("node_ref_expr");
CREATE TABLE "node_label_decl" (
	
)
inherits ("node_decl", "node_typed");
CREATE TABLE "node_parm_decl" (
	"used" character varying(50),
	"str" character varying(50),
	"argt" int4
)
inherits ("node_chained", "node_identifiable", "node_typed", "node_decl", "node_sized", "node_aligned");
CREATE TABLE "node_result_decl" (
	
)
inherits ("node_decl", "node_typed", "node_sized", "node_aligned");
CREATE TABLE "node_type_decl" (
	
)
inherits ("node_decl", "node_identifiable", "node_typed", "node_chained");
CREATE TABLE "node_var_decl" (
	"used" character varying(50),
	"str" character varying(50),
	"init" int4
)
inherits ("node_decl", "node_identifiable", "node_typed", "node_sized", "node_aligned", "node_chained");
CREATE TABLE "node_const_decl" (
	"cnst" int4
)
inherits ("node_decl", "node_identifiable", "node_typed", "node_chained");
CREATE TABLE "component_refcomponent_refop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_component_ref_a_id" int4,
	"node_component_ref_a_op_0" int4,
	"node_component_ref_b_id" int4
);
CREATE TABLE "addr_exprstring_cstop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_addr_expr_a_id" int4,
	"node_string_cst_a_op_0" int4,
	"node_string_cst_b_id" int4
);
CREATE TABLE "addr_exprvar_declop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_addr_expr_a_id" int4,
	"node_var_decl_a_op_0" int4,
	"node_var_decl_b_id" int4
);
CREATE TABLE "array_refcomponent_refop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_array_ref_a_id" int4,
	"node_component_ref_a_op_0" int4,
	"node_component_ref_b_id" int4
);
CREATE TABLE "array_refinteger_cstop_1" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_array_ref_a_id" int4,
	"node_integer_cst_a_op_1" int4,
	"node_integer_cst_b_id" int4
);
CREATE TABLE "array_refvar_declop_1" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_array_ref_a_id" int4,
	"node_var_decl_a_op_1" int4,
	"node_var_decl_b_id" int4
);
CREATE TABLE "component_reffield_declop_1" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_component_ref_a_id" int4,
	"node_field_decl_a_op_1" int4,
	"node_field_decl_b_id" int4
);
CREATE TABLE "component_refindirect_refop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_component_ref_a_id" int4,
	"node_indirect_ref_a_op_0" int4,
	"node_indirect_ref_b_id" int4
);
CREATE TABLE "compound_exprcomponent_refop_1" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_compound_expr_a_id" int4,
	"node_component_ref_a_op_1" int4,
	"node_component_ref_b_id" int4
);
CREATE TABLE "compound_exprcond_exprop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_compound_expr_a_id" int4,
	"node_cond_expr_a_op_0" int4,
	"node_cond_expr_b_id" int4
);
CREATE TABLE "cond_exprcall_exprop_1" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_cond_expr_a_id" int4,
	"node_call_expr_a_op_1" int4,
	"node_call_expr_b_id" int4
);
CREATE TABLE "cond_exprconvert_exprop_2" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_cond_expr_a_id" int4,
	"node_convert_expr_a_op_2" int4,
	"node_convert_expr_b_id" int4
);
CREATE TABLE "cond_expreq_exprop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_cond_expr_a_id" int4,
	"node_eq_expr_a_op_0" int4,
	"node_eq_expr_b_id" int4
);
CREATE TABLE "convert_exprinteger_cstop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_convert_expr_a_id" int4,
	"node_integer_cst_a_op_0" int4,
	"node_integer_cst_b_id" int4
);
CREATE TABLE "eq_exprcomponent_refop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_eq_expr_a_id" int4,
	"node_component_ref_a_op_0" int4,
	"node_component_ref_b_id" int4
);
CREATE TABLE "eq_exprinteger_cstop_1" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_eq_expr_a_id" int4,
	"node_integer_cst_a_op_1" int4,
	"node_integer_cst_b_id" int4
);
CREATE TABLE "field_declidentifier_nodename" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_field_decl_a_id" int4,
	"node_identifier_node_a_name" int4,
	"node_identifier_node_b_id" int4
);
CREATE TABLE "indirect_refnop_exprop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_indirect_ref_a_id" int4,
	"node_nop_expr_a_op_0" int4,
	"node_nop_expr_b_id" int4
);
CREATE TABLE "indirect_refparm_declop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_indirect_ref_a_id" int4,
	"node_parm_decl_a_op_0" int4,
	"node_parm_decl_b_id" int4
);
CREATE TABLE "indirect_refvar_declop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_indirect_ref_a_id" int4,
	"node_var_decl_a_op_0" int4,
	"node_var_decl_b_id" int4
);
CREATE TABLE "nop_expraddr_exprop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_nop_expr_a_id" int4,
	"node_addr_expr_a_op_0" int4,
	"node_addr_expr_b_id" int4
);
CREATE TABLE "nop_exprcomponent_refop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_nop_expr_a_id" int4,
	"node_component_ref_a_op_0" int4,
	"node_component_ref_b_id" int4
);
CREATE TABLE "nop_exprnop_exprop_0" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_nop_expr_a_id" int4,
	"node_nop_expr_a_op_0" int4,
	"node_nop_expr_b_id" int4
);
CREATE TABLE "parm_declidentifier_nodename" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_parm_decl_a_id" int4,
	"node_identifier_node_a_name" int4,
	"node_identifier_node_b_id" int4
);
CREATE TABLE "var_declidentifier_nodename" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"node_var_decl_a_id" int4,
	"node_identifier_node_a_name" int4,
	"node_identifier_node_b_id" int4
);
CREATE TABLE "function_call_expr_func_details" (
	"node_file" character varying(255),
	"args" int4,
	"node_function" character varying(255),
	"strg" text,
	"id" int4,
	"fn" int4
);
CREATE TABLE "Count_decl" (
	"node_file" character varying(255),
	"node_function" character varying(255),
	"count" int4
);
CREATE TABLE "node_identifiable_opt" (
	"node_oid" oid,
	"name" int4,
	"id" int4,
	"node_type" character varying(50),
	"node_file" character varying(255),
	"node_function" character varying(255),
	"strg" text
);
CREATE TABLE "idtype" (
	"strg" text,
	"node_oid" oid,
	"name" int4,
	"id" int4,
	"node_type" character varying(50),
	"node_file" character varying(255),
	"node_function" character varying(255)
);
CREATE TABLE "name_decl_2" (
	"srcl" int4,
	"srcp" character varying(255),
	"strg" text,
	"node_type" character varying(50)
);
CREATE TABLE "name_record_type" (
	"interface_name" character varying(50),
	"name" int4,
	"node_function" character varying(255),
	"id" int4,
	"node_file" character varying(255),
	"node_type" character varying(50),
	"flds" int4,
	"size" int4,
	"algn" character varying(50),
	"qualrest" character varying(50),
	"qualconst" character varying(50),
	"qualvol" character varying(50),
	"unql" int4,
	"str" character varying(50),
	"strg" text
);
CREATE TABLE "name_record_type2" (
	"srcl" int4,
	"srcp" character varying(255),
	"interface_name" character varying(50),
	"name" int4,
	"node_function" character varying(255),
	"id" int4,
	"node_file" character varying(255),
	"node_type" character varying(50),
	"flds" int4,
	"size" int4,
	"algn" character varying(50),
	"qualrest" character varying(50),
	"qualconst" character varying(50),
	"qualvol" character varying(50),
	"unql" int4,
	"str" character varying(50),
	"strg" text
);
CREATE TABLE "tree_union" (
	"union_name" text,
	"scpe" int4,
	"bpos" int4,
	"srcl" int4,
	"srcp" character varying(255),
	"strg" text,
	"type" int4,
	"node_file" character varying(255),
	"node_function" character varying(255)
);
CREATE TABLE "node_base2" (
	"node_function" character varying(255),
	"id" int4,
	"node_file" character varying(255),
	"node_type" character varying(50)
);
CREATE TABLE "global_tree_lists" (
	"node_function" character varying(255),
	"id" int4,
	"node_file" character varying(255),
	"node_type" character varying(50),
	"chan" int4,
	"valu" int4,
	"purp" int4
);
CREATE TABLE "chains" (
	"chan" int4
);
CREATE TABLE "global_tree_list_table" (
	"node_function" character varying(255),
	"id" int4,
	"node_file" character varying(255),
	"node_type" character varying(50),
	"chan" int4,
	"valu" int4,
	"purp" int4
);
CREATE UNIQUE INDEX "pk_file_function" on "file_function" using btree ( "filename" "varchar_ops", "functionname" "varchar_ops" );
CREATE  INDEX "node_addr_expr_op_0" on "node_addr_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_nop_expr_main" on "node_nop_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_nop_expr_op_0" on "node_nop_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_call_expr_main" on "node_call_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "nop_op_1" on "node_nop_expr" using btree ( "op_1" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "addr_op_0" on "node_addr_expr" using btree ( "op_0" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE UNIQUE INDEX "temp_4996" on "temp_b6ac0" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "base_node_type" on "node_base" using btree ( "node_type" "varchar_ops" );
CREATE  INDEX "field_name" on "node_field_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "field_owner" on "node_field_decl" using btree ( "scpe" "int4_ops" );
CREATE  INDEX "named_name" on "node_identifiable" using btree ( "name" "int4_ops" );
CREATE  INDEX "record_name" on "node_record_type" using btree ( "name" "int4_ops" );
CREATE  INDEX "type_decl_name" on "node_type_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "field_main" on "node_field_decl" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_cond_expr_op_2" on "node_cond_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_2" "int4_ops" );
CREATE  INDEX "node_eq_expr_op_0" on "node_eq_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_eq_expr_main" on "node_eq_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_eq_expr_op_1" on "node_eq_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_1" "int4_ops" );
CREATE  INDEX "node_cond_expr_op_0" on "node_cond_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_cond_expr_main" on "node_cond_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_cond_expr_op_1" on "node_cond_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_1" "int4_ops" );
CREATE  INDEX "node_compound_expr_op_0" on "node_compound_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_compound_expr_main" on "node_compound_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_compound_expr_op_1" on "node_compound_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_1" "int4_ops" );
CREATE  INDEX "node_indirect_ref_main" on "node_indirect_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_indirect_ref_op_0" on "node_indirect_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_component_ref_op_0" on "node_component_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_field_decl_main" on "node_field_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_field_decl_name" on "node_field_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "name" "int4_ops" );
CREATE  INDEX "node_component_ref_main" on "node_component_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_component_ref_op_1" on "node_component_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_1" "int4_ops" );
CREATE  INDEX "node_var_decl_main" on "node_var_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_var_decl_name" on "node_var_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "name" "int4_ops" );
CREATE  INDEX "node_array_ref_op_0" on "node_array_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "node_array_ref_main" on "node_array_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_array_ref_op_1" on "node_array_ref" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_1" "int4_ops" );
CREATE  INDEX "node_convert_expr_main" on "node_convert_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_convert_expr_op_0" on "node_convert_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "op_0" "int4_ops" );
CREATE  INDEX "record_main" on "node_record_type" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "type_decl_main" on "node_type_decl" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "identifier_main" on "node_identifier_node" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "string_cst_strg" on "node_string_cst" using btree ( "strg" "text_ops" );
CREATE  INDEX "identifier_node_strg" on "node_identifier_node" using btree ( "strg" "text_ops" );
CREATE  INDEX "function_decl_main" on "node_function_decl" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "parm_decl_name" on "node_parm_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "function_decl_name" on "node_function_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "node_parm_decl_main" on "node_parm_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_parm_decl_name" on "node_parm_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "name" "int4_ops" );
CREATE  INDEX "node_call_expr_func" on "node_call_expr" using btree ( "fn" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_call_addr_addr" on "node_addr_expr" using btree ( "op_0" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_call_expr_args" on "node_call_expr" using btree ( "args" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_addr_expr_main" on "node_addr_expr" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_component_ref_op1" on "node_component_ref" using btree ( "op_1" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_component_ref_op0" on "node_component_ref" using btree ( "op_0" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_tree_list_chan" on "node_tree_list" using btree ( "chan" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "node_tree_list_purp" on "node_tree_list" using btree ( "purp" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "node_tree_list_main" on "node_tree_list" using btree ( "id" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "node_tree_list_valu" on "node_tree_list" using btree ( "valu" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "nop_main" on "node_nop_expr" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "addr_main" on "node_addr_expr" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "string_cst_main" on "node_string_cst" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "nop_op_0" on "node_nop_expr" using btree ( "op_0" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_base2id" on "node_base2" using btree ( "id" "int4_ops" );
CREATE  INDEX "node_base2type" on "node_base2" using btree ( "node_type" "varchar_ops" );
CREATE  INDEX "list_chan" on "node_tree_list" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "chan" "int4_ops" );
CREATE  INDEX "node_integer_cst_main" on "node_integer_cst" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_identifier_node_main" on "node_identifier_node" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_string_cst_main" on "node_string_cst" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "node_base_oid" on "node_base" using btree ( "oid" "oid_ops" );
CREATE  INDEX "node_identifiable_oid" on "node_identifiable" using btree ( "oid" "oid_ops" );
CREATE  INDEX "nio_strg" on "node_identifiable_opt" using btree ( "strg" "text_ops" );
CREATE  INDEX "decl_named" on "node_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "name" "int4_ops" );
CREATE  INDEX "decl_named_const" on "node_const_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "name" "int4_ops" );
CREATE  INDEX "global_list_id" on "global_tree_lists" using btree ( "id" "int4_ops" );
CREATE  INDEX "decl_id_result" on "node_result_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "decl_id_label" on "node_label_decl" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "decl_oid" on "node_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_const" on "node_const_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_function" on "node_function_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_type" on "node_type_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_variable" on "node_var_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_field" on "node_field_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_label" on "node_label_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_result" on "node_result_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "decl_oid_parm" on "node_parm_decl" using btree ( "oid" "oid_ops" );
CREATE  INDEX "name_decl_strg" on "name_decl_2" using btree ( "strg" "text_ops" );
CREATE  INDEX "name_decl_src" on "name_decl_2" using btree ( "srcp" "varchar_ops", "srcl" "int4_ops" );
CREATE  INDEX "name_decl_type" on "name_decl_2" using btree ( "node_type" "varchar_ops" );
CREATE  INDEX "name_decl_all" on "name_decl_2" using btree ( "srcp" "varchar_ops", "strg" "text_ops", "node_type" "varchar_ops", "srcl" "int4_ops" );
CREATE  INDEX "global_list_chan" on "global_tree_lists" using btree ( "chan" "int4_ops" );
