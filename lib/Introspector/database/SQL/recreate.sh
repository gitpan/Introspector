#grep -h drop *.SQL > droptables2.sql
#remove --
sh ./rundrops.sh
sh ./rundrops.sh

sh ./runcreate.sh  > log.txt 2>&1 
sh ./runcreate.sh  >> log.txt 2>&1 
sh ./runcreate.sh  >> log.txt 2>&1 
sh ./runcreate.sh  >> log.txt 2>&1 
sh ./runcreate.sh  >> log.txt 2>&1 
sort -u log.txt 

sh ./runcreate.sh  >> log2.txt 2>&1 

psql introspector -f ./indexes.sql

grep -v -e 'already' log2.txt | grep -v -e 'define an attr' | sort -u > log3.txt
cat log3.txt
