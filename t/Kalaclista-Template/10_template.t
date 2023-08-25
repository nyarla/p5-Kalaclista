#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
  use Kalaclista::Path;
  use lib Kalaclista::Path->detect(qr{t})->child('lib')->path;
}

use Test2::V0;
use Kalaclista::Template qw(load);

subtest "it's should be loading template renderer" => sub {
  my $renderer = load('Test::Kalaclista::Templates::Test');
  is ref $renderer, 'CODE';
};

subtest "it's should be using renderer cache" => sub {
  is load('Test::Kalaclista::Templates::Test'), Test::Kalaclista::Templates::Test->can('render');

  no strict 'refs';
  *{'Test::Kalaclista::Templates::Test::render'} = sub{};
  use strict 'refs';

  isnt load('Test::Kalaclista::Templates::Test'), Test::Kalaclista::Templates::Test->can('render');
};

done_testing;
