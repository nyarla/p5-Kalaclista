use Test2::V0 qw(is);

my $tmpl = sub {
  my ( $vars, $baseURI ) = @_;

  is( $vars, { foo => 'bar' } );

  is( $baseURI->as_string, 'https://example.com' );

  is( __PACKAGE__, 'Kalaclista::Template::_Expand' );

  return 'ok';
};

$tmpl
