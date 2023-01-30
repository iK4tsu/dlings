/// Another key different from integer types is overflowing. Every type has
/// a maximum value it can hold. If the limits of an integer are breached, then
/// the expression continues from the opposite limit. With floating point values
/// overflowing is not ignored.

/// Nothing to do on this exercise! You can keep messing around, or remove the
/// 'Just D it' comment below to proceed to the next exercise.

// Just D it

import std.stdio;

void main()
{
	writefln!"int.max + 1"(int.max + 1); // overflows to int.min
	writefln!"float.max + 1"(float.max + 1); // infinity
}
