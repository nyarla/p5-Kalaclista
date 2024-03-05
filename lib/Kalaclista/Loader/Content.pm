package Kalaclista::Loader::Content;

use v5.38;
use utf8;

use Exporter::Lite;
use YAML::XS;

our @EXPORT = qw(header content readall);

my sub readfile : prototype($) {
  my $path = shift;

  my $lnum = 0;
  my $header;

  open( my $fh, '<', $path ) or die "can't open $path: $!";

  while ( defined( my $line = <$fh> ) ) {
    if ( $line =~ m{^---+\n$} ) {
      if ( $lnum == 0 ) {
        $lnum++;
        next;
      }

      last if $lnum > 0;
    }

    $header .= $line;
  }

  return {
    header => $header,
    fh     => $fh,
  };
}

sub header : prototype($) {
  my $data = readfile shift;
  my ( $header, $fh ) = @{$data}{qw/ header fh /};

  close $fh or die "can't close $fh: $!";

  return YAML::XS::Load($header);
}

sub content : prototype($) {
  my $data    = readfile shift;
  my $fh      = $data->{'fh'};
  my $content = do { local $/; <$fh> };

  close $fh or die "can't close $fh: $!";

  return $content;
}

sub readall : prototype($) {
  my $data = readfile shift;
  my ( $header, $fh ) = @{$data}{qw/ header fh /};
  my $content = do { local $/; <$fh> };

  close $fh or die "can't close $fh: $!";

  return ( YAML::XS::Load($header), $content );
}

1;
