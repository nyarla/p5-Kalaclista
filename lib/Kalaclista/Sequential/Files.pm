package Kalaclista::Sequential::Files;

use strict;
use warnings;

use Carp qw(confess);
use Path::Tiny::Glob;

use Class::Accessor::Lite ( ro => [qw( handle result )], );

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

  my $self = bless {}, $class;

  $self->{'handle'} = $handle;
  $self->{'result'} = $result;

  return $self;
}

sub run {
  my $self  = shift;
  my @globs = @_;

  my $files = pathglob( \@globs );
  my @results;
  while ( defined( my $file = $files->next ) ) {
    push @results, $self->handle->($file);
  }

  return $self->result->(@results);
}

1;
