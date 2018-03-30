use strict;
use Test::More;

use XS::Closure::Example;

my $i = 0;

my $c = XS::Closure::Example::make_closure($i);

is($c->(), 0);

$i++;

$c = XS::Closure::Example::make_closure_c($i);

is($c->(), 1);

done_testing;

