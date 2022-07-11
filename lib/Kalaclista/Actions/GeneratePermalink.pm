package Kalaclista::Actions::GeneratePermalink;

use strict;
use warnings;

use Kalaclista::Sequential::Files;
use Kalaclista::Parallel::Tasks;
use Kalaclista::Entry::Meta;
use Kalaclista::Entry::Content;
use Kalaclista::Page;

use Kalaclista::Utils qw(make_fn make_href);

use Path::Tiny;
use URI::Escape qw( uri_unescape );

sub makeHandle {
  my $context = shift;
  return sub {
    my $file    = shift;
    my $content = Kalaclista::Entry::Content->load( src => $file );

    my $path = $file->stringify;
    $path =~ s{\.md$}{.yaml};

    my $fn   = make_fn $path, $context->dirs->build_dir->stringify;
    my $href = make_href $fn, $context->baseURI;

    my $meta = Kalaclista::Entry::Meta->load(
      src  => $path,
      href => $href,
    );

    $context->call( fixup => $meta );
    $context->call( fixup => $content, $meta );

    return $context->query( page => $content, $meta );
  };
}

sub action {
  my $class   = shift;
  my $context = shift;

  my $build = $context->dirs->build_dir;
  my $dist  = $context->dirs->distdir;

  my $baseURI = $context->baseURI;
  my @pages   = Kalaclista::Sequential::Files->new(
    handle => makeHandle($context),
    result => sub { return @_ },
  )->run( $build->stringify, '**', '*.md' );

  my $builder = Kalaclista::Parallel::Tasks->new(
    handle  => sub { shift->emit; {} },
    result  => sub { shift },
    threads => $context->threads,
  );

  return $builder->run(@pages);
}

1;
