#!/usr/bin/env perl

use v5.38;
use utf8;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Loader::Content;

my $path = Kalaclista::Path->tempfile;
$path->emit(<<"...");
---
title: hello, 世界
---

This is the test message.
...

subtest header => sub {
  my $header = header $path->to_string;

  is $header, {
    title => 'hello, 世界',
  };
};

subtest content => sub {
  my $content = content $path->to_string;

  is $content, <<"...";

This is the test message.
...
};

subtest readall => sub {
  my ( $header, $content ) = readall $path->to_string;

  is $header, { title => 'hello, 世界' };
  is $content, <<"...";

This is the test message.
...
};

done_testing;
