use Test2::V0 qw(is);

my $tmpl = sub {
  my ( $vars, $baseURI ) = @_;

  is( $vars->{'foo'},      'bar' );
  is( $baseURI->as_string, 'https://example.com/foo/bar' );

  return 'hello, world!';
};

$tmpl;
