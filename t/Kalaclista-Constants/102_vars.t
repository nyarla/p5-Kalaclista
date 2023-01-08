#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Constants;

sub main {
  my $vars = Kalaclista::Constants->vars(
    {
      is_production => 1,
    }
  );

  isa_ok( $vars, 'Kalaclista::Variables' );

  ok( $vars->is_production );
  is( $vars, Kalaclista::Constants->vars );

  done_testing;
}

main;
