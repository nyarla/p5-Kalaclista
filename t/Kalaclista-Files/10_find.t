#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Directory;
use Kalaclista::Files;

my $dirs = Kalaclista::Directory->instance;

sub main {
  map { like( $_, qr{\.pm$} ) }
    Kalaclista::Files->find( $dirs->rootdir->child('lib')->stringify );

  done_testing;
}

main;
