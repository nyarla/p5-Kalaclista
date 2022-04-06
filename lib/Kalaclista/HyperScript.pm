package Kalaclista::HyperScript;

use strict;
use warnings;

use Exporter 'import';
use HTML::Escape;
use Carp qw(confess);

BEGIN {
  our @EXPORT = qw(
    h text

    a
    abbr
    address
    area
    article
    aside
    audio
    b
    bdi
    bdo
    blockquote
    br
    button
    canvas
    caption
    cite
    code
    col
    colgroup
    data
    datalist
    dd
    del
    details
    dfn
    dialog
    div
    dl
    dt
    em
    fieldset
    figcaption
    figure
    footer
    form
    h1
    h2
    h3
    h4
    h5
    h6
    header
    hr
    i
    iframe
    img
    input
    ins
    kbd
    label
    legend
    li
    main
    map
    mark
    menuitem
    meter
    nav
    object_
    ol
    optgroup
    option
    output
    p
    param
    picture
    pre
    progress
    q
    rp
    rt
    rtc
    ruby
    s
    samp
    section
    select_
    small
    source
    span
    strong
    sub_
    summary
    sup
    table
    tbody
    td
    textarea
    tfoot
    th
    thead
    time_
    tr
    track
    ul
    video
    wbr
  );

  for my $method (@EXPORT) {
    next if ( $method eq 'h' );
    my $tag = $method;
    $tag =~ s{_}{}g;

    no strict 'refs';
    *{ __PACKAGE__ . "::${method}" } = sub {
      return h( $tag, @_ );
    };
  }
}

sub h {
  if ( @_ > 3 ) {
    confess("invalid usage");
  }

  my $tag = shift;
  my $attrs;
  my $contents;
  my $text;

  for my $item (@_) {
    if ( !ref $item ) {
      $text = $item;
    }
    elsif ( ref $item eq 'ARRAY' ) {
      $contents = $item;
    }
    elsif ( ref $item eq 'HASH' ) {
      $attrs = $item;
    }
  }

  $attrs    //= {};
  $contents //= [];
  $text     //= q{};

  my $attr = q{};
  for my $name ( sort keys $attrs->%* ) {
    $attr .= qq< ${name}="> . escape_html( $attrs->{$name} ) . qq<">;
  }

  my $out = q{};
  if ( $contents->@* == 0 && $text eq q{} ) {
    return qq{<${tag}${attr} />};
  }

  if ( $contents->@* == 0 && $text ne q{} ) {
    return qq{<${tag}${attr}>${text}</${tag}>};
  }

  return qq{<${tag}${attr}>@{[ join q{}, $contents->@* ]}</${tag}>};
}

sub text {
  my $text = shift;
  return escape_html($text);
}

1;
