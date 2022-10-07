#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use URI::Fast;
use Kalaclista::Entry;

use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $href  = URI::Fast->new('https://example.com/foo');
  my $entry = Kalaclista::Entry->new(
    $dirs->rootdir->child('t/fixtures/content/test.md')->stringify,
    $href,
  );

  is( $entry->title,   'hello world' );
  is( $entry->type,    'posts' );
  is( $entry->slug,    'hello' );
  is( $entry->date,    '2022-01-01T00:00:00Z' );
  is( $entry->lastmod, '2023-01-01T00:00:00Z' );

  is( $entry->dom->at('p')->textContent, 'hello, world!' );

  is( $entry->addon('example'), [] );
  is( $entry->addon,            { example => [] } );

  done_testing;
}

main;
