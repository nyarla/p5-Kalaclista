#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Directory;
use Kalaclista::Sequential::Files;
use Kalaclista::Utils qw( split_md );

my $dirs = Kalaclista::Directory->instance(
  dist    => 'dist/the.kalaclista.com',
  data    => 'private/the.kalaclista.com/cache',
  assets  => 'private/the.kalaclista.com/assets',
  content => 'private/the.kalaclosta.com/content',
);

my $build = $dirs->build_dir;

sub msg ($) {
  my $msg = shift;
  print $msg, "\n";
}

sub _split_content {
  msg 'Split files to `md` and `yaml`';

  my $runner = Kalaclista::Sequential::Files->new(
    handle => sub {
      my $file = shift;
      my ( $yaml, $md ) = split_md $file;

      my $path   = $file->stringify;
      my $prefix = $dirs->content_dir->stringify;

      $path =~ s<$prefix/><>;
      $path =~ s<\..+$><>;
      $path =~ s<_index><index>;

      $build->child( '_content', $path )->parent->mkpath;
      $build->child( '_content', "${path}.md" )->spew($md);
      $build->child( '_content', "${path}.yaml" )->spew($yaml);
    }
  );

  $runner->run( $dirs->content_dir->stringify, '**', '*.md' );
}

sub main {
  _split_content;
}

main;
