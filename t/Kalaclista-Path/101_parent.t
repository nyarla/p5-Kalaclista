#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;

sub main {
  my $rootdir = Kalaclista::Path->detect(qr{^t$});
  my $child   = $rootdir->child('t/Kalaclista-Path');

  ok( -d $child->path );
  is( $child->parent->path, $rootdir->child('t')->to_string );

  done_testing;
}

main;
