module info;

import std.algorithm : map;
import std.array : array;
import std.conv : to;
import std.file : exists, FileException, readText;
import std.path : buildPath, pathSplitter;
import std.string : outdent, strip;
import std.utf : UTFException;

import toml;

import util : Result;

debug import std.experimental.logger;

struct Exercise
{
    enum Type { compile, test }

    string name;
    string path;
    string hint;
    Type type;
}

/**
Reads TOML `filepath` and parses its contents into `Exercise`s.

Params:
	filepath = '.toml' file to parse

Returns: an `immutable Exercise[]` with the parsed exercise's data.
*/
@safe
Result!(immutable(Exercise[]), string) exercisesFromTOML(in string filepath)
	in (filepath.exists)
{
	debug infof("parsing file '%s'", filepath);
	alias Err = typeof(return).Err;

	try
	{
		return filepath.readText.exercisesFromTOMLImpl();
	}
	catch (FileException e) { return Err(e.msg); }
	catch (UTFException e) { return Err("malformed UTF-8 file: " ~ e.msg); }

}

/**
Parses 'text' contents into `Exercise`s.

Params:
	text = data in toml format to parse

Returns: an `immutable Exercise[]` with the parsed exercise's data.
*/
@safe
private Result!(immutable(Exercise[]), string) exercisesFromTOMLImpl(in string text)
{
	alias Err = typeof(return).Err;
	alias Ok = typeof(return).Ok;

	TOMLDocument toml;
	try
	{
		toml = text.parseTOML;
	}
	catch (TOMLParserException e) { return Err(e.msg); }

	debug infof("caching all exercise's data.");
	const TOMLValue[] tomlExercises = toml["exercises"].array;

	return Ok(tomlExercises.map!"a.table"
		.map!(exercise => Exercise(
			exercise["name"].str,
			exercise["path"].str.pathSplitter.buildPath(), // ensure path is formatted correctly
			exercise["hint"].str.strip.outdent(),
			exercise["type"].str.to!(Exercise.Type),
		)).array.idup);
}

///
@safe unittest
{
	import util : match;
	immutable exercises = exercisesFromTOMLImpl(`
		[[exercises]]
		name = "foo"
		path = "dummy/path/to/foo"
		hint = "no hint"
		type = "test"

		[[exercises]]
		name = "bar"
		path = "dummy/path/to/bar"
		hint = "no hint"
		type = "compile"

		[unrelated_table]
		key = "value"
	`).match!((string _) => assert(0), (exercises) => exercises);

	import std.algorithm : equal;
	assert(exercises.length == 2);
	assert(exercises.equal([
		Exercise("foo", buildPath("dummy", "path", "to", "foo"), "no hint", Exercise.Type.test),
		Exercise("bar", buildPath("dummy", "path", "to", "bar"), "no hint", Exercise.Type.compile),
	]));
}
