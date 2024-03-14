#!/usr/bin/env perl

use v5.38;
use utf8;

use Test2::V0;
use Kalaclista::Data::Thumbnail;

subtest common => sub {
  my $thumbnail = Kalaclista::Data::Thumbnail->new(
    thumbnail   => 'test',
    type        => 'test',
    title       => 'test',
    description => 'test',
  );

  is $thumbnail->thumbnail,   'test';
  is $thumbnail->type,        'test';
  is $thumbnail->title,       'test';
  is $thumbnail->description, 'test';
};

done_testing;
