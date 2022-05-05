package Kalaclista::Config;

use strict;
use warnings;

use Kalaclista::Directory;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw(dirs data)],
  rw  => [qw(baseURI production)],
);

my $instance;
my $dirs;

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

1;
