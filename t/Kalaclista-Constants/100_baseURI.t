#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Constants;

sub main {
  my $baseURI = Kalaclista::Constants->baseURI('https://example.com');

  isa_ok( $baseURI, 'URI::Fast' );

  is( $baseURI->to_string, 'https://example.com' );

  is( $baseURI, Kalaclista::Constants->baseURI );

  done_testing;
}

main;
