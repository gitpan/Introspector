
while (@row = $result->fetchrow)
{

}

#Pg::doQuery($conn, "select attr1, attr2 from tbl", \@ary);
#for $i ( 0 .. $#ary ) {
#    for $j ( 0 .. $#{$ary[$i]} ) {
#	print "$ary[$i][$j]\t";
#    }
#    print "\n";
#}
