# Dlings
Welcome to `dlings`. This project aims to teach you how to program in D.
If the name doesn't sound strange, it's because you might have heard of [rustlings](https://github.com/rust-lang/rustlings) or [ziglings](https://github.com/ratfactor/ziglings). In fact, this is **heavily** based on [rustlings](https://github.com/rust-lang/rustlings). If you're familiar with how [rustlings](https://github.com/rust-lang/rustlings) work, you will have no trouble getting started with `dlings`.

# Getting started
## Dependencies
* [argparse](https://code.dlang.org/packages/argparse)
* [fswatch](https://code.dlang.org/packages/fswatch)

## Clone the repository
```sh
git clone git@github.com:iK4tsu/dlings.git
cd dlings
```

## Using DUB
```sh
dub build -b release
./dlings --help
```

## Installing with Meson
__Note:__ DUB prioritizes `dmd` when building dependencies. Since Meson is
using DUB's local repository to find dependencies, you must ensure both
Meson and DUB are using the same compiler. This can be done by passing the
`--compiler` argument to DUB, and setting the `DC` environment variable
when invoking Meson. Pay attention to the steps below.

## Manually fetch and build dependencies
```sh
dub fetch <dependency>
dub build <dependency>
```

__Note:__ You can choose another compiler with `--compiler`
```sh
dub build <dependency> --compiler=dmd
```
This will build DUB dependencies and place them in your DUB local repository.

Now that we have all needed dependencies in DUB's local repository, we can
install `dlings`:
```sh
DC=dmd meson setup <builddir> --buildtype=release
ninja -C <builddir> install
dlings --help
```

By default, Meson will use the system's install path. You can change it with `--prefix`.\
If you want to install `dlings` to `$HOME/.local/bin/` then:
```sh
DC=dmd meson --prefix="$HOME/.local/" setup <builddir> --buildtype=release
ninja -C <builddir> install
dlings --help
```

__Note:__ If Meson fails due to sub-dependency issues, you might need to use
__[dub-build-deep](https://code.dlang.org/packages/dub-build-deep)__ to fetch
and build your DUB dependencies.

# Dlings Command Line
## Arguments
| argument | description
| ------- | -----------
| --help \| -h | Prints the help menu
| --color | Colorize the output. If value is omitted then 'always' is used.
| --emoji | Enable emoji output. If value is omitted then 'always' is used.

## Commands
| command | description
| ------- | -----------
| hint    | Prints an exercise's hint
| run     | Examines a single exercise
| verify  | Runs all exercises by the recommended order
| watch   | Verify in interactive mode

*Note: use '--help' with a command for more information about it.*

## Colors and Emojis
By default, `dlings` will auto-detect whether or not to use colored output and
emojis if the respective optional arguments are not used. Dlings depends on
[argparse](https://github.com/andrey-zherikov/argparse#heuristics-for-enabling-styling)
to detect if colors can be used. If the environment variable `NO_EMOJI` is
defined emojis won't be used.

The following sequence disables colors and emojis:
```sh
NO_COLOR=1 NO_EMOJI= dlings --help
```

# Status
This project is in its early days. Currently, only exercises used for testing are
available.

# Discussions
This project is from a user in the D community to everyone in the D community.
If you have any ideas, projects, discussions, or other topics you'd like to
mention, head over to the discussions tab and start a discussion. Or you can
comment on an existing discussion.
* [Road Map](https://github.com/iK4tsu/dlings/discussions/2)
* [Exercises Vision Document](https://github.com/iK4tsu/dlings/discussions/4)

# Contributing
Any suggestion, enhancement, or fix, is appreciated.

## Guidelines
* Commit messages should comply with [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
* Commits should have code changes by context

## How to contribute
* Fork the repository
* Clone this repository `git clone git@github.com:iK4tsu/dlings.git`
* Add remote to **your** repository `git remote add <name> <remote>`
* Create a branch to develop your changes `git checkout -b <name>`
* Push to **your** remote when ready `git push --set-upstream <remote-name> <branch-name>`
* Head over to GitHub and create a Pull Request

### Example
Let's say the user with GitHub USER wants to contribute. After forking:
```sh
git clone git@github.com:iK4tsu/dlings.git
cd dlings
git remote add USER git@github.com:USER/dlings.git
git checkout -b fix-some-issue
```
When ready to push:
```sh
git push --set-upstream USER fix-some-issue
```
Now create a Pull Request in GitHub to this project's master branch.
