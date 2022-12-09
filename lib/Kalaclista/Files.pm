package Kalaclista::Files;

use strict;
use warnings;
use utf8;

use feature qw(state);

use File::Spec;

sub find {
  state $cache ||= {};

  my ( $class, $root ) = @_;

  if ( exists $cache->{$root} && ref $cache->{$root} eq 'ARRAY' ) {
    return $cache->{$root}->@*;
  }

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

  $cache->{$root} = \@files;

  return @files;
}

1;
