package Kalaclista::Actions::GenerateByTemplate;

use strict;
use warnings;

use Kalaclista::Template;

sub action {
  my $class = shift;
  my $app   = shift;

  my $out   = $app->config->dirs->distdir->realpath;
  my $files = $app->config->call('file.generate.templates');

  while ( $files->@* > 0 ) {
    my $path = shift $files->@*;
    my $file = $out->child($path);
    my $template =
      $app->config->dirs->templates_dir->child( shift $files->@* )->realpath;

    my $module = $path;
    $module =~ s{\.([^\.]+)$}{}g;
    $module =~ s{/}{::}g;

    my $data = load( "Assets::${module}", $template );
    $file->parent->realpath->mkpath;
    $file->spew_utf8($data);
  }

  return 1;
}

1;
