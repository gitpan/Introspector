package Introspector::dyncall;

sub methodcall
{
    my $object = shift;
    my $method = shift;
    # @_ are the params
    return $object->$method(@_);
}

1;
