#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;
use Kalaclista::Utils qw( make_href );

use URI;

sub main {
  my $baseURI = URI->new('https://example.com');

  my @tests = (
    [ '/path/to/file', 'https://example.com/path/to/file/' ],
    [ 'path/to/index', 'https://example.com/path/to/' ]
  );

  for my $test (@tests) {
    is( make_href( $test->[0], $baseURI ), $test->[1] );
  }

  done_testing;
}

main;
