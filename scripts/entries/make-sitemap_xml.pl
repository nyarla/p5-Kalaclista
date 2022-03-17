#!/usr/bin/env perl

use strict;
use warnings;

use Kalaclista::Constants qw(linkify);
use Kalaclista::Sequential::Files;

use Path::Tiny;
use Path::Tiny::Glob;
use YAML::Tiny;
use Time::Moment;

sub loc {
  my ( $link, $datetime ) = @_;
  return "<url><loc>${link}</loc><lastmod>${datetime}</lastmod></url>";
}

sub xmlize {
  my $file = shift;
  my $src  = $file->slurp;
  my $data = YAML::Tiny::Load($src);

  my $date = (
    do {
      my $str = $data->{'lastmod'} // $data->{'date'};
      if ( defined($str) && $str ne q{} ) {
        Time::Moment->from_string($str);
      }
      else {
        Time::Moment->now();
      }
    }
  )->strftime('%Y-%m-%dT%H:%M:%S%Z');

  my $permalink = do {
    my $str = ( split q{_sources}, $file->stringify )[1];
    $str =~ s{.yaml}{/};
    linkify($str)->as_string;
  };

  return loc( $permalink, $date );
}

sub main {
  my $source = shift;
  my $dest   = path(shift);
  my $fh     = $dest->openw;

  print $fh '<?xml version="1.0" encoding="utf-8" ?>';
  print $fh "\n";
  print $fh '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';

  my $processor = Kalaclista::Sequential::Files->new(
    process => sub {
      my ( $self, $file ) = @_;
      return xmlize($file);
    },
    result => sub {
      my $self = shift;
      my $fh   = $dest->openw;

      print $fh '<?xml version="1.0" encoding="utf-8" ?>';
      print $fh "\n";
      print $fh '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';

      for my $xml ( sort { $b cmp $a } @_ ) {
        print $fh $xml;
      }

      print $fh '</urlset>';

      $fh->close;
    },
  );

  $processor->run( $source, '**', '*.yaml' );
}

main(@ARGV);
