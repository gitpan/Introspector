#! /usr/bin/perl
# MODULE  : testfile.pl
# Generation : Third Generation
# Status     : to be cleaned up and moved into a makefile
# Category   : testing of output
# Description: runs ParseGCCXML parser on some xml
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

use strict;

push @INC,"../";

#use ParseGCCXML;
require '../ParseGCCXML.pm';

my ($outfile) = @ARGV;

ParseGCCXML::Parse("test",$outfile);
