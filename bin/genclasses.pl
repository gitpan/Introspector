#! /usr/local/bin/perl 
################################################################
#
# MODULE  : genclasses.pl
# The Generator Driver
# 
# Author  : James Michael DuPont
# Copyright James Michael DuPont 2001
# Licence : Perl Artistic Licence 
#
################################################################

=head2

genclasses.pl
copyright mdupont 2001

=cut

use strict;
use warnings;


use CreateClasses;    # Write our class format
use ModifyClasses;
use CrossReference;   # 
use PerlGenerator;    # experimental perl generator, produces code that you can read!
use TranslateClasses; # TRANSLATE THE CLASSES FROM OUR FORMAT TO CLASS CONTRACT


sub main
{
    CreateClasses; # here we add and remove fields and classes to make everything nice!
    
    # here we can override the classes and add functions before they are generated
    CrossReferencePackages;  # calculate the usage
    TranslatePackagesToPerl; # Perl GENERATOR
    1;
}

main;
1;
