package Kalaclista::Context;

use strict;
use warnings;

use Carp qw(confess);

use Class::Accessor::Lite ( ro => [qw(dirs data  baseURI threads)], );

my $instance;

sub new {
  my $class = shift;
  my $args  = ref $_[0] ? $_[0] : {@_};

  if ( ref $args->{'call'} ne 'HASH' ) {
    confess '`call` must be a HAHS reference.';
  }

  if ( ref $args->{'data'} ne 'HASH' ) {
    confess '`data` must be a HASH reference.';
  }

  if ( ref $args->{'dirs'} ne 'Kalaclista::Directory' ) {
    confess "`dirs` is not instance of Kalaclista::Directory";
  }

  if ( ref $args->{'query'} ne 'HASH' ) {
    confess '`query` must be a HAHS reference.';
  }

  if ( ref( $args->{'baseURI'} ) !~ m{^URI::} ) {
    confess '`baseURI` must be a URI-ish classes';
  }

  if ( $args->{'threads'} !~ m{^\d+$} ) {
    confess '`threads` must be a positive number';
  }

  return bless $args, $class;
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

  if ( exists $self->{'call'}->{$hook} ) {
    return !!$self->{'call'}->{$hook}->(@args);
  }

  return !!0;
}

sub query {
  my ( $self, $hook, @args ) = @_;

  if ( exists $self->{'query'}->{$hook} ) {
    return $self->{'query'}->{$hook}->(@args);
  }

  return ();
}

1;
