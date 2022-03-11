#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Parallel::Text;

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
    return { done => "skip: " . $path . "/" };
  }

  for my $ext (qw(md yaml)) {
    my $out = $destdir->child("${path}.${ext}");
    $out->parent->mkpath;

    $out->spew( ( $ext eq q{md} ) ? $text : $yaml );
  }

  return { done => $path . "/" };
}

sub main {
  my $jobs = shift;

  my $destdir   = path("resources/_sources");
  my $contents  = path("private/content")->realpath;
  my $processor = Kalaclista::Parallel::Text->new(
    threads => $jobs,
    source  => sub {
      my ( $processor, $file ) = @_;
      return [ $destdir, $file ];
    },
    process => sub {
      my ( $processor, $args ) = @_;
      my ( $destdir,   $file ) = $args->@*;

      return splitting( $destdir, $file );
    },
  );

  $processor->run( $contents->stringify, "**", "*.md" );
}

main(@ARGV);
