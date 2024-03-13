package Kalaclista::Loader::CSV;

use v5.38;
use utf8;

use Exporter::Lite;

our @EXPORT = qw(loadcsv);

use Text::CSV qw(csv);

sub loadcsv : prototype($&) {
  my $file   = shift;
  my $mapper = shift;

  my $aoa = csv( in => $file, encoding => 'UTF-8' );
  shift $aoa->@*;

  return [ map { $mapper->( $_->@* ) } $aoa->@* ];
}

1;
