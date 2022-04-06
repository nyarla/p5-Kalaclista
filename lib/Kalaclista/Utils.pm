package Kalaclista::Utils;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(split_md);

sub split_md ($) {
  my $file = shift;

  my $fh     = $file->openr;
  my $yaml   = q{};
  my $inside = 0;

  while ( defined( my $line = <$fh> ) ) {
    chomp($line);

    if ( $line eq q{---} ) {
      if ( $inside == 0 ) {
        $inside++;
        next;
      }

      if ( $inside > 0 ) {
        last;
      }
    }

    $yaml .= $line . "\n";
  }

  my $md = do { local $/; <$fh> };
  $md //= q{};

  return ( $yaml, $md );
}

1;
