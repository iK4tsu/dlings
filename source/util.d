module util;

import std.stdio : File, stderr, stdout;

/**
Creates an annonymous enum that extends from T and exposes aliases that bind
to each enum member of T.

Params:
    T = enum to bind the exposed aliases.

Note: This only binds to T. If the underlying type of T is another enum, those
members are not aliased.
*/
mixin template bindEnumMembers(T)
    if (is(T == enum))
{
    mixin(() {
        import std.array : join;
        return "enum : T {" ~ [__traits(allMembers, T)].join(",") ~ "}";
    } ());
}

@safe @nogc pure nothrow unittest
{
    enum A { a }
    mixin bindEnumMembers!A;
    static assert(is(typeof(a) == A));
}


/// https://github.com/dlang/phobos/blob/master/std/stdio.d#L4130
File trustedStdout() @trusted => stdout;
File trustedStderr() @trusted => stderr;
