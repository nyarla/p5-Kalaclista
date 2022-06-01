package Kalaclista::HyperStyle;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(
  css
);

sub key {
  my $key    = shift;
  my $parent = shift // '';

  $key =~ s{([A-Z])}{'-' . lc($1)}es;

  return $key;
}

sub selector {
  my $sel    = shift;
  my $parent = shift;

  return $sel if ( $parent eq q{} );

  if ( $sel =~ m{&} ) {
    $sel =~ s{&}{$parent}g;
  }
  else {
    $sel = "${parent} ${sel}";
  }

  return $sel;
}

sub __css {
  my $rules   = shift;
  my $parents = shift;
  my @out;

  return @out if ( $rules->@* == 0 );

  my $parent = pop $parents->@* // '';

  my ( $key, $val );
  $key = shift $rules->@*;
  $val = shift $rules->@*;

  return if ( !defined $key || !defined $val );

  if ( ref $val eq 'ARRAY' ) {
    my ( $name, $data );
    while ( $val->@* ) {
      $name = shift $val->@*;
      $data = shift $val->@*;

      if ( !ref $data ) {
        push @out, [ selector( $key, $parent ), key($name), $data ];
        next;
      }

      if ( ref $data eq 'ARRAY' ) {
        push $rules->@*, $name, $data;
        push $parents->@*, selector( $key, $parent );
      }
    }
  }

  return @out;
}

sub _css {
  my $rules   = shift;
  my $parents = [];
  my @out;

  while ( $rules->@* > 0 ) {
    push @out, __css( $rules, $parents, @out );
  }

  return @out;
}

sub _as_string {
  my @css = @_;

  my @order;
  my %out;

  for my $data (@css) {
    my ( $sel, $prop, $val ) = $data->@*;

    push @order, $sel if ( !exists $out{$sel} );
    $out{$sel} //= {};
    $out{$sel}->{$prop} = $val;
  }

  my $out;
  for my $sel (@order) {
    $out .= $sel . '{';
    $out .= $_ . ':' . $out{$sel}->{$_} . ';' for ( sort keys $out{$sel}->%* );
    $out .= '}';
  }

  return $out;
}

sub css {
  my $rules = shift;
  return _as_string( _css($rules) );
}

1;
