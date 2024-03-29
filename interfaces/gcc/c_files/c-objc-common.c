/* Some code common to C and ObjC front ends.
   Copyright (C) 2001 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2, or (at your option) any later
version.

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING.  If not, write to the Free
Software Foundation, 59 Temple Place - Suite 330, Boston, MA
02111-1307, USA.  */

#include "config.h"
#include "system.h"
#include "tree.h"
#include "rtl.h"
#include "insn-config.h"
#include "integrate.h"
#include "expr.h"
#include "c-tree.h"
#include "function.h"
#include "flags.h"
#include "toplev.h"
#include "diagnostic.h"
#include "tree-inline.h"
#include "varray.h"
#include "ggc.h"
#include "langhooks.h"
#include "target.h"
#include "tree-dump.h" /* added so that we can hold the dump_info here*/

static bool c_tree_printer PARAMS ((output_buffer *, text_info *));
static tree inline_forbidden_p PARAMS ((tree *, int *, void *));
static void expand_deferred_fns PARAMS ((void));
static tree start_cdtor	PARAMS ((int));
static void finish_cdtor PARAMS ((tree));

static GTY(()) varray_type deferred_fns;

int
c_missing_noreturn_ok_p (decl)
     tree decl;
{
  /* A missing noreturn is not ok for freestanding implementations and
     ok for the `main' function in hosted implementations.  */
  return flag_hosted && MAIN_NAME_P (DECL_ASSEMBLER_NAME (decl));
}

/* We want to inline `extern inline' functions even if this would
   violate inlining limits.  Some glibc and linux constructs depend on
   such functions always being inlined when optimizing.  */

int
c_disregard_inline_limits (fn)
     tree fn;
{
  if (lookup_attribute ("always_inline", DECL_ATTRIBUTES (fn)) != NULL)
    return 1;

  return DECL_DECLARED_INLINE_P (fn) && DECL_EXTERNAL (fn);
}

static tree
inline_forbidden_p (nodep, walk_subtrees, fn)
     tree *nodep;
     int *walk_subtrees ATTRIBUTE_UNUSED;
     void *fn;
{
  tree node = *nodep;
  tree t;

  switch (TREE_CODE (node))
    {
    case CALL_EXPR:
      t = get_callee_fndecl (node);

      if (! t)
	break;

      /* We cannot inline functions that call setjmp.  */
      if (setjmp_call_p (t))
	return node;

      switch (DECL_FUNCTION_CODE (t))
	{
	  /* We cannot inline functions that take a variable number of
	     arguments.  */
	case BUILT_IN_VA_START:
	case BUILT_IN_STDARG_START:
#if 0
	  /* Functions that need information about the address of the
             caller can't (shouldn't?) be inlined.  */
	case BUILT_IN_RETURN_ADDRESS:
#endif
	  return node;

	default:
	  break;
	}

      break;

    case DECL_STMT:
      /* We cannot inline functions that contain other functions.  */
      if (TREE_CODE (TREE_OPERAND (node, 0)) == FUNCTION_DECL
	  && DECL_INITIAL (TREE_OPERAND (node, 0)))
	return node;
      break;

    case GOTO_STMT:
    case GOTO_EXPR:
      t = TREE_OPERAND (node, 0);

      /* We will not inline a function which uses computed goto.  The
	 addresses of its local labels, which may be tucked into
	 global storage, are of course not constant across
	 instantiations, which causes unexpected behavior.  */
      if (TREE_CODE (t) != LABEL_DECL)
	return node;

      /* We cannot inline a nested function that jumps to a nonlocal
         label.  */
      if (TREE_CODE (t) == LABEL_DECL
	  && DECL_CONTEXT (t) && DECL_CONTEXT (t) != fn)
	return node;

      break;

    case RECORD_TYPE:
    case UNION_TYPE:
      /* We cannot inline a function of the form

	   void F (int i) { struct S { int ar[i]; } s; }

	 Attempting to do so produces a catch-22 in tree-inline.c.
	 If walk_tree examines the TYPE_FIELDS chain of RECORD_TYPE/
	 UNION_TYPE nodes, then it goes into infinite recursion on a
	 structure containing a pointer to its own type.  If it doesn't,
	 then the type node for S doesn't get adjusted properly when
	 F is inlined, and we abort in find_function_data.  */
      for (t = TYPE_FIELDS (node); t; t = TREE_CHAIN (t))
	if (variably_modified_type_p (TREE_TYPE (t)))
	  return node;

    default:
      break;
    }

  return NULL_TREE;
}

int
c_cannot_inline_tree_fn (fnp)
     tree *fnp;
{
  tree fn = *fnp;
  tree t;

  if (flag_really_no_inline
      && lookup_attribute ("always_inline", DECL_ATTRIBUTES (fn)) == NULL)
    return 1;

  /* Don't auto-inline anything that might not be bound within 
     this unit of translation.  */
  if (!DECL_DECLARED_INLINE_P (fn) && !(*targetm.binds_local_p) (fn))
    goto cannot_inline;

  if (! function_attribute_inlinable_p (fn))
    goto cannot_inline;

  /* If a function has pending sizes, we must not defer its
     compilation, and we can't inline it as a tree.  */
  if (fn == current_function_decl)
    {
      t = get_pending_sizes ();
      put_pending_sizes (t);

      if (t)
	goto cannot_inline;
    }

  if (DECL_CONTEXT (fn))
    {
      /* If a nested function has pending sizes, we may have already
         saved them.  */
      if (DECL_LANG_SPECIFIC (fn)->pending_sizes)
	goto cannot_inline;
    }
  else
    {
      /* We rely on the fact that this function is called upfront,
	 just before we start expanding a function.  If FN is active
	 (i.e., it's the current_function_decl or a parent thereof),
	 we have to walk FN's saved tree.  Otherwise, we can safely
	 assume we have done it before and, if we didn't mark it as
	 uninlinable (in which case we wouldn't have been called), it
	 is inlinable.  Unfortunately, this strategy doesn't work for
	 nested functions, because they're only expanded as part of
	 their enclosing functions, so the inlinability test comes in
	 late.  */
      t = current_function_decl;

      while (t && t != fn)
	t = DECL_CONTEXT (t);
      if (! t)
	return 0;
    }
    
  if (walk_tree (&DECL_SAVED_TREE (fn), inline_forbidden_p, fn, NULL))
    goto cannot_inline;

  return 0;

 cannot_inline:
  DECL_UNINLINABLE (fn) = 1;
  return 1;
}

/* Called from check_global_declarations.  */

bool
c_warn_unused_global_decl (decl)
     tree decl;
{
  if (TREE_CODE (decl) == FUNCTION_DECL && DECL_DECLARED_INLINE_P (decl))
    return false;
  if (DECL_IN_SYSTEM_HEADER (decl))
    return false;

  return true;
}

/* Initialization common to C and Objective-C front ends.  */
const char *
c_objc_common_init (filename)
     const char *filename;
{
  c_init_decl_processing ();

  filename = c_common_init (filename);
  if (filename == NULL)
    return NULL;

  lang_expand_decl_stmt = c_expand_decl_stmt;

  /* These were not defined in the Objective-C front end, but I'm
     putting them here anyway.  The diagnostic format decoder might
     want an enhanced ObjC implementation.  */
  diagnostic_format_decoder (global_dc) = &c_tree_printer;
  lang_missing_noreturn_ok_p = &c_missing_noreturn_ok_p;

  /* If still unspecified, make it match -std=c99
     (allowing for -pedantic-errors).  */
  if (mesg_implicit_function_declaration < 0)
    {
      if (flag_isoc99)
	mesg_implicit_function_declaration = flag_pedantic_errors ? 2 : 1;
      else
	mesg_implicit_function_declaration = 0;
    }

  VARRAY_TREE_INIT (deferred_fns, 32, "deferred_fns");

  return filename;
}

/* Register a function tree, so that its optimization and conversion
   to RTL is only done at the end of the compilation.  */

int
defer_fn (fn)
     tree fn;
{
  VARRAY_PUSH_TREE (deferred_fns, fn);

  return 1;
}

/* Expand deferred functions for C and ObjC.  */

static void
expand_deferred_fns ()
{
  unsigned int i;

  for (i = 0; i < VARRAY_ACTIVE_SIZE (deferred_fns); i++)
    {
      tree decl = VARRAY_TREE (deferred_fns, i);

      if (! TREE_ASM_WRITTEN (decl))
	{
	  /* For static inline functions, delay the decision whether to
	     emit them or not until wrapup_global_declarations.  */
	  if (! TREE_PUBLIC (decl))
	    DECL_DEFER_OUTPUT (decl) = 1;
	  c_expand_deferred_function (decl);
	}
    }

  deferred_fns = 0;
}

static tree
start_cdtor (method_type)
     int method_type;
{
  tree fnname = get_file_function_name (method_type);
  tree void_list_node_1 = build_tree_list (NULL_TREE, void_type_node);
  tree body;

  start_function (void_list_node_1,
		  build_nt (CALL_EXPR, fnname,
			    tree_cons (NULL_TREE, NULL_TREE, void_list_node_1),
			    NULL_TREE),
		  NULL_TREE);
  store_parm_decls ();

  current_function_cannot_inline
    = "static constructors and destructors cannot be inlined";

  body = c_begin_compound_stmt ();

  pushlevel (0);
  clear_last_expr ();
  add_scope_stmt (/*begin_p=*/1, /*partial_p=*/0);

  return body;
}

static void
finish_cdtor (body)
     tree body;
{
  tree scope;
  tree block;

  scope = add_scope_stmt (/*begin_p=*/0, /*partial_p=*/0);
  block = poplevel (0, 0, 0);
  SCOPE_STMT_BLOCK (TREE_PURPOSE (scope)) = block;
  SCOPE_STMT_BLOCK (TREE_VALUE (scope)) = block;

  RECHAIN_STMTS (body, COMPOUND_BODY (body));

  finish_function (0, 0);
}

/* Called at end of parsing, but before end-of-file processing.  */

void
c_objc_common_finish_file ()
{
  expand_deferred_fns ();

  if (static_ctors)
    {
      tree body = start_cdtor ('I');

      for (; static_ctors; static_ctors = TREE_CHAIN (static_ctors))
	c_expand_expr_stmt (build_function_call (TREE_VALUE (static_ctors),
						 NULL_TREE));

      finish_cdtor (body);
    }

  if (static_dtors)
    {
      tree body = start_cdtor ('D');

      for (; static_dtors; static_dtors = TREE_CHAIN (static_dtors))
	c_expand_expr_stmt (build_function_call (TREE_VALUE (static_dtors),
						 NULL_TREE));

      finish_cdtor (body);
    }

  {
    struct dump_info di; /* this structure contains all the information about the dumper*/
    dump_begin (&di,TDI_all);
    if (di.stream)
      {
	di.flags = di.flags & ~TDF_SLIM;
	dump_node (&di,getdecls (), 1 );
	dump_end (&di,TDI_all);
      }
  }
}

/* Called during diagnostic message formatting process to print a
   source-level entity onto BUFFER.  The meaning of the format specifiers
   is as follows:
   %D: a general decl,
   %F: a function declaration,
   %T: a type.

   These format specifiers form a subset of the format specifiers set used
   by the C++ front-end.
   Please notice when called, the `%' part was already skipped by the
   diagnostic machinery.  */
static bool
c_tree_printer (buffer, text)
     output_buffer *buffer;
     text_info *text;
{
  tree t = va_arg (*text->args_ptr, tree);

  switch (*text->format_spec)
    {
    case 'D':
    case 'F':
    case 'T':
      {
        const char *n = DECL_NAME (t)
          ? (*lang_hooks.decl_printable_name) (t, 2)
          : "({anonymous})";
        output_add_string (buffer, n);
      }
      return true;

    default:
      return false;
    }
}

#include "gt-c-objc-common.h"
