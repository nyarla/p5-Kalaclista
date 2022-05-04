#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Kalaclista::Application;
use Kalaclista::Config;

my $config = Kalaclista::Config->instance(
  directory => {
    dist     => 'dist/the.kalaclista.com',
    data     => 'private/the.kalaclista.com/cache',
    assets   => 'private/the.kalaclista.com/assets',
    content  => 'private/the.kalaclista.com/content',
    template => 'templates/the.kalaclista.com',
    cache    => 'resources',
  },

  data => {
    global => {
      title   => 'カラクリスタ',
      summary => '『輝かしい青春』なんて失かった人の Web サイトです',
      links   => {
        internals => [
          { label => '運営方針', href => '/policies/' },
          { label => '権利情報', href => '/licenses/' },
          {
            label => '検索',
            href  =>
'https://cse.google.com/cse?cx=018101178788962105892:toz3mvb2bhr#gsc.tab=0'
          },
        ],
        externals => [
          { label => 'GitHub',   href => 'https://github.com/nyarla/' },
          { label => 'Zenn.dev', href => 'https://zenn.dev/nyarla' },
          { label => 'Twitter',  href => 'https://twitter.com/kalaclista' },
          { label => 'note',     href => 'https://note.com/kalaclista' },
          { label => 'Lapras',   href => 'https://laspras.com/public/nyarla' },
          { label => 'トピア',      href => 'https://user.topia.tv/5R9Y' },
        ],
      },
    },

    posts => {
      label   => 'ブログ',
      title   => 'カラクリスタ・ブログ',
      summary => '『輝かしい青春』なんて失かった人のブログです',
    },

    echos => {
      label   => '日記',
      title   => 'カラクリスタ・エコーズ',
      summary => '『輝かしい青春』なんて失かった人の日記です',
    },

    notes => {
      label   => 'メモ帳',
      title   => 'カラクリスタ・ノート',
      summary => '『輝かしい青春』なんて失かった人のメモ帳です',
    },
  },
);

my $app = Kalaclista::Application->new( config => $config );

$app->run(@ARGV);

=encoding utf-8

=head1 NAME

Kalaclista::Application - The static website generator for nyarla

=head1 SYNOPSIS

  # kalaclista.pl - configuration script for website
  $ kalaclista.pl -u 'http://nixos:1313' -a split-content

=head1 OPTIONS

=head2 --url,-u 

The baseURI of generate website

=head2 --action,-a 

The action name of running task.

=head1 AUTHOR

OKAMURA Naoki aka nyarla.

=cut
