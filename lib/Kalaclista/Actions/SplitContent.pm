package Kalaclista::Actions::SplitContent;

use strict;
use warnings;

use Kalaclista::Parallel::Files;
use Kalaclista::Utils qw( split_md make_fn );

sub makeHandle {
  my ( $content, $dest ) = @_;

  return sub {
    my $file = shift;

    my ( $yaml, $md ) = split_md $file;
    my $fn = make_fn $file->stringify, $content->stringify;

    $dest->child($fn)->parent->mkpath;
    $dest->child("${fn}.md")->spew($md);
    $dest->child("${fn}.yaml")->spew($yaml);

    print $dest->child("${fn}.yaml")->stringify, "\n";
  };
}

sub action {
  my $class = shift;
  my $ctx   = shift;

  my $content = $ctx->dirs->content_dir;
  my $dest    = $ctx->dirs->build_dir;

  my $runner = Kalaclista::Parallel::Files->new(
    handle  => makeHandle( $content, $dest ),
    threads => $ctx->threads,
  );

  return $runner->run( $content->stringify, '**', '*.md' );
}

1;
