#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Text::HyperScript qw(h);

use Kalaclista::Context;
use Kalaclista::Entries;

use Kalaclista::Generators::SitemapXML;

sub main {
  my $c = Kalaclista::Context->init(
    baseURI => URI::Fast->new("https://example.com"),
    dirs    => {
      detect => qr{^t$},
    },
  );

  my $entries = Kalaclista::Entries->lookup( $c->dirs->rootdir->child('fixtures/content')->path );
  my $file    = Kalaclista::Path->tempfile;

  for ( $entries->@* ) {
    $_->load if !$_->loaded;
    $_->href( URI::Fast->new("https://example.com/test/") );
  }

  Kalaclista::Generators::SitemapXML->generate( dist => $file, entries => $entries );

  is(
    $file->get,
    q|<?xml version="1.0" encoding="UTF-8" ?>| . h(
      urlset => { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
      [
        h(
          url => [
            h( loc     => 'https://example.com/test/' ),
            h( lastmod => q{2023-01-01T00:00:00Z} )
          ]
        ),
        h(
          url => [
            h( loc     => 'https://example.com/test/' ),
            h( lastmod => q{2023-01-01T00:00:00Z} )
          ]
        ),
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
