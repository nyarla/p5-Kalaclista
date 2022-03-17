#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Test;

sub main {
  isa_ok( Kalaclista::Test->distdir, 'Path::Tiny' );
  isa_ok( Kalaclista::Test->rootdir, 'Path::Tiny' );

  is(
    Kalaclista::Test->rootdir->child('dist')->stringify,
    Kalaclista::Test->distdir->stringify,
  );

  done_testing;
}

main;
