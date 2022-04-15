#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Path::Tiny;
use YAML::Tiny;

use Kalaclista::Sequential::Files;

use Kalaclista::Shop::Amazon;
use Kalaclista::Shop::Rakuten;

sub process {
  my $file = shift;
  my $data = YAML::Tiny::Load( $file->slurp_utf8 );

  my @out;
  for my $payload ( $data->{'data'}->@* ) {
    if ( $payload->{'provider'} eq 'amazon' ) {
      my $item = Kalaclista::Shop::Amazon->new(
        label => $data->{'name'},
        asin  => $payload->{'asin'},
        size  => $payload->{'size'},
        tag   => $payload->{'tag'},
      );

      push @out,
        +{
        provider => 'amazon',
        link     => $item->link,
        image    => $item->image,
        size     => $item->size,
        beacon   => $item->beacon,
        };
    }

    if ( $payload->{'provider'} eq 'rakuten' ) {
      my $item = Kalaclista::Shop::Rakuten->new(
        label  => $data->{'name'},
        search => $payload->{'search'},
        size   => $payload->{'size'},
        image  => $payload->{'image'},
        shop   => $payload->{'shop'},
      );

      push @out,
        +{
        provider => 'rakuten',
        link     => $item->link,
        image    => $item->image,
        size     => $item->size,
        };
    }
  }

  return {
    name      => $data->{'name'},
    providers => \@out,
  };
}

sub main {
  my $src = path(shift)->realpath->stringify;

  my $processor = Kalaclista::Sequential::Files->new(
    handle => sub {
      my ($file) = @_;
      return process($file);
    },
    result => sub {
      my (@results) = @_;

      my $out = {};
      for my $result (@results) {
        $out->{ $result->{'name'} } = $result->{'providers'};
      }
      print YAML::Tiny::Dump($out);
    },
  );

  $processor->run( $src, '**', '*.yaml' );
}

main(@ARGV);
