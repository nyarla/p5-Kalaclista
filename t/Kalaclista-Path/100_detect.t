#!/usr/bin/env perl

use strict;
use warnings;

use File::Spec;

use Test2::V0;

use Kalaclista::Path;

sub main {
  my $rootdir = Kalaclista::Path->detect(qr{^t$});

  ok( -d $rootdir->to_string );

  done_testing;
}

main;
