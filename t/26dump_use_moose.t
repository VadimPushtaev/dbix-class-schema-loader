use warnings;
use strict;

use Test::More;
use DBIx::Class::Schema::Loader::Optional::Dependencies ();
BEGIN {
  use DBIx::Class::Schema::Loader::Optional::Dependencies ();
  plan skip_all => 'Tests needs ' . DBIx::Class::Schema::Loader::Optional::Dependencies->req_missing_for('use_moose')
    unless (DBIx::Class::Schema::Loader::Optional::Dependencies->req_ok_for('use_moose'));
}

use lib qw(t/lib);
use dbixcsl_dumper_tests;
my $t = 'dbixcsl_dumper_tests';

$t->cleanup;

# first dump a fresh use_moose=1 schema
$t->dump_test(
  classname => 'DBICTest::DumpMore::1',
  options => {
    use_moose => 1,
    result_base_class => 'My::ResultBaseClass',
    schema_base_class => 'My::SchemaBaseClass',
  },
  warnings => [
    qr/Dumping manual schema for DBICTest::DumpMore::1 to directory /,
    qr/Schema dump completed/,
  ],
  regexes => {
    schema => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::SchemaBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
    Foo => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::ResultBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
    Bar => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::ResultBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
  },
);

$t->cleanup;

# now upgrade a fresh non-moose schema to use_moose=1
$t->dump_test(
  classname => 'DBICTest::DumpMore::1',
  options => {
    result_base_class => 'My::ResultBaseClass',
    schema_base_class => 'My::SchemaBaseClass',
  },
  warnings => [
    qr/Dumping manual schema for DBICTest::DumpMore::1 to directory /,
    qr/Schema dump completed/,
  ],
  regexes => {
    schema => [
      qr/\nuse base 'My::SchemaBaseClass';\n/,
    ],
    Foo => [
      qr/\nuse base 'My::ResultBaseClass';\n/,
    ],
    Bar => [
      qr/\nuse base 'My::ResultBaseClass';\n/,
    ],
  },
);

# check that changed custom content is upgraded for Moose bits
$t->append_to_class('DBICTest::DumpMore::1::Foo', q{# XXX This is my custom content XXX});

$t->dump_test(
  classname => 'DBICTest::DumpMore::1',
  options => {
    use_moose => 1,
    result_base_class => 'My::ResultBaseClass',
    schema_base_class => 'My::SchemaBaseClass',
  },
  warnings => [
    qr/Dumping manual schema for DBICTest::DumpMore::1 to directory /,
    qr/Schema dump completed/,
  ],
  regexes => {
    schema => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::SchemaBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
    Foo => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::ResultBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
    Bar => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::ResultBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
  },
);

$t->cleanup;

# now add the Moose custom content to unapgraded schema, and make sure it is not repeated
$t->dump_test(
  classname => 'DBICTest::DumpMore::1',
  options => {
    result_base_class => 'My::ResultBaseClass',
    schema_base_class => 'My::SchemaBaseClass',
  },
  warnings => [
    qr/Dumping manual schema for DBICTest::DumpMore::1 to directory /,
    qr/Schema dump completed/,
  ],
  regexes => {
    schema => [
      qr/\nuse base 'My::SchemaBaseClass';\n/,
    ],
    Foo => [
      qr/\nuse base 'My::ResultBaseClass';\n/,
    ],
    Bar => [
      qr/\nuse base 'My::ResultBaseClass';\n/,
    ],
  },
);

# add Moose custom content then check it is not repeated

$t->append_to_class('DBICTest::DumpMore::1::Foo', qq{__PACKAGE__->meta->make_immutable;\n1;\n});

$t->dump_test(
  classname => 'DBICTest::DumpMore::1',
  options => {
    use_moose => 1,
    result_base_class => 'My::ResultBaseClass',
    schema_base_class => 'My::SchemaBaseClass',
  },
  warnings => [
    qr/Dumping manual schema for DBICTest::DumpMore::1 to directory /,
    qr/Schema dump completed/,
  ],
  regexes => {
    schema => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::SchemaBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
    Foo => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::ResultBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
    Bar => [
      qr/\nuse Moose;\nuse MooseX::NonMoose;\nuse namespace::autoclean;\nextends 'My::ResultBaseClass';\n\n/,
      qr/\n__PACKAGE__->meta->make_immutable;\n1;(?!\n1;\n)\n.*/,
    ],
  },
  neg_regexes => {
    Foo => [
      qr/\n__PACKAGE__->meta->make_immutable;\n.*\n__PACKAGE__->meta->make_immutable;/s,
    ],
  },
);

done_testing;