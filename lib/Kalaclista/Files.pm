package Kalaclista::Files;

use strict;
use warnings;
use utf8;

use Carp qw(confess);
use File::Spec;

my %cache;

sub find {
  my ( $class, $rootdir ) = @_;

  if ( exists $cache{$rootdir} && ref $cache{$rootdir} eq 'ARRAY' ) {
    return $cache{$rootdir};
  }

  my @files;
  my @dirs;

  push @dirs, $rootdir;

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

  $cache{$rootdir} = \@files;

  return @files;
}

1;
