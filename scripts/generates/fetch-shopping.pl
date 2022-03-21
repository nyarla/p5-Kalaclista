#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Kalaclista::Directory;
use Kalaclista::Sequential::Files;
use Kalaclista::Content;

use Path::Tiny;
use YAML::Tiny;
use Image::Scale;

my $ua = 'Mozilla/5.0 (X11; Linux x86_64; rv:98.0) Gecko/20100101 Firefox/98.0';
my @shops = (
  qr<item.rakuten.co.jp>,       qr<www.amazon.co.jp>,
  qr<www.audio-technica.co.jp>, qr<www.hidizs.co>,
  qr<www.oneplus.com>,          qr<www.yodobashi.com>,
);

sub extract {
  my ($file) = @_;

  my $content = Kalaclista::Content->new( text => $file->slurp_utf8 );
  my $dom     = $content->dom;

  my @items;
  for my $node ( $dom->find('p > a:only-child')->@* ) {
    my $parent = $node->parent;
    my $href   = $node->getAttribute('href');
    if ( $parent->firstChild->isSameNode( $parent->lastChild )
      && is_shop($href) )
    {
      push @items,
        +{
        name => $node->textContent,
        href => $href,
        };
    }
  }

  return { items => \@items };
}

sub is_shop {
  my $href = shift;
  return grep { $href =~ $_ } @shops;
}

sub put {
  my $item = shift;
  my $dest = shift;

  my $fn = $item->{'name'};
  $fn =~
s{[^\p{InHiragana}\p{InKatakana}\p{InCJKUnifiedIdeographs}a-zA-Z0-9\-_]}{_}g;
  $fn =~ s{_+}{_}g;

  my $cache = Kalaclista::Directory->rootdir->child( $dest, "${fn}.yaml" );

  my $msg = $item->{'name'};
  utf8::encode($msg);

  if ( $cache->exists ) {
    print "Skip: ${msg}", "\n";
    return 1;
  }

  print "Fetch: ${msg}", "\n";

  my $out;

  if ( $item->{'href'} =~ m{([A-Z0-9]{10})} ) {
    my $ASIN = $1;
    my $TAG  = 'nyarla-22';
    my $image =
"https://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=${ASIN}&Format=_SL160_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=${TAG}&language=ja_JP";
    my $size = fetch_image_size($image);

    $out = YAML::Tiny::Dump(
      {
        name => $item->{'name'},
        data => [
          {
            provider => 'amazon',
            asin     => $ASIN,
            tag      => $TAG,
            size     => $size,
          },
          {
            provider => 'rakuten',
            search   => $item->{'name'},
            image    => '',
            size     => '',
          }
        ],
      }
    );
  }
  elsif ( $item->{'href'} =~ m{rakuten\.co\.jp} ) {
    $out = YAML::Tiny::Dump(
      {
        name => $item->{'name'},
        data => [
          {
            provider => 'rakuten',
            search   => $item->{'name'},
            image    => '',
            size     => '',
          }
        ]
      }
    );
  }
  else {
    $out = YAML::Tiny::Dump(
      {
        name => $item->{'name'},
        data => [],
      }
    );
  }

  if ( !$cache->exists ) {
    $cache->parent->mkpath;
    $cache->spew_utf8($out);
  }

  return 1;
}

sub fetch_image_size {
  my $href   = shift;
  my $result = `curl -s -L -A '${ua}' '${href}' | identify - | cut -d\\   -f3`;

  sleep( 2 + rand(3) );

  if ( defined $result && $result ne q{} ) {
    chomp($result);
    return $result;
  }

  return q{};
}

sub main {
  my $src  = shift;
  my $dest = shift;

  my $processor = Kalaclista::Sequential::Files->new(
    process => sub {
      my ( $processor, $file ) = @_;

      for my $item ( extract($file)->{'items'}->@* ) {
        put( $item, $dest );
      }

      return 1;
    },
    result => sub {
      print "Done", "\n";
    },
  );

  $processor->run( $src, "**", "*.md" );
}

main(@ARGV);
