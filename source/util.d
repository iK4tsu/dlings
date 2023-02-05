module util;

import core.attribute : mustuse;
import std.algorithm : map;
import std.array : join;
import std.format : format;
import std.meta : All = allSatisfy, IndexOf = staticIndexOf, Map = staticMap;
import std.range : iota;
import std.stdio : File, stderr, stdout;
import std.sumtype;

@mustuse struct Result(Success, Error)
{
	@safe pure nothrow @nogc:

	SumType!(Success, Error) st;
	alias st this;

	static Ok(Success value)
	{
		Result self = { st: value };
		return self;
	}

	static Err(Error value)
	{
		Result self = { st: value };
		return self;
	}

	bool opCast(T : bool)() const
	{
		// access private data of SumType to avoid 'match'
		enum stringify(alias member) = member.stringof;
		enum tid = IndexOf!(Success, st.Types);
		const tag = st.tupleof[IndexOf!("tag", Map!(stringify, st.tupleof))];
		return tag == tid;
	}

	inout success() @system => get!Success;
	inout error() @system => get!Error;

	private ref inout(T) get(T)() @system inout
	{
		// access private data of SumType to avoid 'match'
		enum stringify(alias member) = member.stringof;
		auto storage = &st.tupleof[IndexOf!("storage", Map!(stringify, st.tupleof))];
		return __traits(getMember, *storage, typeof(*storage).memberName!T);
	}
}

/**
Calls SumType's `match` with all defined inner SumTypes of `Result`.

See_Also: $(REF match, std,sumtype)
*/
template match(handlers...)
{
	enum bool isResult(T) = is(T : Result!(Success, Error), Success, Error);

	auto ref match(Results...)(auto ref Results args)
		if (All!(isResult, Results) && args.length > 0)
	{
		enum sumtypes = Results.length.iota.map!`a.format!"args[%d].st"`.join(",");
		return mixin("std.sumtype.match!(handlers)(", sumtypes, ")");
	}
}

///
@safe pure nothrow @nogc unittest
{
	alias Result = .Result!(int, string);
	bool isInt(Result result)
	{
		return result.match!(
			(int) => true,
			_ => false,
		);
	}

	assert( isInt(Result.Ok(int.init)));
	assert(!isInt(Result.Err(string.init)));
}

/// opCast!bool
@safe pure nothrow @nogc unittest
{
	alias Result = .Result!(int, string);

	assert( Result.Ok(int.init));
	assert(!Result.Err(string.init));
}

///
@system pure nothrow @nogc unittest
{
	alias Result = .Result!(int, string);

	assert(Result.Ok(0).success == 0);
	assert(Result.Err("").error == "");
}

///
@safe pure nothrow @nogc unittest
{
	alias Result = .Result!(int, string);

	bool sameResult(Result result1, Result result2)
	{
		alias doMatch = match!(
			(int, int) => true,
			(string _1, string _2) => true,
			(_1, _2) => false,
		);

		return doMatch(result1, result2);
	}

	assert( sameResult(Result.Ok(0), Result.Ok(1)));
	assert( sameResult(Result.Err("!"), Result.Err("*")));
	assert(!sameResult(Result.Ok(int.init), Result.Err(string.init)));
	assert(!sameResult(Result.Err(string.init), Result.Ok(int.init)));
}

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
