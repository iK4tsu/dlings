module info;

import std.path : buildPath;
import std.string : outdent, strip;

struct Exercise
{
    enum Type { compile, test }

    string name;
    string path;
    string hint;
    Type type;
}

// TODO: use ETI - https://github.com/dlang/DIPs/blob/master/DIPs/DIP1044.md
// syntax sugar for Exercise.Type members
private mixin imported!"util".bindEnumMembers!(Exercise.Type);
immutable Exercise[] exercices =
[
// intro:
    {
        name: "intro1",
        path: buildPath("exercises", "intro", "intro1.d"),
        hint: "Remove the 'Just D it' comment to move to the next exercise.",
        type: compile,
    },

    {
        name: "intro2",
        path: buildPath("exercises", "intro", "intro2.d"),
        hint: "
            The format string expects something.
            Add an argument inside the function.".outdent.strip(),
        type: compile,
    },

// variables:
    {
        name: "variables1",
        path: buildPath("exercises", "variables", "variables1.d"),
        hint: "
            When declaring variables, D needs a bit more information than just
            an identifier. Try giving 'a' aditional information about what it is
            and what it represents. Add the type before 'a'.".outdent.strip(),
        type: compile,
    },

    {
        name: "variables2",
        path: buildPath("exercises", "variables", "variables2.d"),
        hint: "
            Unlike C or C++, all variables in D have predictable values when
            initialized. This is because, by default, all variables are
            initialized to their default initializer value. The int.init value
            is '0'.".outdent.strip(),
        type: test,
    },

    {
        name: "variables3",
        path: buildPath("exercises", "variables", "variables3.d"),
        hint: "
            Variable 'a' is a constant value, so it cannot be modified. Remove
            the assignment expression line.".outdent.strip(),
        type: compile,
    },

// floating_point
    {
        name: "floating_point1",
        path: buildPath("exercises", "floating_point", "floating_point1.d"),
        hint: "
            Integer expressions cannot preserve the fractional part of a
            result. Change the expected value '0.5' to '0'.".outdent.strip(),
        type: test,
    },

    {
        name: "floating_point2",
        path: buildPath("exercises", "floating_point", "floating_point2.d"),
        hint: "
            The default initializer of floating point types is 'nan'. Arithmetic
            operations with 'nan' always result in 'nan'. Initialize 'f' to any
            numeric literal, e.g `float f = 0;`".outdent.strip(),
        type: test,
    },

    {
        name: "floating_point3",
        path: buildPath("exercises", "floating_point", "floating_point3.d"),
        hint: "
            Make use of the 'std.math' module. There you can find the 'isNan'
            function and change the code to `assert(isNan(f));`".outdent.strip(),
        type: compile,
    },

    {
        name: "floating_point4",
        path: buildPath("exercises", "floating_point", "floating_point4.d"),
        hint: "No hints this time ;)",
        type: compile,
    },

// functions:
    {
        name: "functions1",
        path: buildPath("exercises", "functions", "functions1.d"),
        hint: "Insert `a + b` after `return`.",
        type: compile,
    },

    {
        name: "functions2",
        path: buildPath("exercises", "functions", "functions2.d"),
        hint: "Insert the parameter `float a`, e.g `float half(float a)`",
        type: compile,
    },

    {
        name: "functions3",
        path: buildPath("exercises", "functions", "functions3.d"),
        hint: "Insert the parameter `float a`, e.g `float half(float a)`",
        type: compile,
    },

    {
        name: "functions4",
        path: buildPath("exercises", "functions", "functions4.d"),
        hint: "Create another function 'add' that receives 'float' types.",
        type: compile,
    },

    {
        name: "functions5",
        path: buildPath("exercises", "functions", "functions5.d"),
        hint: "
            Modify the function signature to work with templated types.
            `T multiply(T)(const T left, const T right)`".outdent.strip(),
        type: compile,
    },

// if:
    {
        name: "if1",
        path: buildPath("exercises", "if", "if1.d"),
        hint: "
			There are a couple of ways to complete this exercise.
			1. ===
			   if (<condition>)
			   {
			       return <identifier>;
			   }
			   else
			   {
			       return <identifier>;
			   }
			   ===
			2. ===
			   return <condition> ? <identifier> : <identifier>;
			   ===

			- The parentheses are optional in D for the `if` statement.
			- The second example uses what it's called a 'ternary operatior'.

			Note that without parenthesis only the first statement after `if` is
			  evaluated!".outdent.strip(),
        type: test,
    },
];
