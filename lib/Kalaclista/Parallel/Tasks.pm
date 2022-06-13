package Kalaclista::Parallel::Tasks;

use strict;
use warnings;

use Carp q(confess);
use Parallel::Fork::BossWorkerAsync;
use Class::Accessor::Lite ( ro => [qw(threads handle result)] );

sub new {
  my $class = shift;
  my $args  = ref $_[0] ? $_[0] : {@_};

  my $handle  = delete $args->{'handle'} // sub { };
  my $result  = delete $args->{'result'} // sub { };
  my $threads = delete $args->{'result'} // 3;

  confess q|`handle` must be a CODE reference|   if ( ref $handle ne 'CODE' );
  confess q|`result` must be a CODE reference|   if ( ref $handle ne 'CODE' );
  confess q|`threads` must be a positive number| if ( $threads !~ m{^\d+$} );

  return bless {
    handle  => $handle,
    result  => $result,
    threads => $threads,
  }, $class;
}

sub run {
  my $self  = shift;
  my @tasks = @_;

  my $bw = Parallel::Fork::BossWorkerAsync->new(
    work_handler   => sub { $self->handle->(@_); },
    result_handler => sub { $self->result->(@_); },
    worker_config  => $self->threads,
  );

  $bw->add_work(@tasks);
  while ( $bw->pending ) {
    my $result = $bw->get_result;
    if ( exists $result->{'ERROR'} ) {
      print STDERR $result->{'ERROR'} . "\n";
    }
  }

  $bw->shut_down;
}

1;
