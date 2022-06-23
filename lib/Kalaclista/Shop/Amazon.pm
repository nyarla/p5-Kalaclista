package Kalaclista::Shop::Amazon;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
  new => 1,
  ro  => [qw( label asin width height tag )],
);

sub link {
  my $self = shift;

  if ( !exists $self->{'link'} || $self->{'link'} eq q{} ) {
    $self->{'link'} =
      "https://www.amazon.co.jp/dp/@{[ $self->asin ]}?tag=@{[ $self->tag ]}";
  }

  return $self->{'link'};
}

sub image {
  my $self = shift;

  if ( !exists $self->{'image'} || $self->{'image'} eq q{} ) {
    $self->{'image'} =
"https://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=@{[ $self->asin ]}&Format=_SL160_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=@{[ $self->tag ]}&language=ja_JP";

  }

  return $self->{'image'};
}

sub beacon {
  my $self = shift;

  if ( !exists $self->{'beacon'} || $self->{'beacon'} eq q{} ) {
    $self->{'beacon'} =
"https://ir-jp.amazon-adsystem.com/e/ir?t=@{[ $self->tag ]}&language=ja_JP&l=li2&o=9&a=@{[ $self->asin ]}";
  }

  return $self->{'beacon'};
}

1;
