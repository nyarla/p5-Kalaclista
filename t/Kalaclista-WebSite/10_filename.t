#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::WebSite;

sub main {
  my $title    = "https://example.com/title/『今日』から始めるブログ講座 vol.1";
  my $filename = "/title/_今日_から始めるブログ講座_vol_1.yaml";

  is( Kalaclista::WebSite::_filename($title), $filename, );

  done_testing;
}

main;
