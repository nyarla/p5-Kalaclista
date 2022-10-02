package Kalaclista::Entries;

use strict;
use warnings;
use utf8;

use Kalaclista::Entry;
use Kalaclista::Files;

sub new {
  my ( $class, $rootdir, $baseURI ) = @_;
  return bless {
    path    => $rootdir,
    baseURI => $baseURI,
    entries => undef,
  }, $class;
}

sub href {
  my ( $self, $path ) = @_;

  $path =~ s|$self->{'path'}||;
  $path =~ s{\.md}{};
  $path =~ s{^/|/$}{}g;
  $path .= "/";

  my $url = $self->{'baseURI'}->clone;
  $url->path($path);

  return $url;
}

sub entries {
  my $self = shift;

  if ( !defined $self->{'entries'} ) {
    $self->{'entries'} = [
      map  { Kalaclista::Entry->new( $_, $self->href($_) ) }
      grep { $_ =~ m{\.md$} } Kalaclista::Files->find( $self->{'path'} )
    ];
  }
}

1;
