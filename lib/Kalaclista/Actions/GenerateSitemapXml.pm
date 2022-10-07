package Kalaclista::Actions::GenerateSitemapXml;

use strict;
use warnings;

use Text::HyperScript qw(h);

use Kalaclista::Entries;

sub xmlize {
  my @links = sort { $b->href->as_string cmp $a->href->as_string } @_;
  my $xml   = qq|<?xml version="1.0" encoding="UTF-8" ?>|;

  my @loc;
  my $latest;
  for my $entry (@links) {
    my $modified = $entry->lastmod;
    if ( !defined $modified || $modified eq q{} ) {
      $modified = $latest->lastmod;
    }
    $latest = $entry;

    push @loc,
        h( 'url', h( 'loc', $entry->href->as_string ), h( 'lastmod', $modified ) );
  }

  return $xml . h(
    'urlset', { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
    @loc
  );
}

sub action {
  my ( $class, $c ) = @_;

  my $dist    = $c->dirs->distdir->child('sitemap.xml');
  my $content = $c->dirs->content_dir->stringify;
  my $baseURI = $c->baseURI;

  my $loader  = Kalaclista::Entries->new( $content, $baseURI );
  my @entries = $loader->entries->@*;

  $dist->spew_utf8( xmlize(@entries) );

  return 1;
}

1;
