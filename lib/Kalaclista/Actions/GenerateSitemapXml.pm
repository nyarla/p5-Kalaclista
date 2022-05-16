package Kalaclista::Actions::GenerateSitemapXml;

use strict;
use warnings;

use Kalaclista::Sequential::Files;
use Kalaclista::Entry::Meta;
use Kalaclista::Utils qw( make_fn make_href );
use Kalaclista::HyperScript qw(h);

sub sitemap_xml {
  my @urls = sort { $b->href->as_string cmp $a->href->as_string } @_;
  my $out  = qq{<?xml version="1.0" encoding="UTF-8"?>\n};
  my @loc  = ();

  my $latest;
  while ( defined( my $url = shift @urls ) ) {
    my $modified = $url->lastmod;
    if ( $modified eq q{} ) {
      $modified = $latest->lastmod;
    }

    push @loc,
      h( 'url',
      [ h( 'loc', $url->href->as_string ), h( 'lastmod', $modified ), ] );

    $latest = $url;
  }

  return $out
    . h( 'urlset', { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
    \@loc );
}

sub action {
  my $class = shift;
  my $app   = shift;

  my $dir   = $app->config->dirs->content_dir->realpath;
  my $build = $app->config->dirs->build_dir->realpath;
  my $out   = $app->config->dirs->distdir->realpath;

  my $baseURI = $app->config->baseURI;

  my $runner = Kalaclista::Sequential::Files->new(
    handle => sub {
      my $file = shift;

      my $fn   = make_fn $file->stringify, $build->stringify;
      my $href = make_href $fn, $baseURI;

      my $meta = Kalaclista::Entry::Meta->load(
        src  => $file,
        href => $href,
      );

      $app->config->call( 'postprocess.entry.meta', $meta );

      return $meta;
    },

    result => sub {
      my $xml = sitemap_xml(@_);

      $out->child('sitemap.xml')->spew($xml);
    },
  );

  return $runner->run( $build->stringify, "**", "*.yaml" );
}

1;
