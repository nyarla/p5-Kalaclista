#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Config::Kalaclista qw(config);
use Kalaclista::Directory;
use Kalaclista::Sequential::Files;
use Kalaclista::Utils qw( split_md make_fn );

use Kalaclista::Page::SitemapXML;

use URI;

my $dirs  = config->dirs;
my $build = $dirs->build_dir;

my $actions = { split => \&_split_content, sitemap => \&_gen_sitemap_xml };

sub msg ($) {
  my $msg = shift;
  print $msg, "\n";
}

sub _split_content {
  msg q|split .md -> .md and .yaml |;

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

  return 0;
}

sub _gen_sitemap_xml {
  my $baseURI = shift;

  my $sitemap = Kalaclista::Page::SitemapXML->new(
    baseURI => $baseURI,
    srcdir  => $build->child('_content'),
  );

  $dirs->distdir->mkpath;
  $sitemap->emit( $dirs->distdir->child('sitemap.xml') );

  return 0;
}

sub main {
  my $production = (shift) eq 'production';
  my $action     = shift;

  my $domain   = ($production) ? 'the.kalaclista.com' : 'nixos:1313';
  my $protocol = ($production) ? 'https'              : 'http';
  my $baseURI  = URI->new("${protocol}://${domain}");

  if ( exists $actions->{$action} ) {
    exit $actions->{$action}->($baseURI);
  }

  print STDERR "this action is not found: ${action}", "\n";
  exit 1;
}

main(@ARGV);
