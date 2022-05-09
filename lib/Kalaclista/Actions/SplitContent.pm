package Kalaclista::Actions::SplitContent;

use strict;
use warnings;

use Kalaclista::Parallel::Files;
use Kalaclista::Utils qw( split_md make_fn );

sub action {
  my $class = shift;
  my $app   = shift;
  my $dir   = $app->config->dirs->content_dir->realpath;
  my $out   = $app->config->dirs->build_dir->realpath;

  my $runner = Kalaclista::Parallel::Files->new(
    handle => sub {
      my $file = shift;

      my ( $yaml, $md ) = split_md $file;
      my $fn = make_fn $file->stringify, $dir->stringify;

      $out->child($fn)->parent->mkpath;
      $out->child("${fn}.md")->spew($md);
      $out->child("${fn}.yaml")->spew($yaml);
    },
    worker_count => $app->config->threads,
  );

  $runner->run( $dir->stringify, '**', '*.md' );
}

1;
