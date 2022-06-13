#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::HyperScript::More;
use Kalaclista::HyperScript qw( head body );

use JSON::Tiny qw( encode_json );

sub main {
  is( document( head(""), body(""), ),
    q|<!doctype html><html lang="ja"><head></head><body></body></html>| );

  is(
    feed( "foo", "https://example.com/feed.xml", "application/rss+xml" ),
q|<link href="https://example.com/feed.xml" rel="alternate" title="foo" type="application/rss+xml" />|
  );

  is( property( "foo", "bar" ), q|<meta content="bar" property="foo" />| );

  is( data_( "foo", "bar" ), q|<meta content="bar" name="foo" />|, );

  my $jsonld = encode_json(
    [
      {
        '@context' => 'https://schema.org',
        '@id'      => 'https://example.com/foo',
        '@type'    => 'WebSite',
        headline   => 'Example',
        author     => {},
        publisher  => {},
        image      => {
          '@type' => 'URL',
          'url'   => 'https://example.com/image.svg',
        },
        mainEntryOfPage => { '@id' => 'https://example.com' },
      },
      {
        '@context'        => 'https://schema.org',
        '@type'           => 'BreadcrumbList',
        'itemListElement' => [
          {
            '@type'  => 'ListItem',
            'item'   => 'https://example.com/foo',
            name     => 'Example',
            position => 1
          }
        ],
      }
    ]
  );
  $jsonld =~ s{\\/}{/}g;

  is(
    jsonld(
      {
        href      => 'https://example.com/foo',
        type      => 'WebSite',
        title     => 'Example',
        author    => {},
        publisher => {},
        image     => 'https://example.com/image.svg',
        parent    => 'https://example.com'
      },
      {
        name => 'Example',
        href => 'https://example.com/foo'
      }
    ),
    $jsonld
  );

  done_testing;
}

main;
