#!/usr/bin/env perl

use strict;
use warnings;

use Test2::V0;
use Kalaclista::Content;
use Kalaclista::Directory;
use HTML5::DOM;

sub main {
  my $content = Kalaclista::Content->new(
    src  => Kalaclista::Directory->rootdir,
    dst  => Kalaclista::Directory->rootdir->child('t/Kalaclista-Content'),
    text => <<'...' );
  <p>
    <img  alt="foo"
          src="https://the.kalaclista.com/t/Kalaclista-Content/fixture.png" />
  </p>
...

  is(
    $content->expand_block_image->at('p.img')->html,
    HTML5::DOM->new->parse(<<'...')->at('p.img')->html );
<p class="img">
  <a href="" title="foo">
    <img alt="foo" src="https://the.kalaclista.com/t/Kalaclista-Content/fixture.png"
    srcset="https://the.kalaclista.com/t/Kalaclista-Content/fixture_1x.png 1x, https://the.kalaclista.com/t/Kalaclista-Content/fixture_2x.png 2x" width="720" height="405">
  </a>
</p>
...

  done_testing;
}

main;
