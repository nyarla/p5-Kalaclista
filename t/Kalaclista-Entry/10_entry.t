#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use URI::Fast;
use Kalaclista::Entry;
use Kalaclista::Path;

my $fixtures = Kalaclista::Path->detect(qr{^t$})->child('fixtures');

subtest load => sub {
  my $entry = Kalaclista::Entry->new( path => $fixtures->child('content/test.md') );

  subtest loaded => sub {
    ok( !$entry->loaded, 'entry does not loaded' );
    $entry->load;
    ok( $entry->loaded, 'entry loaded' );
  };

  subtest meta => sub {
    is $entry->title,         'hello world';
    is $entry->type,          'posts';
    is $entry->slug,          'hello';
    is $entry->date,          '2022-01-01T00:00:00Z';
    is $entry->lastmod,       '2023-01-01T00:00:00Z';
    is $entry->summary,       'foo bar baz';
    is $entry->meta('extra'), 'hi,';

    $entry->title('foo');
    is $entry->title, 'foo';
    $entry->type('foo');
    is $entry->type, 'foo';
    $entry->slug('foo');
    is $entry->slug, 'foo';
    $entry->date('2023-01-01T00:00:00Z');
    is $entry->date, '2023-01-01T00:00:00Z';
    $entry->lastmod('2024-01-01T00:00:00Z');
    is $entry->lastmod, '2024-01-01T00:00:00Z';
    $entry->summary('foo');
    is $entry->summary, 'foo';
    $entry->meta( extra => 'foo' );
    is $entry->meta('extra'), 'foo';
  };
};

done_testing;
