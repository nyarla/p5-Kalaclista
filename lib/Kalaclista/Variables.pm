package Kalaclista::Variables;

use strict;
use warnings;

use Class::Accessor::Lite (
  new => 1,
  ro  => [
    qw(
      contains
      data
      is_production
    )
  ],
  rw => [
    qw(
      breadcrumb
      description
      entries
      href
      kind
      label
      section
      summary
      title
      website
    )
  ],
);

1;
