# This Makefile is for the Introspector extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.03 (Revision: 1.63) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#
#   MakeMaker Parameters:

#     ABSTRACT_FROM => q[Introspector.pm]
#     AUTHOR => q[James Michael DuPont <mdupont777@yahoo.com>]
#     EXE_FILES => [q[./bin/intrspctr.pl]]
#     NAME => q[Introspector]
#     VERSION_FROM => q[./Introspector.pm]

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib/perl/5.8.0/Config.pm)

# They may have been overridden via Makefile.PL or on the command line
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -rdynamic
DLEXT = so
DLSRC = dl_dlopen.xs
LD = cc
LDDLFLAGS = -shared -L/usr/local/lib
LDFLAGS =  -L/usr/local/lib
LIBC = /lib/libc-2.3.1.so
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 2.4.19
RANLIB = :
SO = so
EXE_EXT = 
FULL_AR = /usr/bin/ar


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
NAME = Introspector
DISTNAME = Introspector
NAME_SYM = Introspector
VERSION = 0.04
VERSION_SYM = 0_04
XS_VERSION = 0.04
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INSTALLDIRS = site
PREFIX = /usr
SITEPREFIX = $(PREFIX)/local
VENDORPREFIX = $(PREFIX)
INSTALLPRIVLIB = $(PREFIX)/share/perl/5.8.0
INSTALLSITELIB = $(SITEPREFIX)/share/perl/5.8.0
INSTALLVENDORLIB = $(VENDORPREFIX)/share/perl5
INSTALLARCHLIB = $(PREFIX)/lib/perl/5.8.0
INSTALLSITEARCH = $(SITEPREFIX)/lib/perl/5.8.0
INSTALLVENDORARCH = $(VENDORPREFIX)/lib/perl5
INSTALLBIN = $(PREFIX)/bin
INSTALLSITEBIN = $(SITEPREFIX)/bin
INSTALLVENDORBIN = $(VENDORPREFIX)/bin
INSTALLSCRIPT = $(PREFIX)/bin
PERL_LIB = /usr/share/perl/5.8.0
PERL_ARCHLIB = /usr/lib/perl/5.8.0
SITELIBEXP = /usr/local/share/perl/5.8.0
SITEARCHEXP = /usr/local/lib/perl/5.8.0
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib/perl/5.8.0/CORE
PERL = /mnt/hda4/usr/bin/perl
FULLPERL = /mnt/hda4/usr/bin/perl
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERL = $(PERL)
ABSPERLRUN = $(ABSPERL)
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULL_AR = /usr/bin/ar
PERL_CORE = 0
NOOP = $(SHELL) -c true
NOECHO = @

VERSION_MACRO = VERSION
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc

MAKEMAKER = /usr/share/perl/5.8.0/ExtUtils/MakeMaker.pm
MM_VERSION = 6.03

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
FULLEXT = Introspector
BASEEXT = Introspector
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = ./Introspector.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic

# Handy lists of source code files:
XS_FILES= 
C_FILES = 
O_FILES = 
H_FILES = 
MAN1PODS = ./bin/intrspctr.pl
MAN3PODS = Introspector.pm \
	lib/Class/Contract.pm \
	lib/Introspector/GCC/GCC.pm \
	lib/Introspector/LoadIntrospector.pm \
	lib/Introspector/Visitor.pm
INST_MAN1DIR = blib/man1
MAN1EXT = 1p
INSTALLMAN1DIR = $(PREFIX)/share/man/man1
INSTALLSITEMAN1DIR = $(SITEPREFIX)/man/man1
INSTALLVENDORMAN1DIR = $(VENDORPREFIX)/share/man/man1
INST_MAN3DIR = blib/man3
MAN3EXT = 3pm
INSTALLMAN3DIR = $(PREFIX)/share/man/man3
INSTALLSITEMAN3DIR = $(SITEPREFIX)/man/man3
INSTALLVENDORMAN3DIR = $(VENDORPREFIX)/share/man/man3
PERM_RW = 644
PERM_RWX = 755

# work around a famous dec-osf make(1) feature(?):
makemakerdflt: all

.SUFFIXES: .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

# Nick wanted to get rid of .PRECIOUS. I don't remember why. I seem to recall, that
# some make implementations will delete the Makefile when we rebuild it. Because
# we call false(1) when we rebuild it. So make(1) is not completely wrong when it
# does so. Our milage may vary.
# .PRECIOUS: Makefile    # seems to be not necessary anymore

.PHONY: all config static dynamic test linkext manifest

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)/Config.pm $(PERL_INC)/config.h

# Where to put things:
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC  =
INST_DYNAMIC =
INST_BOOT    =

EXPORT_LIST = 

PERL_ARCHIVE = 

PERL_ARCHIVE_AFTER = 

TO_INST_PM = Introspector.pm \
	lib/B/IntrospectorDeparse.pm \
	lib/Class/Contract.pm \
	lib/Introspector/Breaker.pm \
	lib/Introspector/CodeFormatter.pm \
	lib/Introspector/ConnectionTypes.pm \
	lib/Introspector/CreateClasses.pm \
	lib/Introspector/CrossReference.pm \
	lib/Introspector/DYNCALL.PM \
	lib/Introspector/DYNLOAD.PM \
	lib/Introspector/DebugPrint.pm \
	lib/Introspector/Eval.pm \
	lib/Introspector/FileHandling.pm \
	lib/Introspector/GCC.PM \
	lib/Introspector/GCC/Changes \
	lib/Introspector/GCC/GCC.pm \
	lib/Introspector/GCC/GCC.xs \
	lib/Introspector/GCC/MANIFEST \
	lib/Introspector/GCC/Makefile.PL \
	lib/Introspector/GCC/README \
	lib/Introspector/GCC/build-stamp \
	lib/Introspector/GCC/test.pl \
	lib/Introspector/GeneratedPackage.pm \
	lib/Introspector/HTMLGenerator.pm \
	lib/Introspector/HTMLPrinter.pm \
	lib/Introspector/IncludePaths.pm \
	lib/Introspector/JavaGenerator.pm \
	lib/Introspector/LoadIntrospector.pm \
	lib/Introspector/LoadMetaInfo.pm \
	lib/Introspector/LoadNodes.pm \
	lib/Introspector/MetaAttribute.pm \
	lib/Introspector/MetaConstraint.pm \
	lib/Introspector/MetaFeature.pm \
	lib/Introspector/MetaInheritance.pm \
	lib/Introspector/MetaMethod.pm \
	lib/Introspector/MetaPackage.pm \
	lib/Introspector/MetaPackages.pm \
	lib/Introspector/MetaProperty.pm \
	lib/Introspector/MetaType.pm \
	lib/Introspector/ModifyClasses.pm \
	lib/Introspector/NODE_IDS.PM \
	lib/Introspector/NodeProcess.pm \
	lib/Introspector/NodeVisitors.pm \
	lib/Introspector/ParseGCCXML.pm \
	lib/Introspector/PerlGenerator.pm \
	lib/Introspector/README.txt \
	lib/Introspector/Redland/Storage.pm \
	lib/Introspector/Repository.pm \
	lib/Introspector/SQLGenerator.pm \
	lib/Introspector/StandardPerlGenerator.pm \
	lib/Introspector/TranslateClasses.pm \
	lib/Introspector/TreeCCGenerator.pm \
	lib/Introspector/Visitor.pm \
	lib/Introspector/XMLParser.pm \
	lib/Introspector/XMLPrinter.pm \
	lib/Introspector/components.pm \
	lib/Introspector/database/SQL/create_indexes.sql \
	lib/Introspector/database/SQL/delete_tables.sql \
	lib/Introspector/database/SQL/drops.sql \
	lib/Introspector/database/SQL/droptables.sql \
	lib/Introspector/database/SQL/droptables2.sql \
	lib/Introspector/database/SQL/indexes.sql \
	lib/Introspector/database/SQL/recreate.sh \
	lib/Introspector/database/SQL/runcreate.sh \
	lib/Introspector/database/SQL/rundrops.sh \
	lib/Introspector/database/SQL/rundrops.sql \
	lib/Introspector/database/dumptable.cmd \
	lib/Introspector/database/getschema.sh \
	lib/Introspector/database/grant.sql \
	lib/Introspector/database/introspector_schema.sql \
	lib/Introspector/database/loadrelationships.sql \
	lib/Introspector/database/node_named.sql \
	lib/Introspector/database/queries.pm \
	lib/Introspector/database/queries/currentfiles.sql \
	lib/Introspector/database/queries/drop_indexs.sql \
	lib/Introspector/database/queries/dumptable.cmd \
	lib/Introspector/database/queries/enums.sql \
	lib/Introspector/database/queries/exprs.sql \
	lib/Introspector/database/queries/fields_and_struct.sql \
	lib/Introspector/database/queries/loadrelationships.sql \
	lib/Introspector/database/queries/testconn.pl \
	lib/Introspector/database/queries/tests.sql \
	lib/Introspector/database/schema.sql \
	lib/Introspector/database/schema2.sql \
	lib/Introspector/database/testconn.pl \
	lib/Introspector/db_node_ref.pm \
	lib/Introspector/dyncall.pm \
	lib/Introspector/dynload.pm \
	lib/Introspector/gcc.pm \
	lib/Introspector/gcc/field.pm \
	lib/Introspector/gcc/fields.pm \
	lib/Introspector/gcc/node.pm \
	lib/Introspector/gcc/noderef.pm \
	lib/Introspector/warnings.pm

PM_TO_BLIB = lib/Introspector/database/dumptable.cmd \
	blib/lib/Introspector/database/dumptable.cmd \
	lib/Introspector/database/SQL/droptables2.sql \
	blib/lib/Introspector/database/SQL/droptables2.sql \
	lib/Introspector/GCC/Makefile.PL \
	blib/lib/Introspector/GCC/Makefile.PL \
	lib/Introspector/TreeCCGenerator.pm \
	blib/lib/Introspector/TreeCCGenerator.pm \
	lib/Introspector/ConnectionTypes.pm \
	blib/lib/Introspector/ConnectionTypes.pm \
	lib/Introspector/Visitor.pm \
	blib/lib/Introspector/Visitor.pm \
	lib/Introspector/LoadIntrospector.pm \
	blib/lib/Introspector/LoadIntrospector.pm \
	lib/Introspector/ModifyClasses.pm \
	blib/lib/Introspector/ModifyClasses.pm \
	lib/Introspector/CrossReference.pm \
	blib/lib/Introspector/CrossReference.pm \
	lib/Introspector/SQLGenerator.pm \
	blib/lib/Introspector/SQLGenerator.pm \
	lib/Introspector/GCC/MANIFEST \
	blib/lib/Introspector/GCC/MANIFEST \
	lib/Introspector/GCC/GCC.xs \
	blib/lib/Introspector/GCC/GCC.xs \
	lib/Introspector/db_node_ref.pm \
	blib/lib/Introspector/db_node_ref.pm \
	lib/Introspector/NODE_IDS.PM \
	blib/lib/Introspector/NODE_IDS.PM \
	lib/Introspector/HTMLPrinter.pm \
	blib/lib/Introspector/HTMLPrinter.pm \
	lib/Introspector/database/queries/enums.sql \
	blib/lib/Introspector/database/queries/enums.sql \
	lib/Introspector/components.pm \
	blib/lib/Introspector/components.pm \
	Introspector.pm \
	blib/lib/Introspector.pm \
	lib/Introspector/gcc/field.pm \
	blib/lib/Introspector/gcc/field.pm \
	lib/Introspector/NodeProcess.pm \
	blib/lib/Introspector/NodeProcess.pm \
	lib/Introspector/database/queries/drop_indexs.sql \
	blib/lib/Introspector/database/queries/drop_indexs.sql \
	lib/Introspector/database/queries/exprs.sql \
	blib/lib/Introspector/database/queries/exprs.sql \
	lib/Introspector/GCC/build-stamp \
	blib/lib/Introspector/GCC/build-stamp \
	lib/Introspector/database/queries/testconn.pl \
	blib/lib/Introspector/database/queries/testconn.pl \
	lib/Introspector/gcc/node.pm \
	blib/lib/Introspector/gcc/node.pm \
	lib/Introspector/database/SQL/rundrops.sh \
	blib/lib/Introspector/database/SQL/rundrops.sh \
	lib/Introspector/database/getschema.sh \
	blib/lib/Introspector/database/getschema.sh \
	lib/Introspector/warnings.pm \
	blib/lib/Introspector/warnings.pm \
	lib/Introspector/DebugPrint.pm \
	blib/lib/Introspector/DebugPrint.pm \
	lib/Introspector/MetaProperty.pm \
	blib/lib/Introspector/MetaProperty.pm \
	lib/Introspector/gcc.pm \
	blib/lib/Introspector/gcc.pm \
	lib/Introspector/CreateClasses.pm \
	blib/lib/Introspector/CreateClasses.pm \
	lib/Introspector/MetaType.pm \
	blib/lib/Introspector/MetaType.pm \
	lib/Introspector/GeneratedPackage.pm \
	blib/lib/Introspector/GeneratedPackage.pm \
	lib/Introspector/MetaConstraint.pm \
	blib/lib/Introspector/MetaConstraint.pm \
	lib/Introspector/database/SQL/delete_tables.sql \
	blib/lib/Introspector/database/SQL/delete_tables.sql \
	lib/Introspector/dyncall.pm \
	blib/lib/Introspector/dyncall.pm \
	lib/Introspector/database/SQL/recreate.sh \
	blib/lib/Introspector/database/SQL/recreate.sh \
	lib/Introspector/database/grant.sql \
	blib/lib/Introspector/database/grant.sql \
	lib/Introspector/database/SQL/drops.sql \
	blib/lib/Introspector/database/SQL/drops.sql \
	lib/Introspector/IncludePaths.pm \
	blib/lib/Introspector/IncludePaths.pm \
	lib/Introspector/XMLParser.pm \
	blib/lib/Introspector/XMLParser.pm \
	lib/Introspector/database/queries/tests.sql \
	blib/lib/Introspector/database/queries/tests.sql \
	lib/Introspector/GCC.PM \
	blib/lib/Introspector/GCC.PM \
	lib/Introspector/database/queries/fields_and_struct.sql \
	blib/lib/Introspector/database/queries/fields_and_struct.sql \
	lib/Introspector/FileHandling.pm \
	blib/lib/Introspector/FileHandling.pm \
	lib/Introspector/LoadNodes.pm \
	blib/lib/Introspector/LoadNodes.pm \
	lib/Introspector/database/schema2.sql \
	blib/lib/Introspector/database/schema2.sql \
	lib/Introspector/database/queries/currentfiles.sql \
	blib/lib/Introspector/database/queries/currentfiles.sql \
	lib/Introspector/database/node_named.sql \
	blib/lib/Introspector/database/node_named.sql \
	lib/Introspector/LoadMetaInfo.pm \
	blib/lib/Introspector/LoadMetaInfo.pm \
	lib/Introspector/HTMLGenerator.pm \
	blib/lib/Introspector/HTMLGenerator.pm \
	lib/Introspector/MetaFeature.pm \
	blib/lib/Introspector/MetaFeature.pm \
	lib/Introspector/GCC/GCC.pm \
	blib/lib/Introspector/GCC/GCC.pm \
	lib/Introspector/Breaker.pm \
	blib/lib/Introspector/Breaker.pm \
	lib/Introspector/MetaPackages.pm \
	blib/lib/Introspector/MetaPackages.pm \
	lib/Introspector/GCC/test.pl \
	blib/lib/Introspector/GCC/test.pl \
	lib/Introspector/database/SQL/indexes.sql \
	blib/lib/Introspector/database/SQL/indexes.sql \
	lib/Introspector/DYNCALL.PM \
	blib/lib/Introspector/DYNCALL.PM \
	lib/Introspector/database/introspector_schema.sql \
	blib/lib/Introspector/database/introspector_schema.sql \
	lib/Introspector/database/loadrelationships.sql \
	blib/lib/Introspector/database/loadrelationships.sql \
	lib/Introspector/MetaMethod.pm \
	blib/lib/Introspector/MetaMethod.pm \
	lib/Introspector/database/SQL/rundrops.sql \
	blib/lib/Introspector/database/SQL/rundrops.sql \
	lib/Introspector/NodeVisitors.pm \
	blib/lib/Introspector/NodeVisitors.pm \
	lib/Introspector/database/SQL/runcreate.sh \
	blib/lib/Introspector/database/SQL/runcreate.sh \
	lib/B/IntrospectorDeparse.pm \
	blib/lib/B/IntrospectorDeparse.pm \
	lib/Introspector/database/queries.pm \
	blib/lib/Introspector/database/queries.pm \
	lib/Introspector/database/SQL/droptables.sql \
	blib/lib/Introspector/database/SQL/droptables.sql \
	lib/Introspector/database/SQL/create_indexes.sql \
	blib/lib/Introspector/database/SQL/create_indexes.sql \
	lib/Introspector/StandardPerlGenerator.pm \
	blib/lib/Introspector/StandardPerlGenerator.pm \
	lib/Introspector/database/schema.sql \
	blib/lib/Introspector/database/schema.sql \
	lib/Introspector/GCC/README \
	blib/lib/Introspector/GCC/README \
	lib/Introspector/database/testconn.pl \
	blib/lib/Introspector/database/testconn.pl \
	lib/Introspector/README.txt \
	blib/lib/Introspector/README.txt \
	lib/Introspector/Eval.pm \
	blib/lib/Introspector/Eval.pm \
	lib/Introspector/gcc/fields.pm \
	blib/lib/Introspector/gcc/fields.pm \
	lib/Introspector/CodeFormatter.pm \
	blib/lib/Introspector/CodeFormatter.pm \
	lib/Introspector/database/queries/dumptable.cmd \
	blib/lib/Introspector/database/queries/dumptable.cmd \
	lib/Introspector/MetaAttribute.pm \
	blib/lib/Introspector/MetaAttribute.pm \
	lib/Introspector/dynload.pm \
	blib/lib/Introspector/dynload.pm \
	lib/Introspector/GCC/Changes \
	blib/lib/Introspector/GCC/Changes \
	lib/Introspector/TranslateClasses.pm \
	blib/lib/Introspector/TranslateClasses.pm \
	lib/Introspector/XMLPrinter.pm \
	blib/lib/Introspector/XMLPrinter.pm \
	lib/Introspector/gcc/noderef.pm \
	blib/lib/Introspector/gcc/noderef.pm \
	lib/Introspector/JavaGenerator.pm \
	blib/lib/Introspector/JavaGenerator.pm \
	lib/Introspector/database/queries/loadrelationships.sql \
	blib/lib/Introspector/database/queries/loadrelationships.sql \
	lib/Class/Contract.pm \
	blib/lib/Class/Contract.pm \
	lib/Introspector/Redland/Storage.pm \
	blib/lib/Introspector/Redland/Storage.pm \
	lib/Introspector/MetaPackage.pm \
	blib/lib/Introspector/MetaPackage.pm \
	lib/Introspector/DYNLOAD.PM \
	blib/lib/Introspector/DYNLOAD.PM \
	lib/Introspector/MetaInheritance.pm \
	blib/lib/Introspector/MetaInheritance.pm \
	lib/Introspector/ParseGCCXML.pm \
	blib/lib/Introspector/ParseGCCXML.pm \
	lib/Introspector/Repository.pm \
	blib/lib/Introspector/Repository.pm \
	lib/Introspector/PerlGenerator.pm \
	blib/lib/Introspector/PerlGenerator.pm


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(PERLRUN) -e 'use AutoSplit;  autosplit($$ARGV[0], $$ARGV[1], 0, 1, 1) ;'



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:

SHELL = /bin/sh
CHMOD = chmod
CP = cp
LD = cc
MV = mv
NOOP = $(SHELL) -c true
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1

# The following is a portable way to say mkdir -p
# To see which directories are created, change the if 0 to if 1
MKPATH = $(PERLRUN) "-MExtUtils::Command" -e mkpath

# This helps us to minimize the effect of the .exists files A yet
# better solution would be to have a stable file in the perl
# distribution with a timestamp of zero. But this solution doesn't
# need any changes to the core distribution and works with older perls
EQUALIZE_TIMESTAMP = $(PERLRUN) "-MExtUtils::Command" -e eqtime

# Here we warn users that an old packlist file was found somewhere,
# and that they should call some uninstall routine
WARN_IF_OLD_PACKLIST = $(PERL) -we 'exit unless -f $$ARGV[0];' \
-e 'print "WARNING: I have found an old package in\n";' \
-e 'print "\t$$ARGV[0].\n";' \
-e 'print "Please make sure the two installations are not conflicting\n";'

UNINST=0
VERBINST=0

MOD_INSTALL = $(PERL) "-I$(INST_LIB)" "-I$(PERL_LIB)" "-MExtUtils::Install" \
-e "install({@ARGV},'$(VERBINST)',0,'$(UNINST)');"

DOC_INSTALL = $(PERL) -e '$$\="\n\n";' \
-e 'print "=head2 ", scalar(localtime), ": C<", shift, ">", " L<", $$arg=shift, "|", $$arg, ">";' \
-e 'print "=over 4";' \
-e 'while (defined($$key = shift) and defined($$val = shift)){print "=item *";print "C<$$key: $$val>";}' \
-e 'print "=back";'

UNINSTALL =   $(PERLRUN) "-MExtUtils::Install" \
-e 'uninstall($$ARGV[0],1,1); print "\nUninstall is deprecated. Please check the";' \
-e 'print " packlist above carefully.\n  There may be errors. Remove the";' \
-e 'print " appropriate files manually.\n  Sorry for the inconveniences.\n"'


# --- MakeMaker dist section:
ZIPFLAGS = -r
TO_UNIX = @$(NOOP)
TAR = tar
POSTOP = @$(NOOP)
ZIP = zip
DIST_DEFAULT = tardist
CI = ci -u
SHAR = shar
COMPRESS = gzip --best
DIST_CP = best
PREOP = @$(NOOP)
TARFLAGS = cvf
DISTVNAME = $(DISTNAME)-$(VERSION)
SUFFIX = .gz
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIB="$(LIB)"\
	LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"\
	OPTIMIZE="$(OPTIMIZE)"\
	PASTHRU_DEFINE="$(PASTHRU_DEFINE)"\
	PASTHRU_INC="$(PASTHRU_INC)"


# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:

all :: pure_all manifypods
	@$(NOOP)

pure_all :: config pm_to_blib subdirs linkext
	@$(NOOP)

subdirs :: $(MYEXTLIB)
	@$(NOOP)

config :: Makefile $(INST_LIBDIR)/.exists
	@$(NOOP)

config :: $(INST_ARCHAUTODIR)/.exists
	@$(NOOP)

config :: $(INST_AUTODIR)/.exists
	@$(NOOP)

$(INST_AUTODIR)/.exists :: /usr/lib/perl/5.8.0/CORE/perl.h
	@$(MKPATH) $(INST_AUTODIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl/5.8.0/CORE/perl.h $(INST_AUTODIR)/.exists

	-@$(CHMOD) $(PERM_RWX) $(INST_AUTODIR)

$(INST_LIBDIR)/.exists :: /usr/lib/perl/5.8.0/CORE/perl.h
	@$(MKPATH) $(INST_LIBDIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl/5.8.0/CORE/perl.h $(INST_LIBDIR)/.exists

	-@$(CHMOD) $(PERM_RWX) $(INST_LIBDIR)

$(INST_ARCHAUTODIR)/.exists :: /usr/lib/perl/5.8.0/CORE/perl.h
	@$(MKPATH) $(INST_ARCHAUTODIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl/5.8.0/CORE/perl.h $(INST_ARCHAUTODIR)/.exists

	-@$(CHMOD) $(PERM_RWX) $(INST_ARCHAUTODIR)

config :: $(INST_MAN1DIR)/.exists
	@$(NOOP)


$(INST_MAN1DIR)/.exists :: /usr/lib/perl/5.8.0/CORE/perl.h
	@$(MKPATH) $(INST_MAN1DIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl/5.8.0/CORE/perl.h $(INST_MAN1DIR)/.exists

	-@$(CHMOD) $(PERM_RWX) $(INST_MAN1DIR)

config :: $(INST_MAN3DIR)/.exists
	@$(NOOP)


$(INST_MAN3DIR)/.exists :: /usr/lib/perl/5.8.0/CORE/perl.h
	@$(MKPATH) $(INST_MAN3DIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl/5.8.0/CORE/perl.h $(INST_MAN3DIR)/.exists

	-@$(CHMOD) $(PERM_RWX) $(INST_MAN3DIR)

help:
	perldoc ExtUtils::MakeMaker


# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	@$(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make dynamic"
#dynamic :: Makefile $(INST_DYNAMIC) $(INST_BOOT) $(INST_PM)
dynamic :: Makefile $(INST_DYNAMIC) $(INST_BOOT)
	@$(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
#static :: Makefile $(INST_STATIC) $(INST_PM)
static :: Makefile $(INST_STATIC)
	@$(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:
POD2MAN_EXE = /usr/bin/pod2man
POD2MAN = $(PERL) -we '%m=@ARGV;for (keys %m){' \
-e 'next if -e $$m{$$_} && -M $$m{$$_} < -M $$_ && -M $$m{$$_} < -M "Makefile";' \
-e 'print "Manifying $$m{$$_}\n";' \
-e 'system(q[$(PERLRUN) $(POD2MAN_EXE) ].qq[$$_>$$m{$$_}])==0 or warn "Couldn\047t install $$m{$$_}\n";' \
-e 'chmod(oct($(PERM_RW)), $$m{$$_}) or warn "chmod $(PERM_RW) $$m{$$_}: $$!\n";}'

manifypods : pure_all ./bin/intrspctr.pl \
	lib/Introspector/LoadIntrospector.pm \
	lib/Class/Contract.pm \
	Introspector.pm \
	lib/Introspector/Visitor.pm \
	lib/Introspector/GCC/GCC.pm
	@$(POD2MAN) \
	./bin/intrspctr.pl \
	$(INST_MAN1DIR)/intrspctr.pl.$(MAN1EXT) \
	lib/Introspector/LoadIntrospector.pm \
	$(INST_MAN3DIR)/Introspector::LoadIntrospector.$(MAN3EXT) \
	lib/Class/Contract.pm \
	$(INST_MAN3DIR)/Class::Contract.$(MAN3EXT) \
	Introspector.pm \
	$(INST_MAN3DIR)/Introspector.$(MAN3EXT) \
	lib/Introspector/Visitor.pm \
	$(INST_MAN3DIR)/Introspector::Visitor.$(MAN3EXT) \
	lib/Introspector/GCC/GCC.pm \
	$(INST_MAN3DIR)/Introspector::GCC::GCC.$(MAN3EXT)

# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

$(INST_SCRIPT)/.exists :: /usr/lib/perl/5.8.0/CORE/perl.h
	@$(MKPATH) $(INST_SCRIPT)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl/5.8.0/CORE/perl.h $(INST_SCRIPT)/.exists

	-@$(CHMOD) $(PERM_RWX) $(INST_SCRIPT)

EXE_FILES = ./bin/intrspctr.pl

FIXIN = $(PERLRUN) "-MExtUtils::MY" \
    -e "MY->fixin(shift)"

pure_all :: $(INST_SCRIPT)/intrspctr.pl
	@$(NOOP)

realclean ::
	rm -f $(INST_SCRIPT)/intrspctr.pl

$(INST_SCRIPT)/intrspctr.pl: ./bin/intrspctr.pl Makefile $(INST_SCRIPT)/.exists
	@rm -f $(INST_SCRIPT)/intrspctr.pl
	cp ./bin/intrspctr.pl $(INST_SCRIPT)/intrspctr.pl
	$(FIXIN) $(INST_SCRIPT)/intrspctr.pl
	-@$(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/intrspctr.pl


# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean ::
	-rm -rf ./blib $(MAKE_APERL_FILE) $(INST_ARCHAUTODIR)/extralibs.all perlmain.c tmon.out mon.out so_locations pm_to_blib *$(OBJ_EXT) *$(LIB_EXT) perl.exe perl perl$(EXE_EXT) $(BOOTSTRAP) $(BASEEXT).bso $(BASEEXT).def lib$(BASEEXT).def $(BASEEXT).exp $(BASEEXT).x core core.*perl.*.? *perl.core
	-mv Makefile Makefile.old $(DEV_NULL)


# --- MakeMaker realclean section:

# Delete temporary files (via clean) and also delete installed files
realclean purge ::  clean
	rm -rf $(INST_AUTODIR) $(INST_ARCHAUTODIR)
	rm -rf $(DISTVNAME)
	rm -f  blib/lib/Introspector/database/dumptable.cmd
	rm -f blib/lib/Introspector/database/SQL/droptables2.sql
	rm -f blib/lib/Introspector/GCC/Makefile.PL blib/lib/Introspector/TreeCCGenerator.pm
	rm -f blib/lib/Introspector/ConnectionTypes.pm blib/lib/Introspector/Visitor.pm
	rm -f blib/lib/Introspector/LoadIntrospector.pm blib/lib/Introspector/ModifyClasses.pm
	rm -f blib/lib/Introspector/CrossReference.pm blib/lib/Introspector/SQLGenerator.pm
	rm -f blib/lib/Introspector/GCC/MANIFEST blib/lib/Introspector/GCC/GCC.xs
	rm -f blib/lib/Introspector/db_node_ref.pm blib/lib/Introspector/NODE_IDS.PM
	rm -f blib/lib/Introspector/HTMLPrinter.pm
	rm -f blib/lib/Introspector/database/queries/enums.sql
	rm -f blib/lib/Introspector/components.pm blib/lib/Introspector.pm
	rm -f blib/lib/Introspector/gcc/field.pm blib/lib/Introspector/NodeProcess.pm
	rm -f blib/lib/Introspector/database/queries/drop_indexs.sql
	rm -f blib/lib/Introspector/database/queries/exprs.sql
	rm -f blib/lib/Introspector/GCC/build-stamp
	rm -f blib/lib/Introspector/database/queries/testconn.pl
	rm -f blib/lib/Introspector/gcc/node.pm blib/lib/Introspector/database/SQL/rundrops.sh
	rm -f blib/lib/Introspector/database/getschema.sh blib/lib/Introspector/warnings.pm
	rm -f blib/lib/Introspector/DebugPrint.pm blib/lib/Introspector/MetaProperty.pm
	rm -f blib/lib/Introspector/gcc.pm blib/lib/Introspector/CreateClasses.pm
	rm -f blib/lib/Introspector/MetaType.pm blib/lib/Introspector/GeneratedPackage.pm
	rm -f blib/lib/Introspector/MetaConstraint.pm
	rm -f blib/lib/Introspector/database/SQL/delete_tables.sql
	rm -f blib/lib/Introspector/dyncall.pm blib/lib/Introspector/database/SQL/recreate.sh
	rm -f blib/lib/Introspector/database/grant.sql
	rm -f blib/lib/Introspector/database/SQL/drops.sql
	rm -f blib/lib/Introspector/IncludePaths.pm blib/lib/Introspector/XMLParser.pm
	rm -f blib/lib/Introspector/database/queries/tests.sql blib/lib/Introspector/GCC.PM
	rm -f blib/lib/Introspector/database/queries/fields_and_struct.sql
	rm -f blib/lib/Introspector/FileHandling.pm blib/lib/Introspector/LoadNodes.pm
	rm -f blib/lib/Introspector/database/schema2.sql
	rm -f blib/lib/Introspector/database/queries/currentfiles.sql
	rm -f blib/lib/Introspector/database/node_named.sql
	rm -f blib/lib/Introspector/LoadMetaInfo.pm blib/lib/Introspector/HTMLGenerator.pm
	rm -f blib/lib/Introspector/MetaFeature.pm blib/lib/Introspector/GCC/GCC.pm
	rm -f blib/lib/Introspector/Breaker.pm blib/lib/Introspector/MetaPackages.pm
	rm -f blib/lib/Introspector/GCC/test.pl blib/lib/Introspector/database/SQL/indexes.sql
	rm -f blib/lib/Introspector/DYNCALL.PM
	rm -f blib/lib/Introspector/database/introspector_schema.sql
	rm -f blib/lib/Introspector/database/loadrelationships.sql
	rm -f blib/lib/Introspector/MetaMethod.pm
	rm -f blib/lib/Introspector/database/SQL/rundrops.sql
	rm -f blib/lib/Introspector/NodeVisitors.pm
	rm -f blib/lib/Introspector/database/SQL/runcreate.sh blib/lib/B/IntrospectorDeparse.pm
	rm -f blib/lib/Introspector/database/queries.pm
	rm -f blib/lib/Introspector/database/SQL/droptables.sql
	rm -f blib/lib/Introspector/database/SQL/create_indexes.sql
	rm -f blib/lib/Introspector/StandardPerlGenerator.pm
	rm -f blib/lib/Introspector/database/schema.sql blib/lib/Introspector/GCC/README
	rm -f blib/lib/Introspector/database/testconn.pl blib/lib/Introspector/README.txt
	rm -f blib/lib/Introspector/Eval.pm blib/lib/Introspector/gcc/fields.pm
	rm -f blib/lib/Introspector/CodeFormatter.pm
	rm -f blib/lib/Introspector/database/queries/dumptable.cmd
	rm -f blib/lib/Introspector/MetaAttribute.pm blib/lib/Introspector/dynload.pm
	rm -f blib/lib/Introspector/GCC/Changes blib/lib/Introspector/TranslateClasses.pm
	rm -f blib/lib/Introspector/XMLPrinter.pm blib/lib/Introspector/gcc/noderef.pm
	rm -f blib/lib/Introspector/JavaGenerator.pm
	rm -f blib/lib/Introspector/database/queries/loadrelationships.sql
	rm -f blib/lib/Class/Contract.pm blib/lib/Introspector/Redland/Storage.pm
	rm -f blib/lib/Introspector/MetaPackage.pm blib/lib/Introspector/DYNLOAD.PM
	rm -f blib/lib/Introspector/MetaInheritance.pm blib/lib/Introspector/ParseGCCXML.pm
	rm -f blib/lib/Introspector/Repository.pm blib/lib/Introspector/PerlGenerator.pm
	rm -rf Makefile Makefile.old


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ *.orig */*~ */*.orig



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT)
	@$(PERL) -le 'print "Warning: Makefile possibly out of date with $$vf" if ' \
	    -e '-e ($$vf="$(VERSION_FROM)") and -M $$vf < -M "Makefile";'

tardist : $(DISTVNAME).tar$(SUFFIX)

zipdist : $(DISTVNAME).zip

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(POSTOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) \
		$(DISTVNAME).tar$(SUFFIX) > \
		$(DISTVNAME).tar$(SUFFIX)_uu

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)


# --- MakeMaker dist_dir section:
distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"



# --- MakeMaker dist_test section:

disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)


# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
		-e "@all = keys %{ maniread() };" \
		-e 'print("Executing $(CI) @all\n"); system("$(CI) @all");' \
		-e 'print("Executing $(RCS_LABEL) ...\n"); system("$(RCS_LABEL) @all");'


# --- MakeMaker install section:

install :: all pure_install doc_install

install_perl :: all pure_perl_install doc_perl_install

install_site :: all pure_site_install doc_site_install

install_vendor :: all pure_vendor_install doc_vendor_install

pure_install :: pure_$(INSTALLDIRS)_install

doc_install :: doc_$(INSTALLDIRS)_install

pure__install : pure_site_install
	@echo INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	@echo INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install ::
	@umask 022; $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(INSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(INSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(INSTALLARCHLIB) \
		$(INST_BIN) $(INSTALLBIN) \
		$(INST_SCRIPT) $(INSTALLSCRIPT) \
		$(INST_MAN1DIR) $(INSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(INSTALLMAN3DIR)
	@$(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install ::
	@umask 02; $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(INSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(INSTALLSITELIB) \
		$(INST_ARCHLIB) $(INSTALLSITEARCH) \
		$(INST_BIN) $(INSTALLSITEBIN) \
		$(INST_SCRIPT) $(INSTALLSCRIPT) \
		$(INST_MAN1DIR) $(INSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(INSTALLSITEMAN3DIR)
	@$(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install ::
	@umask 022; $(MOD_INSTALL) \
		$(INST_LIB) $(INSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(INSTALLVENDORARCH) \
		$(INST_BIN) $(INSTALLVENDORBIN) \
		$(INST_SCRIPT) $(INSTALLSCRIPT) \
		$(INST_MAN1DIR) $(INSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(INSTALLVENDORMAN3DIR)

doc_perl_install ::
	@echo Appending installation info to $(INSTALLARCHLIB)/perllocal.pod
	-@umask 022; $(MKPATH) $(INSTALLARCHLIB)
	-@umask 022; $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(INSTALLARCHLIB)/perllocal.pod

doc_site_install ::
	@echo Appending installation info to $(INSTALLSITEARCH)/perllocal.pod
	-@umask 02; $(MKPATH) $(INSTALLSITEARCH)
	-@umask 02; $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(INSTALLSITEARCH)/perllocal.pod

doc_vendor_install ::


uninstall :: uninstall_from_$(INSTALLDIRS)dirs

uninstall_from_perldirs ::
	@$(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	@$(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE:
	@$(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:

# We take a very conservative approach here, but it\'s worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
Makefile : Makefile.PL $(CONFIGDEP)
	@echo "Makefile out-of-date with respect to $?"
	@echo "Cleaning current config before rebuilding Makefile..."
	-@$(RM_F) Makefile.old
	-@$(MV) Makefile Makefile.old
	-$(MAKE) -f Makefile.old clean $(DEV_NULL) || $(NOOP)
	$(PERLRUN) Makefile.PL 
	@echo "==> Your Makefile has been rebuilt. <=="
	@echo "==> Please rerun the make command.  <=="
	false



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /mnt/hda4/usr/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) -f $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE)
	@echo Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	@$(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = 
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE)
	@echo 'No tests defined for $(NAME) extension.'

test_dynamic :: pure_all

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd:
	@$(PERL) -e "print qq{<SOFTPKG NAME=\"$(DISTNAME)\" VERSION=\"0,04,0,0\">\n\t<TITLE>$(DISTNAME)</TITLE>\n\t<ABSTRACT></ABSTRACT>\n\t<AUTHOR>James Michael DuPont &lt;mdupont777\@yahoo.com&gt;</AUTHOR>\n}" > $(DISTNAME).ppd
	@$(PERL) -e "print qq{\t<IMPLEMENTATION>\n}" >> $(DISTNAME).ppd
	@$(PERL) -e "print qq{\t\t<OS NAME=\"$(OSNAME)\" />\n\t\t<ARCHITECTURE NAME=\"i386-linux-thread-multi\" />\n\t\t<CODEBASE HREF=\"\" />\n\t</IMPLEMENTATION>\n</SOFTPKG>\n}" >> $(DISTNAME).ppd

# --- MakeMaker pm_to_blib section:

pm_to_blib: $(TO_INST_PM)
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/dumptable.cmd blib/lib/Introspector/database/dumptable.cmd lib/Introspector/database/SQL/droptables2.sql blib/lib/Introspector/database/SQL/droptables2.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/TreeCCGenerator.pm blib/lib/Introspector/TreeCCGenerator.pm lib/Introspector/GCC/Makefile.PL blib/lib/Introspector/GCC/Makefile.PL}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/ConnectionTypes.pm blib/lib/Introspector/ConnectionTypes.pm lib/Introspector/Visitor.pm blib/lib/Introspector/Visitor.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/LoadIntrospector.pm blib/lib/Introspector/LoadIntrospector.pm lib/Introspector/CrossReference.pm blib/lib/Introspector/CrossReference.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/ModifyClasses.pm blib/lib/Introspector/ModifyClasses.pm lib/Introspector/SQLGenerator.pm blib/lib/Introspector/SQLGenerator.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/GCC/MANIFEST blib/lib/Introspector/GCC/MANIFEST lib/Introspector/GCC/GCC.xs blib/lib/Introspector/GCC/GCC.xs lib/Introspector/db_node_ref.pm blib/lib/Introspector/db_node_ref.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/NODE_IDS.PM blib/lib/Introspector/NODE_IDS.PM lib/Introspector/HTMLPrinter.pm blib/lib/Introspector/HTMLPrinter.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries/enums.sql blib/lib/Introspector/database/queries/enums.sql lib/Introspector/components.pm blib/lib/Introspector/components.pm Introspector.pm blib/lib/Introspector.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/gcc/field.pm blib/lib/Introspector/gcc/field.pm lib/Introspector/NodeProcess.pm blib/lib/Introspector/NodeProcess.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries/drop_indexs.sql blib/lib/Introspector/database/queries/drop_indexs.sql lib/Introspector/database/queries/exprs.sql blib/lib/Introspector/database/queries/exprs.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/GCC/build-stamp blib/lib/Introspector/GCC/build-stamp lib/Introspector/database/queries/testconn.pl blib/lib/Introspector/database/queries/testconn.pl}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/gcc/node.pm blib/lib/Introspector/gcc/node.pm lib/Introspector/database/SQL/rundrops.sh blib/lib/Introspector/database/SQL/rundrops.sh}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/getschema.sh blib/lib/Introspector/database/getschema.sh lib/Introspector/warnings.pm blib/lib/Introspector/warnings.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/DebugPrint.pm blib/lib/Introspector/DebugPrint.pm lib/Introspector/MetaProperty.pm blib/lib/Introspector/MetaProperty.pm lib/Introspector/gcc.pm blib/lib/Introspector/gcc.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/CreateClasses.pm blib/lib/Introspector/CreateClasses.pm lib/Introspector/MetaType.pm blib/lib/Introspector/MetaType.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/GeneratedPackage.pm blib/lib/Introspector/GeneratedPackage.pm lib/Introspector/MetaConstraint.pm blib/lib/Introspector/MetaConstraint.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/SQL/delete_tables.sql blib/lib/Introspector/database/SQL/delete_tables.sql lib/Introspector/dyncall.pm blib/lib/Introspector/dyncall.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/grant.sql blib/lib/Introspector/database/grant.sql lib/Introspector/database/SQL/recreate.sh blib/lib/Introspector/database/SQL/recreate.sh}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/IncludePaths.pm blib/lib/Introspector/IncludePaths.pm lib/Introspector/database/SQL/drops.sql blib/lib/Introspector/database/SQL/drops.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/XMLParser.pm blib/lib/Introspector/XMLParser.pm lib/Introspector/GCC.PM blib/lib/Introspector/GCC.PM}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries/tests.sql blib/lib/Introspector/database/queries/tests.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries/fields_and_struct.sql blib/lib/Introspector/database/queries/fields_and_struct.sql lib/Introspector/FileHandling.pm blib/lib/Introspector/FileHandling.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/LoadNodes.pm blib/lib/Introspector/LoadNodes.pm lib/Introspector/database/schema2.sql blib/lib/Introspector/database/schema2.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries/currentfiles.sql blib/lib/Introspector/database/queries/currentfiles.sql lib/Introspector/database/node_named.sql blib/lib/Introspector/database/node_named.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/LoadMetaInfo.pm blib/lib/Introspector/LoadMetaInfo.pm lib/Introspector/HTMLGenerator.pm blib/lib/Introspector/HTMLGenerator.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/MetaFeature.pm blib/lib/Introspector/MetaFeature.pm lib/Introspector/GCC/GCC.pm blib/lib/Introspector/GCC/GCC.pm lib/Introspector/Breaker.pm blib/lib/Introspector/Breaker.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/MetaPackages.pm blib/lib/Introspector/MetaPackages.pm lib/Introspector/GCC/test.pl blib/lib/Introspector/GCC/test.pl}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/SQL/indexes.sql blib/lib/Introspector/database/SQL/indexes.sql lib/Introspector/DYNCALL.PM blib/lib/Introspector/DYNCALL.PM}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/introspector_schema.sql blib/lib/Introspector/database/introspector_schema.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/loadrelationships.sql blib/lib/Introspector/database/loadrelationships.sql lib/Introspector/MetaMethod.pm blib/lib/Introspector/MetaMethod.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/SQL/rundrops.sql blib/lib/Introspector/database/SQL/rundrops.sql lib/Introspector/NodeVisitors.pm blib/lib/Introspector/NodeVisitors.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/SQL/runcreate.sh blib/lib/Introspector/database/SQL/runcreate.sh lib/B/IntrospectorDeparse.pm blib/lib/B/IntrospectorDeparse.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries.pm blib/lib/Introspector/database/queries.pm lib/Introspector/database/SQL/create_indexes.sql blib/lib/Introspector/database/SQL/create_indexes.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/SQL/droptables.sql blib/lib/Introspector/database/SQL/droptables.sql lib/Introspector/database/schema.sql blib/lib/Introspector/database/schema.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/StandardPerlGenerator.pm blib/lib/Introspector/StandardPerlGenerator.pm lib/Introspector/GCC/README blib/lib/Introspector/GCC/README}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/testconn.pl blib/lib/Introspector/database/testconn.pl lib/Introspector/README.txt blib/lib/Introspector/README.txt lib/Introspector/Eval.pm blib/lib/Introspector/Eval.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/gcc/fields.pm blib/lib/Introspector/gcc/fields.pm lib/Introspector/CodeFormatter.pm blib/lib/Introspector/CodeFormatter.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/database/queries/dumptable.cmd blib/lib/Introspector/database/queries/dumptable.cmd lib/Introspector/dynload.pm blib/lib/Introspector/dynload.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/MetaAttribute.pm blib/lib/Introspector/MetaAttribute.pm lib/Introspector/GCC/Changes blib/lib/Introspector/GCC/Changes lib/Introspector/XMLPrinter.pm blib/lib/Introspector/XMLPrinter.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/TranslateClasses.pm blib/lib/Introspector/TranslateClasses.pm lib/Introspector/gcc/noderef.pm blib/lib/Introspector/gcc/noderef.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/JavaGenerator.pm blib/lib/Introspector/JavaGenerator.pm lib/Introspector/database/queries/loadrelationships.sql blib/lib/Introspector/database/queries/loadrelationships.sql}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/DYNLOAD.PM blib/lib/Introspector/DYNLOAD.PM lib/Introspector/MetaPackage.pm blib/lib/Introspector/MetaPackage.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/Redland/Storage.pm blib/lib/Introspector/Redland/Storage.pm lib/Class/Contract.pm blib/lib/Class/Contract.pm lib/Introspector/MetaInheritance.pm blib/lib/Introspector/MetaInheritance.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/ParseGCCXML.pm blib/lib/Introspector/ParseGCCXML.pm lib/Introspector/Repository.pm blib/lib/Introspector/Repository.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(PERLRUNINST) "-MExtUtils::Install" \
	-e "pm_to_blib({qw{lib/Introspector/PerlGenerator.pm blib/lib/Introspector/PerlGenerator.pm}},'$(INST_LIB)/auto','$(PM_FILTER)')"
	@$(TOUCH) $@

# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
