#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::WebSite;

sub main {
  my $href    = "https://the.kalaclista.com/";
  my $website = Kalaclista::WebSite->new( href => $href );

  $website->fetch;

  ok( $website->title ne q{} );
  ok( $website->summary ne q{} );

  done_testing;
}

main;
