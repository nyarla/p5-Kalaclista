use v5.38;
use utf8;

use feature qw(class);
no warnings qw(experimental);

class Kalaclista::Data::Thumbnail {
  field $thumbnail : param;
  field $type : param;
  field $title : param;
  field $description : param;

  method title       { $title }
  method type        { $type }
  method description { $description }
  method thumbnail   { $thumbnail }
}
