#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test2::V0;
use URI::Fast;

use Kalaclista::Data::WebSite;

subtest internal => sub {
  my $website = Kalaclista::Data::WebSite->new(
    label   => 'テスト',
    title   => 'テストウェブサイト',
    summary => 'これはテストです',
    href    => URI::Fast->new('https://テスト.com/example/テスト/'),
  );

  is $website->label,   'テスト';
  is $website->title,   'テストウェブサイト';
  is $website->summary, 'これはテストです';
  is $website->cite,    'https://テスト.com/example/テスト/';

  ok $website->internal;
  ok !$website->external;
};

subtest external => sub {
  my $website = Kalaclista::Data::WebSite->new(
    title => 'テストウェブサイト',
    href  => URI::Fast->new('https://テスト.com/example/テスト/'),
    gone  => !!1,
  );

  is $website->title,           'テストウェブサイト';
  is $website->href->to_string, $website->link->to_string;
  is $website->cite,            'https://テスト.com/example/テスト/';
  ok $website->gone;

  ok !$website->internal;
  ok $website->external;
};

done_testing;
