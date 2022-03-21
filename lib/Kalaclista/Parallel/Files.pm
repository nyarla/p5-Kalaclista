package Kalaclista::Parallel::Files;

use strict;
use warnings;

use Path::Tiny::Glob pathglob => { all => 1 };
use Parallel::Fork::BossWorkerAsync;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( threads process result )],
);

sub run {
  my $self  = shift;
  my @globs = @_;

  my @files = pathglob( [@globs] );
  my $bw    = Parallel::Fork::BossWorkerAsync->new(
    work_handler   => sub { $self->process->( $self, @_ ); },
    result_handler => sub { $self->result->( $self, @_ ); },
    worker_count   => $self->threads,
  );

  $bw->add_work(@files);
  while ( $bw->pending ) {
    $bw->get_result;
  }

  $bw->shut_down();
}

1;
