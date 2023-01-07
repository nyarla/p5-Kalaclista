#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Generators::WebP;
use Kalaclista::Path;

my $tempdir = Kalaclista::Path->tempdir;
$tempdir->temporary(0);

sub main {
  my $rootdir = Kalaclista::Path->detect(qr{^t$})->child('t/fixtures');

  my $distdir = $tempdir->child('dist');
  my $datadir = $tempdir->child('data');

  Kalaclista::Generators::WebP->generate(
    images  => $rootdir->child('images'),
    distdir => $distdir,
    datadir => $datadir,
    scales  => [
      [ '1x', 700 ],
      [ '2x', 1400 ],
    ],
  );

  ok( -f $distdir->child('test_1x.webp')->path );

  is(
    YAML::XS::LoadFile( $datadir->child('test.yaml')->path ),
    {
      src  => { width => 1024, height => 1024, },
      '1x' => { width => 700,  height => 700, },
      '2x' => { width => 1024, height => 1024, },
    },
  );

  $tempdir->cleanup;

  done_testing;
}

main;
