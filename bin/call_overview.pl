#################################################################
#
# MODULE     : call_ overview.pl
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
metacall(q[__fxstat64],parm(q[],q[3]}),	parm(q[__fd],q[int]}),	parm(q[__statbuf]}),	);
metacall(q[__fxstat],parm(q[],q[3]}),	parm(q[__fd],q[int]}),	parm(q[__statbuf]}),	);
metacall(q[__lxstat64],parm(q[],q[3]}),	parm(q[__path]}),	parm(q[__statbuf]}),	);
metacall(q[__lxstat],parm(q[],q[3]}),	parm(q[__path]}),	parm(q[__statbuf]}),	);
metacall(q[__xmknod],parm(q[],q[1]}),	parm(q[__path]}),	parm(q[__mode],q[__mode_t]}),	parm(q[__dev],q[__dev_t]}),	);
metacall(q[__xstat64],parm(q[],q[3]}),	parm(q[__path]}),	parm(q[__statbuf]}),	);
metacall(q[__xstat],parm(q[],q[3]}),	parm(q[__path]}),	parm(q[__statbuf]}),	);
metacall(q[bit_position],parm(q[t]}),	);
metacall(q[dequeue_and_dump],parm(q[di]}),	);
metacall(q[dequeue_and_dump_nochain],parm(q[di]}),	);
metacall(q[dump_index],parm(q[di],q[dump_info_p]}),	parm(q[index]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[algn]}),	parm(q[t],q[decl],q[u1],q[a],q[align]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[algn]}),	parm(q[t],q[type],q[align]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[high]}),	parm(q[t],q[int_cst],q[int_cst],q[high]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[line]}),	parm(q[t],q[tree],q[exp],q[complexity]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[lngt]}),	parm(q[t],q[identifier],q[length]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[lngt]}),	parm(q[t],q[string],q[length]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[lngt]}),	parm(q[t],q[vec],q[length]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[low]}),	parm(q[t],q[int_cst],q[int_cst],q[low]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[prec]}),	parm(q[t],q[type],q[precision]}),	);
metacall(q[dump_int],parm(q[di],q[dump_info_p]}),	parm(q[used]}),	parm(q[t],q[common],q[used_flag]}),	);
metacall(q[dump_maybe_newline],parm(q[di],q[dump_info_p]}),	);
metacall(q[dump_new_line],parm(q[di],q[dump_info_p]}),	);
metacall(q[dump_next_stmt],parm(q[di],q[dump_info_p]}),	parm(q[t]}),	);
metacall(q[dump_stmt],parm(q[di],q[dump_info_p]}),	parm(q[t]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[artificial]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[begn]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[bitfield]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[clnp]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[end]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[extern]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[null]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[priv]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[prot]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[pub]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[register]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[static]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[struct]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[undefined]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[union]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[unsigned]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[virt]}),	);
metacall(q[dump_string],parm(q[di],q[dump_info_p]}),	parm(q[volatile]}),	);
metacall(q[dump_string_field],parm(q[di],q[dump_info_p]}),	parm(q[strg]}),	parm(q[t],q[identifier],q[pointer]}),	);
metacall(q[dump_string_field],parm(q[di],q[dump_info_p]}),	parm(q[strg]}),	parm(q[t],q[string],q[pointer]}),	);
metacall(q[error],parm(q[could not open dump file `%s']}),	parm(q[name]}),	);
metacall(q[fancy_abort],parm(q[c-dump.c]}),	parm(q[],q[1010]}),	parm(q[dequeue_and_dump_nochain]}),	);
metacall(q[fancy_abort],parm(q[c-dump.c]}),	parm(q[],q[474]}),	parm(q[dequeue_and_dump]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[ ]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[ idx="%u" ]}),	parm(q[index],q[unsigned int]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[ ref_node_name="%s" ]}),	parm(q[tree_code_name],q[t],q[tree],q[common],q[code]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[&#%d;]}),	parm(q[c]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[&amp;]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[&apos;]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[&gt;]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[&lt;]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[&quot;]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[/>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<%s ]}),	parm(q[field]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<%s>%d</%s>]}),	parm(q[field]}),	parm(q[i],q[int]}),	parm(q[field]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<%s>]}),	parm(q[field]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[</%s>]}),	parm(q[field]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[</node> ]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[</node>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[</srcp>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[</str>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<node ]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<pointer type="%s" val="%lx"/>]}),	parm(q[field]}),	parm(q[ptr]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<qualconst>%c</qualconst><qualvol>%c</qualvol><qualrest>%c</qualrest>]}),	parm(q[quals],q[],q[1],q[],q[99],q[],q[32]}),	parm(q[quals],q[],q[2],q[],q[0],q[],q[118],q[],q[32]}),	parm(q[quals],q[],q[4],q[],q[0],q[],q[114],q[],q[32]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<srcl>%d</srcl>]}),	parm(q[t],q[decl],q[linenum]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<srcp>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[<str>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[>]}),	);
metacall(q[fprintf],parm(q[di],q[dump_info_p],q[stream]}),	parm(q[node_name="%s" ]}),	parm(q[code_name]}),	);
metacall(q[fprintf],parm(q[stream]}),	parm(q[</xmlroot>]}),	);
metacall(q[fprintf],parm(q[stream]}),	parm(q[<xml_cfile name="%s"/>]}),	parm(q[dump_base_name]}),	);
metacall(q[fprintf],parm(q[stream]}),	parm(q[<xml_cfunction name="%s"/>]}),	parm(q[buffer]}),	);
metacall(q[fprintf],parm(q[stream]}),	parm(q[<xmlroot>]}),	);
metacall(q[fputc_unlocked],parm(q[c]}),	parm(q[di],q[dump_info_p],q[stream]}),	);
metacall(q[free],parm(q[dq]}),	);
metacall(q[free],parm(q[name]}),	);
metacall(q[pclose],parm(q[stream]}),	);
metacall(q[popen],parm(q[name]}),	parm(q[w]}),	);
metacall(q[printf],parm(q[
metacall(q[queue],parm(q[di],q[dump_info_p]}),	parm(q[t],q[tree]}),	parm(q[flags],q[int]}),	);
metacall(q[queue],parm(q[di]}),	parm(q[t],q[tree]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[args]}),	parm(q[t],q[decl],q[arguments]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[args]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[argt]}),	parm(q[t],q[decl],q[initial]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[base]}),	parm(q[t],q[vec],q[a],q[],q[4]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[binf]}),	parm(q[t],q[type],q[binfo]}),	parm(q[],q[1]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[body]}),	parm(q[t],q[decl],q[lang_specific],q[saved_tree]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[body]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[body]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[body]}),	parm(q[t],q[exp],q[operands],q[],q[3]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[bpos]}),	parm(q[]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[buffer]}),	parm(q[t],q[vec],q[a],q[i]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[chan]}),	parm(q[t],q[common],q[chain]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[clas]}),	parm(q[t],q[type],q[maxval]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[clbr]}),	parm(q[t],q[exp],q[operands],q[],q[4]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[clnp]}),	parm(q[t],q[exp],q[operands],q[],q[2]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[cnst]}),	parm(q[t],q[decl],q[initial]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[cond]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[cond]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[csts]}),	parm(q[t],q[type],q[values]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[decl]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[dest]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[domn]}),	parm(q[t],q[type],q[values]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[else]}),	parm(q[t],q[exp],q[operands],q[],q[2]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[elts]}),	parm(q[t],q[common],q[type]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[elts]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[expr]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[expr]}),	parm(q[t],q[exp],q[operands],q[],q[2]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[flds]}),	parm(q[t],q[type],q[values]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[fn]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[fncs]}),	parm(q[t],q[type],q[maxval]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[high]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[init]}),	parm(q[t],q[decl],q[initial]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[init]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[init]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[init]}),	parm(q[t],q[exp],q[operands],q[],q[3]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[ins]}),	parm(q[t],q[exp],q[operands],q[],q[3]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[labl]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[low]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[max]}),	parm(q[t],q[type],q[maxval]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[min]}),	parm(q[t],q[type],q[minval]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[mngl]}),	parm(q[t],q[decl],q[assembler_name],q[],q[0],q[],q[0],q[t],q[decl],q[assembler_name]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[name]}),	parm(q[t],q[decl],q[name]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[name]}),	parm(q[t],q[type],q[name]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[next]}),	parm(q[t],q[tree],q[common],q[chain]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[op_0]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[op_1]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[op_2]}),	parm(q[t],q[exp],q[operands],q[],q[2]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[outs]}),	parm(q[t],q[exp],q[operands],q[],q[2]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[prms]}),	parm(q[t],q[type],q[values]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[ptd]}),	parm(q[t],q[common],q[type]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[purp]}),	parm(q[t],q[list],q[purpose]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[refd]}),	parm(q[t],q[common],q[type]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[retn]}),	parm(q[t],q[common],q[type]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[scpe]}),	parm(q[t],q[decl],q[context]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[size]}),	parm(q[t],q[decl],q[size]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[size]}),	parm(q[t],q[type],q[size]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[stmt]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[strg]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[then]}),	parm(q[t],q[exp],q[operands],q[],q[1]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[type]}),	parm(q[t],q[common],q[type]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[type]}),	parm(q[t],q[tree],q[common],q[type]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[unql]}),	parm(q[t],q[type],q[main_variant]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[valu]}),	parm(q[t],q[list],q[value]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_index],parm(q[di],q[dump_info_p]}),	parm(q[vars]}),	parm(q[t],q[exp],q[operands],q[],q[0]}),	parm(q[],q[0]}),	);
metacall(q[queue_and_dump_type],parm(q[di],q[dump_info_p]}),	parm(q[t]}),	);
metacall(q[quote_string],parm(q[di],q[dump_info_p]}),	parm(q[filename]}),	);
metacall(q[quote_string],parm(q[di],q[dump_info_p]}),	parm(q[string]}),	);
metacall(q[read_integral_parameter],parm(q[option_value],q[],q[1]}),	parm(q[arg]}),	parm(q[],q[0]}),	);
metacall(q[splay_tree_delete],parm(q[di],q[nodes]}),	);
metacall(q[splay_tree_insert],parm(q[di],q[dump_info_p],q[nodes]}),	parm(q[t],q[tree]}),	parm(q[dni]}),	);
metacall(q[splay_tree_lookup],parm(q[di],q[dump_info_p],q[nodes]}),	parm(q[t],q[tree]}),	);
metacall(q[splay_tree_new],parm(q[splay_tree_compare_pointers]}),	parm(q[],q[0]}),	parm(q[free]}),	);
metacall(q[sprintf],parm(q[buffer]}),	parm(q[%u]}),	parm(q[i]}),	);
metacall(q[sprintf],parm(q[buffer]}),	parm(q[.%X]}),	parm(q[f],q[tree]}),	);
metacall(q[sprintf],parm(q[buffer]}),	parm(q[.%s]}),	parm(q[f],q[tree],q[decl],q[name],q[identifier],q[pointer]}),	);
metacall(q[strip_array_types],parm(q[t]}),	);
metacall(q[strlen],parm(q[dump_files],q[ix],q[swtch]}),	);
metacall(q[strlen],parm(q[filename]}),	);
metacall(q[strlen],parm(q[src]}),	);
metacall(q[strlen],parm(q[string]}),	);
metacall(q[strncmp],parm(q[arg]}),	parm(q[dump_files],q[ix],q[swtch]}),	parm(q[]}),	);
metacall(q[strrchr],parm(q[t],q[decl],q[filename]}),	parm(q[],q[47]}),	);
metacall(q[warning],parm(q[ignoring `%s' at end of `-f%s']}),	parm(q[option_value]}),	parm(q[dump_files],q[ix],q[swtch]}),	);
metacall(q[xmalloc],parm(q[],q[8]}),	);
