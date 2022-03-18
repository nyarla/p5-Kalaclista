#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Constants qw(linkify);

sub main {
  my $path = "/nyarla/";
  my $uri  = linkify( $path, 1 );

  is( $uri->as_string, 'https://the.kalaclista.com/nyarla/' );

  done_testing;
}

main;
