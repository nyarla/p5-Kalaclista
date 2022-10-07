package Kalaclista::Test::URI;

use strict;
use warnings;

use Exporter::Lite;
use URI;
use Carp 'confess';

our @EXPORT_OK = qw(
  is_pages

  is_posts
  is_echos
  is_notes

  is_permalink
);

sub is_pages {
  my $href = shift;
  confess "Argument is not URI Object: " if ref($href) !~ m{^URI};

  my @path = split q{/}, $href->path;

  if ( @path == 2 ) {
    return
           $path[1] eq 'nyarla'
        || $path[1] eq 'licenses'
        || $path[1] eq 'policies';
  }

  return 0;
}

sub is_notes {
  my $href = shift;
  confess "Argument is not URI Object: " if ref($href) !~ m{^URI};

  my @path = split q{/}, $href->path;
  if ( @path == 3 ) {
    return $path[1] eq 'notes';
  }

  return 0;
}

sub is_posts {
  my $href = shift;
  confess "Argument is not URI Object: " if ref($href) !~ m{^URI};

  my @path = split q{/}, $href->path;
  if ( @path == 6 ) {
    return $path[1] eq 'posts';
  }

  return 0;
}

sub is_echos {
  my $href = shift;
  confess "Argument is not URI Object: " if ref($href) !~ m{^URI};

  my @path = split q{/}, $href->path;
  if ( @path == 6 ) {
    return $path[1] eq 'echos';
  }

  return 0;
}

sub is_permalink {
  my $href = shift;
  confess "Argument is not URI Object: " if ref($href) !~ m{^URI};

  if ( is_pages($href) ) {
    return 1;
  }

  my @path = split q{/}, $href->path;
  if ( is_posts($href) || is_echos($href) ) {
    return
           $path[2] =~ m{^\d{4}$}
        && $path[3] =~ m{^\d{2}$}
        && $path[4] =~ m{^\d{2}$}
        && $path[5] =~ m{^\d{6}$};
  }

  if ( is_notes($href) ) {
    return @path == 3;
  }

  return 0;
}

1;
