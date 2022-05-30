package Kalaclista::Entry::Meta;

use strict;
use warnings;
use utf8;

use Carp qw(confess);
use YAML::Tiny;
use URI;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw( href title summary type slug date lastmod )],
);

sub load {
  my $class = shift;
  my %args  = @_;

  my $file = delete $args{'src'};
  my $href = delete $args{'href'};

  if ( !defined($file) || ref $file ne 'Path::Tiny' ) {
    confess 'argument `src` is not Path::Tiny object';
  }

  if ( !defined($href) || $href eq q{} ) {
    confess 'argument `href` is empty.';
  }

  my $data    = YAML::Tiny::Load( $file->slurp_utf8 );
  my $title   = $data->{'title'};
  my $type    = $data->{'type'}    // q{pages};
  my $slug    = $data->{'slug'}    // q{};
  my $date    = $data->{'date'}    // q{};
  my $lastmod = $data->{'lastmod'} // $date;

  return $class->new(
    title   => $title,
    summary => q{},
    type    => $type,
    slug    => $slug,
    href    => URI->new($href),
    date    => $date,
    lastmod => $lastmod,
  );
}

1;
