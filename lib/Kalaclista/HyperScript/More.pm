package Kalaclista::HyperScript::More;

use strict;
use warnings;

use Kalaclista::HyperScript qw( html link_ meta true );

use Exporter 'import';
use JSON::Tiny qw(encode_json);

our @EXPORT = qw(
  document
  feed
  property
  data_
  jsonld
);

sub document {
  my ( $head, $body ) = @_;
  return q(<!doctype html>) . html( { lang => 'ja' }, $head, $body );
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

sub jsonld {
  my ( $desc, @items ) = @_;
  my $jsonld = encode_json( [ jsonld_self($desc), jsonld_breadcrumb(@items) ] );
  utf8::decode($jsonld);
  $jsonld =~ s{\\/}{/}g;
  return $jsonld;
}

sub jsonld_self {
  my $desc = shift;

  return {
    '@context'  => 'https://schema.org',
    '@id'       => $desc->{'href'},
    '@type'     => $desc->{'type'},
    'headline'  => $desc->{'title'},
    'author'    => $desc->{'author'},
    'publisher' => $desc->{'publisher'},
    'image'     => {
      '@type' => 'URL',
      'url'   => $desc->{'image'},
    },
    (
      exists $desc->{'parent'}
      ? ( 'mainEntryOfPage' => { '@id' => $desc->{'parent'} } )
      : ()
    ),
  };
}

sub jsonld_breadcrumb {
  my @items = @_;
  my $out   = [];
  my $idx   = 1;

  for my $item (@items) {
    push $out->@*,
      +{
      '@type'    => 'ListItem',
      'item'     => $item->{'href'},
      'name'     => $item->{'name'},
      'position' => $idx,
      };

    $idx++;
  }

  return {
    '@context'        => 'https://schema.org',
    '@type'           => 'BreadcrumbList',
    'itemListElement' => $out,
  };
}

1;
