package TestSchemaBaseClass;
use base DBIx::Class::Schema;

our $test_ok = 0;

sub connection {
    my ($self, @info) = @_;

    if ($info[0] =~ /^dbi/) {
        $test_ok = 1;
    }

    return $self->next::method(@info);
}

1;
