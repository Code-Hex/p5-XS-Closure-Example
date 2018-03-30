use strict;
use Test::More;

use XS::Closure::Example;

my $i = 0;

my $c = make_closure($i);

is($c->(), 0);

$i++;

$c = make_closure_c($i);

is($c->(), 1);

done_testing;

