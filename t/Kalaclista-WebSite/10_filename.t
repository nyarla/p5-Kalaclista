#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::WebSite;

sub main {
  my $data = Kalaclista::WebSite->new( href => 'https://the.kalaclista.com' );

  is( $data->filename, 'the_kalaclista_com/index' );

  done_testing;
}

main;
