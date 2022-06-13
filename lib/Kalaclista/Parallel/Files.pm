package Kalaclista::Parallel::Files;

use strict;
use warnings;

use Path::Tiny::Glob pathglob => { all => 1 };
use Parallel::Fork::BossWorkerAsync;

use Class::Accessor::Lite ( rw => [qw( threads handle result )], );

use Carp qw(confess);

sub new {
  my ( $class, %args ) = @_;

  my $handle  = delete $args{'handle'} // sub { };
  my $result  = delete $args{'result'} // sub { };
  my $threads = int( delete $args{'threads'} // 3 );

  if ( ref $handle ne 'CODE' ) {
    confess q{argument `handle` is not subroutine.};
  }

  if ( ref $result ne 'CODE' ) {
    confess q{argument `result` is not subroutine.};
  }

  return bless {
    handle  => $handle,
    result  => $result,
    threads => $threads,
  }, $class;
}

sub run {
  my $self  = shift;
  my @globs = @_;

  my @files = pathglob( [@globs] );
  my $bw    = Parallel::Fork::BossWorkerAsync->new(
    work_handler   => sub { $self->handle->(@_); },
    result_handler => sub { $self->result->(@_); },
    worker_count   => $self->threads,
  );

  $bw->add_work(@files);
  while ( $bw->pending ) {
    my $result = $bw->get_result;
    if ( exists $result->{'ERROR'} ) {
      print STDERR $result->{'ERROR'} . "\n";
    }
  }

  $bw->shut_down();
}

1;

=pod

=head1 NAME

Kalaclista::Parallel::Files - A async files processor by parallel fork.

=head1 USAGE

  my $processor = Kalaclista::Parallel::Files->new(
    threads => 31,
    handle  => sub { ... },
    result  => sub { ... },
  );

  $processor->run('**', '*.yaml');

=head1 CONSTRUCTOR ARGUMENTS

=head2 threads : Int

Number of paralles processing by C<handle>.

Default value is 3.

=head2 handle : CodeRef

A CODE ref of processing files.

Default value is empty CODE ref.

=head2 result : CodeRef

A CODE ref of handle result about processed files.

Default value is empty CODE ref.

=head1 SEE ALSO

L<Parallel::Fork::BossWorkerAsync>

L<Path::Tiny::Glob>

=cut
