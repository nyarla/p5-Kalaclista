#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Shop::Rakuten;

use URI::Escape qw(uri_escape_utf8);

sub main {
  my $item =
    Kalaclista::Shop::Rakuten->new( shop => 'https://example.com/shop/item', );

  is( $item->link, 'https://example.com/shop/item' );

  $item = Kalaclista::Shop::Rakuten->new( search => 'foo bar', );

  my $query = "https://search.rakuten.co.jp/search/mall/foo+bar/";
  my $href =
    "https://hb.afl.rakuten.co.jp/hgc/0d591c80.1e6947ee.197d1bf7.7a323c41/?pc=";
  $href .= uri_escape_utf8($query);
  $href .=
    "&link_type=text&ut=eyJwYWdlIjoidXJsIiwidHlwZSI6InRleHQiLCJjb2wiOjF9";

  is( $item->link, $href );

  done_testing;
}

main;
