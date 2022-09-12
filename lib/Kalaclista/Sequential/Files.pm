package Kalaclista::Sequential::Files;

use strict;
use warnings;

use Kalaclista::Files;

use Carp qw(confess);

use Class::Accessor::Lite ( ro => [qw( handle result )] );

sub new {
  my ( $class, %args ) = @_;

  my $handle = delete $args{'handle'} // sub { };
  my $result = delete $args{'result'} // sub { };

  if ( ref $handle ne 'CODE' ) {
    confess q{argument `handle ` is not subroutine.};
  }

  if ( ref $result ne 'CODE' ) {
    confess q{argument `result` is not subroutine.};
  }

  return bless {
    handle => $handle,
    result => $result,
  }, $class;
}

sub run {
  my ( $self, @files ) = @_;

  my @results;
  for my $file (@files) {
    push @results, $self->handle->($file);
  }

  return $self->result->(@results);
}

1;
