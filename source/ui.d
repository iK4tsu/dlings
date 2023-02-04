module ui;

import std.conv : to;

import argparse.ansi;

struct UI
{
	/**
	Chooses one of 'render' or 'fallback' based on 'emojis' condition.

	Params:
		emoji = emoji to return.
		fallback = text to return if condition fails.

	Returns: 'emoji' if emoji output is enabled, 'fallback' otherwise.
	*/
	string emoji(return scope string emoji, lazy return scope string fallback) const
	{
		return emojis ? emoji : fallback;
	}

	/**
	Chooses one of 'Style' or 'noStyle' based on 'colored' condition.

	Params:
		Style = terminal colors to use in format.
		str = text to format.

	Returns: a formated string with 'Style' if colors are enabled, 'noStyle'
	otherwise.
	*/
	string style(alias Style)(in string str) const
	{
		return colored ? Style(str).to!string : noStyle(str).to!string;
	}

	bool colored;
	bool emojis;
}
