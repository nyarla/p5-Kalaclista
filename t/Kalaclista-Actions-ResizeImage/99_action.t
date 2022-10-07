#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use YAML::XS;
use URI;

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::ResizeImages;

sub main {
  my $dirs = Kalaclista::Directory->instance();
  my $root = $dirs->rootdir;

  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );
  $dirs->tmp( $dirs->root );
  my $png = $dirs->assets_dir->child('images/test.png');
  $png->parent->mkpath;
  $root->child('t/fixtures/images/test.png')->copy($png);

  my $context = Kalaclista::Context->new(
    dirs    => $dirs,
    data    => {},
    call    => {},
    query   => {},
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  Kalaclista::Actions::ResizeImages->action($context);

  ok( $dirs->datadir->child("images/test.yaml")->is_file );
  is(
    YAML::XS::Load( $dirs->datadir->child("images/test.yaml")->slurp ),
    {
      origin => {
        root   => $dirs->distdir->stringify,
        path   => $dirs->distdir->child("images/test.png")->stringify,
        width  => 1024,
        height => 1024,
      },
      '1x' => {
        path   => $dirs->distdir->child("images/test_thumb_1x.png")->stringify,
        width  => 700,
        height => 700,
      }
    }
  );

  done_testing;
}

main;
