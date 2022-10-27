#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);

use Kalaclista::Directory;
use Kalaclista::Actions::ResizeImages;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $dist = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 )->child("test.png");

  my $src = Image::Scale->new( $dirs->rootdir->child('t/fixtures/images/test.png')->stringify );

  my $x1 = 700;

  Kalaclista::Actions::ResizeImages::resize( $dist, $src, $x1 );

  ok( $dist->is_file );

  done_testing;
}

main;
