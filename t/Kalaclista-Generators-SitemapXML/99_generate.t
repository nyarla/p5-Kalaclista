#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Text::HyperScript qw(h);

use Kalaclista::Constants;
use Kalaclista::Entries;

use Kalaclista::Generators::SitemapXML;

sub main {
  Kalaclista::Constants->baseURI('https://example.com');
  my $root    = Kalaclista::Constants->rootdir(qr{^t$});
  my $entries = Kalaclista::Entries->instance( $root->child('t/fixtures/content')->path );

  my $file = Kalaclista::Path->tempfile;

  Kalaclista::Generators::SitemapXML->generate( file => $file, entries => $entries );

  is(
    $file->get,
    q|<?xml version="1.0" encoding="UTF-8"?>| . h(
      urlset => { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
      [
        h(
          url => [
            h( loc     => 'https://example.com/test/' ),
            h( lastmod => q{2023-01-01T00:00:00Z} )
          ]
        )
      ]
    ),
  );

  done_testing;
}

main;
