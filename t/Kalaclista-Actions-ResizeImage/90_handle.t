#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use YAML::Tiny;

use Kalaclista::Directory;
use Kalaclista::Actions::ResizeImages;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $assets = $dirs->rootdir->child('t/fixtures/images');
  my $build  = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 );
  my $dist   = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 );

  my $file = $assets->child('test.png');

  my $handle =
    Kalaclista::Actions::ResizeImages::makeHandle( $assets, $build, $dist );
  $handle->($file);

  ok( $build->child("test.yaml")->is_file );
  is(
    YAML::Tiny::Load( $build->child("test.yaml")->slurp ),
    {
      origin => {
        root   => $dist->stringify,
        path   => $dist->child("@{[ $file->basename ]}")->stringify,
        width  => 1024,
        height => 1024,
      },
      '1x' => {
        path =>
          $dist->child("@{[ $file->basename(qr<\.[^.]+$>) ]}_thumb_1x.png")
          ->stringify,
        width  => 700,
        height => 700,
      }
    }
  );

  done_testing;
}

main;
