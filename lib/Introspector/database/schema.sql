\connect - mdupont
CREATE TABLE "pga_queries" (
	"queryname" character varying(64),
	"querytype" character,
	"querycommand" text,
	"querytables" text,
	"querylinks" text,
	"queryresults" text,
	"querycomments" text
);
REVOKE ALL on "pga_queries" from PUBLIC;
GRANT ALL on "pga_queries" to PUBLIC;
CREATE TABLE "pga_forms" (
	"formname" character varying(64),
	"formsource" text
);
REVOKE ALL on "pga_forms" from PUBLIC;
GRANT ALL on "pga_forms" to PUBLIC;
CREATE TABLE "pga_scripts" (
	"scriptname" character varying(64),
	"scriptsource" text
);
REVOKE ALL on "pga_scripts" from PUBLIC;
GRANT ALL on "pga_scripts" to PUBLIC;
CREATE TABLE "pga_reports" (
	"reportname" character varying(64),
	"reportsource" text,
	"reportbody" text,
	"reportprocs" text,
	"reportoptions" text
);
REVOKE ALL on "pga_reports" from PUBLIC;
GRANT ALL on "pga_reports" to PUBLIC;
CREATE TABLE "pga_schema" (
	"schemaname" character varying(64),
	"schematables" text,
	"schemalinks" text
);
REVOKE ALL on "pga_schema" from PUBLIC;
GRANT ALL on "pga_schema" to PUBLIC;
CREATE TABLE "pga_layout" (
	"tablename" character varying(64),
	"nrcols" int2,
	"colnames" text,
	"colwidth" text
);
REVOKE ALL on "pga_layout" from PUBLIC;
GRANT ALL on "pga_layout" to PUBLIC;
CREATE TABLE "relationships" (
	"from_type" character varying(45) NOT NULL,
	"field_name" character varying(15) NOT NULL,
	"to_type" character varying(45) NOT NULL,
	"count" int4 NOT NULL
);
CREATE TABLE "file" (
	"filename" character varying(64) NOT NULL,
	PRIMARY KEY ("filename")
);
CREATE TABLE "file_function" (
	"filename" character varying(64) NOT NULL,
	"functionname" character varying(255) NOT NULL
);
CREATE TABLE "temp_b6ac0" (
	"node_function" character varying(50),
	"id" int4,
	"node_file" character varying(50),
	"node_type" character varying(50)
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
inherits ("node_type", "node_sized", "node_aligned");
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
CREATE TABLE "records_and_fields" (
	"field_name" text,
	"record_name" text
);
CREATE TABLE "records_and_fields_refs" (
	"field_name" text,
	"strg" text,
	"node_function" character varying(255)
);
CREATE TABLE "field_names" (
	"id" int4,
	"node_function" character varying(255),
	"node_file" character varying(255),
	"strg" text
);
CREATE TABLE "function_names" (
	"node_function" character varying(255),
	"node_file" character varying(255),
	"id" int4,
	"strg" text
);
CREATE TABLE "functioncall1" (
	"node_function" character varying(255),
	"node_type" character varying(50)
);
CREATE TABLE "add_expr_type" (
	"count" int4,
	"node_type" character varying(50)
);
CREATE TABLE "add_expr_type_function_decl" (
	"id" int4,
	"strg" text,
	"node_function" character varying(255),
	"node_file" character varying(255)
);
CREATE TABLE "function_call_expr_func" (
	"count" int4,
	"node_function" character varying(255),
	"strg" text
);
CREATE TABLE "function_call_expr_func_details" (
	"args" int4,
	"node_function" character varying(255),
	"strg" text
);
CREATE UNIQUE INDEX "pk_file_function" on "file_function" using btree ( "filename" "varchar_ops", "functionname" "varchar_ops" );
CREATE  INDEX "rel_from_type" on "relationships" using btree ( "from_type" "varchar_ops" );
CREATE  INDEX "rel_to_type" on "relationships" using btree ( "to_type" "varchar_ops" );
CREATE  INDEX "rel_field" on "relationships" using btree ( "field_name" "varchar_ops" );
CREATE  INDEX "rel_all" on "relationships" using btree ( "from_type" "varchar_ops", "field_name" "varchar_ops", "to_type" "varchar_ops" );
CREATE  INDEX "field_name" on "node_field_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "field_owner" on "node_field_decl" using btree ( "scpe" "int4_ops" );
CREATE UNIQUE INDEX "temp_4996" on "temp_b6ac0" using btree ( "node_file" "varchar_ops", "node_function" "varchar_ops", "id" "int4_ops" );
CREATE  INDEX "named_name" on "node_identifiable" using btree ( "name" "int4_ops" );
CREATE  INDEX "record_name" on "node_record_type" using btree ( "name" "int4_ops" );
CREATE  INDEX "type_decl_name" on "node_type_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "field_main" on "node_field_decl" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "record_main" on "node_record_type" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "type_decl_main" on "node_type_decl" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "identifier_main" on "node_identifier_node" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "string_cst_strg" on "node_string_cst" using btree ( "strg" "text_ops" );
CREATE  INDEX "identifier_node_strg" on "node_identifier_node" using btree ( "strg" "text_ops" );
CREATE  INDEX "function_decl_main" on "node_function_decl" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "parm_decl_name" on "node_parm_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "function_decl_name" on "node_function_decl" using btree ( "name" "int4_ops" );
CREATE  INDEX "node_call_expr_main" on "node_call_expr" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_addr_expr_main" on "node_addr_expr" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_call_expr_func" on "node_call_expr" using btree ( "fn" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_call_addr_addr" on "node_addr_expr" using btree ( "op_0" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_call_expr_args" on "node_call_expr" using btree ( "args" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "base_node_type" on "node_base" using btree ( "node_type" "varchar_ops" );
CREATE  INDEX "node_component_ref_main" on "node_component_ref" using btree ( "id" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_component_ref_op1" on "node_component_ref" using btree ( "op_1" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_component_ref_op0" on "node_component_ref" using btree ( "op_0" "int4_ops", "node_function" "varchar_ops", "node_file" "varchar_ops" );
CREATE  INDEX "node_tree_list_chan" on "node_tree_list" using btree ( "chan" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "node_tree_list_purp" on "node_tree_list" using btree ( "purp" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "node_tree_list_main" on "node_tree_list" using btree ( "id" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE  INDEX "node_tree_list_valu" on "node_tree_list" using btree ( "valu" "int4_ops", "node_file" "varchar_ops", "node_function" "varchar_ops" );
CREATE RULE "_RETrecords_and_fields" AS ON SELECT TO records_and_fields DO INSTEAD SELECT t1.strg AS field_name, t3.strg AS record_name FROM node_field_decl t0, node_identifier_node t1, node_record_type t2, node_identifier_node t3 WHERE (((((((((t1.id = t0.name) AND (t1.node_file = t0.node_file)) AND (t1.node_function = t0.node_function)) AND (t0.node_function = t2.node_function)) AND (t0.node_file = t2.node_file)) AND (t2.id = t0.scpe)) AND (t3.id = t2.name)) AND (t2.node_function = t3.node_function)) AND (t2.node_file = t3.node_file));
CREATE RULE "_RETrecords_and_fields_refs" AS ON SELECT TO records_and_fields_refs DO INSTEAD SELECT t1.strg AS field_name, t3.strg, t3.node_function FROM node_field_decl t0, node_identifier_node t1, node_record_type t2, node_identifier_node t3, node_component_ref t4 WHERE (((((((((((((t1.id = t0.name) AND (t1.node_file = t0.node_file)) AND (t1.node_function = t0.node_function)) AND (t0.node_function = t2.node_function)) AND (t0.node_file = t2.node_file)) AND (t2.id = t0.scpe)) AND (t3.id = t2.name)) AND (t2.node_function = t3.node_function)) AND (t2.node_file = t3.node_file)) AND (t0.id = t4.op_1)) AND (t0.node_file = t4.node_file)) AND (t0.node_function = t4.node_function)) AND (t3.node_function = 'dequeue_and_dump'::"varchar"));
CREATE RULE "_RETfield_names" AS ON SELECT TO field_names DO INSTEAD SELECT a.id, a.node_function, a.node_file, b.strg FROM node_field_decl a, node_identifier_node b WHERE ((a.name = b.id) AND (a.node_function = b.node_function));
CREATE RULE "_RETfunction_names" AS ON SELECT TO function_names DO INSTEAD SELECT fd.node_function, fd.node_file, fd.id, idn.strg FROM node_function_decl fd, node_identifier_node idn WHERE (((idn.node_file = fd.node_file) AND (idn.node_function = fd.node_function)) AND (fd.name = idn.id));
CREATE RULE "_RETfunctioncall1" AS ON SELECT TO functioncall1 DO INSTEAD SELECT t0.node_function, t1.node_type FROM node_call_expr t0, node_base* t1 WHERE (((t0.fn = t1.id) AND (t0.node_file = t1.node_file)) AND (t0.node_function = t1.node_function)) GROUP BY t0.node_function, t1.node_type;
CREATE RULE "_RETadd_expr_type" AS ON SELECT TO add_expr_type DO INSTEAD SELECT count(*) AS count, t4.node_type FROM node_addr_expr t3, node_base* t4 WHERE (t4.id = t3.op_0) GROUP BY t4.node_type;
CREATE RULE "_RETadd_expr_type_function_decl" AS ON SELECT TO add_expr_type_function_decl DO INSTEAD SELECT t3.id, t4.strg, t4.node_function, t4.node_file FROM node_addr_expr t3, function_names t4 WHERE (t4.id = t3.op_0);
CREATE RULE "_RETfunction_call_expr_func" AS ON SELECT TO function_call_expr_func DO INSTEAD SELECT count(*) AS count, t2.node_function, t5.strg FROM node_call_expr t2, node_addr_expr t3, node_function_decl t4, node_identifier_node t5 WHERE (((((((((t3.op_0 = t4.id) AND (t2.fn = t3.id)) AND (t4.name = t5.id)) AND (t2.node_function = t3.node_function)) AND (t2.node_file = t3.node_file)) AND (t4.node_function = t3.node_function)) AND (t4.node_file = t3.node_file)) AND (t4.node_function = t5.node_function)) AND (t4.node_file = t5.node_file)) GROUP BY t2.node_function, t5.strg;
CREATE RULE "_RETfunction_call_expr_func_det" AS ON SELECT TO function_call_expr_func_details DO INSTEAD SELECT t2.args, t2.node_function, t5.strg FROM node_call_expr t2, node_addr_expr t3, node_function_decl t4, node_identifier_node t5 WHERE (((((((((t3.op_0 = t4.id) AND (t2.fn = t3.id)) AND (t4.name = t5.id)) AND (t2.node_function = t3.node_function)) AND (t2.node_file = t3.node_file)) AND (t4.node_function = t3.node_function)) AND (t4.node_file = t3.node_file)) AND (t4.node_function = t5.node_function)) AND (t4.node_file = t5.node_file));





node_nop_expr e1, node_nop_expr e2, node_addr_expr a1, node_string_cst st

(a.node_file = b.node_file) AND (a.node_function = b.node_function) AND (a.op_0 = b.id) AND
(b.node_file = c.node_file) AND (b.node_function = c.node_function) AND (b.op_0 = c.id) AND
(c.node_file = d.node_file) AND (c.node_function = d.node_function) AND (c.op_0 = d.id) AND
(d.node_file = e.node_file) AND (d.node_function = e.node_function) AND (d.op_0 = e.id)


####


CREATE  INDEX "nop_main" on "node_nop_expr" ( "id" , "node_function" , "node_file" );
CREATE  INDEX "addr_main" on "node_addr_expr" ( "id" , "node_function" , "node_file" );
CREATE  INDEX "string_cst_main" on "node_string_cst" ( "id" , "node_function" , "node_file" );
CREATE  INDEX "nop_op_0" on "node_nop_expr" ( "op_0" , "node_function" , "node_file" );
CREATE  INDEX "nop_op_1" on "node_nop_expr" ( "op_1" , "node_function" , "node_file" );
CREATE  INDEX "addr_op_0" on "node_addr_expr" ( "op_0" , "node_function" , "node_file" );

