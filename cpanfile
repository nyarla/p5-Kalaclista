requires( 'Carp',                  '== 1.50' );
requires( 'Class::Accessor::Lite', '== 0.08' );
requires( 'Encode',                '== 3.21' );
requires( 'Exporter::Lite',        '== 0.09' );
requires( 'HTML5::DOM',            '== 1.26' );
requires( 'HTTP::Tinyish',         '== 0.19' );
requires( 'JSON::XS',              '== 4.03' );
requires( 'Module::Load',          0 );
requires( 'Net::LibIDN',           '== 0.12' );
requires( 'Perl::Tidy',            '== 20250311' );
requires( 'Test2::V0',             '== 1.302211' );
requires( 'Text::CSV',             '== 2.06' );
requires( 'Text::HyperScript',     '== 0.08' );
requires( 'URI::Escape::XS',       '== 0.14' );
requires( 'URI::Fast',             '== 0.55' );
requires( 'YAML::XS',              '== v0.904.0' );

on develop => sub {
  requires( 'App::UpdateCPANfile', '== v1.1.1' );
  requires( 'Carton',              '== 1.000035' );
};

# vim: ft=perl :
