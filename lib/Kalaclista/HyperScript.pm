package Kalaclista::HyperScript;

use strict;
use warnings;

use Text::HyperScript;
use Text::HyperScript::HTML5;

use JSON::XS ();

use parent qw(Exporter::Lite);

my $jsonify = JSON::XS->new->utf8->canonical(1);

our @EXPORT = (
  @Text::HyperScript::EXPORT,
  @Text::HyperScript::HTML5::EXPORT,
  qw[ document classes ]
);

sub document {
  my ( $head, $body ) = @_;
  return q(<!DOCTYPE html>) . html( { lang => 'ja' }, $head, $body );
}

sub classes {
  return { class => join( q{ }, split q{ }, join q{ }, @_ ) };
}

1;
