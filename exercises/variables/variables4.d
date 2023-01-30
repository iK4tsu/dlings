module exercises.variables.variables4_;

/// Variables in D are mutable by default. But sometimes we want to express
/// them otherwise and make their values unchangeable.

/// There are 3 ways to make this happen:
/// * enum constants
/// * const
/// * immutable

/// Working with constant values also allows us to work with CTFE - Compile Time
/// Function Evaluation - a D feature that allows any function to execute at
/// compile time! We will get more into this in future chapters.

/// Since constant values cannot change, once they're initialized, their state
/// remains the same until its lifetime is over.

import std.stdio;

// Just D it

void main()
{
	const a = 5; // notice 'a' being infered as `const int`
	a = 10;
	writefln!"a is %s"(a);
}
