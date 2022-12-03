package Kalaclista::Generators::Page;

use strict;
use warnings;

use Kalaclista::Template qw(load);

sub generate {
  my $class = shift;
  my %args  = @_;

  my $dist     = delete $args{'dist'};
  my $template = delete $args{'template'};
  my $vars     = delete $args{'vars'};

  my $renderer = load($template);
  my $output   = $renderer->($vars);

  $dist->parent->mkpath;
  $dist->emit($output);

  return 1;
}

1;
