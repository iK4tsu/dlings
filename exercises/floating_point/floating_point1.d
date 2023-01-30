/// Floating point values are peculiar with how they work. They have a
/// different representation from integer types. This way it is possible to
/// have a value without truncating it.

/// The test is failing!
/// Run `dlings hint variables1` or type 'hint' if in watch mode.

// Just D it

unittest
{
	const int a = 1;
	const int b = 2;
	assert(a / b == 0.5); // Modify this line only!
}
