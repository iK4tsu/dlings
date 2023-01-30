/// Function templates are similar to normal functions but can be receive
/// diferent types.
/// Run `dlings hint variables1` or type 'hint' if in watch mode.

// Just D it

import std.stdio;

multiply()
{
	// With only function allow this function to receive multiple types
	return left * right;
}

void main()
{
	writeln(multiply(1f, 2f)); // float
	writeln(multiply(1, 2)); // int
	writeln(multiply(1u, 2u)); // uint
}
