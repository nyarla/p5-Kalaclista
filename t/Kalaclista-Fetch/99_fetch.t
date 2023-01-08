#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test2::V0;

use Kalaclista::Fetch;
use Kalaclista::Path;

my $ua = 'Mozilla/5.0 (X11; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0';

sub main {
  my $tempdir = Kalaclista::Path->tempdir;
  my $agent   = Kalaclista::Fetch->new(
    datadir      => $tempdir,
    agent        => $ua,
    timeout      => 3,
    max_redirect => 5,
  );

  my $data = $agent->fetch('https://the.kalaclista.com');

  ok( !$data->is_gone );
  ok( !$data->is_ignore );

  ok( !$data->has_redirect );
  is( $data->href, 'https://the.kalaclista.com' );

  like( $data->updated_at, qr{^\d+$} );

  is( $data->title,   'カラクリスタ' );
  is( $data->summary, '『輝かしい青春』なんて失かった人の Web サイトです' );

  done_testing;
}

main;
