/*
  gcc-introspectr.h
  isolation for the introspctor to the java compiler

Copyright 2001,2002 by James Michael DuPont <mdupont777@yahoo.com>
This file is part of the GCC introspector patch.

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

extern void intrspctr_dump_java_tree PARAMS ((enum tree_dump_index, tree));
extern void intrspctr_dump_java_function PARAMS ((enum tree_dump_index, tree));
