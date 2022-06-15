#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;
use Path::Tiny qw(tempdir);

use Kalaclista::Actions::GenerateSitemapXml;

use Kalaclista::Context;
use Kalaclista::Directory;

use URI;

my $dirs = Kalaclista::Directory->instance;

sub main {
  my $file = $dirs->rootdir->child('t/fixtures/build/test.yaml');
  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );
  my $context = Kalaclista::Context->new(
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

  my $handle = Kalaclista::Actions::GenerateSitemapXml::makeHandle($context);

  my $meta = $handle->($file);

  is( $meta->title, 'hello, world!' );

  done_testing;
}

main;
