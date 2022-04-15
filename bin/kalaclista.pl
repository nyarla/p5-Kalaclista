#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Directory;
use Kalaclista::Sequential::Files;
use Kalaclista::Utils qw( split_md make_fn );

use Kalaclista::Page::SitemapXML;

use URI;

my $dirs = Kalaclista::Directory->instance(
  dist    => 'dist/the.kalaclista.com',
  data    => 'private/the.kalaclista.com/cache',
  assets  => 'private/the.kalaclista.com/assets',
  content => 'private/the.kalaclista.com/content',
  build   => 'resources',
);

my $build = $dirs->build_dir;

sub msg ($) {
  my $msg = shift;
  print $msg, "\n";
}

sub _split_content {
  msg 'Split files to `md` and `yaml`';

  my $runner = Kalaclista::Sequential::Files->new(
    handle => sub {
      my $file = shift;
      my ( $yaml, $md ) = split_md $file;

      my $path = make_fn $file->stringify, $dirs->content_dir->stringify;

      $build->child( '_content', $path )->parent->mkpath;
      $build->child( '_content', "${path}.md" )->spew($md);
      $build->child( '_content', "${path}.yaml" )->spew($yaml);
    }
  );

  $runner->run( $dirs->content_dir->stringify, '**', '*.md' );
}

sub main {
  my $production = (shift) eq 'production';

  my $domain   = ($production) ? 'the.kalaclista.com' : 'nixos:1313';
  my $protocol = ($production) ? 'https'              : 'http';
  my $baseURI  = URI->new("${protocol}://${domain}");

  _split_content;

  my $sitemap_xml = Kalaclista::Page::SitemapXML->new(
    baseURI => $baseURI,
    basedir => $build->child('_content'),
  );

  $dirs->distdir->mkpath;

  $sitemap_xml->output( $dirs->distdir->child('sitemap.xml') );

}

main(@ARGV);
