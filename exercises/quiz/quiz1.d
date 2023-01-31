/// Congrats on reaching your first quiz!
/// This exercise groups the following chapters:
/// - variables
/// - floating_point
/// - functions
/// - if

// Beerconf is right around the corner but we're restrict on the beer 'quantity'
// this month! Since we're low on resources we need to rationalize how much beer
// each person can have, so that everyone has an equal share. There are few
// things to be taken into account:
// - if there are no atendents, no beer should to be distributed
// - the value must be precise, no beer remainings allowed!
// - the quantity is specified in beer barrels, each barrel has 25L of beer

// Just D it

import std.math;

unittest
{
	// Note: you can force the type of numeric literal by using <type>(<value>)
	// int(3) forces the literal '3' to be an 'int'

	// Tip: 'uint' stands for unsigned int; this represents quantity type, i.e a
	// type with no negative values.

	// Do not modify any of the code below!
	const eqLitters1 = equalParts(2, 25);
	const eqLitters2 = equalParts(100, 0);
	const eqLitters3 = equalParts(1, 36);

	assert(isClose(2, eqLitters1, 1e0));
	assert(isClose(0, eqLitters2, 0.0, float.min_10_exp));
	assert(isClose(0.694, eqLitters3, 1e-3));
}
