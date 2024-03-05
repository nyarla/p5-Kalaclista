use v5.38;
use utf8;

use feature qw(class);
no warnings qw(experimental);

class Kalaclista::Context::Environment {
  field $stage : param;
  field $on : param;

  method production  { $stage eq 'production' }
  method staging     { $stage eq 'staging' }
  method development { $stage eq 'development' }
  method test        { $stage eq 'test' }

  method runtime { $on eq 'runtime' }
  method ci      { $on eq 'ci' }
  method local   { $on eq 'local' }
}
