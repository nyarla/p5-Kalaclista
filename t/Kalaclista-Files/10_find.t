#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Files;

sub main {
  map { like( $_, qr{\.pm$} ) } Kalaclista::Files->find( Kalaclista::Path->detect(qr{^t$})->child('lib')->path );

  done_testing;
}

main;
