#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Actions::ResizeImages;

sub main {
  ok( Kalaclista::Actions::ResizeImages::is_resized("test_thumb_1x.png") );
  ok( !Kalaclista::Actions::ResizeImages::is_resized("test.png") );

  done_testing;
}

main;
