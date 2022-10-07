package Kalaclista::Utils;

use strict;
use warnings;

use URI;
use URI::Escape qw( uri_unescape );

use Exporter::Lite;

our @EXPORT_OK = qw(split_md make_fn make_href make_path);

sub split_md ($) {
  my $file = shift;

  my $fh     = $file->openr;
  my $yaml   = q{};
  my $inside = 0;

  while ( defined( my $line = <$fh> ) ) {
    chomp($line);

    if ( $line eq q{---} ) {
      if ( $inside == 0 ) {
        $inside++;
        next;
      }

      if ( $inside > 0 ) {
        last;
      }
    }

    $yaml .= $line . "\n";
  }

  my $md = do { local $/; <$fh> };
  $md //= q{};

  return ( $yaml, $md );
}

sub make_fn ($$) {
  my ( $path, $prefix ) = @_;

  $path =~ s<$prefix/><>;
  $path =~ s<\..+$><>;
  $path =~ s<_index><index>;

  return $path;
}

sub make_href ($$) {
  my ( $path, $baseURI ) = @_;

  $path =~ s{index}{};
  $path =~ s{([^/])$}{$1/};

  my $uri = $baseURI->clone;
  $uri->path($path);

  return $uri->as_string;
}

sub make_path ($) {
  my $href = shift;
  my $link = URI->new($href);

  if ( $link->path eq q{} ) {
    $link->path('/');
  }

  my $path = uri_unescape( $link->as_string );
  utf8::decode($path);

  $path =~ s{^https?://}{};
  $path =~ s{[^\p{InHiragana}\p{InKatakana}\p{InCJKUnifiedIdeographs}a-zA-Z0-9\-_/]}{_}g;

  $path =~ s{_+}{_}g;
  $path =~ s{/$}{/index};

  return $path;
}

1;
