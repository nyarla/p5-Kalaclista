#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI::Fast;
use Text::HyperScript qw(h);

use Kalaclista::Generators::SitemapXML;
use Kalaclista::Data::Entry;

use YAML::XS;

sub main {
  my @entries;
  for my $path (qw(foo bar)) {
    my $entry = Kalaclista::Data::Entry->new(
      title   => '',
      summary => '',
      section => '',
      date    => '2022-01-01T00:00:00+09:00',
      lastmod => ( $path eq 'foo' ? '2023-01-01T00:00:00+09:00' : '2022-01-01T00:00:00+09:00' ),
      href    => URI::Fast->new( 'https://example.com/' . $path ),
    );

    push @entries, $entry;
  }

  my $xml = Kalaclista::Generators::SitemapXML::xmlize( [@entries] );

  is(
    $xml,
    q|<?xml version="1.0" encoding="UTF-8" ?>| . h(
      urlset => { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
      h(
        url => [
          h( loc => 'https://example.com/foo' ),
          h( 'lastmod', '2023-01-01T00:00:00+09:00' )
        ],
      ),
      h(
        url => [
          h( loc     => 'https://example.com/bar' ),
          h( lastmod => '2022-01-01T00:00:00+09:00' )
        ],
      ),
    )
  );

  done_testing;
}

main;
