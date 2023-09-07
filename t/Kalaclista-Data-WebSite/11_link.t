#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test2::V0;
use Kalaclista::Data::WebSite;

subtest 'it should return $permalink value' => sub {
  my $web = Kalaclista::Data::WebSite->new(
    permalink => 'https://example.com',
  );

  is $web->permalink, 'https://example.com',;
};

subtest 'it should reutrn $link value' => sub {
  my $web = Kalaclista::Data::WebSite->new(
    link => 'https://example.com',
  );

  is $web->permalink, 'https://example.com';
};

subtest 'it should return $permalink value istead of $link' => sub {
  my $web = Kalaclista::Data::WebSite->new(
    link      => 'http://example.com',
    permalink => 'https://example.com',
  );

  is $web->permalink, 'https://example.com';
};

subtest 'it should return uri unescaped string' => sub {
  my $web = Kalaclista::Data::WebSite->new( link => 'https://example.com/%E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF' );

  is $web->cite, 'https://example.com/こんにちは';
};

done_testing;
