#################################################################
#
# MODULE     : Handle_indexes.pl
# Author     : James Michael DuPont
# Date       : 24.7.01
# Generation : ?
# Status     : To review
# Category   : Tree Walker
# Description:  A simple overview of how some functions are called
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

meta_c_dump_queue_and_dump_index({name => qw[args],	expr => qw[t,decl,arguments]});
meta_c_dump_queue_and_dump_index({name => qw[args],	expr => qw[t,exp,operands]});

meta_c_dump_queue_and_dump_index({name => qw[argt],	expr => qw[t,decl,initial]});
meta_c_dump_queue_and_dump_index({name => qw[binf],	expr => qw[t,type,binfo]});
meta_c_dump_queue_and_dump_index({name => qw[body],	expr => qw[t,decl,lang_specific,saved_tree]});
meta_c_dump_queue_and_dump_index({name => qw[body],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[bpos],	expr => qw[]});
meta_c_dump_queue_and_dump_index({name => qw[buffer],	expr => qw[t,vec,a,i]});
meta_c_dump_queue_and_dump_index({name => qw[chan],	expr => qw[t,common,chain]});
meta_c_dump_queue_and_dump_index({name => qw[clas],	expr => qw[t,type,maxval]});
meta_c_dump_queue_and_dump_index({name => qw[clbr],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[clnp],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[cnst],	expr => qw[t,decl,initial]});
meta_c_dump_queue_and_dump_index({name => qw[cond],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[csts],	expr => qw[t,type,values]});
meta_c_dump_queue_and_dump_index({name => qw[decl],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[dest],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[domn],	expr => qw[t,type,values]});
meta_c_dump_queue_and_dump_index({name => qw[else],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[elts],	expr => qw[t,common,type]});
meta_c_dump_queue_and_dump_index({name => qw[elts],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[expr],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[flds],	expr => qw[t,type,values]});
meta_c_dump_queue_and_dump_index({name => qw[fn],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[fncs],	expr => qw[t,type,maxval]});
meta_c_dump_queue_and_dump_index({name => qw[high],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[init],	expr => qw[t,decl,initial]});
meta_c_dump_queue_and_dump_index({name => qw[init],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[ins],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[labl],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[low],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[max],	expr => qw[t,type,maxval]});
meta_c_dump_queue_and_dump_index({name => qw[min],	expr => qw[t,type,minval]});
meta_c_dump_queue_and_dump_index({name => qw[op_0],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[op_1],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[op_2],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[outs],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[prms],	expr => qw[t,type,values]});
meta_c_dump_queue_and_dump_index({name => qw[ptd],	expr => qw[t,common,type]});
meta_c_dump_queue_and_dump_index({name => qw[purp],	expr => qw[t,list,purpose]});
meta_c_dump_queue_and_dump_index({name => qw[refd],	expr => qw[t,common,type]});
meta_c_dump_queue_and_dump_index({name => qw[retn],	expr => qw[t,common,type]});
meta_c_dump_queue_and_dump_index({name => qw[size],	expr => qw[t,decl,size]});
meta_c_dump_queue_and_dump_index({name => qw[size],	expr => qw[t,type,size]});
meta_c_dump_queue_and_dump_index({name => qw[stmt],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[strg],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[then],	expr => qw[t,exp,operands]});
meta_c_dump_queue_and_dump_index({name => qw[unql],	expr => qw[t,type,main_variant]});
meta_c_dump_queue_and_dump_index({name => qw[valu],	expr => qw[t,list,value]});
meta_c_dump_queue_and_dump_index({name => qw[vars],	expr => qw[t,exp,operands]});
