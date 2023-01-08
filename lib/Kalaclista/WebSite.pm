package Kalaclista::WebSite;

use strict;
use warnings;

use URI::Fast;
use URI::Escape qw(uri_unescape);
use YAML::XS qw(Dump LoadFile);

use Class::Accessor::Lite (
  new => 1,
  rw  => [
    qw(
      is_gone
      is_ignore
      has_redirect

      updated_at

      href
      title
      summary
    )
  ],
);

sub filename {
  my $self = shift;
  my $href = URI::Fast->new( $self->href );

  if ( $href->path eq q{} ) {
    $href->path('/');
  }

  my $path = uri_unescape( $href->as_string );
  utf8::decode($path);

  $path =~ s{^https?://}{};
  $path =~ s{[^\p{InHiragana}\p{InKatakana}\p{InCJKUnifiedIdeographs}a-zA-Z0-9\-_/]}{_}g;
  $path =~ s{/$}{/index};
  $path =~ s{_+}{_}g;

  return $path;
}

sub emit {
  my ( $self, $dir ) = @_;
  return $dir->child( $self->filename . ".yaml" )->emit( { $self->%* } );
}

sub load {
  my ( $class, $href, $dir ) = @_;

  my $self = $class->new( href => $href );
  my $fn   = $self->filename;

  my $path = $dir->child("${fn}.yaml");

  if ( -e $path->path ) {
    $self->%* = LoadFile( $path->path )->%*;
  }

  return $self;
}

1;
