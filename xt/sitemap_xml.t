#!/usr/bin/perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Directory;

use Kalaclista::Test::DateTime qw( match_datetime );
use Kalaclista::Test::URI qw(
  is_pages
  is_posts
  is_echos
  is_notes
  is_permalink
);

use XML::LibXML;

use URI;

sub main {
  my $xml = XML::LibXML->load_xml(
    string => Kalaclista::Directory->distdir->child('sitemap.xml')->slurp );

  my $xc = XML::LibXML::XPathContext->new($xml);
  $xc->registerNs( 'm', 'http://www.sitemaps.org/schemas/sitemap/0.9' );

  for my $node ( $xc->findnodes('//m:url')->get_nodelist ) {
    my $loc = URI->new( $xc->findnodes( 'm:loc', $node )->pop->textContent );
    my $lastmod = $xc->findnodes( 'm:lastmod', $node )->pop->textContent;

    match_datetime($lastmod);

    is( $loc->scheme, 'https' );
    is( $loc->host,   'the.kalaclista.com' );

    if ( is_pages($loc) ) {
      ok(1);
      next;
    }

    if ( is_posts($loc) || is_echos($loc) || is_notes($loc) ) {
      ok( is_permalink($loc) );
      next;
    }

    ok(0);
  }

  done_testing;
}

main;
