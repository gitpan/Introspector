map {
	print "$_\n";
	my ($id) = /ID(\d+)/;
	if ($id)
	{
	  my $cmd= "sabcmd ./xsl/node.xsl $_  ~/nodes/index/html/ID$1.HTML \n";
	  system $cmd;
	  print $cmd;
	}
    } glob("~/nodes/index/*");
