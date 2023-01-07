#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use YAML::XS;

use Kalaclista::Path;
use Kalaclista::Generators::WebP;

sub main {
  my $rootdir = Kalaclista::Path->detect(qr{^t$});
  my $tempdir = Kalaclista::Path->tempdir;

  my $src  = $rootdir->child('t/fixtures/images/test.png');
  my $dest = $tempdir->child('images/image');

  $dest->parent->mkpath;

  my $scales = [
    [ '1x' => 700 ],
    [ '2x' => 1400 ],
  ];

  my $meta = $tempdir->child('meta.yaml');

  Kalaclista::Generators::WebP::resize( $meta->path, $src->path, $dest->path, $scales );

  is(
    YAML::XS::LoadFile( $meta->path ), {
      src => {
        width  => 1024,
        height => 1024,
      },
      '1x' => {
        width  => 700,
        height => 700,
      },
      '2x' => {
        width  => 1024,
        height => 1024,
      },
    }
  );

  ok( -f $tempdir->child('images/image_1x.webp')->path );

  done_testing;
}

main;
