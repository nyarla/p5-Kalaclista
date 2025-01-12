use v5.38;
use builtin qw(true false);
use feature qw(class);
no warnings qw(experimental);

use FindBin ();
use File::Spec;
use File::Temp ();

class Kalaclista::Path {
  field $path : param;
  field $temporary : param = false;

  sub detect {
    my $class  = shift;
    my $anchor = shift;
    my @dirs   = File::Spec->splitdir($FindBin::Bin);

    while ( defined( my $dir = pop @dirs ) ) {
      if ( $dir =~ $anchor ) {
        return $class->new( path => File::Spec->join(@dirs) );
      }
    }
  }

  sub tempdir {
    my $class = shift;
    return $class->new( path => File::Temp::tempdir(), temporary => 1, );
  }

  sub tempfile {
    my $class = shift;
    return $class->new( path => ( File::Temp::tempfile() )[1], temporary => 1 );
  }

  method path {
    return $path;
  }

  method to_string {
    return $path;
  }

  method temporary {
    return $temporary;
  }

  method parent {
    my @dirs = File::Spec->splitdir($path);
    pop @dirs;

    return ref($self)->new( path => File::Spec->join(@dirs) );
  }

  method child {
    my $child = shift;
    return ref($self)->new( path => File::Spec->join( $path, $child ) );
  }

  method emit {
    my $content = shift;
    utf8::encode($content) if utf8::is_utf8($content);

    open( my $fh, '>', $path )
        or die "failed to open file: ${path}: $!";

    print $fh $content;

    close($fh)
        or die "failed to close file: ${path}: $!";

    return true;
  }

  method load {
    open( my $fh, '<', $path )
        or die "failed to open file: ${path}: $!";

    my $content = do { local $/; <$fh> };

    close($fh)
        or die "failed to close file: ${path}: $!";

    return $content;
  }

  method remove {
    return if !-d $path && -e $path && unlink $path;
    return if -d $path && rmdir $path;
    return;
  }

  method mkpath {
    my @path = File::Spec->splitdir( File::Spec->rel2abs($path) );

    my $new = q{};
    while ( defined( my $dir = shift @path ) ) {
      $new = File::Spec->join( $new, $dir );

      if ( !-d $new ) {
        mkdir $new
            or warn "failed to mkdir: ${new}: $!";
      }
    }
  }

  method cleanup {
    my $target = $self;

    if ( !-d $target->path ) {
      return $target->remove;
    }

    if ( -d $target->path && opendir( my $dh, $target->path ) ) {
      for my $fn ( readdir $dh ) {
        next if $fn eq q{.} || $fn eq q{..};

        my $item = $target->child($fn);

        if ( -d $item->path ) {
          $item->cleanup;
        }
        elsif ( -e $item->path ) {
          $item->remove;
        }
      }

      closedir($dh) or die "failed to close dir: @{[ $target->path ]}: ${!}";
    }

    return;
  }

  method DESTROY {
    $self->cleanup if $self->temporary;
  }
};

1;
