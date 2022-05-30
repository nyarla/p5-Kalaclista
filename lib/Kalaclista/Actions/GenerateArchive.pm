package Kalaclista::Actions::GenerateArchive;

use strict;
use warnings;

use Kalaclista::Sequential::Files;
use Kalaclista::Entry::Meta;
use Kalaclista::Utils qw( make_fn make_href );

use Parallel::Fork::BossWorkerAsync;

sub action {
  my $class = shift;
  my $app   = shift;

  my $dir   = $app->config->dirs->content_dir->realpath;
  my $build = $app->config->dirs->build_dir->realpath;
  my $out   = $app->config->dirs->distdir->realpath;

  my $baseURI = $app->config->baseURI;

  my $runner = Kalaclista::Sequential::Files->new(
    handle => sub {
      my $file = shift;

      my $fn   = make_fn $file->stringify, $build->stringify;
      my $href = make_href $fn, $baseURI;

      my $meta = Kalaclista::Entry::Meta->load(
        src  => $file,
        href => $href,
      );

      $app->config->call( 'entry.postprocess.meta', $meta );

      return $meta;
    },
    result => sub {
      return @_;
    },
  );

  my @entries = $runner->run( $build->stringify, "**", '*.yaml' );

  my @pages = map { $_->baseURI( $app->config->baseURI ); $_ }
    $app->config->call( 'entries.archives.pages', @entries );

  my $bw = Parallel::Fork::BossWorkerAsync->new(
    work_handler => sub {
      return shift->emit;
    },
    worker_count => $app->config->threads,
  );

  $bw->add_work(@pages);

  while ( $bw->pending ) {
    my $err = $bw->get_result;
    if ( exists $err->{'ERROR'} ) {
      print STDERR $err->{'ERROR'};
    }
  }

  return 0;
}

1;
