#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use URI::Fast;
use Kalaclista::Entry;
use Kalaclista::Path;

sub main {
  my $root = Kalaclista::Path->detect(qr{^t$});

  my $href  = URI::Fast->new('https://example.com/foo');
  my $entry = Kalaclista::Entry->new(
    $root->child('t/fixtures/content/test.md')->path,
    $href,
  );

  is( $entry->title,   'hello world' );
  is( $entry->type,    'posts' );
  is( $entry->slug,    'hello' );
  is( $entry->date,    '2022-01-01T00:00:00Z' );
  is( $entry->lastmod, '2023-01-01T00:00:00Z' );

  is( $entry->dom->at('p')->textContent, 'hello, world!' );

  is( $entry->addon( foo => 'bar' ), q{bar} );
  is( $entry->addon('foo'),          'bar' );

  done_testing;
}

main;
