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






