# Author  : James Michael DuPont
# Copyright James Michael DuPont 2001
# Category    : Meta-Programming- Code Generation
# Description : Basics level and tab handling for code generators

# LICENCE STATEMENT
#    This file is part of the GCC XML Node Introspector Project
#    Copyright (C) 2002  James Michael DuPont
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

package Introspector::CodeFormatter;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw (tabs pushl popl resettabs);
use strict;
use warnings;

my $tablevel;

sub tabs
{
    return "\t" x $tablevel;
}
sub resettabs
{
    $tablevel=0;
}
sub pushl # indent level
{
    $tablevel++;
}
sub popl # indent level
{
    $tablevel--;
}
1;
