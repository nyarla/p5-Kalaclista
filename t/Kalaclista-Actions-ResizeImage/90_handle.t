#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use YAML::XS;

use Kalaclista::Directory;
use Kalaclista::Actions::ResizeImages;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $assets = $dirs->rootdir->child('t/fixtures/images');
  my $build  = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 );
  my $dist   = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 );

  my $file = $assets->child('test.png');

  my $handle = Kalaclista::Actions::ResizeImages::makeHandle( $assets, $build, $dist );
  $handle->($file);

  ok( $build->child("test.yaml")->is_file );
  is(
    YAML::XS::Load( $build->child("test.yaml")->slurp ),
    {
      origin => {
        width  => 1024,
        height => 1024,
      },
      '1x' => {
        width  => 700,
        height => 700,
      }
    }
  );

  done_testing;
}

main;
