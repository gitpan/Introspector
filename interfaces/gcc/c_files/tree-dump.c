/* Tree-dumping functionality for intermediate representation.
   Copyright (C) 1999, 2000, 2002 Free Software Foundation, Inc.
   Written by Mark Mitchell <mark@codesourcery.com>

Modifications copyright 2001,2002 by James Michael DuPont <mdupont777@yahoo.com>
This file is part of GCC.

Additions made :
  linkage of librdf
  usage of pipes to communicate with perl
  
  dump_index_rdf_main // the main dumping code for indexes
  
Removed
  dump_index

Todo :
    librdf_model_add_statement :   factor all these into one function

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

/*
  ideas for strings
  <rdf:Description rdf:ID="foo"><literal>some text here</literal></rdf:Description>
*/
#include "config.h"
#include "system.h"
#include "tree.h"
#include "splay-tree.h"
#include "diagnostic.h"
#include "toplev.h"
#include "tree-dump.h"
#include "langhooks.h"

librdf_node* librdf_new_node_from_literal_escaped (librdf_world *world,
						   const char* string,
						   const char* xml_language,
						   int is_wf_xml);

static unsigned int queue PARAMS ((dump_info_p, tree, int));
static void dump_index_rdf_main PARAMS ((dump_info_p, unsigned int));
static void dequeue_and_dump PARAMS ((dump_info_p, int ));
static void dump_string_field PARAMS ((dump_info_p, const char *, char *));
/*
definitions from tree-dump.h as a reminder
#define dump_child(field, child) \
  queue_and_dump_index (di, field, child, DUMP_NONE)
extern void dump_pointer
  PARAMS ((dump_info_p, void *));
extern void dump_int
  PARAMS ((dump_info_p, const char *, int));
extern void dump_string
  PARAMS ((dump_info_p, const char *));
extern void dump_stmt
  PARAMS ((dump_info_p, tree));
extern void dump_next_stmt
  PARAMS ((dump_info_p, tree));
extern void queue_and_dump_index
  PARAMS ((dump_info_p, const char *, tree, int));
extern void queue_and_dump_type
  PARAMS ((dump_info_p, tree));
*/

//   intrpsctr_serialize
void intrspctr_finish   PARAMS ((dump_info_p));

void intrspctr_serialize   PARAMS ((dump_info_p));
void          intrspctr_free                          PARAMS ((dump_info_p));
void          intrspctr_start_file                    PARAMS ((dump_info_p));
void          intrspctr_start_function                PARAMS ((dump_info_p, const char *));
void          intrspctr_init_model                    PARAMS ((dump_info_p));
void          intrspctr_add_statement                 PARAMS ((dump_info_p,librdf_node*,librdf_node* ));
void          intrspctr_add_statement_typed_string    PARAMS ((dump_info_p,librdf_node* ,librdf_uri * , const char *));
void          intrspctr_add_statement_literal_string  PARAMS ((dump_info_p,librdf_node* , char *));
librdf_node*  intrspctr_get_field_predicate           PARAMS ((dump_info_p, const char *));
void          intrspctr_set_node_type                 PARAMS ((dump_info_p, librdf_node*,  tree ));
void          intrspctr_node_ref                      PARAMS ((dump_info_p, librdf_node*,  unsigned int  ));
void          intrspctr_open_ipc                      PARAMS ((dump_info_p, enum tree_dump_index, const char *  ));
void          intrspctr_assert_field_true             PARAMS ((dump_info_p, const char *  ));
void          intrspctr_dump_filename                 PARAMS ((dump_info_p, const char *, unsigned int  ));

void dump_info_init  PARAMS((dump_info_p, tree));
void dump_info_finish PARAMS((dump_info_p));


/* Define a tree dump switch.  */
struct dump_file_info
{
  const char *const suffix;	/* suffix to give output file.  */
  const char *const swtch;	/* command line switch */
  int flags;			/* user flags */
  int state;			/* state of play */
};

/* Table of tree dump switches. This must be consistent with the
   TREE_DUMP_INDEX enumeration in tree.h */
static struct dump_file_info dump_files[TDI_end] =
{
  {".tu", "dump-translation-unit", 0, 0},
  {".class", "dump-class-hierarchy", 0, 0},
  {".original", "dump-tree-original", 0, 0},
  {".optimized", "dump-tree-optimized", 0, 0},
  {".inlined", "dump-tree-inlined", 0, 0},
};

/* Define a name->number mapping for a dump flag value.  */
struct dump_option_value_info
{
  const char *const name;	/* the name of the value */
  const int value;		/* the value of the name */
};

/* Table of dump options. This must be consistent with the TDF_* flags
   in tree.h */
static const struct dump_option_value_info dump_options[] =
{
  {"address", TDF_ADDRESS},
  {"slim", TDF_SLIM},
  {"all", ~0},
  {NULL, 0}
};


void intrspctr_start_file(di)     
     dump_info_p di;
{
  di->function_name[0] = 0; /* there is no current function */
}



void intrspctr_start_function(di, function_name)
     dump_info_p di;
     const char *function_name;
{
  strcpy(di->function_name, function_name); /* there is no current function */
}


void intrspctr_init_model(di)
     dump_info_p di;
{

  /*
    to do : read this from the di
  */
  strcpy(di->librdf_type,"hashes");
  strcpy(di->librdf_storagename,"gccdu");



  #ifdef __RDF_BDB_
     strcpy(di->librdf_options,"hash-type='bdb',dir='.',write='yes',new='yes'");
  #else
     strcpy(di->librdf_options,"hash-type='memory',dir='.',write='yes',new='yes'");
  #endif


  // RDF!
  di->pworld=librdf_new_world();
  librdf_world_open(di->pworld);


  di->pstorage=librdf_new_storage(di->pworld, 
				  di->librdf_type,
				  di->librdf_storagename,
				  di->librdf_options
				  /*
				    new means to overwrite
				   */
				 );

  di->pmodel=librdf_new_model(di->pworld, di->pstorage, NULL);

  // the basis for gcc specfic types
  di->plogic_boolean    =librdf_new_uri(di->pworld,"http://purl.oclc.org/NET/introspector/2002/11/24/logic/boolean#");
  di->pgcc_node_types    =librdf_new_uri(di->pworld,"http://purl.oclc.org/NET/introspector/2002/11/24/gcc/node_types#");
  di->pgcc_node_modifiers=librdf_new_uri(di->pworld,"http://purl.oclc.org/NET/introspector/2002/11/24/gcc/node_modifiers#");
  di->pgcc_node_fields    =librdf_new_uri(di->pworld,"http://purl.oclc.org/NET/introspector/2002/11/24/gcc/node_fields#");


  // this will change to be something more usefull!
  di->pcurrent_uri         =librdf_new_uri(di->pworld,"#");

  di->pcurrent_functions =  di->pcurrent_addresses=
    di->pcurrent_integers  =    di->pcurrent_strings =
    di->pcurrent_files = di->pcurrent_functions =  di->pcurrent_uri;

  /*

  // memory addresses
  di->pcurrent_addresses   =librdf_new_uri(di->pworld,"./nodes/node-addresses#");

  // integers
  di->pcurrent_integers     =librdf_new_uri(di->pworld,"./nodes/node-integers#");

  // strings
  di->pcurrent_strings     =librdf_new_uri(di->pworld,"./nodes/node-strings#");

  // file information
  di->pcurrent_files       =librdf_new_uri(di->pworld,"./nodes/node-files#");

  // functions 
  di->pcurrent_functions   =librdf_new_uri(di->pworld,"./nodes/node-functions#");

  */
  // the current subject, file and function
  di->psubject  = NULL;

  //  librdf_node* parc;     // the current predicate (id)

  //di=librdf_new_uri_from_uri_local_name(di->pgcc_node_types, "List");
  di->pgccfield_filename =intrspctr_get_field_predicate(di,"filename");
  di->pgccfield_linenumber =intrspctr_get_field_predicate(di,"linenumber");

  di->pgccfield_treecode =intrspctr_get_field_predicate(di,"tree-code");
  di->pgccfield_address =intrspctr_get_field_predicate(di,"address");

  di->pgccfield_string =intrspctr_get_field_predicate(di,"string");
  di->pgccfield_integer =intrspctr_get_field_predicate(di,"integer");

  di->pgccfield_modifier =intrspctr_get_field_predicate(di,"modifier");



}


/* Add T to the end of the queue of nodes to dump.  Returns the index
   assigned to T.  */

void intrspctr_add_statement (di, ppredicate, pobject)
     dump_info_p di;
     librdf_node* ppredicate;
     librdf_node* pobject;
{
  librdf_statement* pstatement=NULL;
  pstatement=librdf_new_statement(di->pworld);    

  librdf_statement_set_subject(pstatement,di->psubject); // the current object
  librdf_statement_set_predicate(pstatement,ppredicate); // the uri passed
  librdf_statement_set_object(pstatement,pobject);       // the object passed

  librdf_model_add_statement(di->pmodel, pstatement);        // book' em

}


void intrspctr_add_statement_typed_string (di, ppredicate, pobject_base, pstring)
     dump_info_p di;
     librdf_node* ppredicate;
     librdf_uri* pobject_base;
     const char * pstring;
{

  librdf_node* pobject= NULL;
  pobject=  librdf_new_node_from_uri_local_name(di->pworld, 
						pobject_base, 
						pstring);
  intrspctr_add_statement(di, 
			  ppredicate,
			  pobject	  
			  );
}


void intrspctr_add_statement_literal_string (di, ppredicate, pstring)
     dump_info_p di;
     librdf_node* ppredicate;
     char * pstring;
{
  librdf_node* pobject;
  pobject=  librdf_new_node_from_literal_escaped(di->pworld, 
					 pstring,
					 NULL,
					 0); // create a new node
   intrspctr_add_statement(di, 
			  ppredicate,
			  pobject	  
			  );
  }


librdf_node* 
intrspctr_get_field_predicate (di, pfield_name)
     dump_info_p di;
     const char * pfield_name;
{
  // TODO, we should cache these, and look it up, do we have this field created?
  return librdf_new_node_from_uri_local_name(di->pworld, 
					     di->pgcc_node_fields, 
					     pfield_name);  
}


void intrspctr_set_node_type ( di, ppredicate, t )
     dump_info_p di;
     librdf_node  * ppredicate;
     tree t;
{
  // this goes into dump_node_typename
  /// this type information is stored in a separate statement! for convienence

  /* And the type of node this is.  */
  //  if (t->binfo_p)
  //  code_name = "binfo";
  //else
  const char * code_name;
  code_name = tree_code_name[(int) TREE_CODE (t)];


  intrspctr_add_statement_typed_string  (
					 di,   
					 ppredicate,
					 di->pgcc_node_types,                  // this is a gcc node type
					 code_name   // whos names is 
					 );

}


void intrspctr_node_ref( di, ppredicate, index )
     dump_info_p di;
     librdf_node*  ppredicate;
     unsigned int  index;
{
  char buffer [INTRSPCTR_BUFFER_MAX];
  sprintf (buffer,"id-%u", index); // format the string
  
  /*
    TODO : take the type of the node that is available 
      code_name = tree_code_name[(int) TREE_CODE (t)];
      (emitted by intrspctr_set_node_type)
      and build that into the uri, so we append for each type of
      node, a different base uri. We could store them in an array of uri bases.
  */
 intrspctr_add_statement_typed_string  (
						di,    
						ppredicate,
						di->pcurrent_uri, // the current uri
						buffer           // the string
						);
}



void intrspctr_open_ipc(di, phase, pfunction_name)
     dump_info_p di;     
     enum tree_dump_index phase;
     const char * pfunction_name;
{

  // dump_base_name is a global from toplev.c
  char *command;

  

  //  command = concat ("introspect_gcc.pl --file-name=", dump_base_name, NULL); // append the parameters

  command = concat ("perl -MIntrospector::GCC -e'Introspector::GCC::stream(\"",
		    dump_base_name, NULL); // append the parameters

  command = concat (command, "\",\"" , NULL); // space between parameters
  command = concat (command, dump_files[phase].suffix, NULL);

  if (pfunction_name)
    {

      command = concat (command, "\",\"" , NULL); // space between parameters
      command = concat (command, pfunction_name, NULL);
    }

  command = concat (command, "\");\'", NULL);

  printf ("\ngoing to open dumper `%s'\n", command);
  di->stream = popen (command, dump_files[phase].state < 0 ? "w" : "w");

  if (!di->stream)
    error ("could not open dump file `%s'", command);
  else
    dump_files[phase].state = 1;

  free (command);    
}


void intrspctr_assert_field_true(di, pfield_name) /* old*/
     dump_info_p di;
     const char *pfield_name;
{
  intrspctr_add_statement_typed_string(di, 
				       intrspctr_get_field_predicate(di,pfield_name),
				       di->plogic_boolean ,  // a gcc modififer
				       "true"               // with the value of this string
				       );
}

void intrspctr_dump_filename(di, filename,linenumber)
     dump_info_p di;
     const char *filename;     
     unsigned int linenumber;
{
  char linebuffer[32];
  char filebuffer[64];
  char * pc = linebuffer;
  sprintf(linebuffer,"%u",linenumber);
  sprintf(filebuffer,"filename-%s",filename);
  
  // TODO: localize the filenames and extract the URI for them
  intrspctr_add_statement_typed_string(  
					      di,
					      di->pgccfield_filename,
					      di->pcurrent_files,   // this is very important, where the files are located
					      filebuffer
					      );
  intrspctr_add_statement_literal_string(di,					 
					 /* lookup this field  type*/
					 di->pgccfield_linenumber,
					 /* dump this string */
					 pc
					 );
}

/*
  this routine sets the current node id in the subject
*/
static void
dump_index_rdf_main (di, index)
     dump_info_p di;
     unsigned int index;
{
  char buffer [INTRSPCTR_BUFFER_MAX];  
  sprintf (buffer,"id-%u", index); // mdupont introspector
  di->psubject=       librdf_new_node_from_uri_local_name(di->pworld, di->pcurrent_uri, buffer);
}

/* Dump pointer PTR using FIELD to identify it.  */

void
dump_pointer (di, ptr)
     dump_info_p di;
     void *ptr;
{
  char buffer[INTRSPCTR_BUFFER_MAX];
  sprintf (buffer, "%lx", (long) ptr); // mdupont introspector
  intrspctr_add_statement_typed_string(
		di,		
		di->pgccfield_address,
		di->pcurrent_addresses,
		buffer
		);
}

/* Dump integer I using FIELD to identify it.  */

void
dump_int (di, pfield_name, i)
     dump_info_p di;
     const char *pfield_name;
     int i;
{
  char buffer[INTRSPCTR_BUFFER_MAX];
  sprintf (buffer, "%d", i); // mdupont introspector
  intrspctr_add_statement_literal_string(
		di,
		intrspctr_get_field_predicate(di,pfield_name),
		buffer
		);
}

/* Dump the string S. 
   extern!
 */
void dump_string (di, string)
     dump_info_p di;
     const char *string;
{
  intrspctr_add_statement_typed_string(
		di,
		di->pgccfield_modifier,    // the type of the current node is a modifier
		di->pgcc_node_modifiers,   // which one? 
		string                     // with the value of this string
		);
}

/* 
   Dump the string field S
   the type of the predicate is the field name in the gcc model.
*/

static void
dump_string_field (di, pfield_name, string)
     dump_info_p di;
     const char *pfield_name;
     char *string;
{

  intrspctr_add_statement_literal_string(di,

					 /* lookup this field  type*/
					 intrspctr_get_field_predicate(di,pfield_name),
					 /* dump this string */
					 string             
					   );
}


// dump child
/* If T has not already been output, queue it for subsequent output.
   FIELD is a string to print before printing the index.  Then, the
   index of T is printed.  */

void
queue_and_dump_index (di, field, t, flags)
     dump_info_p di;
     const char *field;
     tree t;
     int flags;
{
  unsigned int index;

  librdf_node    * ppredicate=NULL; /*
				      look up the type of the field passed as a parameter 
				     */
  splay_tree_node n;

  /* If there's no node, just return.  This makes for fewer checks in
     our callers.  */
  if (!t)
    return;

  /* See if we've already queued or dumped this node.  */
  n = splay_tree_lookup (di->nodes, (splay_tree_key) t);
  if (n)
    index = ((dump_node_info_p) n->value)->index;
  else
    /* If we haven't, add it to the queue.  */
    index = queue (di, t, flags);

  /*
    look up the field, dump a ref to another object, and also emit information about the type of that object
    the next step will be put put the different types of nodes into subdirs
   */
  ppredicate = intrspctr_get_field_predicate(di,field);
  intrspctr_node_ref(di,ppredicate,index);
  intrspctr_set_node_type(di,ppredicate,t);

}

/* Dump the type of T.  */

void
queue_and_dump_type (di, t)
     dump_info_p di;
     tree t;
{
  queue_and_dump_index (di, "type", TREE_TYPE (t), DUMP_NONE);
}

/*
  -------------------
*/
static unsigned int
queue (di, t, flags)
     dump_info_p di;
     tree t;
     int flags;
{
  dump_queue_p dq;
  dump_node_info_p dni;
  unsigned int index;

  /* Assign the next available index to T.  */
  index = ++di->index;

  /* Obtain a new queue node.  */
  if (di->free_list)
    {
      dq = di->free_list;
      di->free_list = dq->next;
    }
  else
    dq = (dump_queue_p) xmalloc (sizeof (struct dump_queue));

  /* Create a new entry in the splay-tree.  */
  dni = (dump_node_info_p) xmalloc (sizeof (struct dump_node_info));
  dni->index = index;
  dni->binfo_p = ((flags & DUMP_BINFO) != 0);
  dq->node = splay_tree_insert (di->nodes, (splay_tree_key) t,
				(splay_tree_value) dni);

  /* Add it to the end of the queue.  */
  dq->next = 0;
  if (!di->queue_end)
    di->queue = dq;
  else
    di->queue_end->next = dq;
  di->queue_end = dq;

  /* Return the index.  */
  return index;
}

/* Dump the next node in the queue.  */
static void
dequeue_and_dump (di,follow_chains )
     dump_info_p di;
     int follow_chains;
{
  dump_queue_p dq;
  splay_tree_node stn;
  dump_node_info_p dni;
  tree t;
  unsigned int index;
  enum tree_code code;
  char code_class;
  // code  const char* code_name;

  /* Get the next node from the queue.  */
  dq = di->queue;
  stn = dq->node;
  t = (tree) stn->key;
  dni = (dump_node_info_p) stn->value;
  index = dni->index;

  /* Remove the node from the queue, and put it on the free list.  */
  di->queue = dq->next;
  if (!di->queue)
    di->queue_end = 0;
  dq->next = di->free_list;
  di->free_list = dq;

  /* Print the node index.  */
  dump_index_rdf_main (di, index);

  /* And the type of node this is.  */
  /*
if (dni->binfo_p)
    code_name = "binfo";
  else
    code_name = tree_code_name[(int) TREE_CODE (t)];
*/
  intrspctr_set_node_type(di, 					 
			  di->pgccfield_treecode, // the
			  t);

  /* Figure out what kind of node this is.  */
  code = TREE_CODE (t);
  code_class = TREE_CODE_CLASS (code);

  /* Although BINFOs are TREE_VECs, we dump them specially so as to be
     more informative.  */
  if (dni->binfo_p)
    {
      if (TREE_VIA_PUBLIC (t))
	dump_string (di, "pub");
      else if (TREE_VIA_PROTECTED (t))
	dump_string (di, "prot");
      else if (TREE_VIA_PRIVATE (t))
	dump_string (di, "priv");
      if (TREE_VIA_VIRTUAL (t))
	dump_string (di, "virt");

      dump_child ("type", BINFO_TYPE (t));
      dump_child ("base", BINFO_BASETYPES (t));

      goto done;
    }

  /* We can knock off a bunch of expression nodes in exactly the same
     way.  */
  if (IS_EXPR_CODE_CLASS (code_class))
    {
      /* If we're dumping children, dump them now.  */
      queue_and_dump_type (di, t);

      switch (code_class)
	{
	case '1':
	  dump_child ("op_0", TREE_OPERAND (t, 0));
	  break;

	case '2':
	case '<':
	  dump_child ("op_0", TREE_OPERAND (t, 0));
	  dump_child ("op_1", TREE_OPERAND (t, 1));
	  break;

	case 'e':
	  /* These nodes are handled explicitly below.  */
	  break;

	default:
	  abort ();
	}
    }
  else if (DECL_P (t))
    {
      /* All declarations have names.  */
      if (DECL_NAME (t))
	dump_child ("name", DECL_NAME (t));
      if (DECL_ASSEMBLER_NAME_SET_P (t)
	  && DECL_ASSEMBLER_NAME (t) != DECL_NAME (t))
	dump_child ("mngl", DECL_ASSEMBLER_NAME (t));
      /* And types.  */
      queue_and_dump_type (di, t);
      dump_child ("scpe", DECL_CONTEXT (t));
      /* And a source position.  */
      if (DECL_SOURCE_FILE (t))
	{
	  const char *filename = strrchr (DECL_SOURCE_FILE (t), '/');
	  if (!filename)
	    filename = DECL_SOURCE_FILE (t);
	  else
	    /* Skip the slash.  */
	    ++filename;

	    if (strcmp(filename, "<built-in>") ==0)
	    { 
	      intrspctr_dump_filename(di,"built-in",0); // line number is not needed
	    }
	    else	      
	    {
	      intrspctr_dump_filename(di,filename,DECL_SOURCE_LINE (t)); // line number is not needed
	    }	    
	}

      /* And any declaration can be compiler-generated.  */
      if (DECL_ARTIFICIAL (t))
	dump_string (di, "artificial");

      if (follow_chains) // to avoid decl chaining inside of function bodies
	{
	  if (TREE_CHAIN (t) && !dump_flag (di, TDF_SLIM, NULL))
	    dump_child ("chan", TREE_CHAIN (t));
	}
    }
  else if (code_class == 't')
    {
      /* All types have qualifiers.  */
      int quals = (*lang_hooks.tree_dump.type_quals) (t);

      if (quals != TYPE_UNQUALIFIED)
	{

	  if (quals & TYPE_QUAL_CONST)
	    {
	      intrspctr_assert_field_true(di,"const");
	    }

	  if (quals & TYPE_QUAL_VOLATILE)
	    {
	      intrspctr_assert_field_true(di,"volitile");
	    }

	  if (quals & TYPE_QUAL_RESTRICT)
	    {
	      intrspctr_assert_field_true(di,"restrict");
	    }
	}

      /* All types have associated declarations.  */
      dump_child ("name", TYPE_NAME (t));

      /* All types have a main variant.  */
      if (TYPE_MAIN_VARIANT (t) != t)
	dump_child ("unql", TYPE_MAIN_VARIANT (t));

      /* And sizes.  */
      dump_child ("size", TYPE_SIZE (t));

      /* All types have alignments.  */
      dump_int (di, "algn", TYPE_ALIGN (t));
    }
  else if (code_class == 'c')
    /* All constants can have types.  */
    queue_and_dump_type (di, t);

  /* Give the language-specific code a chance to print something.  If
     it's completely taken care of things, don't bother printing
     anything more ourselves.  */
  if ((*lang_hooks.tree_dump.dump_tree) (di, t))
    goto done;

  /* Now handle the various kinds of nodes.  */
  switch (code)
    {
      int i;

    case IDENTIFIER_NODE:
      dump_string_field (di, "strg", IDENTIFIER_POINTER (t));
      dump_int (di, "lngt", IDENTIFIER_LENGTH (t));
      break;

    case TREE_LIST:
      dump_child ("purp", TREE_PURPOSE (t));
      dump_child ("valu", TREE_VALUE (t));
      dump_child ("chan", TREE_CHAIN (t)); // TODO: maybe we need to turn this off on follow chains?
      break;

    case TREE_VEC:
      dump_int (di, "lngt", TREE_VEC_LENGTH (t));
      for (i = 0; i < TREE_VEC_LENGTH (t); ++i)
	{
	  char buffer[32];
	  sprintf (buffer, "%u", i);
	  dump_child (buffer, TREE_VEC_ELT (t, i));
	}
      break;

    case INTEGER_TYPE:
    case ENUMERAL_TYPE:
      dump_int (di, "prec", TYPE_PRECISION (t));
      if (TREE_UNSIGNED (t))
	dump_string (di, "unsigned");
      dump_child ("min", TYPE_MIN_VALUE (t));
      dump_child ("max", TYPE_MAX_VALUE (t));

      if (code == ENUMERAL_TYPE)
	dump_child ("csts", TYPE_VALUES (t));
      break;

    case REAL_TYPE:
      dump_int (di, "prec", TYPE_PRECISION (t));
      break;

    case POINTER_TYPE:
      dump_child ("ptd", TREE_TYPE (t));
      break;

    case REFERENCE_TYPE:
      dump_child ("refd", TREE_TYPE (t));
      break;

    case METHOD_TYPE:
      dump_child ("clas", TYPE_METHOD_BASETYPE (t));
      /* Fall through.  */

    case FUNCTION_TYPE:
      dump_child ("retn", TREE_TYPE (t));
      dump_child ("prms", TYPE_ARG_TYPES (t));
      break;

    case ARRAY_TYPE:
      dump_child ("elts", TREE_TYPE (t));
      dump_child ("domn", TYPE_DOMAIN (t));
      break;

    case RECORD_TYPE:
    case UNION_TYPE:
      if (TREE_CODE (t) == RECORD_TYPE)
	dump_string (di, "struct");
      else
	dump_string (di, "union");

      dump_child ("flds", TYPE_FIELDS (t));
      dump_child ("fncs", TYPE_METHODS (t));
      queue_and_dump_index (di, "binf", TYPE_BINFO (t),
			    DUMP_BINFO);
      break;

    case CONST_DECL:
      dump_child ("cnst", DECL_INITIAL (t));
      break;

    case VAR_DECL:
    case PARM_DECL:
    case FIELD_DECL:
    case RESULT_DECL:
      if (TREE_CODE (t) == PARM_DECL)
	dump_child ("argt", DECL_ARG_TYPE (t));
      else
	dump_child ("init", DECL_INITIAL (t));
      dump_child ("size", DECL_SIZE (t));
      dump_int (di, "algn", DECL_ALIGN (t));

      if (TREE_CODE (t) == FIELD_DECL)
	{

	  /*	  if (DECL_C_BIT_FIELD (t))
		  dump_string (di, "bitfield");*/

	  if (DECL_FIELD_OFFSET (t))
	    dump_child ("bpos", bit_position (t));
	}
      else if (TREE_CODE (t) == VAR_DECL
	       || TREE_CODE (t) == PARM_DECL)
	{
	  dump_int (di, "used", TREE_USED (t));
	  if (DECL_REGISTER (t))
	    dump_string (di, "register");
	}
      break;

    case FUNCTION_DECL:
      dump_child ("args", DECL_ARGUMENTS (t));
      if (DECL_EXTERNAL (t))
	dump_string (di, "undefined");
      if (TREE_PUBLIC (t))
	dump_string (di, "extern");
      else
	dump_string (di, "static");
      if (DECL_LANG_SPECIFIC (t) && !dump_flag (di, TDF_SLIM, t))
	dump_child ("body", DECL_SAVED_TREE (t));
      break;

    case INTEGER_CST:
      if (TREE_INT_CST_HIGH (t))
	dump_int (di, "high", TREE_INT_CST_HIGH (t));
      dump_int (di, "low", TREE_INT_CST_LOW (t));
      break;

    case STRING_CST:

      // TODO, replace with a string literal!
      intrspctr_add_statement_literal_string(
					   di,
					   di->pgccfield_string,
					   TREE_STRING_POINTER (t) 
					   );
            
      dump_int (di, "lngt", TREE_STRING_LENGTH (t));
      break;

    case TRUTH_NOT_EXPR:
    case ADDR_EXPR:
    case INDIRECT_REF:
    case CLEANUP_POINT_EXPR:
    case SAVE_EXPR:
      /* These nodes are unary, but do not have code class `1'.  */
      dump_child ("op_0", TREE_OPERAND (t, 0));
      break;

    case TRUTH_ANDIF_EXPR:
    case TRUTH_ORIF_EXPR:
    case INIT_EXPR:
    case MODIFY_EXPR:
    case COMPONENT_REF:
    case COMPOUND_EXPR:
    case ARRAY_REF:
    case PREDECREMENT_EXPR:
    case PREINCREMENT_EXPR:
    case POSTDECREMENT_EXPR:
    case POSTINCREMENT_EXPR:
      /* These nodes are binary, but do not have code class `2'.  */
      dump_child ("op_0", TREE_OPERAND (t, 0));
      dump_child ("op_1", TREE_OPERAND (t, 1));
      break;

    case COND_EXPR:
      dump_child ("op_0", TREE_OPERAND (t, 0));
      dump_child ("op_1", TREE_OPERAND (t, 1));
      dump_child ("op_2", TREE_OPERAND (t, 2));
      break;

    case CALL_EXPR:
      dump_child ("fn", TREE_OPERAND (t, 0));
      dump_child ("args", TREE_OPERAND (t, 1));
      break;

    case CONSTRUCTOR:
      dump_child ("elts", TREE_OPERAND (t, 1));
      break;

    case BIND_EXPR:
      dump_child ("vars", TREE_OPERAND (t, 0));
      dump_child ("body", TREE_OPERAND (t, 1));
      break;

    case LOOP_EXPR:
      dump_child ("body", TREE_OPERAND (t, 0));
      break;

    case EXIT_EXPR:
      dump_child ("cond", TREE_OPERAND (t, 0));
      break;

    case TARGET_EXPR:
      dump_child ("decl", TREE_OPERAND (t, 0));
      dump_child ("init", TREE_OPERAND (t, 1));
      dump_child ("clnp", TREE_OPERAND (t, 2));
      /* There really are two possible places the initializer can be.
	 After RTL expansion, the second operand is moved to the
	 position of the fourth operand, and the second operand
	 becomes NULL.  */
      dump_child ("init", TREE_OPERAND (t, 3));
      break;

    case EXPR_WITH_FILE_LOCATION:
      dump_child ("expr", EXPR_WFL_NODE (t));
      break;

    default:
      /* There are no additional fields to print.  */
      break;
    }
 done:
  if (dump_flag (di, TDF_ADDRESS, NULL))
    dump_pointer (di,  (void *)t); /* "addr",*/
}


/* Return nonzero if FLAG has been specified for the dump, and NODE
   is not the root node of the dump.  */

int dump_flag (di, flag, node)
     dump_info_p di;
     int flag;
     tree node;
{
  return (di->flags & flag) && (node != di->node);
}




/* Dump T, and all its children, on STREAM.  */

void
dump_node (di, t,  followchains)
     dump_info_p di;
     tree t;
     int followchains;
{


  //----------------
  /* Queue up the first node.  */
  queue (di, t, DUMP_NONE);

  /* Until the queue is empty, keep dumping nodes.  */
  while (di->queue)
    dequeue_and_dump (di,followchains);

}

void dump_info_init (di,t)
     dump_info_p di;
     tree t;
{

  /* Initialize the dump-information structure.  */
  //  di->stream = stream;
  di->stream = 0;
  di->flags = 0;
  di->flags = 0;
  di->node = t;
  di->node = 0;
  di->index = 0;
  di->column = 0;
  di->queue = 0;
  di->queue_end = 0;
  di->free_list = 0;
  di->nodes = splay_tree_new (splay_tree_compare_pointers, 0,
			     (splay_tree_delete_value_fn) &free);


}

/* Begin a tree dump for PHASE. Stores any user supplied flag in
   *FLAG_PTR and returns a stream to write to. If the dump is not
   enabled, returns NULL.
   Multiple calls will reopen and append to the dump file.  */

//extern dump_info_p dump_begin		PARAMS ((dump_info_p,enum tree_dump_index));

dump_info_p dump_begin (di,phase)
     dump_info_p di;
     enum tree_dump_index phase;
{
  dump_info_init(di,NULL);

  if (!dump_files[phase].state)
    return NULL;

  intrspctr_init_model(di);

   /* 
      open a perl program to post process the output
    */
  //  intrspctr_start_file(di);
  intrspctr_open_ipc(di,phase,NULL);

  return di;
}

/*
  mdupont:
  this is for dumping function bodies
*/
dump_info_p dump_begin_function (di, phase, f)
     dump_info_p di;
     enum tree_dump_index phase;
     tree f;
{
  char buffer[INTRSPCTR_BUFFER_MAX] = ""; // for storing the objects buffer  
  dump_info_init(di,NULL);

  if (!dump_files[phase].state)
    return NULL;

  /*
	       decl_as_string (fn, TFF_DECL_SPECIFIERS));
      fprintf (stream, " (%s)\n",
	       decl_as_string (DECL_ASSEMBLER_NAME (fn), 0));

*/
  if (DECL_NAME (f))
    {
      if (DECL_NAME (f))
	{
	  sprintf (buffer, ".%s",IDENTIFIER_POINTER (DECL_NAME (f)));
	}
      else
	{
	  sprintf (buffer, ".%d", f);
	}
    }
  else
    {
      sprintf (buffer, ".%d", f);
    }
  /*
    dump_base_name
  */

  intrspctr_start_function(di,buffer);
  intrspctr_init_model(di);
  intrspctr_open_ipc(di,phase,buffer);
 			    
  return di;
}

/* Returns nonzero if tree dump PHASE is enabled.  */

int
dump_enabled_p (phase)
     enum tree_dump_index phase;
{
  return dump_files[phase].state;
}

/* Returns the switch name of PHASE.  */

const char *
dump_flag_name (phase)
     enum tree_dump_index phase;
{
  return dump_files[phase].swtch;
}

void intrspctr_finish(di)
     dump_info_p di;
{
  //  intrpsctr_serialize(di);
  di->pserializer=librdf_new_serializer(di->pworld, "ntriples", NULL, NULL);

  // later try with "application/rdf+xml"
  
  if (di->pserializer)
    {
      if (di->stream)
	{
	  
	  librdf_serializer_serialize_model(di->pserializer, di->stream, NULL, di->pmodel);
	  librdf_free_serializer(di->pserializer);
	}
    }

  //  intrpsctr_free(di);
  //  librdf_free_uri(uri);
  librdf_free_uri(di->pgcc_node_types);
  librdf_free_uri(di->pgcc_node_modifiers);
  librdf_free_uri(di->pgcc_node_fields);
  librdf_free_uri(di->pcurrent_uri);

  librdf_free_model(di->pmodel);
  librdf_free_storage(di->pstorage);
  librdf_free_world(di->pworld);

}

/*
  handle the output of the dumping
*/
void dump_info_finish(di)
     dump_info_p di;
{
  dump_queue_p next_dq;
  dump_queue_p dq;


  /* Now, clean up.  */
  for (dq = di->free_list; dq; dq = next_dq)
    {
      next_dq = dq->next;
      free (dq);
    }
  splay_tree_delete (di->nodes);

  intrspctr_finish(di);

}


/* Finish a tree dump for PHASE. STREAM is the stream created by
   dump_begin.  */

void
dump_end (di,phase)
     dump_info_p di;
     enum tree_dump_index phase ATTRIBUTE_UNUSED;

{
  dump_info_finish(di);
  if (di->stream)
    {     
      pclose (di->stream);
      di->stream=0;
    }
}

/* Parse ARG as a dump switch. Return nonzero if it is, and store the
   relevant details in the dump_files array.  */

int
dump_switch_p (arg)
     const char *arg;
{
  unsigned ix;
  const char *option_value;

  for (ix = 0; ix != TDI_end; ix++)
    if ((option_value = skip_leading_substring (arg, dump_files[ix].swtch)))
      {
	const char *ptr = option_value;


	int flags = 0;

	while (*ptr)
	  {
	    const struct dump_option_value_info *option_ptr;
	    const char *end_ptr;
	    unsigned length;

	    while (*ptr == '-')
	      ptr++;
	    end_ptr = strchr (ptr, '-');
	    if (!end_ptr)
	      end_ptr = ptr + strlen (ptr);
	    length = end_ptr - ptr;

	    for (option_ptr = dump_options; option_ptr->name;
		 option_ptr++)
	      if (strlen (option_ptr->name) == length
		  && !memcmp (option_ptr->name, ptr, length))
		{
		  flags |= option_ptr->value;
		  goto found;
		}
	    warning ("ignoring unknown option `%.*s' in `-f%s'",
		     length, ptr, dump_files[ix].swtch);
	  found:;
	    ptr = end_ptr;
	  }

	dump_files[ix].state = -1;
	dump_files[ix].flags = flags;

	return 1;
      }
  return 0;
}
