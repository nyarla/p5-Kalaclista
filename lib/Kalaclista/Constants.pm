package Kalaclista::Constants;

use strict;
use warnings;
use utf8;

use feature qw(state);

use URI::Fast;

use Kalaclista::Path;
use Kalaclista::Variables;

sub baseURI {
  my $class = shift;
  state $baseURI;

  return $baseURI if ( defined $baseURI );

  if ( @_ == 1 ) {
    $baseURI = URI::Fast->new(shift);
  }

  return $baseURI;
}

sub rootdir {
  my $class = shift;
  state $rootdir;

  return $rootdir if ( defined $rootdir );

  $rootdir = Kalaclista::Path->detect(shift);

  return $rootdir;
}

sub vars {
  my $class = shift;
  state $vars;

  return Kalaclista::Variables->new( $vars->%* ) if ( defined $vars );

  $vars = Kalaclista::Variables->new(@_);

  return $vars;
}

1;
