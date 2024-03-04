package Kalaclista::Context::Path;

use v5.38;

use Exporter::Lite ();
use Carp           qw(croak);

use Kalaclista::Path;

our @EXPORT = qw(rootdir);

sub rootdir { state $root ||= shift; $root }

sub import {
  croak qq|you can't pass to more than 1 arguments|                                      if @_ > 2;
  croak qq|missing regexp to detect rootdir; usage: 'use @{[ __PACKAGE__ ]} qr{^lib\$}'| if @_ != 2;

  rootdir( Kalaclista::Path->detect( pop @_ ) );

  my $exporter = Exporter::Lite->can('import');
  goto $exporter;
}

1;
