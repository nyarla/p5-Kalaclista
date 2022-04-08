package Kalaclista::Utils;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(split_md make_fn make_href);

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

1;
