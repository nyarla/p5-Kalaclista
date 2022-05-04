package Kalaclista::Config;

use strict;
use warnings;

use Kalaclista::Directory;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw(directory data)],
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

sub dirs {
  my $self = shift;
  if ( defined $dirs && ref($dirs) eq 'Kalaclista::Directory' ) {
    return $dirs;
  }

  $dirs = Kalaclista::Directory->new( ( $self->directory // {} )->%* );

  return $dirs;
}

sub section {
  my ( $self, $section ) = @_;
  return ( $self->data // {} )->{$section};
}

1;
