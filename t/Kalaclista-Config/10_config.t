#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Config;

Kalaclista::Config->instance(
  data => {
    test => {
      hello => 'world',
    },
  }
);

sub main {
  my $config = Kalaclista::Config->instance;

  isa_ok( $config, 'Kalaclista::Config' );

  is( $config->section('test')->{'hello'}, 'world' );

  done_testing;
}

main;