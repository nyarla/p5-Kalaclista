#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::HyperScript qw(raw p);

sub main {
  is( p('hello, world!'),  '<p>hello, world!</p>' );
  is( raw('<hi>')->markup, "<hi>" );

  done_testing;
}

main;
