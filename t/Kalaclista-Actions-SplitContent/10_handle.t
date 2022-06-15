#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;
use Kalaclista::Actions::SplitContent;

my $dirs = Kalaclista::Directory->instance( content => 't/fixtures/content' );

sub main {
  my $content = $dirs->content_dir;
  my $dest    = $dirs->build_dir;
  my $handle = Kalaclista::Actions::SplitContent::makeHandle( $content, $dest );

  $handle->( $content->child('test.md') );

  is( $dest->child('test.yaml')->slurp, "title: hello\n" );
  is( $dest->child('test.md')->slurp,   "\nhello, world!\n" );

  done_testing;
}

main;
