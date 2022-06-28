#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Entry::Meta;
use Kalaclista::Directory;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $meta = Kalaclista::Entry::Meta->load(
    src  => $dirs->rootdir->child('t/fixtures/build/test.yaml')->stringify,
    href => 'https://example.com/test',
  );

  is( ref $meta->href,        'URI::https' );
  is( $meta->href->as_string, 'https://example.com/test' );

  is( $meta->title,   'test' );
  is( $meta->type,    'home' );
  is( $meta->slug,    '' );
  is( $meta->date,    '2021-06-01T10:50:35+09:00' );
  is( $meta->lastmod, '2021-06-01T10:50:35+09:00' );

  done_testing;
}

main;
