requires( 'Carp',                  0 );
requires( 'Class::Accessor::Lite', 0 );
requires( 'Encode',                '== 3.20' );
requires( 'Exporter::Lite',        0 );
requires( 'HTML5::DOM',            '== 1.25' );
requires( 'HTTP::Tinyish',         '== 0.18' );
requires( 'JSON::XS',              0 );
requires( 'Module::Load',          0 );
requires( 'Perl::Tidy',            0 );
requires( 'Test2::V0',             0 );
requires( 'Text::HyperScript',     0 );
requires( 'URI::Escape::XS',       0 );
requires( 'URI::Fast',             0 );
requires( 'YAML::XS',              0 );

on develop => sub {
  requires( 'Carton',              0 );
  requires( 'App::UpdateCPANfile', 0 );
};

# vim: ft=perl :
