package Kalaclista::Actions::GenerateSitemapXml;

use strict;
use warnings;

use Kalaclista::Sequential::Files;
use Kalaclista::Entry::Meta;
use Kalaclista::Utils qw( make_fn make_href );
use Kalaclista::HyperScript qw(h);
use Kalaclista::Files;
use Path::Tiny;

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
  my $build   = $context->dirs->build_dir->child('contents');
  my $baseURI = $context->baseURI;

  return sub {
    my $file = shift;

    my $fn   = make_fn $file->stringify, $build->stringify;
    my $href = make_href $fn, $baseURI;

    my $meta = Kalaclista::Entry::Meta->load(
      src  => $file,
      href => $href,
    );

    $context->call( fixup => $meta );

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

sub files {
  my ( $class, $rootdir ) = @_;

  return map { path($_) }
    grep { $_ =~ m{\.yaml$} } Kalaclista::Files->find($rootdir);
}

sub action {
  my $class   = shift;
  my $context = shift;

  my $dist = $context->dirs->distdir->child('sitemap.xml');

  my $runner = Kalaclista::Sequential::Files->new(
    handle => makeHandle($context),
    result => makeSitemapXML($dist),
  );

  return $runner->run( $class->files( $context->dirs->build_dir->stringify ) );
}

1;
