#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::WebSite;

sub main {
  my $time = 1648629617;
  my $data = Kalaclista::WebSite::_if_modified_since($time);

  is( $data, "Wed, 30 Mar 2022 08:40:17 GMT" );

  done_testing;
}

main;
