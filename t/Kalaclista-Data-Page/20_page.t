#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Data::Page;
use Test2::V0;

subtest instance => sub {
  my $page = Kalaclista::Data::Page->new(
    title   => 'hi,',
    summary => 'hello, world!',
    section => 'test',
    kind    => 'page',
    href    => 'https://example.com',
    entries => ['foo'],
    vars    => { foo => 'bar' },
  );

  isa_ok $page, 'Kalaclista::Data::Page',;

  is $page->title,   'hi,';
  is $page->summary, 'hello, world!';
  is $page->section, 'test';
  is $page->kind,    'page';
  is $page->href,    'https://example.com';
  is $page->entries, ['foo'];
  is $page->vars, { foo => 'bar' },;
};

done_testing;
