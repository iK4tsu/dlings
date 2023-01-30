/// Not a number is the result of a meaningless expression, a value that cannot
/// be represented. Any value computed with 'nan' will also result in 'nan'.
/// Another property of 'nan' is that it is not equal to anything. A 'nan'
/// cannot be the same as another 'nan'. But... how do we know if something is
/// 'nan'?
/// Run `dlings hint variables1` or type 'hint' if in watch mode.

// Just D it

import std.math;
import std.stdio;

void main()
{
	writefln!"0 / 0 = %f"(0 / 0f); // example of a 'nan' outcome

	const float f; // default initializer is 'nan'
	assert(f == float.nan); // Modify this line only!
}
