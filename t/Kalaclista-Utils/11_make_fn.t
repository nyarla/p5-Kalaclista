#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Utils qw( make_fn );

sub main {
  my @tests = (
    [ 'path/to/file.md', 'path/to', 'file' ],
    [ 'path/to/_index',  'path',    'to/index' ],
  );

  for my $test (@tests) {
    is( make_fn( $test->[0], $test->[1] ), $test->[2] );
  }

  done_testing;
}

main;
