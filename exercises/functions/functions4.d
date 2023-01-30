/// Make me compile!
/// Run `dlings hint variables1` or type 'hint' if in watch mode.

// Just D it

import std.stdio;

int add(const int left, const int right)
{
	return left + right;
}

void main()
{
	writeln(add(1, 2));
	writeln(add(1f, 2f));
}
