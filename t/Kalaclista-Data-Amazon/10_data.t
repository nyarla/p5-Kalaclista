#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Data::Amazon;

subtest "it's should be accessable to property data" => sub {
  my $data = Kalaclista::Data::Amazon->new(
    title => 'Test',
    link  => 'http://example.com',
    image => '<img src="test.png" width="1" height="1" />',
  );

  is $data->title, 'Test';
  is $data->link,  'http://example.com';
  is $data->image, '<img src="test.png" width="1" height="1" />';
};

done_testing;
