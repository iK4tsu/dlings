import std.algorithm : dropUntil = find;
import std.range : empty, front, takeOne;
import std.stdio : writeln, writefln;
import std.sumtype;
import std.typecons : No, Yes;

import argparse;

import info : exercices;
import tutor : run, verify, watch;

debug import std.experimental.logger;


@(Command("hint")
 .ShortDescription("Prints the exercise's hint"))
struct Hint
{
	@PositionalArgument(0)
	string exercise;
}

@(Command("run")
 .ShortDescription("Verify a single exercise."))
struct Run
{
	@PositionalArgument(0)
	string exercise;
}

@(Command("verify")
 .ShortDescription("Compiles and runs all exercises by the recommended order."))
struct Verify
{}

@(Command("watch")
 .ShortDescription("Similiar to 'verify' but reruns each time the file is modified."))
struct Watch {}

struct DlingsCmdlArgs
{
	SumType!(Hint, Run, Verify, Watch) cmd;
}

void main(string[] args)
{
	if (!args[1 .. $].length)
		args ~= "--help";

	DlingsCmdlArgs cmdlArgs;
	if (!CLI!DlingsCmdlArgs.parseArgs(cmdlArgs, args[1 .. $]))
		return;

	cmdlArgs.cmd.match!(
		(in Hint arg)
		{
			debug infof("command 'hint' with args %s", arg);

			// find exercise
			auto maybeExercise = exercices.dropUntil!(e => e.name == arg.exercise).takeOne();
			debug infof("exercise search result: %(%s%)", maybeExercise);

			if (maybeExercise.empty)
			{
				writefln("error: no exercise named '%s' found!", arg.exercise);
				return;
			}

			writefln("hint: %s", maybeExercise.front.hint);
		},
		(in Run arg)
		{
			debug infof("command 'run' with args: %s", arg);

			const maybeExercise = exercices.dropUntil!(e => e.name == arg.exercise).takeOne();
			debug infof("exercise search result: %(%s%)", maybeExercise);

			if (maybeExercise.empty)
			{
				writefln("error: no exercise named '%s' found!", arg.exercise);
				return;
			}

			run(maybeExercise.front).output.writeln;
		},
		(in Verify _)
		{
			debug info("command 'verify'");
			cast(void) verify(exercices, 0);
		},
		(in Watch _)
		{
			final switch (watch(exercices))
			{
				case Yes.finished:
					writeln("We hope you enjoyed learning about the various aspects of D!");
					break;

				case No.finished:
					writeln("We hope you're enjoying learning about D!");
					writeln("If you want to continue working on the exercises "
					      ~ "at a later point, you can simply run `dlings watch` again.");
					break;
			}

			return;
		},
	);
}
