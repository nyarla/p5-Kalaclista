#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Actions::ResizeImages;

sub main {
  ok( Kalaclista::Actions::ResizeImages::is_supported("test.jpg") );
  ok( !Kalaclista::Actions::ResizeImages::is_supported("test.gif") );

  done_testing;
}

main;
