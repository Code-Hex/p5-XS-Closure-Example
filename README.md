# NAME

XS::Closure::Example - It's example module for closure

# SYNOPSIS

    use feature 'say';
    use XS::Closure::Example;

    my $i = 0;
    my $c = make_closure($i);
    say $c->(); # 0

    $i++;

    my $c_c = make_closure_c($i);
    say $c_c->(); # 1

# DESCRIPTION

XS::Closure::Example

# LICENSE

Copyright (C) K.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

K <x00.x7f@gmail.com>
