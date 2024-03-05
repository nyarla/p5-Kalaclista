package Kalaclista::Loader::Files;

use v5.38;
use utf8;

use Exporter::Lite;
use Carp qw(croak);

use File::Spec;

our @EXPORT = qw(files);

sub files : prototype($) {
  my $root = shift;

  my @files;
  my @dirs;

  push @dirs, $root;

  while ( defined( my $dir = shift @dirs ) ) {
    opendir( my $dh, $dir )
        or confess("failed to open directory: ${dir}: $!");

    while ( defined( my $item = readdir $dh ) ) {
      next if ( $item eq q{.} || $item eq q{..} );

      my $path = File::Spec->join( $dir, $item );

      if ( -f $path ) {
        push @files, $path;
        next;
      }

      if ( -d $path ) {
        push @dirs, $path;
        next;
      }
    }

    closedir($dh)
        or confess("failed to close directory: ${dir}");
  }

  return @files;
}

1;
