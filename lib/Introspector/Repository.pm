package Repository;
sub new
{
    my $class = shift;

#  0  'NeededBy'
#  1  'Needs'

#  2  '_types'

#  3  'base_class'
#  4  'baseclass'


#  5  'basepackage'
#  19  'rootclass'



#  6  'debug'
#  7  'done'


#  8  'event_types'
#  9  'eventhandler'



#  11  'identifiers'
#  12  'links'
#  13  'maxweight'
#  14  'newnodes'
#  15  'nodes'
#  16  'package'# NUL
#  17  'program'# NUL
#  18  'rels'   # NUL

#  20  'seen'   ### EMPTY
#  21  'self'   ### used by parser
#  22  'tovisit'### EMPTY

#  23  'type'   ### EMPTY
#  10  'fields'
#  24  'types'

###################
#  25  'usage'
#  26  'use'    ### EMPTY
#  27  'used'
#  28  'users'  ### EMPTY
#  29  'uses'   ### EMPTY

#  30  'version'
#  31  'visit'
#  32  'waiting'
#  33  'weights'

    my $self = {
	version => 1,
	debug   => 0,

# from intrspctr.	
	# weights
	weights => {}, # the type of node, and the weight of it
	maxweight => 10000,  # the largest weight
	links     => {}, # from to node
	seen      => {}, # list of nodes seen
	rels      => {}, # the relationships

# from gcc 
	nodes => {},
	users=> {},		# relationship id uses    id 
	used=> {},			# relationship id used by id 
	tovisit=> {},
	types=> {},
	fields=> {},
	self=> {},			# this is created by the individual function calls,

# from metainfo
    identifiers =>{},  # ID
    type        =>{},  # Type -> ID 
    program     => "",
    visit       =>{} , # group members

##############################################################
# this is like a mutex!
# if something needs something
# then we might have to wait for it or go and get it.
    Needs=>{},
    NeededBy=>{}, # the reverse relationship


	};
    bless $self,$class;
    return $self;
};

1;
