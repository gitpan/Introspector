/*
  
*/
#include "config.h"
#include "system.h"
#include "tree.h"
#include "splay-tree.h"
#include "diagnostic.h"
#include "toplev.h"
#include "tree-dump.h"
#include "langhooks.h"
#include "gcc-intrspctr.h"

/* Dump a tree of some kind.  This is a convenience wrapper for the
   dump_* functions in tree-dump.c.  */
void
intrspctr_dump_java_tree (phase, t)
     enum tree_dump_index phase;
     tree t;
{
  struct dump_info di; 
  
  dump_begin (&di,phase);
  di.flags |= TDF_SLIM;
  if (di.stream)
    {
      dump_node(&di,t,0);
      dump_end (&di,phase);
    }
}

void
intrspctr_dump_java_function (phase, fn)
     enum tree_dump_index phase;
     tree fn;
{
  struct dump_info di;   
  dump_begin (&di, phase);
  if (di.stream)
    {
      di.flags = TDF_SLIM | di.flags;
      dump_node (&di,fn, 1);
      dump_end (&di,phase);
    }
}


