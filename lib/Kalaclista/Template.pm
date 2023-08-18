use strict;
use warnings;
use utf8;

package Kalaclista::Template;

use feature qw(state);

use Exporter::Lite;

our @EXPORT = qw(load);

use Module::Load ();

use Kalaclista::Constants;

sub load {
  state $renderers ||= {};

  my $template = shift;

  if ( exists $renderers->{$template} ) {
    return $renderers->{$template};
  }

  Module::Load::load($template);
  my $renderer = $template->can('render');

  $renderers->{$template} = $renderer;

  return $renderer;
}

1;
