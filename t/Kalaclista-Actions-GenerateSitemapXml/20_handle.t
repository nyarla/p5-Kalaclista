#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;

use Kalaclista::Actions::GenerateSitemapXml;

use Kalaclista::Config;
use Kalaclista::Directory;

use URI;

sub main {
  my $dirs   = Kalaclista::Directory->instance;
  my $config = Kalaclista::Config->new(
    dirs  => $dirs,
    data  => {},
    hooks => [
      [ 'Kalaclista::Entry::Meta', 'postprocess' ] => sub {
        my $meta = shift;
        $meta->title('hello, world!');
      },
    ],
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  my $handle = Kalaclista::Actions::GenerateSitemapXml::makeHandle($config);
  my $file   = $dirs->rootdir->child('t/fixtures/build/test.yaml');

  my $meta = $handle->($file);

  is( $meta->title, 'hello, world!' );

  done_testing;
}

main;
