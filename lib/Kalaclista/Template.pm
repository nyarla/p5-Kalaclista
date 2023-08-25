use v5.38;
use utf8;

package Kalaclista::Template {
  use Exporter::Lite;
  use Module::Load ();

  our @EXPORT = qw(load);

  sub load {
    state $renderers ||= {};

    my $template = shift;
    if ( exists $renderers->{$template} ) {
      return $renderers->{$template};
    }

    Module::Load::load($template);
    my $renderer = ($renderers->{$template} = $template->can('render'));

    if ( ref $renderer ne q{CODE} ) {
      die "This template (${template}) does not have 'render' method.";
    }

    return $renderer;
  }
}
