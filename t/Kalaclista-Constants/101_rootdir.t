#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Constants;

sub main {
  my $rootdir = Kalaclista::Constants->rootdir(qr{^t$});

  isa_ok( $rootdir, 'Kalaclista::Path' );

  ok( $rootdir->path ne q{} );
  is( $rootdir, Kalaclista::Constants->rootdir );

  done_testing;
}

main;
