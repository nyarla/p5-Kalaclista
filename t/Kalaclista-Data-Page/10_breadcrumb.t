#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use URI::Fast;

use Kalaclista::Data::Page;

subtest new => sub {
  my $breadcrumb = Kalaclista::Data::Page::Breadcrumb->new;

  isa_ok( $breadcrumb, 'Kalaclista::Data::Page::Breadcrumb' );
};

subtest accessors => sub {
  my $b = Kalaclista::Data::Page::Breadcrumb->new;

  $b->push(
    label   => 'test',
    title   => 'this is a test',
    summary => 'this is a test breadcrumb item',
    href    => URI::Fast->new('http://example.com/this/is/a/test'),
  );

  is $b->length, 1, 'this value should be `1`';

  isa_ok( $b->index(0), 'Kalaclista::Data::WebSite::Internal' );
};

done_testing;
