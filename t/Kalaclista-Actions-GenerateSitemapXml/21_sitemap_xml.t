#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);

use Kalaclista::Directory;
use Kalaclista::Actions::GenerateSitemapXml;
use Text::HyperScript q(h);

sub main {
  my $dirs = Kalaclista::Directory->instance(
    root => tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );
  my $dist = $dirs->build_dir->child('sitemap.xml');
  $dist->parent->mkpath;

  my $sitemap = Kalaclista::Actions::GenerateSitemapXml::makeSitemapXML($dist);
  my @meta    = (
    Kalaclista::Entry::Meta->new(
      href    => URI->new('https://example.com/foo'),
      lastmod => 10,
    ),
    Kalaclista::Entry::Meta->new(
      href => URI->new('https://example.com/bar'),
    ),
  );
  my $result = q|<?xml version="1.0" encoding="UTF-8" ?>|
    . h(
    'urlset',
    { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
    h( 'url', h( 'loc', "https://example.com/foo" ), h( "lastmod", 10 ) ),
    h( 'url', h( 'loc', "https://example.com/bar" ), h( "lastmod", 10 ) ),
    );

  $sitemap->(@meta);

  is( $dist->slurp, $result, );

  done_testing;
}

main;
