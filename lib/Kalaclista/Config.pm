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
  return ( $self->data // {} )->{$section};
}

sub call {
  my ( $self, $method, $href ) = @_;
  return ( $self->functions->{$method} // sub { } )->($href);
}

1;
