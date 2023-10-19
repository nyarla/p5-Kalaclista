package Kalaclista::Generators::SitemapXML;

use strict;
use warnings;

use Text::HyperScript qw(h raw);

use YAML::XS;

sub generate {
  my ( $class, %args ) = @_;

  my $file = delete $args{'file'};
  my $src  = delete $args{'entries'};

  $file->emit( xmlize( $src->entries->@* ) );
}

sub xmlize {
  my @entries = sort { $b->href->to_string cmp $a->href->to_string } @_;
  my $xmldoc  = qq|<?xml version="1.0" encoding="UTF-8"?>|;

  my $out;
  for my $entry (@entries) {
    $out .= h( url => h( loc => $entry->href->to_string ), h( lastmod => $entry->lastmod ) );
  }

  return $xmldoc . h( urlset => { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' }, raw($out) );
}

1;
