#! /usr/local/bin/perl 
use Data::Dumper;
#################################################################################
# MODULE  : gcc::fields
# Author  : James Michael DuPont
# Generation : First Generation
# Status     : To Review
# Category   : Loading of data
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

############################################
my $classes;
open IN,"field_overview.pm";
$/ = "";
my $file = <IN>;
my $data = eval($file);
use strict;
use warnings;

open OUT,">fieldreport.txt";
process_fields ($data);
close OUT;

open OUT,">fieldreport1.txt";
print OUT Dumper($classes);
print OUT "\n";
close OUT;

open OUT,">fieldreport2.txt";
print OUT Dumper(sort keys %{$classes});
print OUT "\n";
close OUT;

open OUT,">fieldreport3.txt";
print OUT Dumper(sort  values %{$classes});
close OUT;

close IN;


#############################################
sub process_fields
{
    my $fields = shift;
    # go over all fields
    # see who has the same fields
    # build all the permutations of the types of fields
    # see what classes we can make 
    my @keys = keys %$fields;
    # splice out bindata and binlength
    @keys = map {if ($_ !~ /bindata|binlen/) {$_} else {();}} @keys;

    my @result = ();
    permutate (\@keys,\@result,$fields);
}

sub permutate
{
    my $rset = shift;
    my $result  = shift;
    my $fields = shift;
    my @result = @{$result};

    my @tmp = @$rset;
    # for each field in the input set
    foreach my $i (0..$#tmp-1)
    {
	my @tmp2 = @$rset;
	my @temp = @result;
	# remove the set
	my $element = splice @tmp2,$i,1; # take one off
	if ($element)
	{
	    # push the element onto new one
	    push @temp,$element;
	    
	    if (handle(\@temp,$fields))
	    {
		permutate(\@tmp2,\@temp,$fields);
	    }
	    else
	    {
		#return 0; # stop the permutatations
	    }
	}
	else
	{
	    return 1;
	}
    }
    # $i is the current node
    return 0;
}


sub handle
{
    my $fields_list = shift;
    my $fields = shift;
    my $x; 
    my @types_with_same_fields;

    map{$x->{$_}++;$_} map {keys %{$fields->{$_}}} @{$fields_list};
    map {if ( $x->{$_} eq scalar(@{$fields_list})){push (@types_with_same_fields,$_);}} keys %$x;

    return if (! @types_with_same_fields);# if it is empty

    # result
    my $attribute_string = join (",",sort @{$fields_list}); # 
    my $types_string = join (",",sort @types_with_same_fields); # the new class

    my $oldattribute_string = $classes->{$types_string};
    if ($oldattribute_string)
    {
	if (length($attribute_string) > length($oldattribute_string))
	{	
	    map {
		print OUT  $_ ." ->" . $attribute_string . "\n";    
	    } @types_with_same_fields; # print out each type on a different line, so that we can see what types of configurations of the object occur!
	    

	    print $types_string ." ->" . $attribute_string . "\n";    
	    $classes->{$types_string} = $attribute_string;
	    return 1;
	}
	else
	{
	    # no longer string, so stop the permutations
	    return 0;
	}
    }
    else
    {
	# the old attribute_string
	$classes->{$types_string} = $attribute_string; # the set of classes mapped to the set of common fields collection
	return 1;
    }
}


