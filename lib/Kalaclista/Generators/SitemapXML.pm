package Kalaclista::Generators::SitemapXML;

use strict;
use warnings;

use Text::HyperScript qw(h raw);

use YAML::XS;

sub generate {
  my ( $class, %args ) = @_;

  my $file    = delete $args{'dist'};
  my $entries = delete $args{'entries'};

  my $xml = xmlize($entries);

  $file->emit( xmlize($entries) );
}

sub compare {
  my ( $a, $b ) = @_;

  my $cmpA = $a->updated;
  my $cmpB = $b->updated;

  my $cmp = $cmpB cmp $cmpA;
  return $cmp if ( $cmp != 0 );
  return $b->href->path cmp $a->href->path;
}

sub xmlize {
  my $entries = shift;

  my $xmldoc = qq|<?xml version="1.0" encoding="UTF-8" ?>|;

  my $out;
  for my $entry ( sort { compare( $a, $b ) } $entries->@* ) {
    my $loc  = h( loc     => $entry->href->to_string );
    my $date = h( lastmod => $entry->updated );

    $out .= h( url => [ $loc, $date ] );
  }

  return $xmldoc . h( urlset => { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' }, raw($out) );
}

1;
