package Kalaclista::Config;

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

  return bless {
    dirs  => $args->{'dirs'},
    data  => $args->{'data'},
    hooks => $args->{'hooks'},
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
  my ( $self, $hook, $object, @args ) = @_;

  for ( my $idx = 0 ; $idx < $self->hooks->@* ; $idx++ ) {
    my $matcher = $self->hooks->[$idx];
    my $action  = $self->hooks->[ ++$idx ];

    if ( $matcher->[0] eq ref($object) && $matcher->[1] eq $action ) {
      $object = $action->( $object, @args );
    }
  }

  return $object;
}

1;
