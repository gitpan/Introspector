package Eval;

# Author        : James Michael DuPont
# Generation    : Current
# Status        : To Clean up
# Category      : Perl Tricks- Eval
# Description   : This module gives you a way to call eval and catch the errors that might occur

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

use Introspector::DebugPrint;
use Carp qw (cluck confess carp);
sub SafeEvalError 
{
    my $code     = shift;
    my $noprint  = shift;
    my $message =  "## DEBUG SafeEval returned UNDEF, error was $@ \n Code was : \n#-----------!\n$code\n#----------!" ;
    cluck $message;
    if (!$noprint) 
    { 
	carp $message;
	confess $message;
    }
    else
    {
	print "Error $@\n";
	cluck $message; # we had some problems
    }
    die $message;
}

sub safe_eval_check
{
    if ($@ ne "")
    {
	SafeEvalError ("normal eval returned"  . $@ ,0);
    }
}

sub safe_eval
{
    my $code = shift;
    my $noprint=0;

    print "## DEBUG SafeEval -- Going to eval \n$code\n" if (!$noprint);
    
    my $return = eval $code;
    if ($return){
        print "## DEBUG SafeEval - eval returned $return\n" if (!$noprint);
	if (not defined ($return))
	{
	    SafeEvalError ($code,$noprint);
	}
    }
    else
    {       
	if ($@ ne "")
	{
	    SafeEvalError ($code,$noprint);
	}
	else
	{
	    # must have been an empty statement!
	}
    }	
    return $return;
}
1;

