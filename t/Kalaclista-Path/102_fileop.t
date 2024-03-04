#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;

sub main {
  my $file = Kalaclista::Path->tempfile;

  $file->emit("hello, world!");
  ok( -f $file->path );
  is( $file->load, 'hello, world!' );
  $file->cleanup;
  ok( !-e $file );

  my $nested = Kalaclista::Path->tempdir->child('a/b/c/d/e/f/g/h/i/j/k/l/m/n');
  my $path   = $nested->path;

  $nested->parent->mkpath;
  $nested->emit('nested path');
  is( $nested->load, 'nested path' );

  undef $nested;
  ok( !-e $path || !-d $path );

  done_testing;
}

main;
