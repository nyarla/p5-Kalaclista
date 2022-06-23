#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Shop::Amazon;

sub main {
  my $item = Kalaclista::Shop::Amazon->new(
    asin => 'XXXXXXXXXX',
    tag  => 'example-22',
  );

  is( $item->link, 'https://www.amazon.co.jp/dp/XXXXXXXXXX?tag=example-22', );

  is(
    $item->image,
"https://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=XXXXXXXXXX&Format=_SL160_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=example-22&language=ja_JP",
  );

  is( $item->beacon,
"https://ir-jp.amazon-adsystem.com/e/ir?t=example-22&language=ja_JP&l=li2&o=9&a=XXXXXXXXXX"
  );

  done_testing;
}

main;
