#! /usr/local/bin/perl -w
#    eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
#        if 0; #$running_under_some_shell
#################################################################
#
# MODULE     : indexnodes.pl
# Author     : James Michael DuPont
# Generation : First Gereration
# Status     : Obsolete - To remove
# Category   : File Indexing
# Description:  Indexes Node files
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
#########################################################################################

use strict;
use File::Find ();
use File::Path;



# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;


# Traverse desired filesystems
use Cwd ();
my $cwd = Cwd::cwd();
my $indexbase ="./output/nodes/index";

sub wanted {
    #&doexec(0, 'echo','{}');
    chdir $cwd; #sigh
    if (
	(-f $name)
	&&
	($name =~ /ID(\d+)$/) 
	)
    {
	print  "found $name $1\n";
	system "sabcmd ./xsl/node.xsl $_ o$indexbase/html/ID$1.html "; # convert to html
       	system "ln $_ o$indexbase/ID$1.xml ";

	chdir $File::Find::dir;
	print INDEX "$_\n";
    }
    
}

sub doexec {
    my $ok = shift;
    for my $word (@_)
        { $word =~ s#{}#$name#g }
    if ($ok) {
        my $old = select(STDOUT);
        $| = 1;
        print "@_";
        select($old);
        return 0 unless <STDIN> =~ /^y/;
    }
    chdir $cwd; #sigh
    system @_;
    chdir $File::Find::dir;
    return !$?;
}

mkpath("$indexbase");

open INDEX,$indexbase . "index.html";

File::Find::find(\&wanted,
		 '/windows/C/development/introspector/output/nodes/introspector');

close INDEX;

exit;


