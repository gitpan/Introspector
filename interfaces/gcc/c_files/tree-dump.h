/* Tree-dumping functionality for intermediate representation.
   Copyright (C) 1999, 2000 Free Software Foundation, Inc.
   Written by Mark Mitchell <mark@codesourcery.com>

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

#ifndef GCC_TREE_DUMP_H
#define GCC_TREE_DUMP_H

/* for the RDF ouput we include the redland here */
#include <redland.h>

/* Flags used with queue functions.  */
#define DUMP_NONE     0
#define DUMP_BINFO    1

#define INTRSPCTR_BUFFER_MAX 512

/* Information about a node to be dumped.  */

typedef struct dump_node_info
{
  /* The index for the node.  */
  unsigned int index;
  /* Nonzero if the node is a binfo.  */
  unsigned int binfo_p : 1;
} *dump_node_info_p;

/* A dump_queue is a link in the queue of things to be dumped.  */

typedef struct dump_queue
{
  /* The queued tree node.  */
  splay_tree_node node;
  /* The next node in the queue.  */
  struct dump_queue *next;
} *dump_queue_p;

/* A dump_info gives information about how we should perform the dump
   and about the current state of the dump.  */

struct dump_info
{
  FILE * stream; // the current output stream

  char function_name[INTRSPCTR_BUFFER_MAX]; // a buffer containing the current function name

  /*
    the redland RDF world we are building for the introspector
  */
  librdf_world  * pworld;   // the world
  librdf_storage *pstorage; // the db file, the storage
  librdf_model* pmodel;     // the model in that world, TODO : add one per function bodie
  librdf_serializer* pserializer; // this is how we write xml/rdf

  // for logic in general
  librdf_uri*  plogic_boolean;     // true and false values

  // for all gcc interaction
  librdf_uri*  pgcc_node_types;     // the url of the gcc
  librdf_uri*  pgcc_node_modifiers;     // the url of the gcc
  librdf_uri*  pgcc_node_fields;     // the url of the gcc

  // for all current object
  librdf_uri*  pcurrent_uri; // the uri of the current file
  librdf_uri*  pcurrent_addresses; // the uri of the current file, all memory addresses
  librdf_uri*  pcurrent_integers;  // the uri of the current file, all integers
  librdf_uri*  pcurrent_strings;   // the uri of the current file, all strings
  librdf_uri*  pcurrent_files;     // the uri of the current file, all files
  librdf_uri*  pcurrent_functions; // the uri of the current file, all functions

  // more predicates
  librdf_node* pgccfield_filename;    // the filename predicate of a node
  librdf_node* pgccfield_linenumber;  // the line number of the current node
  librdf_node* pgccfield_treecode;    // the treecode, the type of node
  librdf_node* pgccfield_address;     // the memory address of the object

  librdf_node* pgccfield_modifier;    // modifier

  librdf_node* pgccfield_string;      // if the node has a string value, it is stored here
  librdf_node* pgccfield_integer;     // the integer value if there is one


  // here are helper variables
  librdf_node* psubject;      // the current subject (id), this is used to indicate what node we are dealing with
  
  char librdf_type[INTRSPCTR_BUFFER_MAX];        // the type of hash
  char librdf_storagename[INTRSPCTR_BUFFER_MAX]; // the name of the storage
  char librdf_options[INTRSPCTR_BUFFER_MAX];     // the options

  /* The original node.  */
  tree node;
  /* User flags.  */
  int flags;
  /* The next unused node index.  */
  unsigned int index;
  /* The next column.  */
  unsigned int column;
  /* The first node in the queue of nodes to be written out.  */
  dump_queue_p queue;
  /* The last node in the queue.  */
  dump_queue_p queue_end;
  /* Free queue nodes.  */
  dump_queue_p free_list;
  /* The tree nodes which we have already written out.  The
     keys are the addresses of the nodes; the values are the integer
     indices we assigned them.  */
  splay_tree nodes;

};

/* Dump the CHILD and its children.  */
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

#endif /* ! GCC_TREE_DUMP_H */
