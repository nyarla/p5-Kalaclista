#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::HyperScript qw(document head body classes);

sub main {
  is(
    document( head(""), body(""), ),
    q|<!DOCTYPE html><html lang="ja"><head></head><body></body></html>|
  );

  is classes( qw|aaa bbb ccc|, q|ddd eee fff| ), { class => 'aaa bbb ccc ddd eee fff' };

  done_testing;
}

main;
