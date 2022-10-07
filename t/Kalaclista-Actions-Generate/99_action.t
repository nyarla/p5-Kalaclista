#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;
use Path::Tiny qw(tempdir);

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Page;
use Kalaclista::Actions::Generate;

my $dirs = Kalaclista::Directory->instance;

sub testfile {
  my $dirs = shift;

  $dirs->content_dir->parent->mkpath;
  $dirs->content_dir->child('test.md')->spew_utf8(<<"...");
---
title: 'hello, world!'
date: '2021-06-01T10:50:35+09:00'
---

hello, world!
...

  my $tmpl = $dirs->templates_dir->child('test.pl');
  $tmpl->parent->mkpath;
  $tmpl->spew('my $tmpl = sub {return "hello, world!" }; $tmpl;');
}

sub main {
  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );
  testfile($dirs);

  my $context = Kalaclista::Context->instance(
    dirs  => $dirs,
    data  => {},
    call  => {},
    query => {
      page => sub {
        my $entry = shift;

        isa_ok( $entry, "Kalaclista::Entry" );

        return Kalaclista::Page->new(
          dist     => $dirs->distdir->child('page.html'),
          baseURI  => URI->new('https://example.com'),
          template => $dirs->templates_dir->child('test.pl'),
          vars     => {},
        );
      },
      archives => sub {
        my @entries = shift;

        ok( @entries != 0 );
        isa_ok( $_, "Kalaclista::Entry" ) for (@entries);

        return Kalaclista::Page->new(
          dist     => $dirs->distdir->child('index.html'),
          baseURI  => URI->new('https://example.com'),
          template => $dirs->templates_dir->child('test.pl'),
          vars     => {},
        );
      },
    },
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  testfile($dirs);

  Kalaclista::Actions::Generate->action($context);

  is( $dirs->distdir->child('page.html')->slurp,  'hello, world!' );
  is( $dirs->distdir->child('index.html')->slurp, 'hello, world!' );

  done_testing;
}

main;
