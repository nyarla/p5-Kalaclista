#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Generators::WebP;
use Kalaclista::Path;

sub main {
  my $rootdir = Kalaclista::Path->detect(qr{^t$})->child('t/fixtures');
  my $distdir = $rootdir->child('dist');

  Kalaclista::Generators::WebP->generate(
    images  => $rootdir->child('images'),
    distdir => $distdir->child('images'),
    datadir => $distdir->child('data'),
    scales  => [
      [ '1x', 700 ],
      [ '2x', 1400 ],
    ],
  );

  ok( -f $distdir->child('images/test_1x.webp')->path );

  is(
    YAML::XS::LoadFile( $distdir->child('images/test.yaml')->path ),
    {
      src  => { width => 1024, height => 1024, },
      '1x' => { width => 700,  height => 700, },
    },
  );

  $distdir->child('images/test_1x.webp')->remove;
  $distdir->child('images/test.yaml')->remove;
  $distdir->child('images')->remove;

  done_testing;
}

main;
