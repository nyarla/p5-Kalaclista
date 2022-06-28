package Kalaclista::Entry::Meta;

use strict;
use warnings;
use utf8;

use Carp qw(confess);
use YAML::Tiny;
use URI;
use Path::Tiny;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw( href title type slug date lastmod )],
);

sub load {
  my $class = shift;
  my $args  = ref $_[0] ? $_[0] : {@_};

  my $file = delete $args->{'src'};
  my $href = delete $args->{'href'};

  if ( !defined $file ) {
    confess 'argument `src` is empty';
  }

  $file = path("${file}") if ( ref $file ne 'Path::Tiny' );

  if ( !defined $href ) {
    confess 'argument `href` is empty.';
  }

  $href = URI->new("${href}") if ( ref $href ne 'URI' );

  my $data = YAML::Tiny::Load( $file->slurp_utf8 );
  $data->{'type'}    //= 'pages';
  $data->{'slug'}    //= q{};
  $data->{'date'}    //= q{};
  $data->{'lastmod'} //= $data->{'date'};

  return $class->new( $data->%*, href => $href );
}

1;
