#! /bin/bash

psql introspector -a -f rundrops.sql > drop2.log   2>&1 

grep -h drop *.SQL | sed -e s/---// > droptables.sql

psql introspector -a -f droptables.sql > drop.log   2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 
psql introspector -a -f droptables.sql >> drop.log  2>&1 

grep -B1 DROP drop.log | grep drop 


