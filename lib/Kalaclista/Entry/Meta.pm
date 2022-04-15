package Kalaclista::Entry::Meta;

use strict;
use warnings;

use Carp qw(confess);
use YAML::Tiny;

use Class::Accessor::Lite (
  new => 1,
  rw  => [qw( href title summary type date lastmod )],
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

  my $data    = YAML::Tiny::Load( $file->slurp );
  my $title   = $data->{'title'};
  my $type    = $data->{'type'}    // q{pages};
  my $date    = $data->{'date'}    // q{};
  my $lastmod = $data->{'lastmod'} // $date;

  if ( exists $data->{'slug'} ) {
    $href =~ s!notes/[^/]+!notes/$data->{'slug'}/!;
  }

  if ( $href =~ m{index} ) {
    $href =~ s<(\d{4})/index><$1/>;
  }

  if ( $href =~ m{(posts|echos|notes)} ) {
    $type = $1;
  }

  return $class->new(
    title   => $title,
    summary => q{},
    type    => $type,
    href    => $href,
    date    => $date,
    lastmod => $lastmod,
  );
}

1;
