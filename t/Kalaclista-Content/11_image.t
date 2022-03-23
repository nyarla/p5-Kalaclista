#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use HTML5::DOM;

use Kalaclista::Content;
use Kalaclista::Directory;
use Kalaclista::HyperScript qw(p a img);

sub main {
  my $in = p(
    img(
      {
        alt => 'foo',
        src => 'https://the.kalaclista.com/t/Kalaclista-Content/fixture.png'
      }
    )
  );

  my $out = p(
    { class => 'img' },
    a(
      {
        href  => 'https://the.kalaclista.com/t/Kalaclista-Content/fixture.png',
        title => 'foo'
      },
      img(
        {
          src => 'https://the.kalaclista.com/t/Kalaclista-Content/fixture.png',
          alt => 'foo',
          srcset =>
"https://the.kalaclista.com/t/Kalaclista-Content/fixture_1x.png 1x, https://the.kalaclista.com/t/Kalaclista-Content/fixture_2x.png 2x",
          width  => 720,
          height => 405,
        }
      )
    )
  );

  my $content = Kalaclista::Content->new(
    src    => Kalaclista::Directory->rootdir,
    outdir => Kalaclista::Directory->rootdir->child('t/Kalaclista-Content'),
    text   => $in,
  );

  is(
    $content->expand_block_image->at('p.img')->html,
    HTML5::DOM->new->parse($out)->at('p.img')->html,
  );

  done_testing;
}

main;
