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

sub replace {
  my $sel    = shift;
  my $prefix = shift;

  if ( $sel =~ m{&} ) {
    $sel =~ s{&}{$prefix}g;
  }
  else {
    $sel = "${prefix} ${sel}";
  }

  return $sel;
}

sub selector {
  my $selectors = shift;
  my $prefixes  = shift // [];

  $prefixes  = [$prefixes]  if ( !ref $prefixes );
  $selectors = [$selectors] if ( !ref $selectors );

  if ( $prefixes->@* == 0 ) {
    return [ map { [$_] } $selectors->@* ];
  }

  my $out = [];
  for ( my $idx = 0 ; $idx < scalar( $prefixes->@* ) ; $idx++ ) {
    my $prefix = $prefixes->[$idx];
    $prefix = [$prefix] if ( !ref $prefix );
    for my $s ( $selectors->@* ) {
      push $out->@*, [ $s, $prefix->@* ];
    }
  }

  return $out;
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

sub _as_selector_string {
  my $data = shift;
  $data = [$data] if ( !ref $data );

  my @out;
  for my $selectors ( $data->@* ) {
    $selectors = [$selectors] if ( !ref $selectors );

    my $sel = shift $selectors->@*;
    for my $parent ( $selectors->@* ) {
      $sel = replace( $sel, $parent );
    }
    push @out, $sel;
  }

  return join q{,}, @out;
}

sub _as_string {
  my ($payload) = @_;

  my $out;
  my $prev;
  do {
    my $data = shift $payload->@*;
    my ( $sel, $key, $value ) = $data->@*;

    $sel = _as_selector_string($sel);

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
