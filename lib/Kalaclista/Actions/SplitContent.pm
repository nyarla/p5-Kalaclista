package Kalaclista::Actions::SplitContent;

use strict;
use warnings;

use Kalaclista::Files;
use Kalaclista::Parallel::Files;
use Kalaclista::Utils qw( split_md make_fn );

use Path::Tiny;

sub makeHandle {
  my ( $content, $dest ) = @_;

  return sub {
    my $file = shift;

    my ( $yaml, $md ) = split_md $file;
    my $fn = make_fn $file->stringify, $content->stringify;

    $dest->child($fn)->parent->mkpath;
    $dest->child("${fn}.md")->spew($md);
    $dest->child("${fn}.yaml")->spew($yaml);

    return {};
  };
}

sub files {
  my ( $class, $rootdir ) = @_;

  return
    map { path($_) } grep { $_ =~ m{\.md$} } Kalaclista::Files->find($rootdir);
}

sub action {
  my $class = shift;
  my $ctx   = shift;

  my $content = $ctx->dirs->content_dir;
  my $dest    = $ctx->dirs->build_dir->child('contents');

  my $runner = Kalaclista::Parallel::Files->new(
    handle => makeHandle( $content, $dest ),
    result => sub {
      my $result = shift;
      if ( exists $result->{'ERROR'} ) {
        print STDERR $result->{'ERROR'};
      }

      return $result;
    },
    threads => $ctx->threads,
  );

  return $runner->run( $class->files( $content->stringify ) );
}

1;
