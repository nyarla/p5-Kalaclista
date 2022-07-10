use Test2::V0 qw(is);
use URI;

my $tmpl = sub {
  my $baseURI = URI->new('https://example.com');

  is( href( '/foo/bar', $baseURI ), 'https://example.com/foo/bar' );

  is( { className('block') },              { class => 'block' } );
  is( { className( 'block', 'element' ) }, { class => 'block__element' } );
  is(
    { className( 'block', 'element', "modifier" ) },
    { class => 'block__element--modifier' }
  );
  is( { className( 'block', '', 'modifier' ) },
    { class => 'block--modifier' } );

  is( date('2022-01-01T00:00:00'), '2022-01-01' );

  is( __PACKAGE__, 'Kalaclista::Template::_Test' );

  is( expand( "expand.pl", { foo => 'bar' }, $baseURI ), 'ok' );
};

$tmpl;
