# ./pg_dump -s introspector

CREATE TABLE "node_type" (
	"type_name" character varying(45) NOT NULL,
	
)	

CREATE TABLE "attributes" (
	"type_name" character varying(45) NOT NULL,
	"field_name" character varying(15) NOT NULL,
);

CREATE TABLE "relationship_types" (
	"from_type" character varying(45) NOT NULL,
	"field_name" character varying(15) NOT NULL,
	"to_type" character varying(45) NOT NULL,
	"count" int4 NOT NULL
);

CREATE  INDEX "rel_from_type" on "relationship_types" using btree ( "from_type" "varchar_ops" );
CREATE  INDEX "rel_to_type" on "relationship_types" using btree ( "to_type" "varchar_ops" );
CREATE  INDEX "rel_field" on "relationship_types" using btree ( "field_name" "varchar_ops" );
CREATE  INDEX "rel_all" on "relationship_types" using btree ( "from_type" "to_type" "field_name" );
copy relationship_types FROM '\/development\/gcc-3.0\/gcc\/relationships.txt'