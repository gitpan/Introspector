use ExtUtils::MakeMaker;
#    ExtUtils::Manifest::manicheck;
#    ExtUtils::Manifest::filecheck;
#    ExtUtils::Manifest::fullcheck;
#    ExtUtils::Manifest::skipcheck;
#    ExtUtils::Manifest::manifind();
#    ExtUtils::Manifest::maniread($file);
#    ExtUtils::Manifest::manicopy($read,$target,$how);
#BINARY_LOCATION=>qw[x86/introspector.tar.gz],

WriteMakefile( 
	       NAME => "Introspector" ,
	       ABSTRACT_FROM => q[Introspector.pm],
	       AUTHOR => q[James Michael DuPont <mdupont777@yahoo.com>],
	       VERSION_FROM => './Introspector.pm',
	       EXE_FILES => [
			     "./bin/intrspctr.pl"
			     ]
	       );


