#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI;
use Path::Tiny qw(tempdir);

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Page;
use Kalaclista::Actions::GenerateArchive;

sub testfile {
  my $dirs = shift;

  my $data = {
    title => 'hello, world!',
    date  => "2021-06-01T10:50:35+09:00"
  };

  my $yaml = $dirs->build_dir->child('test/test.yaml');
  $yaml->parent->mkpath;
  $yaml->spew( YAML::Tiny::Dump($data) );

  my $tmpl = $dirs->templates_dir->child('templates/test.pl');
  $tmpl->parent->mkpath;
  $tmpl->spew('my $tmpl = sub {return "hi," }; $tmpl;');
}

sub main {
  my $dirs = Kalaclista::Directory->instance;
  my $root = $dirs->rootdir;

  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );

  my $context = Kalaclista::Context->instance(
    dirs  => $dirs,
    data  => {},
    call  => {},
    query => {
      archives => sub {
        my @entries = shift;

        return (
          Kalaclista::Page->new(
            dist     => $dirs->distdir->child('test/test.html'),
            baseURI  => URI->new('https://example.com'),
            template => $dirs->templates_dir->child('templates/test.pl'),
            vars     => {},
          )
        );
      },
    },
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  testfile($dirs);

  Kalaclista::Actions::GenerateArchive->action($context);

  is( $dirs->distdir->child('test/test.html')->slurp, 'hi,' );

  done_testing;
}

main;
