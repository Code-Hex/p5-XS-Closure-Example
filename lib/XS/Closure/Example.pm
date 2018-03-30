package XS::Closure::Example;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/make_closure make_closure_c/;

1;
__END__

=encoding utf-8

=head1 NAME

XS::Closure::Example - It's example module for closure

=head1 SYNOPSIS

    use feature 'say';
    use XS::Closure::Example;

    my $i = 0;
    my $c = make_closure($i);
    say $c->(); # 0

    $i++;

    my $c_c = make_closure_c($i);
    say $c_c->(); # 1

=head1 DESCRIPTION

XS::Closure::Example

=head1 LICENSE

Copyright (C) K.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

K E<lt>x00.x7f@gmail.comE<gt>

=cut

