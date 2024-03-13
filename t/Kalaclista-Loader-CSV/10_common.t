#!/usr/bin/env perl

use v5.38;
use utf8;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Loader::CSV;

subtest loadcsv => sub {
  my $root    = Kalaclista::Path->detect(qr{^t$});
  my $fixture = $root->child('t/Kalaclista-Loader-CSV/example.csv')->path;

  loadcsv $fixture => sub {
    my ( $foo, $bar, $baz ) = @_;

    is $foo, 'foo';
    is $bar, 'bar';
    is $baz, 'baz';
  };
};

done_testing;
