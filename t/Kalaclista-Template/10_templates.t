#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Path::Tiny qw(path);

use Kalaclista::Directory;
use Kalaclista::Template qw(load);

my $dirs = Kalaclista::Directory->instance;
$dirs->root( path('t/fixtures') );

sub main {
  is( Kalaclista::Template::className( "foo.../2020bar.pl", 'foo' ), "::Foo::Bar" );

  my $tmpl = load( $dirs->templates_dir->child('test.pl')->stringify );

  $tmpl->();

  done_testing;
}

main;
