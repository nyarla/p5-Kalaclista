#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;
use Kalaclista::Image;

sub main {
  my $fixture =
    Kalaclista::Directory->rootdir->child('t/Kalaclista-Image/fixture.png');

  my $image =
    Kalaclista::Image->new( source => $fixture, outdir => $fixture->parent );
  $image->resize;

  ok( -e $fixture->parent->child('fixture_1x.png')->stringify );
  ok( -e $fixture->parent->child('fixture_2x.png')->stringify );

  done_testing;
}

main;
