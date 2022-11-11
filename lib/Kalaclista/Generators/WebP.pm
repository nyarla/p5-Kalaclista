package Kalaclista::Generators::WebP;

use strict;
use warnings;
use utf8;

use File::Spec;
use YAML::XS;

use Kalaclista::Parallel::Tasks;
use Kalaclista::Files;

my $nproc = `nproc --all --ignore 1`;
chomp($nproc);

sub generate {
  my $class = shift;
  my %args  = @_;

  my $images  = delete $args{'images'};
  my $distdir = delete $args{'distdir'};
  my $datadir = delete $args{'datadir'};
  my $sizes   = delete $args{'scales'};

  my @files = grep { $_ =~ m{\.(png|jpeg|jpg|gif)$} } Kalaclista::Files->find( $images->path );

  my @tasks;

  for my $src (@files) {
    my $path = $src;
    substr( $path, 0, length( $images->path ) + 1, '' );
    $path =~ s{\.[^\.]+}{};

    my $meta = $datadir->child("${path}.yaml");
    $meta->parent->mkpath;

    my $dest = $distdir->child("${path}");
    $dest->parent->mkpath;

    push @tasks, [ $meta->path, $src, $dest->path, $sizes ];
  }

  my $worker = Kalaclista::Parallel::Tasks->new(
    handle  => sub { resize( $_[0]->@* ) },
    threads => $nproc,
  );

  return $worker->run(@tasks);
}

sub resize {
  my ( $meta, $src, $dest, $scales ) = @_;

  if ( $src =~ m{\.gif$} ) {
    my $info = `identify '${src}' | head -n1 | cut -d ' ' -f3`;
    my $data = {
      src => {
        width  => ( split qr{x}, $info )[0],
        height => ( split qr{x}, $info )[1],
      }
    };
    YAML::XS::DumpFile( $meta, $data );

    return {};
  }

  my $data = {};
  my $info = `identify '${src}' | cut -d ' ' -f3`;

  chomp($info);

  $data->{'src'} = {
    width  => ( split qr{x}, $info )[0],
    height => ( split qr{x}, $info )[1],
  };

  for my $scale ( $scales->@* ) {
    my $size  = $scale->[0];
    my $width = $scale->[1];

    next if ( $data->{'src'}->{'width'} < $width );

    my $height = `cwebp -resize ${width} 0 -q 100 '${src}' -o '${dest}_${size}.webp' 2>&1 | grep Dimension | cut -d ' ' -f4`;
    chomp($height);

    $data->{$size} = {
      width  => $width,
      height => $height,
    };
  }

  YAML::XS::DumpFile( $meta, $data );

  return {};
}

1;
