#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test2::V0;

use Kalaclista::Directory;
use Kalaclista::Sequential::Files;

use YAML::Tiny;

sub msg {
  my $msg  = shift;
  my $file = shift->stringify;

  utf8::decode($file);

  return $msg . ": " . $file;
}

sub testing_amazon {
  my $item = shift;
  my $file = shift;

  is( $item->{'provider'}, 'amazon', msg( "item provider is amazon", $file ) );

  like( $item->{'asin'}, qr{^[A-Z0-9]{10}$},
    msg( "item has valid asin", $file ) );

  is( $item->{'tag'}, 'nyarla-22', msg( "item.tag eq nyarla-22", $file ) );
  like( $item->{'size'}, qr{^\d+x\d+$},
    msg( 'item.size is valid format', $file ) );
}

sub testing_rakuten {
  my $item = shift;
  my $file = shift;

  is( $item->{'provider'}, 'rakuten',
    msg( "item provider is rakuten", $file ) );

  if ( exists $item->{'shop'} ) {
    like( $item->{'shop'}, qr{^https://},
      msg( 'item.shop is not empty', $file ) );
    like( $item->{'image'}, qr{^https://},
      msg( 'item.image is not empty', $file ) );
    ok( $item->{'size'} ne q{}, msg( 'item.size is not empty', $file ) );
  }
  else {
    ok( $item->{'search'} ne q{}, msg( 'item.search is not empty', $file ) );
  }
}

sub testing_others {
  my $item = shift;
  my $file = shift;

  ok( $item->{'provider'} ne q{}, msg( 'item.provider is not empty.', $file ) );
  ok( $item->{'link'} ne q{},     msg( 'item.link is not empty.',     $file ) );
}

sub testing {
  my $file = shift;
  my $data = YAML::Tiny::Load( $file->slurp );

  ok( exists $data->{'name'} && $data->{'name'} ne q{},
    msg( "name field exists", $file ) );

  ok( exists $data->{'data'}, msg( "data field exists", $file ) );
  is( ref $data->{'data'}, 'ARRAY', msg( "data is ArrayRef", $file ) );
  ok( scalar( $data->{'data'}->@* ) > 0,
    msg( "data field has one or multiple items", $file ) );

  for my $item ( $data->{'data'}->@* ) {
    ok( exists $item->{'provider'},
      msg( "data.item has provider field", $file ) );

    if ( $item->{'provider'} eq 'amazon' ) {
      testing_amazon( $item, $file );
    }
    elsif ( $item->{'provider'} eq 'rakuten' ) {
      testing_rakuten( $item, $file );
    }
    else {
      testing_others( $item, $file );
    }
  }

  if ( $data->{'data'}->@* == 1
    && $data->{'data'}->[0]->{'provider'} eq 'rakuten' )
  {
    my $item = $data->{'data'}->[0];
    ok(
      exists $item->{'image'} && $item->{'image'} ne q{},
      msg( "data[0].image should exists", $file )
    );
    ok(
      exists $item->{'size'} && $item->{'size'} ne q{},
      msg( "data[0].size should exists", $file )
    );
    ok(
      exists $item->{'shop'} && $item->{'shop'} ne q{},
      msg( "data[0].shop should exists", $file )
    );
  }
}

sub main {
  my $dirs = Kalaclista::Directory->instance(
    data => 'private/the.kalaclista.com/cache',
    dist => 'dist/the.kalaclista.com',
  );

  my $src = $dirs->datadir->child('shopping')->realpath;

  my $processor = Kalaclista::Sequential::Files->new(
    handle => sub {
      return testing(shift);
    },
    result => sub { done_testing },
  );

  $processor->run( $src->stringify, "*.yaml" );
}

main;
