package Kalaclista::Parallel::Text;

use strict;
use warnings;

use Path::Tiny::Glob;
use Parallel::Fork::BossWorkerAsync;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( threads source process )],
);

sub run {
  my $self  = shift;
  my @globs = @_;

  my @tasks;
  my $files = pathglob( [@globs] );
  while ( defined( my $file = $files->next ) ) {
    push @tasks, $self->source->( $self, $file );
  }

  my $bw = Parallel::Fork::BossWorkerAsync->new(
    work_handler   => sub { $self->process->( $self, @_ ); },
    result_handler => sub { return $_[0] },
    worker_count   => $self->threads,
  );

  $bw->add_work(@tasks);
  while ( $bw->pending ) {
    my $ref = $bw->get_result;
    if ( $ref->{'ERROR'} ) {
      print STDERR "failed to process file: " . $ref->{'done'} . "\n";
    }
    else {
      print STDOUT "process success: " . $ref->{'done'} . "\n";
    }
  }

  $bw->shut_down();
}

1;
