package Kalaclista::HyperScript::HTMLUtils;

use strict;
use warnings;

use Kalaclista::HyperScript qw( html link_ meta true );

use Exporter 'import';

our @EXPORT = qw(
  document
  webfont
  feed
  property
  data_
);

sub document {
  my ( $head, $body ) = @_;
  return q(<!doctype html>) . html( { lang => 'ja' }, $head, $body );
}

sub webfont {
  my ( $type, $href ) = @_;
  return link_(
    {
      rel         => 'preload',
      as          => 'font',
      type        => $type,
      href        => $href,
      crossorigin => true,
    }
  );
}

sub feed {
  my ( $title, $href, $type ) = @_;
  return link_(
    {
      rel   => 'alternate',
      title => $title,
      href  => $href,
      type  => $type,
    }
  );
}

sub property {
  my ( $name, $data ) = @_;
  return meta( { property => $name, content => $data } );
}

sub data_ {
  my ( $name, $data ) = @_;
  return meta( { name => $name, content => $data } );
}

1;
