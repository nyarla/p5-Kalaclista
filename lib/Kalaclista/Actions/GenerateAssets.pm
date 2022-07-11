package Kalaclista::Actions::GenerateAssets;

use strict;
use warnings;

use Kalaclista::Template;

sub action {
  my $class   = shift;
  my $context = shift;

  my @files = $context->query('assets');

  while ( @files > 0 ) {
    my $assets = shift @files;
    my $path   = shift @files;
    my $template =
      load( $context->dirs->templates_dir->child($path)->stringify );

    my $file = $context->dirs->distdir->child($assets);
    $file->parent->mkpath;

    $file->spew_utf8( $template->($context) );
  }

  return 1;
}

1;
