#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Entries;

my $fixtures = Kalaclista::Path->detect(qr{^t$})->child('fixtures/content');

sub path    { $_[0]->path->path }
sub fixture { $fixtures->child( $_[0] )->path }

subtest filter => sub {
  my $entries = Kalaclista::Entries->lookup(
    $fixtures->path,
  );

  is(
    [ path( $entries->[0] ), path( $entries->[1] ), path( $entries->[2] ) ],
    [ fixture("test.md"),    fixture("test2.md"),   fixture("test3.md") ]
  );

  $entries = Kalaclista::Entries->lookup(
    $fixtures->path,
    filter => sub { $_ !~ m{test2\.md$} },
  );

  is(
    [ path( $entries->[0] ), path( $entries->[1] ) ],
    [ fixture("test.md"),    fixture("test3.md") ]
  );
};

subtest fixup => sub {
  my $entries = Kalaclista::Entries->lookup(
    $fixtures->path,
    fixup => sub { $_[0]->href('https://example.com') },
  );

  for my $entry ( $entries->@* ) {
    isa_ok $entry->href, 'URI::Fast';
  }
};

subtest sort => sub {
  my $entries = Kalaclista::Entries->lookup(
    $fixtures->path,
  );

  is(
    [ path( $entries->[0] ), path( $entries->[1] ), path( $entries->[2] ) ],
    [ fixture('test.md'),    fixture('test2.md'),   fixture('test3.md') ],
  );

  $entries = Kalaclista::Entries->lookup(
    $fixtures->path,
    sort => sub { $_[1]->path->path cmp $_[0]->path->path },
  );

  is(
    [ path( $entries->[0] ), path( $entries->[1] ), path( $entries->[2] ) ],
    [ fixture('test3.md'),   fixture('test2.md'),   fixture('test.md') ],
  );
};

done_testing;
