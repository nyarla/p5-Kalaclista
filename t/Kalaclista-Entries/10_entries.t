#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Constants;
use Kalaclista::Entries;

sub init {
  Kalaclista::Constants->baseURI('https://example.com');
  Kalaclista::Constants->rootdir(qr{^t$});
}

sub main {
  my $entries = Kalaclista::Entries->instance( Kalaclista::Constants->rootdir->child('t/fixtures/content')->path );
  my $entry   = $entries->entries->[0];

  $entries->fixup(
    sub {
      my $entry = shift;

      isa_ok( $entry, 'Kalaclista::Entry' );
    }
  );

  is( $entry->href->to_string, 'https://example.com/test/' );

  done_testing;
}

init;
main;
