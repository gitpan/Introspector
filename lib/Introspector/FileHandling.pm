# Author  : James Michael DuPont
# Generation    : Current
# Status        : To Clean up
# Category      : Perl Tricks- File Handling
# Description   : Centralised File Handling

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

package Introspector::FileHandling;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(OpenOutputFile OpenReadFile CloseFile ExistsFile);
use strict;
use warnings;
require FileHandle;
use File::Path;

my $outputbase= "./output/"; # where to put the output files
my $inputbase= "./input/"; # where to put the output files

sub OpenOutputFile
{
    my $repository = shift;
    my $filename = shift;
    my $fh = new FileHandle;

    mkpath $outputbase unless -d $outputbase;


# Open output file
    if ($fh->open (">" . $outputbase . $filename))
    {
#	warn "opening ". $outputbase . $filename . "\n";
	return $fh;
    }
    else 
    {
	die "cannot open $filename"
    }
}

# open inpput file
sub ExistsFile
{
    my $repository = shift;
    my $filename = shift;
    mkpath $inputbase unless -d $inputbase;
    return -f $inputbase . $filename;
}


# open inpput file
sub OpenReadFile
{
    my $repository = shift;
    my $filename = shift;
    my $fh = new FileHandle;

    die unless "$filename";
    mkpath $inputbase unless -d $inputbase;

# Open output file
    if ($fh->open ( $inputbase . $filename))
    {
#	warn "opening ". $inputbase . $filename . "\n";
	return $fh;
    }
    else 
    {
	die "cannot open $filename"
    }
}

# create directory
# close output files
sub CloseFile
{
    my $repository = shift;
    my $fh = shift;
    $fh->close;
}
1;
