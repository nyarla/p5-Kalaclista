#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Config::Kalaclista qw(dirs);

sub main {
  isa_ok( dirs->rootdir,     'Path::Tiny' );
  isa_ok( dirs->distdir,     'Path::Tiny' );
  isa_ok( dirs->datadir,     'Path::Tiny' );
  isa_ok( dirs->assets_dir,  'Path::Tiny' );
  isa_ok( dirs->content_dir, 'Path::Tiny' );

  done_testing;
}

main;
