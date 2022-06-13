#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;

sub main {
  my $dirs = Kalaclista::Directory->instance;

  isa_ok( $dirs->rootdir,       'Path::Tiny' );
  isa_ok( $dirs->distdir,       'Path::Tiny' );
  isa_ok( $dirs->datadir,       'Path::Tiny' );
  isa_ok( $dirs->assets_dir,    'Path::Tiny' );
  isa_ok( $dirs->content_dir,   'Path::Tiny' );
  isa_ok( $dirs->templates_dir, 'Path::Tiny' );
  isa_ok( $dirs->build_dir,     'Path::Tiny' );

  done_testing;
}

main;
