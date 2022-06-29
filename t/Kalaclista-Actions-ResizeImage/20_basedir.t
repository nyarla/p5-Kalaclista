#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Actions::ResizeImages;

sub main {
  my $path   = "/path/to/foo/bar";
  my $prefix = "/path/to";

  is( Kalaclista::Actions::ResizeImages::basedir( $path, $prefix ), "/foo" );

  done_testing;
}

main;
