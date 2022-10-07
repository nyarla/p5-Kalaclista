#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use URI;

use Kalaclista::Directory;
use Kalaclista::Entries;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $rootdir = $dirs->rootdir->child('t/fixtures/content')->stringify;
  my $baseURI = URI->new('https://example.com');

  my $loader = Kalaclista::Entries->new( $rootdir, $baseURI );
  my $entry  = $loader->entries->[0];

  is( $entry->href->as_string, 'https://example.com/test/' );

  $loader->fixup(
    sub {
      my $entry = shift;

      isa_ok( $entry, 'Kalaclista::Entry' );
    }
  );

  done_testing;
}

main;
