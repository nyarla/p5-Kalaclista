#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use URI;
use YAML::XS;
use Path::Tiny qw(tempdir);

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Actions::GenerateSitemapXml;

use Text::HyperScript qw(h);

sub main {
  my $dirs = Kalaclista::Directory->instance(
    content => 't/fixtures/content',
  );

  my $context = Kalaclista::Context->instance(
    dirs    => $dirs,
    data    => {},
    call    => {},
    query   => {},
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  Kalaclista::Actions::GenerateSitemapXml->action($context);

  is(
    $dirs->distdir->child('sitemap.xml')->slurp,
    q|<?xml version="1.0" encoding="UTF-8" ?>| . h(
      'urlset',
      { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
      h(
        'url',
        h( 'loc',     'https://example.com/test/' ),
        h( 'lastmod', '2023-01-01T00:00:00Z' )
      )
    )
  );

  done_testing;
}

main;
