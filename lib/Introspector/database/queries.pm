package database::queries;
#################################################################################
# MODULE  : database/queries.pm
# Author  : James Michael DuPont
# Generation : Third Generation
# Status     : To Clean Up
# Category   : Database Schema
# Description: Contains the connection to the database server
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


use Pg;
use strict;
sub new
{
    my $class=shift;
    
    my $conn = Pg::connectdb("dbname=introspector");
    
    
    print "conn :" . $conn->errorMessage . $conn->errorMessage  ."\n";

    my $self = {
	conn => $conn
    };
    
    bless $self,$class;

#    print_query($self,"select * from all_nodes");

    return $self;
}

sub disconnect
{
    my $self = shift; my $conn = $self->{conn};
#    PQfinish($conn)

}

sub exec
{
    my $self = shift; my $conn = $self->{conn};
    my $query = shift;
    return $conn->exec($query);
}

sub print_query
{
    
    my $self = shift; my $conn = $self->{conn};
    my $sql = shift;
    my @ary;
    my ($i,$j);
    warn "$sql";
    Pg::doQuery($conn, "$sql", \@ary);
    for $i ( 0 .. $#ary ) {
	for $j ( 0 .. $#{$ary[$i]} ) {
	    print "$ary[$i][$j]\t";
	}
	print "\n";
    }
}


sub doQueryHTML {

    my $self = shift; 
    my $conn = $self->{conn};
    my $sql = shift;
    my @ary;
    my ($result, $status, $i, $j);
    if ($result = $conn->exec($sql)) {
        if (2 == ($status = $result->resultStatus)) {
	    
	    print "<table border=1>";
	    print "<tr>";
	    for $j (0..$result->nfields - 1) { # column
		my $fname = $result->fname($j); # get the name!		    
		print "<td>$j $fname</td>";

	    }    
	    print "</tr>";
            for $i (0..$result->ntuples - 1) { # row
		print "<tr>";
                for $j (0..$result->nfields - 1) { # column		    

		    print "<td>$j";
                    print $result->getvalue($i, $j);
		    print "</td>";
                }
		print "</tr>\n";
            }
        }
    }
    print "</table>";
    return $status;
}

sub doQuery {

    my $conn      = shift;
    my $query     = shift;
    my $array_ref = shift;

    my ($result, $status, $i, $j);

    
    #for $j (0..$result->nfields - 1) {

    if ($result = $conn->exec($query)) {
        if (2 == ($status = $result->resultStatus)) {
            for $i (0..$result->ntuples - 1) {
                for $j (0..$result->nfields - 1) {
		    my $fname = $result->fname($j); # get the name!		    

                    $$array_ref[$i]->{$fname} = $result->getvalue($i, $j);
                }
            }
        }
    }
    return $status;
}

sub query_list
{
    my $self = shift; my $conn = $self->{conn};
    my $sql = shift;
    my @ary;
    my ($i,$j);
    Pg::doQuery($conn, "$sql", \@ary);


    my $errorMessage = $conn->errorMessage;
    warn $errorMessage if $errorMessage;

    return \@ary;
}

sub query_hashref
{
    
    my $self = shift; my $conn = $self->{conn};
    my $sql = shift;
    my @ary;
    my ($i,$j);
#    warn "$sql";
    doQuery($conn, "$sql", \@ary);
    return \@ary;
}

########################################
# now for the gcc specific queries
########################################

sub create_tables
{
    my $self = shift; my $conn = $self->{conn};
    $self->exec(q[
		  CREATE TABLE "node" (
				       "id" int4,
				       "type" character varying(35)
				       );
		  ]);
};

sub add_file
{
    my $self = shift;
    my $filename = shift;
    $self->exec("insert into file values ('$filename')");
}

sub add_function
{
    my $self     = shift;
    my $filename = shift;
    my $function = shift;
    print "$filename,$function\n";

    $self->exec("insert into file_function values ('$filename','$function')");

}

sub add_node
{
    my $self = shift;
    my $name = shift;    
    my $fields = shift;
    my @fieldstr;
    my @fieldnames;

    foreach (sort keys %{$fields})
    {
	push @fieldnames, "$_"         ;
	push @fieldstr  , $fields->{$_};
    }
    my $sql = "insert into node_" . $name . " (". join (",",@fieldnames) . ") values (". join (",",@fieldstr) . ");\n";    
    my $res = $self->exec ($sql);
    my $cmdStatus = $self->{conn}->status; 
    my $oid = $res->oidStatus;
    my $errorMessage = $self->{conn}->errorMessage;
    return ($errorMessage,$oid,$cmdStatus,$sql);

}
1;
