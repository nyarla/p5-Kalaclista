#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Data::WebSite;

subtest 'loader should load data from csv file' => sub {
  my $path   = Kalaclista::Path->detect(qr{^t$})->child('fixtures')->child('website.csv')->path;
  my $loader = Kalaclista::Data::WebSite::Loader->new( path => $path );

  is $loader->load('https://example.com'), {
    gone      => !!0,
    title     => 'hi',
    link      => 'http://example.com',
    permalink => 'https://example.com',
    summary   => 'hi!',
  };

  is $loader->load('http://example.com'), {
    gone      => !!0,
    title     => 'hi',
    link      => 'http://example.com',
    permalink => 'https://example.com',
    summary   => 'hi!',
  };
};

subtest 'it should load data from csv file by Kalaclista::Data::WebSite->load' => sub {
  my $path = Kalaclista::Path->detect(qr{^t$})->child('fixtures')->child('website.csv')->path;
  Kalaclista::Data::WebSite->init($path);

  my $web = Kalaclista::Data::WebSite->load( text => 'hello', href => 'http://example.com' );

  is $web->title,     'hi';
  is $web->summary,   'hi!';
  is $web->permalink, 'https://example.com';
  is $web->cite,      'https://example.com';
  is $web->gone,      !!0;
};

subtest 'it should fallback to default values' => sub {
  my $path = Kalaclista::Path->detect(qr{^t$})->child('fixtures')->child('website.csv')->path;
  Kalaclista::Data::WebSite->init($path);

  my $web = Kalaclista::Data::WebSite->load( text => 'hello', href => 'https://example.com/hi' );

  is $web->title,     'hello';
  is $web->summary,   'hello';
  is $web->permalink, 'https://example.com/hi';
  is $web->cite,      'https://example.com/hi';
  is $web->gone,      !!0;
};

done_testing;
