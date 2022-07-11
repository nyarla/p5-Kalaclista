#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(tempdir);
use URI;

use Kalaclista::Context;
use Kalaclista::Directory;
use Kalaclista::Page;
use Kalaclista::Actions::GeneratePermalink;

my $dirs = Kalaclista::Directory->instance;

sub testfile {
  my $dirs = shift;

  my $data = {
    title => 'hello, world!',
    date  => "2021-06-01T10:50:35+09:00"
  };

  my $yaml = $dirs->build_dir->child('test/test.yaml');
  $yaml->parent->mkpath;
  $yaml->spew( YAML::Tiny::Dump($data) );

  my $md = $dirs->build_dir->child('test/test.md');
  $md->parent->mkpath;
  $md->spew('hello, world!');

  my $tmpl = $dirs->templates_dir->child('test.pl');
  $tmpl->parent->mkpath;
  $tmpl->spew('my $tmpl = sub {return "hello, world!" }; $tmpl;');
}

sub main {
  $dirs->root( tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 ) );
  testfile($dirs);

  my $context = Kalaclista::Context->instance(
    dirs => $dirs,
    data => {},
    call => {
      fixup => sub {
        if ( @_ == 1 ) {
          isa_ok( shift, 'Kalaclista::Entry::Meta' );
        }
        elsif ( @_ == 2 ) {
          isa_ok( shift, 'Kalaclista::Entry::Content' );
          isa_ok( shift, 'Kalaclista::Entry::Meta' );
        }
      },
    },
    query => {
      page => sub {
        isa_ok( shift, 'Kalaclista::Entry::Content' );
        isa_ok( shift, 'Kalaclista::Entry::Meta' );

        return Kalaclista::Page->new(
          dist     => $dirs->distdir->child('test/test.html'),
          template => $dirs->templates_dir->child('test.pl')->stringify,
          vars     => { foo => 'bar' },
        );
      },
    },
    baseURI => URI->new('https://example.com'),
    threads => 1,
  );

  Kalaclista::Actions::GeneratePermalink->action($context);

  is( $dirs->distdir->child('test/test.html')->slurp, 'hello, world!' );

  done_testing;
}

main;
