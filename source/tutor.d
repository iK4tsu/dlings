module tutor;

import core.atomic : atomicLoad, atomicStore;
import core.attribute;
import std.algorithm : dropUntil = find;
import std.algorithm : cache, canFind, each, map;
import std.concurrency : spawn;
import std.datetime.systime : SysTime;
import std.file : isFile, readText;
import std.format : format;
import std.functional : bind;
import std.process : execute;
import std.range : drop, dropExactly, enumerate, front, repeat;
import std.stdio : readln, write, writeln, writefln;
import std.stdio : File, stderr, stdout;
import std.string : endsWith, lineSplitter, strip;
import std.sumtype;
import std.typecons : Nullable, Tuple, tuple;
import std.typecons : Flag, No, Yes;

import argparse;
import fswatch;

import info : Exercise;
import util : trustedStderr, trustedStdout;

debug import std.experimental.logger;


/**
Compiles and executes a single exercise.

The file runs and the output is displayed.

Params:
	interactive = if true, the comment '// Just D it' invalidates the exercise.
	exercise = file with the code to validate.

Returns: a struct with a 'failure' bool and the 'output' string.
*/
auto run(Flag!"interactive" interactive = No.interactive)(immutable Exercise exercise)
{
	debug infof("running '%s' in '%s.interactive'", exercise.name, interactive);
	alias Header = Tuple!(string, "success", string, "failure");


	/// UI helpers
	immutable header = [
		Exercise.Type.compile: Header("🎉 🎉  \x1B[92mProgram compiled successfully!\x1B[0m 🎉 🎉", // green fg
									  "\x1B[33m󰀦  \x1B[1mProgram failed to compile!\x1B[0m"), // yellow fg
		Exercise.Type.test:    Header("🎉 🎉  \x1B[92mProgram compiled successfully and test passed!\x1B[0m 🎉 🎉", // green fg
									  "\x1B[33m󰀦  \x1B[1mProgram failed to compile or tests did not pass!\x1B[0m"), // yellow fg
	];

	immutable separator = "\x1B[36m====================\x1B[0m"; // blue fg


	/// compiler arguments
	immutable args = [
		Exercise.Type.compile: ["dmd", "-color=on", "-run"],
		Exercise.Type.test: ["dmd", "-color=on", "-unittest", "-main", "-run"],
	];


	@mustuse struct Result
	{
		bool failure;
		string output;
	}

	debug with(exercise) infof("compiling with '%-(%s %)'", args[type] ~ path);
	const dmd = execute(args[exercise.type] ~ exercise.path);
	const compiled = dmd.status == 0;

	// Program compiled successfully!
	// Output:
	// ===============
	//
	// Hello Dlings
	//
	// ===============
	string output = format!"%s\nOutput:\n%2$s\n\n%3$s\n%2$s"
	(
		compiled ? header[exercise.type].success : header[exercise.type].failure,
		separator,
		dmd.output,
	);


	static if (interactive)
	{
		const keepWorking = exercise.path.readText.lineSplitter.canFind!`a == "// Just D it"`;
		if (compiled && keepWorking)
		{
			// adds a final hint to a successful compilation
			// if the keep working comment is present
			immutable hint = "\n\n\x1B[33mYou can keep working on this exercise, "
						   ~ "or jump into the next one by removing the "
						   ~ "\x1B[1m`Just D it`\x1B[22m comment.\x1B[0m";
			output ~= hint;
		}

		const failure = !compiled || keepWorking;
	}
	else
	{
		const failure = !compiled;
	}

	return Result(failure, output);
}


/**
Executes 'run' on each exercise following the recomended order.

Params:
	exercises = files to verify.
	from = offset to start from.

Retuns: a Nullable!size_t with the offset to the failed exercise, otherwise null
if all exercises succeed.
*/
Nullable!size_t verify(immutable(Exercise)[] exercises, size_t from)
{
	debug infof("verifying exercise '%s' starting from offset '%s'", exercises[from].name, from);

	void clearTerm() { writeln("\x1B[2J\x1B[1;1H"); }
	void displayBar(size_t completed)
	{
		/// Progress [------] (0/6)
		/// Progress [>-----] (1/6) (16.67%)
		/// Progress [##>---] (3/6) (50.00%)
		/// Progress [####>-] (5/6) (100.00%)
		/// Progress [######] (6/6) (100.00%)
		writefln!"Progress [\x1B[32m%-(%s%)\x1B[1m%s\x1B[31m%-(%s%)\x1B[0m] (%d/%d)%s"
		(
			'#'.repeat(completed).drop(1),
			completed ? ">" : "",
			"-".repeat(exercises.length - completed),
			completed, exercises.length,
			completed ? format!" (%.2f%%)"(completed * 100f / exercises.length) : ""
		);
	}

	auto failedExercises = exercises
		.enumerate
		.dropExactly(from)
		.map!(bind!((i, exercise) => tuple!("index", "value")(i, exercise.run!(Yes.interactive))))
		.cache
		.dropUntil!("a.value.failure");

	if (!failedExercises.length)
	{
		displayBar(exercises.length);
		writeln("🎉 🎉  \x1B[92mCongrats! No more exercises left to do!\x1B[0m 🎉 🎉");
		return Nullable!size_t.init;
	}
	else
	{
		displayBar(failedExercises.front.index);
		writeln(failedExercises.front.value.output);
		return Nullable!size_t(failedExercises.front.index);
	}
}


@(Command("clear")
 .ShortDescription("Clears the screen"))
struct Clear {}

@(Command("hint")
 .ShortDescription("Prints the current exercise's hint"))
struct Hint {}

@(Command("quit", "exit")
 .ShortDescription("Quits watch mode"))
struct Quit {}

@Command("watch")
struct WatchCmdlArgs
{
	SumType!(Clear, Hint, Quit) cmd;
}


/**
Interactive mode over 'verify'.

Keeps watch of the failing exercise file and reruns verify each time the file
is modified.

Params:
	exercise = sequence of exercises to verify.

Returns: Yes.finished if all exercises were completed, otherwise No.finished if
exiting without completing all exercises.
*/
Flag!"finished" watch(immutable(Exercise)[] exercises)
	in (exercises.length)
{
	// run verify
	Nullable!size_t failedIndex = verify(exercises, 0);
	if (failedIndex.isNull) return Yes.finished; // all exercises succeeded!

	// prepare shared data
	shared bool shouldQuit = false; /// manually modified or by completing all exercises
	shared string exerciseHint = exercises[failedIndex.get].hint; /// updated each new exercise
	startCLI(shouldQuit, exerciseHint);

	assert (isFile(exercises.front.path));
	auto watcher = FileWatch("exercises/", true);

	// begin watch mode
	while (!shouldQuit.atomicLoad())
	{
		if (watcher.getEvents.canFind!(event => exercises[failedIndex.get].path.endsWith(event.path) && event.type == FileChangeEventType.modify))
		{
			// clears screen
			writeln("\x1Bc");

			debug infof("file '%s' modified!", exercises[failedIndex.get].path);

			failedIndex = verify(exercises, failedIndex.get);
			if (failedIndex.isNull) return Yes.finished; // all exercises completed!

			synchronized { exerciseHint = exercises[failedIndex.get].hint; }
		}
	}

	return No.finished;
}


/**
Executes a new thread that evaluates user input.

Params:
	shouldQuit = mutable shared flag for exitting the program when required.
	exerciseHint = non-mutable shared string holding the current exercise's hint.
*/
private void startCLI(shared ref bool shouldQuit, shared scope const ref string exerciseHint)
{
	writeln("Welcome to watch mode!");
	writeln("To get a list of allowed commands type '--help'.");

	spawn((shared bool* shouldQuit, shared in string* exerciseHint)
	{
		assert(!atomicLoad(*shouldQuit));

		do
		{
			// using argparse since it has nice syntax output
			WatchCmdlArgs args;
			if (CLI!(WatchCmdlArgs).parseArgs(args, [readln.strip()]))
			{
				args.cmd.match!(
					(Clear _) { writeln("\x1B[2J\x1B[1;1H"); },
					(Hint _)  { synchronized writeln(*exerciseHint); },
					(Quit _)  { atomicStore(*shouldQuit, true); },
				);
			}
		} while(!atomicLoad(*shouldQuit));

		writeln("Bye!");
	}, &shouldQuit, &exerciseHint);
}
