module info;

import std.path : buildPath;

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
        hint: "No hint yet",
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
