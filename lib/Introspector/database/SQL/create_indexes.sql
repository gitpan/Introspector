#/usr/lib/postgresql/bin/pg_dump -s introspector > ~/introspector.sql

create unique index node_pk on node_base
(
	node_file,
node_function,
id
);

create index node_type_ak on node_base
(node_type);
