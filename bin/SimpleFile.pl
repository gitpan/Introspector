use LoadNodes;
use MetaPackage;
$filename = "test_tree.pl" unless $filename; # the name of the perl file to read in
 LoadNodes::LoadNodes(
		      $filename, # incrementally load the nodes
		      sub {
			  print join ",",@_;
		      }
);
;
