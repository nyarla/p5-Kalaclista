#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Constants qw(linkify);

sub production {
  my $path = "/nyarla/";
  my $uri  = linkify( $path, 1 );

  is( $uri->as_string, 'https://the.kalaclista.com/nyarla/' );

}

sub development {
  my $path = "/nyarla/";
  my $uri  = linkify( $path, 0 );

  is( $uri->as_string, 'http://nixos:1313/nyarla/' );

}

sub main {
  production;
  development;

  done_testing;
}

main;
