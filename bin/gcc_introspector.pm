#! perl -w
# b ParseGCCXML::Parse
# this script streams out xml from the compiler, and then parses it when done.
package gcc_introspector;
use strict;
#################################################################
#
# MODULE  : gcc_introspector;
# Generation : Third Generation
# Status     : to be cleaned up and integrated into a makefile
# Category   : compiler interface
# Description: Handles an incoming stream of xml from the compiler
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

# create the xml directory
if (! -d "./xml")
{
    mkdir ("xml",777);
}

push @INC,"/development/projects/sourceforge/introspector_root/";

#use ParseGCCXML;
require '/development/projects/sourceforge/introspector_root/ParseGCCXML.pm';

sub process
{
    my $type = shift;
    my $outfile = shift;

    my $timestr .= scalar(localtime()); # add on the time
    $timestr =~ s/\s/_/g; # remove spaces
    $timestr =~ s/:/_/g;  # remove colons

    $outfile = "./xml/tmp_" . $timestr . $outfile;


    open OUT, ">$outfile" ;   
    if (@ARGV)
    {
	my $file = shift @ARGV;
	open IN,$file or die $file;	
    }
    else
    {
	*IN=*STDIN;
    }
    while (<IN>)
    {
	print OUT $_;
    }
    close IN;
    close OUT;    
  ParseGCCXML::Parse($type,$outfile);
}

sub process_stream
{
    process "main","test.xml";
}

sub process_func_stream
{
    process "func","testfunc.xml";
}


1;
