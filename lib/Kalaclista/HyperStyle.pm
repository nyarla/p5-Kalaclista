package Kalaclista::HyperStyle;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT = qw(
  css
);

sub prop {
  my $key    = shift;
  my $parent = shift // '';

  $key =~ s{([A-Z])}{'-' . lc($1)}eg;

  return $key;
}

sub selector {
  my $sel    = shift;
  my $prefix = shift;

  return $sel if ( !defined $prefix || ( !ref $prefix && $prefix eq q{} ) );

  $prefix = [$prefix] if ( !ref $prefix );

  my @out;
  for my $parent ( $prefix->@* ) {
    my $item = $sel;
    if ( $item =~ m{&} ) {
      $item =~ s{&}{$parent}g;
    }
    else {
      $item = "${parent} ${sel}";
    }

    push @out, $item;
  }

  return join q{, }, @out;
}

sub _css {
  my $rules = shift;
  my $data  = [];

  my $rule = [];

  while ( $rules->@* > 0 ) {
    my $key   = shift $rules->@*;
    my $value = shift $rules->@*;

    if ( !ref $value ) {
      push $rule->@*, $key, $value;
    }

    if ( ref $value ) {
      while ( $value->@* ) {
        my $name = shift $value->@*;
        my $prop = shift $value->@*;

        if ( !ref $prop ) {
          push $rule->@*, $key, prop($name), $prop;
          push $data->@*, $rule;
          $rule = [];
        }
        elsif ( ref $prop eq 'ARRAY' ) {
          unshift $rules->@*, selector( $name, $key ), $prop;
        }
      }
    }
  }

  return $data;
}

sub _as_string {
  my ($payload) = @_;

  my $out;
  my $prev;
  do {
    my $data = shift $payload->@*;
    my ( $sel, $key, $value ) = $data->@*;

    if ( !defined $prev || $prev ne $sel ) {
      if ( defined $prev ) {
        $out .= '}';
      }

      $out .= $sel . '{';
    }

    if ( !defined $prev || $prev ne $sel ) {
    }

    $out .= $key . ':' . $value . ";";

    $prev = $sel;
  } while ( $payload->@* > 0 );

  $out .= '}';

  return $out;
}

sub css {
  my $rules = shift;
  return _as_string( _css($rules) );
}

1;
