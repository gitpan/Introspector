
#  Package node_ids part of the GCC Introspector Project 
#  Copyright James Michael DuPont 2001
#  Licenced under the Perl Artistic Licence
#  Package generated at Thu Nov  8 09:08:24 2001



package introspector::node_ids;



# INHERITS
our @ISA = qw[ introspector::node_base  ];

# USES
use introspector::node_HASH;
use introspector::node_base;
use introspector::node_base;

sub new # simple contructor with no implementation
{
    my $proto = shift;
    my $class = ref($proto) || $proto;    
    my $self = {};
    bless ($self,$class);
    return $self;

}


# MEMBERS
 sub  Getnamed
                {
                          my $self = shift;
                          return  $self->{_named};
                };
sub  Setnamed
                {
		    my $self = shift;
                    my $newval = shift;
		    return  $self->{_named} = $newval;
                };
 

#METHODS

####################################################
#package node_ids;
sub OnUsed # OnUsed
{# package CreateClasses removed
my $self = shift @_;
    my $NodeType = shift @_;
    my $Field = shift @_;
    my $UsedBy = shift @_;
    introspector::node_base::OnUsed $self, $NodeType, $Field, $UsedBy;
    NodeVisitors::VisitIdentifier $self, $NodeType, $Field, $UsedBy;
};


####################################################
#package node_ids;
sub OnFirstVisit # OnFirstVisit
{# package CreateClasses removed
my $self = shift @_;
    NodeVisitors::SeeIdentifier $self;
};


sub  PrintXML
{
  my $self = shift;
  Introspector::XMLPrinter::printObjectXML($self);
};


sub GetAttrs
{
   my $self = shift;
   return $self;
}

sub GetData
{
    my $self = shift;
    return $self;
}

sub test
{
    my $self = shift;
    print 'test introspector::node_ids
'  ;
}

1; # return a true
