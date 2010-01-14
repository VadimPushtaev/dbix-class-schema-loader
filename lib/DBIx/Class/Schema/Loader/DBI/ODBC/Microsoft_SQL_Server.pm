package DBIx::Class::Schema::Loader::DBI::ODBC::Microsoft_SQL_Server;

use strict;
use warnings;
use base 'DBIx::Class::Schema::Loader::DBI::MSSQL';
use Carp::Clan qw/^DBIx::Class/;
use Class::C3;

our $VERSION = '0.04999_14';

=head1 NAME

DBIx::Class::Schema::Loader::DBI::ODBC::Microsoft_SQL_Server - ODBC wrapper for
L<DBIx::Class::Schema::Loader::DBI::MSSQL>

=head1 DESCRIPTION

Proxy for L<DBIx::Class::Schema::Loader::DBI::MSSQL> when using L<DBD::ODBC>.

See L<DBIx::Class::Schema::Loader::Base> for usage information.

=cut

sub _tables_list { 
    my $self = shift;

    return $self->next::method(undef, undef);
}

=head1 SEE ALSO

L<DBIx::Class::Schema::Loader::DBI::MSSQL>,
L<DBIx::Class::Schema::Loader>, L<DBIx::Class::Schema::Loader::Base>,
L<DBIx::Class::Schema::Loader::DBI>

=head1 AUTHOR

See L<DBIx::Class::Schema::Loader/AUTHOR> and L<DBIx::Class::Schema::Loader/CONTRIBUTORS>.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
