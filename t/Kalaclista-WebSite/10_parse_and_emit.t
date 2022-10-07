#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test2::V0;
use Path::Tiny qw(tempfile);
use YAML::XS;

use Kalaclista::Directory;
use Kalaclista::WebSite;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $content = $dirs->rootdir->child('t/Kalaclista-WebSite/fixture.html')->slurp_utf8;

  my $website = Kalaclista::WebSite->parse($content);

  is( $website->title,   'カラクリスタ・ブログ' );
  is( $website->summary, '『輝かしい青春』なんて失かった方の『にゃるら』の Webサイトです。' );

  my $file = tempfile;

  $website->href('https://the.kalaclista.com/posts/');
  $website->emit($file);

  is(
    YAML::XS::Load( $file->slurp_utf8 ),
    {
      href    => 'https://the.kalaclista.com/posts/',
      title   => 'カラクリスタ・ブログ',
      summary => '『輝かしい青春』なんて失かった方の『にゃるら』の Webサイトです。',
    },
  );

  done_testing;
}

main;
