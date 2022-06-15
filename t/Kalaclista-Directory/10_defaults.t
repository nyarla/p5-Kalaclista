#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;
use Path::Tiny qw(tempdir);

sub main {
  my $root = tempdir( 'kalaclista_test_XXXXXX', CLEANUP => 1 );
  my $dirs = Kalaclista::Directory->instance( root => $root );

  is( $dirs->distdir->stringify,       $root->child('dist')->stringify );
  is( $dirs->datadir->stringify,       $root->child('data')->stringify );
  is( $dirs->assets_dir->stringify,    $root->child('assets')->stringify );
  is( $dirs->content_dir->stringify,   $root->child('content')->stringify );
  is( $dirs->templates_dir->stringify, $root->child('templates')->stringify );
  like( $dirs->build_dir->stringify, qr<kalaclista_\w{6}> );

  done_testing;
}

main;
