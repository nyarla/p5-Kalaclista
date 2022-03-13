#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Sequential::Files;

use Path::Tiny;

sub splitting {
  my ( $destdir, $file ) = @_;

  my $fh     = $file->openr;
  my $yaml   = q{};
  my $inside = 0;
  while ( defined( my $line = <$fh> ) ) {
    chomp($line);

    if ( $line eq '---' ) {
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

  my $text = do { local $/; <$fh> };
  my $path = ( split q{content/}, $file->stringify )[1];
  $path =~ s{\.[^.]+$}{};

  if ( !defined($text) || $text eq q{} ) {
    return { msg => "skip: " . $path . "/" };
  }

  for my $ext (qw(md yaml)) {
    my $out = $destdir->child("${path}.${ext}");
    $out->parent->mkpath;

    $out->spew( ( $ext eq q{md} ) ? $text : $yaml );
  }

  return { msg => "done: " . $path . "/" };
}

sub main {
  my $destdir = path(shift);

  my $processor = Kalaclista::Sequential::Files->new(
    process => sub {
      my ( $self, $file ) = @_;
      splitting( $destdir, $file );
    },
    result => sub { },
  );

  $processor->run( path(shift)->realpath->stringify, '**', '*.md' );
}

main(@ARGV);
