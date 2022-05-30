package Kalaclista::Config;

use strict;
use warnings;

use Kalaclista::Directory;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw(dirs data functions)],
  rw  => [qw(baseURI threads)],
);

my $instance;

sub instance {
  my $class = shift;
  if ( defined $instance && ref($instance) eq $class ) {
    return $instance;
  }

  $instance = $class->new(@_);

  return $instance;
}

sub section {
  my ( $self, $section ) = @_;

  if ( exists $self->data->{$section} ) {
    return $self->data->{$section};
  }

  return undef;
}

sub call {
  my ( $self, $method, @args ) = @_;
  return ( $self->functions->{$method} // sub { } )->(@args);
}

1;
