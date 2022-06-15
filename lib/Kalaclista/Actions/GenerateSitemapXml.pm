package Kalaclista::Actions::GenerateSitemapXml;

use strict;
use warnings;

use Kalaclista::Sequential::Files;
use Kalaclista::Entry::Meta;
use Kalaclista::Utils qw( make_fn make_href );
use Kalaclista::HyperScript qw(h);

sub xmlize {
  my @links = sort { $b->href->as_string cmp $a->href->as_string } @_;
  my $xml   = qq|<?xml version="1.0" encoding="UTF-8" ?>|;

  my @loc;
  my $latest;
  for my $meta (@links) {
    my $modified = $meta->lastmod;
    if ( !defined $modified || $modified eq q{} ) {
      $modified = $latest->lastmod;
    }
    $latest = $meta;

    push @loc,
      h( 'url', h( 'loc', $meta->href->as_string ), h( 'lastmod', $modified ) );
  }

  return $xml
    . h( 'urlset', { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' },
    @loc );
}

sub makeHandle {
  my $context = shift;
  my $dir     = $context->dirs->content_dir->realpath;
  my $build   = $context->dirs->build_dir->realpath;
  my $dist    = $context->dirs->distdir->realpath;
  my $baseURI = $context->baseURI;

  return sub {
    my $file = shift;

    my $fn   = make_fn $file->stringify, $build->stringify;
    my $href = make_href $fn, $baseURI;

    my $meta = Kalaclista::Entry::Meta->load(
      src  => $file,
      href => $href,
    );

    $context->call( 'postprocess', $meta );

    return $meta;
  };
}

sub makeSitemapXML {
  my $dist = shift;
  return sub {
    my $xml = xmlize(@_);
    $dist->spew($xml);
  }
}

sub action {
  my $class   = shift;
  my $context = shift;

  my $dist = $context->dirs->distdir->child('sitemap.xml');

  my $runner = Kalaclista::Sequential::Files->new(
    handle => makeHandle($context),
    result => makeSitemapXML($dist),
  );

  return $runner->run( $context->dirs->build_dir->stringify, '**', '*.yaml' );
}

1;
