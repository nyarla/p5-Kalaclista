#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Directory;

sub main {
  isa_ok( Kalaclista::Directory->distdir, 'Path::Tiny' );
  isa_ok( Kalaclista::Directory->rootdir, 'Path::Tiny' );

  is(
    Kalaclista::Directory->rootdir->child('dist')->stringify,
    Kalaclista::Directory->distdir->stringify,
  );

  done_testing;
}

main;
