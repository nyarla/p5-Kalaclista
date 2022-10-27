#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use URI::Fast;

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::GenerateAssets;

sub main {
  my $dirs = Kalaclista::Directory->instance( tmp => tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );
  $dirs->root( $dirs->rootdir->child('t/fixtures') );

  my $context = Kalaclista::Context->instance(
    dirs  => $dirs,
    data  => {},
    call  => {},
    query => {
      assets => sub {
        return ( 'assets.out' => 'assets.pl' );
      },
    },
    baseURI => URI::Fast->new('https://example.com'),
    threads => 1,
  );

  Kalaclista::Actions::GenerateAssets->action($context);

  is( $dirs->distdir->child('assets.out')->slurp, 'hi,' );

  done_testing;
}

main;
