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

// if:
    {
        name: "if1",
        path: buildPath("exercises", "if", "if1.d"),
        hint: "No hint yet",
        type: test,
    },
];
