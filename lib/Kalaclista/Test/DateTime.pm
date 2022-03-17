package Kalaclista::Test::DateTime;

use strict;
use warnings;

use Exporter 'import';
use Test2::V0;

our @EXPORT_OK = qw(
  match_datetime
);

sub match_datetime {
  like( shift,
    qr{^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:[\-+]\d{2}:\d{2}|Z)$} );
}

1;
