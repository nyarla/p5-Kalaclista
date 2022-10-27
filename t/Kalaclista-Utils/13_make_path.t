#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test2::V0;

use Kalaclista::Utils qw(make_path);

sub main {
  is( make_path('https://the.kalaclista.com'), 'the_kalaclista_com/index' );

  is(
    make_path('https://the.kalaclista.com/notes/%E8%87%AA%E4%BD%9C%E3%82%AD%E3%83%BC%E3%83%9C%E3%83%BC%E3%83%89/'),
    'the_kalaclista_com/notes/自作キーボード/index'
  );

  is(
    make_path('https://example.com/foo?bar#hoge'),
    'example_com/foo_bar_hoge',
  );

  done_testing;
}

main;
