package Kalaclista::Context;

use strict;
use warnings;

use Carp qw(confess);

use Class::Accessor::Lite ( ro => [qw(dirs data hooks baseURI threads)], );

my $instance;

sub new {
  my $class = shift;
  my $args  = ref $_[0] ? $_[0] : {@_};

  if ( ref $args->{'dirs'} ne 'Kalaclista::Directory' ) {
    confess "`dirs` is not instance of Kalaclista::Directory";
  }

  if ( ref $args->{'data'} ne 'HASH' ) {
    confess '`data` must be a HASH reference.';
  }

  if ( ref $args->{'hooks'} ne 'ARRAY' ) {
    confess '`hooks` must be a ARRAY reference.';
  }

  if ( ref( $args->{'baseURI'} ) !~ m{^URI::} ) {
    confess '`baseURI` must be a URI-ish classes';
  }

  if ( $args->{'threads'} !~ m{^\d+$} ) {
    confess '`threads` must be a positive number';
  }

  return bless {
    dirs    => $args->{'dirs'},
    data    => $args->{'data'},
    hooks   => $args->{'hooks'},
    baseURI => $args->{'baseURI'},
    threads => $args->{'threads'},
  }, $class;
}

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
  my ( $self, $hook, @args ) = @_;

  for ( my $idx = 0 ; $idx < $self->hooks->@* ; $idx++ ) {
    my $matcher = $self->hooks->[$idx];
    my $action  = $self->hooks->[ ++$idx ];

    if ( $matcher->[0] eq ref( $args[0] ) && $matcher->[1] eq $hook ) {
      $action->(@args);
    }
  }

  return 1;
}

1;
