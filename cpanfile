requires( 'Carp',                  0 );
requires( 'Class::Accessor::Lite', '== 0.08' );
requires( 'Encode',                '== 3.20' );
requires( 'Exporter::Lite',        '== 0.09' );
requires( 'HTML5::DOM',            '== 1.25' );
requires( 'HTTP::Tinyish',         '== 0.18' );
requires( 'JSON::XS',              '== 4.03' );
requires( 'Module::Load',          0 );
requires( 'Perl::Tidy',            '== 20230912' );
requires( 'Test2::V0',             '== 0.000159' );
requires( 'Text::HyperScript',     '== 0.08' );
requires( 'URI::Escape::XS',       '== 0.14' );
requires( 'URI::Fast',             '== 0.55' );
requires( 'YAML::XS',              '== 0.88' );

on develop => sub {
  requires( 'App::UpdateCPANfile', '== v1.1.1' );
  requires( 'Carton',              '== 1.000035' );
};

# vim: ft=perl :
