#!/usr/bin/env perl

use v5.38;
use builtin qw(true false);
use utf8;
no warnings qw(experimental);

use Test2::V0;
use URI::Fast;
use HTML5::DOM;

use Kalaclista::Data::Entry;

my sub entry {
  return Kalaclista::Data::Entry->new(
    title   => 'hello, world!',
    summary => 'this is a test entry.',
    section => 'posts',
    date    => '2024-01-01T00:00:00',
    lastmod => '2024-02-01T00:00:00',
    href    => URI::Fast->new('https://example.com/entry'),
    meta    => { foo => 'bar', bar => 'baz' },
  );
}

subtest common => sub {
  my $entry = entry;
  is $entry->title,           'hello, world!';
  is $entry->summary,         'this is a test entry.';
  is $entry->section,         'posts';
  is $entry->draft,           false;
  is $entry->date,            '2024-01-01T00:00:00';
  is $entry->lastmod,         '2024-02-01T00:00:00';
  is $entry->href->to_string, 'https://example.com/entry';
  is $entry->dom,             undef;
  is $entry->src,             '';
  is $entry->meta, { foo => 'bar', bar => 'baz' };
};

subtest clone => sub {
  my $entry = entry->clone(
    title => 'hello, new world!',
    draft => true,
    meta  => {
      foo => 'baz',
      baz => 'foo',
    }
  );

  is $entry->title, 'hello, new world!';
  is $entry->draft, true;
  is $entry->meta, { foo => 'baz', bar => 'baz', baz => 'foo' };
};

done_testing;
