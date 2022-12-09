package Kalaclista::Entries;

use strict;
use warnings;
use utf8;

use feature qw(state);

use Kalaclista::Constants;
use Kalaclista::Files;
use Kalaclista::Entry;

sub instance {
  state $instance;
  return $instance if ( defined $instance );

  my ( $class, $rootdir ) = @_;

  $instance ||= bless \$rootdir, $class;

  return $instance;
}

sub entries {
  state $entries;
  return $entries if ( defined $entries && ref $entries eq 'ARRAY' );

  my $instance = shift;

  $entries ||= [
    map  { Kalaclista::Entry->new( $_, $instance->href($_) ) }
    grep { $_ =~ m{\.md$} } Kalaclista::Files->find( $instance->$* )
  ];

  return $entries;
}

sub href {
  my ( $instance, $path ) = @_;

  my $len = length( $instance->$* );

  substr( $path, 0,  $len, q{} );
  substr( $path, -3, 3,    q{} );

  substr( $path, 0, 1,  q{} ) if ( substr( $path, 0, 1 ) eq "/" );
  substr( $path, 0, -1, q{} ) if ( substr( $path, 0, -1 ) eq "/" );

  $path .= "/";

  my $URI = Kalaclista::Constants->baseURI->clone;
  $URI->path($path);

  return $URI;
}

sub fixup {
  my ( $self, $code ) = @_;

  if ( !ref $code eq 'CODE' ) {
    confess("fixup function is not CodeRef");
  }

  $code->($_) for $self->entries->@*;

  return 1;
}

1;
