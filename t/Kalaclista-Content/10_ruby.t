#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Kalaclista::Content;

use Test2::V0;

sub simple {
  my $text    = q!聖剣{約束されし勝利の剣|エクスカリバー}!;
  my $content = Kalaclista::Content->new( source => $text );

  is(
    $content->expand_inline_ruby->at('body > *:first-child'),
    q{<p>聖剣<ruby>約束されし勝利の剣<rp>（</rp><rt>エクスカリバー</rt><rp>）</rp></ruby></p>},
  );
}

sub multiple {
  my $text    = q!{富士山|ふ|じ|さん}!;
  my $content = Kalaclista::Content->new( source => $text );

  is(
    $content->expand_inline_ruby->at('body > *:first-child'),
    q{<p><ruby>富<rt>ふ</rt>士<rt>じ</rt>山<rt>さん</rt></ruby></p>}
  );
}

sub main {
  simple;
  multiple;
  done_testing;
}

main;
