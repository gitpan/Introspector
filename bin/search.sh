#
# MODULE  : search.sh
# Generation : Third Generation
# Status     : to be cleaned up and moved into a makefile
# Category   : building the modified compiler
# Description: Looks for types of input statements in the output
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

perl -n -e'print $_ unless $_ =~ /(type|expr|stmt|decl)/' types.txt
perl -ne 'print $_ if /^([\w\s])+insert into node_case_label/' testrun.txt | cut -d\( -f1,2 | sort -u
perl -ne 'print $_ if /^([\w\s])+insert into node_case_label/' testrun.txt  | sort -u