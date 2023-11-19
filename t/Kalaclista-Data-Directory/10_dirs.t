#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;

use Kalaclista::Path;
use Kalaclista::Data::Directory;

my sub instance { return Kalaclista::Data::Directory->instance }

subtest default => sub {
  Kalaclista::Data::Directory->instance( detect => qr{^t$} );
  my sub instance { return Kalaclista::Data::Directory->instance }
  my $path = Kalaclista::Path->detect(qr{^t$});

  subtest rootdir => sub {
    is $path->path, instance->rootdir->path;
  };

  subtest cachedir => sub {
    is $path->child('cache')->path, instance->cachedir->path;
  };

  subtest cache => sub {
    is $path->child('cache/file')->path, instance->cache('file')->path;
  };

  subtest distdir => sub {
    is $path->child('dist')->path, instance->distdir->path;
  };

  subtest dist => sub {
    is $path->child('dist/file')->path, instance->dist('file')->path;
  };

  subtest srcdir => sub {
    is $path->child('src')->path, instance->srcdir->path;
  };

  subtest src => sub {
    is $path->child('src/file')->path, instance->src('file')->path;
  };
};

subtest custom => sub {
  Kalaclista::Data::Directory->instance(
    detect => qr{^t$},
    cache  => 't/cache',
    dist   => 't/dist',
    src    => 't/src',
  );
  my $path = Kalaclista::Path->detect(qr{^t$});

  subtest rootdir => sub {
    is $path->path, instance->rootdir->path;
  };

  subtest cachedir => sub {
    is $path->child('t/cache')->path, instance->cachedir->path;
  };

  subtest cache => sub {
    is $path->child('t/cache/file')->path, instance->cache('file')->path;
  };

  subtest distdir => sub {
    is $path->child('t/dist')->path, instance->distdir->path;
  };

  subtest dist => sub {
    is $path->child('t/dist/file')->path, instance->dist('file')->path;
  };

  subtest srcdir => sub {
    is $path->child('t/src')->path, instance->srcdir->path;
  };

  subtest src => sub {
    is $path->child('t/src/file')->path, instance->src('file')->path;
  };

};

done_testing;
