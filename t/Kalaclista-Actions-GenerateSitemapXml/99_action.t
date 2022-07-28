#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use URI;
use YAML::Tiny;
use Path::Tiny qw(tempdir);

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::GenerateSitemapXml;

use Kalaclista::HyperScript qw(h);

sub testfile {
  my $build = shift;

  my $data = {
    title => 'hello, world!',
    date  => "2021-06-01T10:50:35+09:00"
  };

  my $yaml = $build->child('test/test.yaml');
  $yaml->parent->mkpath;
  $yaml->spew( YAML::Tiny::Dump($data) );

  print $yaml->stringify, "\n";
}

sub main {
  my $dirs = Kalaclista::Directory->instance(
    root  => tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ),
    build => 'build',
  );

  my $context = Kalaclista::Context->instance(
    dirs    => $dirs,
    data    => {},
    call    => {},
    query   => {},
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  testfile( $dirs->build_dir->child('contents') );

  Kalaclista::Actions::GenerateSitemapXml->action($context);

  is(
    $dirs->distdir->child('sitemap.xml')->slurp,
    q|<?xml version="1.0" encoding="UTF-8" ?>|
      . h(
      'urlset',
      { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
      h(
        'url',
        h( 'loc',     'https://example.com/test/test/' ),
        h( 'lastmod', '2021-06-01T10:50:35+09:00' )
      )
      )
  );

  done_testing;
}

main;
