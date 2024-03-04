#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Text::HyperScript qw(h);

use Kalaclista::Context;
use Kalaclista::Data::Entry;

use Kalaclista::Generators::SitemapXML;

sub main {
  my $c = Kalaclista::Context->init(
    baseURI => URI::Fast->new("https://example.com"),
    dirs    => {
      detect => qr{^t$},
    },
  );

  my $entries = [
    Kalaclista::Data::Entry->new(
      title   => '',
      summary => '',
      section => '',
      date    => '2023-01-01T00:00:00Z',
      lastmod => '2023-01-01T00:00:00Z',
      href    => URI::Fast->new('https://example.com/baz'),
    ),
    Kalaclista::Data::Entry->new(
      title   => '',
      summary => '',
      section => '',
      date    => '2023-01-01T00:00:00Z',
      lastmod => '2023-02-01T00:00:00Z',
      href    => URI::Fast->new('https://example.com/bar'),
    ),
    Kalaclista::Data::Entry->new(
      title   => '',
      summary => '',
      section => '',
      date    => '2023-01-01T00:00:00Z',
      lastmod => '2023-03-01T00:00:00Z',
      href    => URI::Fast->new('https://example.com/foo'),
    )
  ];

  my $file = Kalaclista::Path->tempfile;

  Kalaclista::Generators::SitemapXML->generate( dist => $file, entries => $entries );

  is(
    $file->load,
    q|<?xml version="1.0" encoding="UTF-8" ?>| . h(
      urlset => { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
      [
        h(
          url => [
            h( loc     => 'https://example.com/foo' ),
            h( lastmod => q{2023-03-01T00:00:00Z} )
          ]
        ),
        h(
          url => [
            h( loc     => 'https://example.com/bar' ),
            h( lastmod => q{2023-02-01T00:00:00Z} )
          ]
        ),
        h(
          url => [
            h( loc     => 'https://example.com/baz' ),
            h( lastmod => q{2023-01-01T00:00:00Z} )
          ]
        )
      ]
    ),
  );

  done_testing;
}

main;
