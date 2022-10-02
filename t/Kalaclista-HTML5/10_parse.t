#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::HTML5;

sub main {
  my $dom = Kalaclista::HTML5->parse('<p>hi,</p>');

  is( $dom->at('p')->textContent, 'hi,' );

  done_testing;
}

main;
