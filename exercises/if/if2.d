/// Pass the tests!

// Just D it

int compare(const int value, const int to)
{
	// Make this method return:
	// * -1 if 'value' is lower than 'to'
	// * 0  if 'value' and'to' are equal
	// * 1  if 'value' is higher than 'to'
	// Do not use:
	// * another function call
	// * additional variables
}

unittest
{
	assert(compare(1, 2) == -1);
	assert(compare(2, 2) == 0);
	assert(compare(3, 2) == 1);
}
