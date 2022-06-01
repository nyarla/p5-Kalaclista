package Kalaclista::HyperScript;

use strict;
use warnings;

use Exporter 'import';
use HTML::Escape;
use Carp qw(confess);

BEGIN {
  our @EXPORT = qw(
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
    body
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
    head
    header
    hr
    html
    i
    iframe
    img
    input
    ins
    kbd
    label
    legend
    li
    link_
    main
    map
    mark
    menuitem
    meta
    meter
    nav
    object
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
    script
    section
    select_
    small
    style
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
    title
    time_
    tr
    track
    ul
    video
    wbr
  );

  for my $method (@EXPORT) {
    my $tag = $method;
    $tag =~ s{_}{}g;

    no strict 'refs';
    *{ __PACKAGE__ . "::${method}" } = sub {
      return h( $tag, @_ );
    };
  }

  push @EXPORT, qw( h text true false );
}

sub true {
  my $bool = !!1;
  return bless \$bool, 'Kalaclista::HyperScirpt::Boolean';
}

sub false {
  my $bool = !!0;
  return bless \$bool, 'Kalaclista::HyperScirpt::Boolean';
}

sub h {
  my $tag   = shift;
  my $attrs = {};
  my @contents;

  for my $data (@_) {
    if ( ref $data eq 'HASH' ) {
      $attrs = { $attrs->%*, $data->%* };
    }
    elsif ( ref $data eq 'ARRAY' ) {
      push @contents, $data->@*;
    }
    else {
      push @contents, $data;
    }
  }

  my $attr = q{};
  for my $name ( sort keys $attrs->%* ) {
    my $value = $attrs->{$name};

    if ( ref $value eq 'HASH' ) {
      for my $suffix ( sort keys $value->%* ) {
        my $key = qq(${name}-${suffix});
        my $val = $value->{$suffix};

        $attr .= qq( @{[ escape_html($key) ]}="@{[ escape_html($val) ]}");
      }
    }
    elsif ( ref $value eq 'ARRAY' ) {
      $attr .= qq( @{[ escape_html($name) ]});
      $attr .= qq(="@{[ join q{ }, map { escape_html($_) } sort $value->@* ]}");
    }
    elsif ( ref $value eq 'Kalaclista::HyperScirpt::Boolean' ) {
      if ( $value->$* ) {
        $attr .= qq( @{[ escape_html($name) ]});
      }
    }
    else {
      $attr .= qq( @{[ escape_html($name) ]}="@{[ escape_html($value) ]}");
    }
  }

  if ( @contents == 0 ) {
    return qq(<${tag}${attr} />);
  }
  else {
    return qq(<${tag}${attr}>@{[ join q{}, @contents ]}</${tag}>);
  }
}

sub text {
  my $text = shift;
  return escape_html($text);
}

1;
